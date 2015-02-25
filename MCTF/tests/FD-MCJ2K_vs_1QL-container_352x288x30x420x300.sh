#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=container_352x288x30x420x300
IBS=32 # Initial block_size
FBS=32 # Final block size
Y_DIM=288
X_DIM=352
FPS=30
PICTURES=289

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
    mcj2k compress --pictures=$PICTURES --slopes=$1
    mcj2k info --pictures=$PICTURES
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcj2k expand --pictures=$PICTURES
    mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    snr --file_A=$HOME/data/${VIDEO}.yuv --file_B=tmp/low_0 2> PSNR_$1.dat
}

J2K 44500
J2K 44000
J2K 43400
J2K 43000
J2K 42800

gnuplot <<EOF
set terminal svg
set output "output.svg"
set grid
set xtics "32,64,96,128,160,192,224,256"
set title "${0##*/}"
set xlabel "Frame"
set ylabel "PSNR [dB]"
plot "PSNR_44500.dat" with lines title "44500", "PSNR_44000.dat" with lines title "44000", "PSNR_43400.dat" with lines title "43400", "PSNR_43000.dat" with lines title "43000", "PSNR_42800.dat" with lines title "42800" 
EOF

set +x

firefox file://`pwd`/output.svg &
