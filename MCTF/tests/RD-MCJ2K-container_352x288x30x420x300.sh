#!/bin/bash

source ./test_DATA.sh

set -x

data_dir=data-${0##*/}

VIDEO=container_352x288x30x420x300
IBS=32 # Initial block_size
FBS=32 # Final block size
Y_DIM=288
X_DIM=352
FPS=30
PICTURES=257

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
    echo -e $rate'\t'$RMSE >> MCJ2K_TRL$2.dat
}


# GOP_size = 32
J2K 44500 6
#J2K 44000 6
#J2K 43400 6
#J2K 43000 6
#J2K 42800 6

gnuplot << EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot "MCJ2K_TRL6.dat" title "6 TRLs (GOP_size=32)" with linespoints
EOF

set +x

#firefox file://`pwd`/output.svg &
