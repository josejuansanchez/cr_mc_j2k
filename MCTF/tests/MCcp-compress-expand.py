#!/bin/bash

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_dir=data-${0##*/}

#VIDEO=coastguard_352x288x30x420x300
VIDEO=coastguard-with-numbers_352x288x30x420x300
#VIDEO=mobile_352x288x30x420x300
#VIDEO=container_352x288x30x420x300
#VIDEO=foreman_352x288x30x420x300
#VIDEO=tempete_352x288x30x420x260
#PICTURES=289
GOPs=2
#TRLs=2 # GOP_size = 2
#TRLs=7 # GOP_size = 64
TRLs=8 # GOP_size = 128

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
mccp compress --GOPs=$GOPs --TRLs=$TRLs --update_factor=0

# "Enviamos"
rm -rf tmp
mkdir tmp
cp *.mjc *.cp *type* tmp

# Descomprimimos
cd tmp
mccp expand --GOPs=$GOPs --TRLs=$TRLs --update_factor=0

# Qué hemos hecho????
mccp info --GOPs=$GOPs --TRLs=$TRLs

set +x
