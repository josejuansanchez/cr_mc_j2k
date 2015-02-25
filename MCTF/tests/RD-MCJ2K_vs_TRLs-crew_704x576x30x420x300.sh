#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=crew_704x576x30x420x400
IBS=32 # Initial block_size
FBS=32 # Final block size (stockholm has a very simple motion)
Y_DIM=576
X_DIM=704
FPS=30
#PICTURES=33
PICTURES=65 # Allows up to 7 TRLs

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
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES --temporal_levels=$2 --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCJ2K_TRL$2.dat
}

# GOP_size = 1
J2K 44500 1
J2K 44250 1
J2K 44000 1
J2K 43700 1
J2K 43400 1

# GOP_size = 2
J2K 44500 2
J2K 44000 2
J2K 43400 2
J2K 43000 2
J2K 42800 2

# GOP_size = 4
J2K 44500 3
J2K 44000 3
J2K 43400 3
J2K 43000 3
J2K 42800 3

# GOP_size = 8
J2K 44500 4
J2K 44000 4
J2K 43400 4
J2K 43000 4
J2K 42800 4

# GOP_size = 16
J2K 44500 5
J2K 44000 5
J2K 43400 5
J2K 43000 5
J2K 42800 5

# GOP_size = 32
J2K 44500 6
J2K 44000 6
J2K 43400 6
J2K 43000 6
J2K 42800 6

# GOP_size = 64
J2K 44500 7
J2K 44000 7
J2K 43400 7
J2K 43000 7
J2K 42800 7

gnuplot << EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot "MCJ2K_TRL1.dat" title "1 TRL (GOP_size=1)" with linespoints, "MCJ2K_TRL2.dat" title "2 TRLs (GOP_size=2)" with linespoints,  "MCJ2K_TRL3.dat" title "3 TRLs (GOP_size=4)" with linespoints, "MCJ2K_TRL4.dat" title "4 TRLs (GOP_size=8)" with linespoints, "MCJ2K_TRL5.dat" title "5 TRLs (GOP_size=16)" with linespoints, "MCJ2K_TRL6.dat" title "6 TRLs (GOP_size=32)" with linespoints, "MCJ2K_TRL7.dat" title "7 TRLs (GOP_size=64)" with linespoints
EOF

set +x

firefox file://`pwd`/output.svg &
