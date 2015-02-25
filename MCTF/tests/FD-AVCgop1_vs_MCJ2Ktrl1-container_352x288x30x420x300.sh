#!/bin/bash

set -x

data_dir=data-${0##*/}

VIDEO=container_352x288x30x420x300
IBS=32 # Initial block_size
FBS=32 # Final block size
X_DIM=352
Y_DIM=288
FPS=30
PICTURES=289
DURATION=10
TRL=1
GOPsize=1

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


##################### AVC, gop=1=keyint

ruta_video=$DATA/$VIDEO.yuv
decompressed_video=$VIDEO.yuv
compressed_video=$VIDEO.avi
data_file=$VIDEO.dat

QSCALE=30
#QSCALE=30 -> bitrate=698
#QSCALE=5 -> bitrate=2350
avc(){
rm -f $data_file
    x264 --keyint $GOPsize --crf $QSCALE --input-res ${X_DIM}x${Y_DIM} -o $compressed_video $DATA/$VIDEO.yuv
    ffmpeg -y -i $compressed_video $decompressed_video

    #guarda el bit-rate para compararlo con el que de j2k para 'tal' slope
    compressed_size=`wc -c < $compressed_video`
    rate_avc=`echo "$compressed_size*8/$DURATION/1000" | bc`

    snr --file_A=$HOME/data/${VIDEO}.yuv --file_B=$decompressed_video 2> AVC_PSNR_$QSCALE.dat
rm -f $compressed_video $decompressed_video
}

avc

##################### MCJ2K, 1=temporal_levels=trl

ln -s $DATA/$VIDEO.yuv low_0

#rango=10
slope=44017
#while [ $slope -le 51 ]; do
    mcj2k compress --pictures=$PICTURES --slopes=$slope --temporal_levels=$TRL
    mcj2k info --pictures=$PICTURES --temporal_levels=$TRL
    mkdir tmp
    cp *.mjc *type* tmp
    cd tmp
    mcj2k expand --pictures=$PICTURES --temporal_levels=$TRL
    #mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
    cd ..
    rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRL | grep "Total average:" | cut -d " " -f 3`

    snr --file_A=$HOME/data/${VIDEO}.yuv --file_B=tmp/low_0 2> MCJ2K_PSNR.dat

#    suma=`echo $rate_mcj2k + $rango | bc` 

    #Mira que sean parecidos los bitrates de mcj2k y AVC. Si es así deja de buscar.
    #if [[ ($rate_avc -le $suma) && ($suma -le $rate_avc) ]]; then
#	echo "- - - BIT-RATES - - -"
#	echo "AVC($QSCALE): $rate_avc MCJ2K: $rate_mcj2k"
#	break;
#    fi

#    let slope=slope-10
#done



##################### GNUPLOT

gnuplot <<EOF
set terminal svg
set output "output.svg"
set grid
set xtics "32,64,96,128,160,192,224,256"
set title "${0##*/} kbps=$rate_mcj2k"
set xlabel "Frame"
set ylabel "PSNR [dB]"
plot	"MCJ2K_PSNR.dat" title "MCJ2K $slope" with lines, \
	"AVC_PSNR_$QSCALE.dat" title "AVC $QSCALE" with lines
EOF

set +x

firefox file://`pwd`/output.svg &
