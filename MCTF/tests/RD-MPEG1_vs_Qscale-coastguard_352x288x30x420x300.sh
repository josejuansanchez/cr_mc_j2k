#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=mobile_352x288x30x420x300
PICTURES=289
Y_DIM=288
X_DIM=352
FPS=30
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
ln -s $DATA/${VIDEO}.yuv low_0

MPEG1 () {
    ffmpeg -s ${X_DIM}x${Y_DIM} -g 30 -vcodec mpeg1video -qscale $1 -i $DATA/$VIDEO.yuv 1.avi
    AVI_bytes=`wc -c < 1.avi`
    rate=`echo "$AVI_bytes*8/$TIME/1000" | bc -l`
    ffmpeg -y -i 1.avi 1.yuv
    # Hacemos que la primera imagen de la secuencia descomprimida sea
    # igual a a segunda porque ffmpeg inexplicablemente, para este
    # número de imágenes, no genera la imagen 0 en la salida.
    dd if=1.yuv of=1 bs=`echo "($X_DIM*$Y_DIM*3)/2" | bc` count=1
    cat 1.yuv >> 1
    mv 1 1.yuv
    RMSE=`snr --file_A=$HOME/data/$VIDEO.yuv --file_B=1.yuv 2> /dev/null | grep RMSE | cut -f 3`
    echo -e $rate'\t'$RMSE >> AVC.dat
    mplayer 1.yuv -demuxer rawvideo -rawvideo w=352:h=288 > /dev/null 2> /dev/null
}

MPEG1 20

gnuplot <<EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set xlabel "Kbps"
set ylabel "RMSE"
set title "${0##*/}"
plot "MCJ2K.dat"title "MCJ2K"  with linespoints, "AVC.dat" title "H.264/AVC" with linespoints
EOF

set +x

firefox file://`pwd`/output.svg &
