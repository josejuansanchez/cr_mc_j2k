#!/bin/bash
if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_dir=data-${0##*/}

VIDEO=mobile_352x288x30x420x300
PICTURES=5

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
mcmj2k compress --slopes="44900,44700,44500,44300,44100" --pictures=$PICTURES --temporal_levels=2

# "Enviamos"
rm -rf tmp
mkdir tmp
cp *.mjc *type* tmp

# Descomprimimos
#cd tmp
#mcj2k expand --pictures=$PICTURES --layers=1

# Qué hemos hecho????
mcmj2k info --pictures=$PICTURES --temporal_levels=2

set +x
