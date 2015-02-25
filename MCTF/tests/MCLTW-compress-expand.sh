#!/bin/bash

source ./test_DATA.sh
source ./test_ltw.sh
source ./test_ffmepg.sh
source ./test_wget.sh
source ./test_MCTF.sh

set -x

data_dir=data-${0##*/}

VIDEO=coastguard_352x288x30x420x300
#PICTURES=289
GOPs=1
TRLs=5 # GOP_size = 16
SRLs=3

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
mcltw compress --GOPs=$GOPs --TRLs=$TRLs --quantizations="10.0" --SRLs=$SRLs

# "Enviamos"
rm -rf tmp
mkdir tmp
cp *.mjc *.ltw *type* tmp

# Descomprimimos
cd tmp
mcltw expand --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs

# Qué hemos hecho????
mcltw info --GOPs=$GOPs --TRLs=$TRLs

set +x
