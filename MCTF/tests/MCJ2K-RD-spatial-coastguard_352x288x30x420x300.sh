#!/bin/bash

# Curva RD para varios niveles de resolución espacial. Sólo
# escalabilidad en resolución.

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })
data_dir=data-${0##*/}
gpt_file=$script_name.gpt

VIDEO=coastguard_352x288x30x420x300
#PICTURES=289
PICTURES=5
TEMPORAL_LEVELS=2
PIXELS_IN_Y=288
PIXELS_IN_X=352
BLOCK_SIZE=16

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

J2K () {
    mcj2k compress --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --block_size=$BLOCK_SIZE
    rm -rf tmp
    mkdir tmp
    cp *.mjc *type* tmp
    mcj2k extract --temporal_levels=$TEMPORAL_LEVELS --pictures=$PICTURES --resolutions=$2
    cd tmp
    piy=`echo "$PIXELS_IN_Y/(2^$2)" | bc -l`
    pix=`echo "$PIXELS_IN_X/(2^$2)" | bc -l`
    bs=`echo "$BLOCK_SIZE/(2^$2)" | bc -l`
    mcj2k expand --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$piy --pixels_in_x=$pix --subpixel_accuracy=$2 --block_size=$bs
    zoom_in_YUV -l $2 -y $PIXELS_IN_Y -x $PIXELS_IN_X -p $PICTURES < low_0 > /tmp/1
    mv /tmp/1 low_0s
    # Falta ampliar
    cd ..
    RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcj2k info --pictures=$PICTURES | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> MCMJ2K.dat
}

set +x
