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
ln -s $DATA/${VIDEO}.yuv low_0

run1 () {
    mcj2k compress --slopes=$1 --pictures=$PICTURES
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    rate=`mcj2k info --pictures=$PICTURES | grep "Total average:" | cut -d " " -f 3`
    mcj2k expand --pictures=$PICTURES --layers=$2
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    echo -e $rate'\t'$RMSE >> with_layers.dat
}

run1 "44500" 1
run1 "44500,44250" 2
run1 "44500,44250,44000" 3
run1 "44500,44250,44000,43700" 4
run1 "44500,44250,44000,43700,43400" 5

run2 () {
    mcj2k compress --slopes=$1 --pictures=$PICTURES
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    rate=`mcj2k info --pictures=$PICTURES | grep "Total average:" | cut -d " " -f 3`
    mcj2k expand --pictures=$PICTURES --layers=1
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    echo -e $rate'\t'$RMSE >> without_layers.dat
}

run2 "44500"
run2 "44250"
run2 "44000"
run2 "43700"
run2 "43400"

gnuplot <<EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot "with_layers.dat" title "5 quality layer" with linespoints, "1 quality layer.dat" with linespoints
EOF

set +x

firefox file://`pwd`/output.svg &
