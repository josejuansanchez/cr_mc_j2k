#!/bin/bash

set -x

data_dir=data-${0##*/}

DATA=/home/carmelo/svn_paper/motriz2010/data
VIDEO=parkjoy_1920x1080x50x420x500.yuv
IBS=32 # Initial block_size
FBS=32 # Final block size
X_DIM=1920
Y_DIM=1080
FPS=50
PICTURES=500
DURATION=10
TRL=1
GOPsize=1

if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    current_dir=$PWD
    cd $DATA
    wget http://media.xiph.org/video/derf/y4m/park_joy_1080p50.y4m
    mencoder park_joy_1080p50.y4m -ovc raw -of rawvideo -vf format=i420 -o $VIDEO.yuv
    cd $current_dir
fi



rm -rf $data_dir
mkdir $data_dir
cd $data_dir


##################### AVC, gop=1=keyint

ruta_video=$DATA/$VIDEO.yuv
decompressed_video=$VIDEO.yuv
compressed_video=$VIDEO.avi
data_file=$VIDEO.dat

QSCALE=40
#QSCALE=40 -> bitrate=4332

avc(){
rm -f $data_file

    x264 --keyint 1 --crf $QSCALE --input-res ${X_DIM}x${Y_DIM} --fps 50 -o $compressed_video $DATA/$VIDEO.yuv
    ffmpeg -y -i $compressed_video $decompressed_video
#-dframes 257

    #guarda el bit-rate para compararlo con el que de j2k para 'tal' slope
    compressed_size=`wc -c < $compressed_video`
    rate_avc=`echo "$compressed_size*8/$DURATION/1000" | bc`

    snr --block_size=3110400 --file_A=$HOME/data/${VIDEO}.yuv --file_B=$decompressed_video 2> AVC_PSNR_$QSCALE.dat
rm -f $compressed_video $decompressed_video
}

avc

##################### MCJ2K, 1=temporal_levels=trl

j2k(){
#rango=10
ln -s $DATA/$VIDEO.yuv low_0

#slope=44703 rate_mcj2k=4333.67003891
slope=44703
#while [ $slope -le 51 ]; do
    mcj2k compress --pictures=$PICTURES --pixels_in_x=${X_DIM} --pixels_in_y=${Y_DIM} --slopes=$slope --temporal_levels=1
    rate_mcj2k=`mcj2k info --pictures=$PICTURES --pictures_per_second=50 --temporal_levels=1 | grep "Total average:" | cut -d " " -f 3`
    mkdir tmp
    cp *.mjc tmp
    cd tmp
    mcj2k expand --pictures=$PICTURES --pixels_in_x=${X_DIM} --pixels_in_y=${Y_DIM} --temporal_levels=1
    #mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..

    snr --block_size=3110400 --file_A=$HOME/data/${VIDEO}.yuv --file_B=tmp/low_0 2> MCJ2K_PSNR_$slope.dat

#    suma=`echo $rate_mcj2k + $rango | bc` 

    #Mira que sean parecidos los bitrates de mcj2k y AVC. Si es así deja de buscar.
    #if [[ ($rate_avc -le $suma) && ($suma -le $rate_avc) ]]; then
#	echo "- - - BIT-RATES - - -"
#	echo "AVC($QSCALE): $rate_avc MCJ2K: $rate_mcj2k"
#	break;
#    fi

#    let slope=slope-10
#done
}

j2k


##################### GNUPLOT

gnuplot <<EOF
set terminal svg
set output "output.svg"
set grid
set xtics "32,64,96,128,160,192,224,256"
set title "${0##*/} kbps=$rate_mcj2k"
set xlabel "Frame"
set ylabel "PSNR [dB]"
plot	"MCJ2K_PSNR_$slope.dat" title "MCJ2K $slope" with lines, \
	"AVC_PSNR_$QSCALE.dat" title "AVC $QSCALE" with lines
EOF

set +x

firefox file://`pwd`/output.svg &
