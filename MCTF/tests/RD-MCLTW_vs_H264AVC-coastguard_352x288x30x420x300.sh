#!/bin/bash

if [ -z "$DATA" ]; then
    echo "Undefined DATA!"
    echo 'Maybe you should define this variable with "export DATA=$HOME/motriz2010/data"?'
    exit 1
fi

hash ltw 2>/dev/null || { echo >&2 'I require ltw but it is not installed or it is not in PATH. Maybe you should define this variable with "PATH=$PATH:$HOME/motriz2010/bin"? If you are using a 64bit machine, be sure to have installed ia32-libs!'; exit 1; }

hash mcltw 2>/dev/null || { echo >&2 'I require mcltw but it is not installed or it is not in PATH. Maybe you should run the script "$HOME/motriz2010/src/MCTF/compile"?'; exit 1; }

if [ -z "$MCTF" ]; then
    echo "Undefined MCTF!"
    echo 'Maybe you should define this variable with "export MCTF=$HOME/motriz2010/src/MCTF"?'
    exit 1
fi

hash kdu_v_compress 2>/dev/null || { echo >&2 'I require kdu_v_compress but it is not installed or it is not in PATH. Maybe you should run the script "$HOME/motriz2010/src/Kakadu/compile"?'; exit 1; }

hash mux 2>/dev/null || { echo >&2 'I require mux but it is not installed or it is not in PATH. Maybe you should run the script "$HOME/motriz2010/src/mux/compile"?'; exit 1; }

hash snr 2>/dev/null || { echo >&2 'I require snr but it is not installed or it is not in PATH. Maybe you should run the script "$HOME/motriz2010/src/SNR/compile"?'; exit 1; }

set -x

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })
data_dir=data-$script_name
gpt_file=$script_name.gpt

VIDEO=coastguard_352x288x30x420x300
IBS=32 # Initial block_size
FBS=32 # Final block size
Y_DIM=288
X_DIM=352
FPS=30
# TRL GOP_size
# 0   1
# 1   2
# 2   4
# 3   8
# 4   16
# 5   32
# 6   64
# 7   128   
PICTURES=33 # Allows up to 5 TRLs
#PICTURES=257 # Allows up to 9 TRLs
TRLs=4

if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    current_dir=$PWD
    cd $DATA
    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
    ffmpeg -i $VIDEO.avi $VIDEO.yuv
    cd $current_dir
fi

rm -rf $data_dir
mkdir $data_dir
cd $data_dir
ln -s $DATA/$VIDEO.yuv low_0

LTW () {
    echo Encoding with LTW for slope $1 and $2 TRLs
    mcltw compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --update_factor=0
    rm -rf tmp
    mkdir tmp
    cp *.ltw *.mjc *type* tmp
    cd tmp
    mcltw expand --block_size=$IBS --block_size_min=$FBS --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --update_factor=0
    mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcltw info --pictures=$PICTURES --temporal_levels=$2 --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCLTW.dat
}

J2K () {
    echo Encoding with J2K for slope $1 and $2 TRLs
    mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --update_factor=0
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcj2k expand --block_size=$IBS --block_size_min=$FBS --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --update_factor=0
    mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES --temporal_levels=$2 --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCJ2K.dat
}

LTW 10.0 $TRL 4
LTW 8.0 $TRL 4
LTW 6.0 $TRL 4
LTW 4.0 $TRL 4
LTW 2.0 $TRL 4
LTW 0.5 $TRL 4

J2K 44500 4
J2K 44000 4
J2K 43400 4
J2K 43000 4
J2K 42000 4
J2K 40000 4

cd ..

rm -f $gpt_file
cat >> $gpt_file << EOF
set terminal fig color fontsize 12
set output "$script_name.fig"
set yrange [0:]
set xrange[0:]
set title "$script_name"
set xlabel "Kbps"
set ylabel "RMSE"
plot "data-$script_name/MCLTW.dat" title "MCLTW" with linespoints, \\
"data-$script_name/MCJ2K.dat" title "MCJ2K" with linespoints
EOF

#gnuplot $gpt_file

set +x

#firefox file://`pwd`/output.svg &
