#!/bin/bash

source ./test_DATA.sh
source ./test_Kakadu.sh
source ./test_ffmepg.sh
source ./test_wget.sh
source ./test_MCTF.sh

set -x

data_dir=data-${0##*/}

VIDEO=coastguard_352x288x30x420x300
#PICTURES=289
GOPs=2
TRLs=6 # GOP_size = 2
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
mcj2k compress --GOPs=$GOPs --TRLs=$TRLs --quantizations="45000,44500"

# "Enviamos"
rm -rf tmp
mkdir tmp
cp *.mjc *.j2c *type* tmp

# Descomprimimos
cd tmp
mcj2k expand --GOPs=$GOPs --TRLs=$TRLs

# Qué hemos hecho????
mcj2k info --GOPs=$GOPs --TRLs=$TRLs

set +x
