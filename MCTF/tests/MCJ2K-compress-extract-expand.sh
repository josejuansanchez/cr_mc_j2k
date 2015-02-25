#!/bin/bash

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_dir=data-${0##*/}

VIDEO=coastguard_352x288x30x420x300
#PICTURES=289
PICTURES=5
TEMPORAL_LEVELS=2
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

# Comprimimos
mcj2k compress --slopes="42500,42250" --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS

# "Enviamos"
rm -rf tmp
mkdir tmp
cp *.mjc *type* tmp
mcj2k extract --temporal_levels=$TEMPORAL_LEVELS --pictures=$PICTURES --resolutions=2

# Descomprimimos
cd tmp
mcj2k expand --pictures=$PICTURES --layers=1 --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=72 --pixels_in_x=88 --subpixel_accuracy=3 --block_size=4

# Qué hemos hecho????
mcj2k info --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS

set +x
