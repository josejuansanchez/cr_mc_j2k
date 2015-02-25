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
    echo Encoding with J2K for slope $1 and $2 TRLs
    mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcj2k expand --block_size=$IBS --block_size_min=$FBS --pictures=$PICTURES --temporal_levels=$2 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM
    mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    snr --file_A=$HOME/data/${VIDEO}.yuv --file_B=tmp/low_0 2> PSNR_$2.dat
}

J2K 44500 1
J2K 44500 2
J2K 44500 3
J2K 44500 4
J2K 44500 5
J2K 44500 6

gnuplot <<EOF
set terminal svg
set output "output.svg"
set grid
set xtics "32,64,96,128,160,192,224,256"
set title "${0##*/}"
set xlabel "Frame"
set ylabel "PSNR [dB]"
plot "PSNR_1.dat" with lines title "1 TRL (GOP_size=1)", "PSNR_2.dat" with lines title "2 TRLs (GOP_size=2)", "PSNR_3.dat" with lines title "3 TRLs (GOP_size=4)", "PSNR_4.dat" with lines title "4 TRLs (GOP_size=8)", "PSNR_5.dat" with lines title "5 TRLs (GOP_size=16)", "PSNR_6.dat" with lines title "6 TRLs (GOP_size=32)" 
EOF

set +x

firefox file://`pwd`/output.svg &
