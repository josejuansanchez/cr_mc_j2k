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
DURATION=10

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


##################### MCJ2K, 1=temporal_levels=trl

ln -s $DATA/${VIDEO}.yuv low_0

J2K () {
    mcj2k compress --slopes=$1 --pictures=$PICTURES --temporal_levels=1
    rm -rf tmp
    mkdir tmp
    cp *.mjc tmp # Ojo, no copiamos los *type* porque no existen
    cd tmp
    mcj2k expand --pictures=$PICTURES --temporal_levels=1
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES --temporal_levels=1 | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCJ2K.dat
    #mplayer tmp/low_0 -demuxer rawvideo -rawvideo w=352:h=288 > /dev/null 2> /dev/null
}

J2K "44500"
J2K "44250"
J2K "44000"
J2K "43700"
J2K "43400"
J2K "43200"
J2K "43000"
J2K "42500"
J2K "42000"
J2K "41500"
J2K "41300"
J2K "41000"


##################### AVC, gop=1=keyint

ruta_video=$DATA/$VIDEO.yuv
decompressed_video=$VIDEO.yuv
compressed_video=$VIDEO.avi
data_file=$VIDEO.dat

QSCALE=0
rm -f $data_file
while [ $QSCALE -le 51 ]; do
    x264 --keyint 1 --crf $QSCALE --input-res ${X_DIM}x${Y_DIM} -o $compressed_video $DATA/$VIDEO.yuv
    ffmpeg -y -i $compressed_video $decompressed_video

    compressed_size=`wc -c < $compressed_video`
    BIT_RATE_IN_KBPS=`echo "$compressed_size*8/$DURATION/1000" | bc -l`
    RMSE=`snr --file_A=$ruta_video --file_B=$decompressed_video 2> /dev/null | grep RMSE | cut -d "=" -f 2`

    echo $BIT_RATE_IN_KBPS $RMSE >> AVC.dat
    echo qscale=$QSCALE bit-rate=$BIT_RATE_IN_KBPS Kbps RMSE=$RMSE
    let QSCALE=QSCALE+1
done
rm -f $compressed_video $decompressed_video


##################### GNUPLOT
gnuplot <<EOF
set terminal svg
set output "output.svg"
set yrange [0:]
set xrange[0:]
set xlabel "Kbps"
set ylabel "RMSE"
set title "${0##*/}"
plot "MCJ2K.dat" title "MCJ2K trl=1"  with linespoints, "AVC.dat" title "H.264/AVC gop=1" with linespoints

EOF

set +x

firefox file://`pwd`/output.svg &
