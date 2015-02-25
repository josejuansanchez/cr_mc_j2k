#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=mobile_352x288x30x420x300
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

# Motion JPEG 2000
MJ2K () {
    echo Encoding with Motion J2K for slope $1
    mcmj2k compress --slopes='"'$1'"' --pictures=$PICTURES
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcmj2k expand --pictures=$PICTURES
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCMJ2K.dat
}

# Motion JPEG
MJPEG () {
    echo Encoding with Motion JPEG for slope $1
    mcmjpeg compress --slopes='"'$1'"' --pictures=$PICTURES
    rm -rf tmp
    mkdir tmp
    cp *.mjc *.mjpeg *type* tmp
    cd tmp
    mcmjpeg expand --pictures=$PICTURES
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcjpg info --pictures=$PICTURES | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCMJPEG.dat
}

MJ2K 44500
MJ2K 44000
MJ2K 43400
MJ2K 43000
MJ2K 42000
MJ2K 40000

MJPEG 31
MJPEG 20
MJPEG 15
MJPEG 5
MJPEG 1

gnuplot <<EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot "MCMJ2K.dat" title "MCJ2K"  with linespoints, "MCMJPEG.dat" title "MCJPG" with linespoints
EOF

firefox file://`pwd`/output.svg &
