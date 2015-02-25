#!/bin/bash

if [ -z "$DATA" ]; then
    echo "Undefined DATA!"
    echo 'Maybe you should define this variable with "export DATA=$HOME/motriz2010/data"?'
    exit 1
fi

hash kdu_v_compress 2>/dev/null || { echo >&2 'I require kdu_v_compress but it is not installed or it is not in PATH. Maybe you should define this variable with "PATH=$PATH:$HOME/motriz2010/bin"?'; exit 1; }

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
TIME=`echo "$PICTURES/$FPS" | bc -l`

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

J2K 44500 4
J2K 44000 4
J2K 43400 4
J2K 43000 4
J2K 42000 4
J2K 40000 4

AVC () {
    x264 --input-res ${X_DIM}x${Y_DIM} --keyint 30 --crf $1 --frames $PICTURES -o 1.avi $DATA/$VIDEO.yuv
    #x264 --input-res ${X_DIM}x${Y_DIM} --qp 0 --frames $PICTURES -o 1.avi $DATA/$VIDEO.yuv
    AVI_bytes=`wc -c < 1.avi`
    rate=`echo "$AVI_bytes*8/$TIME/1000" | bc -l`
    ffmpeg -y -i 1.avi 1.yuv
    # Hacemos que la primera imagen de la secuencia descomprimida sea
    # igual a a segunda porque ffmpeg inexplicablemente, para este
    # número de imágenes, no genera la imagen 0 en la salida.
    dd if=1.yuv of=1 bs=`echo "($X_DIM*$Y_DIM*3)/2" | bc` count=1
    cat 1.yuv >> 1
    mv 1 1.yuv
    RMSE=`snr --file_A=$DATA/$VIDEO.yuv --file_B=1.yuv 2> /dev/null | grep RMSE | cut -f 3`
    echo -e $rate'\t'$RMSE >> AVC.dat
    mplayer 1.yuv -demuxer rawvideo -rawvideo w=352:h=288 > /dev/null 2> /dev/null
}

AVC 51
AVC 45
AVC 35
AVC 25
AVC 15

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
plot "data-$script_name/MCJ2K.dat" title "MCJ2K" with linespoints, \\
"data-$script_name/AVC.dat" title "AVC" with linespoints
EOF

#gnuplot $gpt_file

set +x

#firefox file://`pwd`/output.svg &
