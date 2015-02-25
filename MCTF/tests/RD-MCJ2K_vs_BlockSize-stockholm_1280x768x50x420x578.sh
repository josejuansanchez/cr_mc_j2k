#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=stockholm_1280x768x50x420x578
Y_DIM=768
X_DIM=1280
FPS=50
#PICTURES=33
PICTURES=65 # Allows up to 7 TRLs
TRLs=5

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
    rm -f *motion*
    mcj2k compress --block_size=$2 --block_size_min=$2 --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$TRLs --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcj2k expand --block_size=$2 --block_size_min=$2 --pictures=$PICTURES --temporal_levels=$TRLs --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM
    mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRLs --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> $2.dat
}

# block_size = 4
J2K 44500 4
J2K 44250 4
J2K 44000 4
J2K 43700 4
J2K 43400 4
J2K 43300 4
J2K 43200 4

# block_size = 8
J2K 44500 8
J2K 44000 8
J2K 43400 8
J2K 43000 8
J2K 42800 8

# block_size = 16
J2K 44500 16
J2K 44000 16
J2K 43400 16
J2K 43000 16
J2K 42800 16

# block_size = 32
J2K 44500 32
J2K 44000 32
J2K 43400 32
J2K 43000 32
J2K 42800 32

# block_size = 64
J2K 44500 64
J2K 44000 64
J2K 43400 64
J2K 43000 64
J2K 42800 64

# block_size = 128
J2K 44500 128
J2K 44000 128
J2K 43400 128
J2K 43000 128
J2K 42800 128

gnuplot << EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot "4.dat" title "4x4" with linespoints, "8.dat" title "8x8" with linespoints,  "16.dat" title "16x16" with linespoints, "32.dat" title "32x32" with linespoints, "64.dat" title "64x64" with linespoints, "128.dat" title "128x128" with linespoints
EOF

set +x

firefox file://`pwd`/output.svg &
