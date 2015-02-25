#!/bin/bash

source ./test_DATA.sh
source ./test_ffmpeg.sh
source ./test_MCTF.sh
source ./test_wget.sh
source ./test_ltw.sh

VIDEO=coastguard_352x288x30x420x300
GOPs=1 # Without including the first GOP (that has only a I image)
Y_DIM=288
X_DIM=352
FPS=30
MAX_Q_SCALE=10.0
TRLs=6
# TRLs=1 GOP_SIZE=1
# TRLs=2 GOP_SIZE=2
# TRLs=3 GOP_SIZE=4
# TRLs=4 GOP_SIZE=8
# TRLs=5 GOP_SIZE=16
# TRLs=6 GOP_SIZE=32
SRLs=3

if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    current_dir=$PWD
    cd $DATA
    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
    ffmpeg -i $VIDEO.avi $VIDEO.yuv
    cd $current_dir
fi

set -x

DATA_DIR=data-${0##*/}
rm -rf $DATA_DIR
mkdir $DATA_DIR
cd $DATA_DIR
ln -s $DATA/$VIDEO.yuv low_0

Q_SCALE=$MAX_Q_SCALE
while [ `echo "$Q_SCALE >= 1.0" | bc -l` -eq 1 ]
do
    ../RD-MCLTW.sh -v $VIDEO -g $GOPs -y $Y_DIM -x $X_DIM -f $FPS -q $Q_SCALE -t $TRLs -s $SRLs >> RD-MCLTW-$VIDEO.dat 2>> stderr
    Q_SCALE=`echo "$Q_SCALE-0.5" | bc -l`
done

set +x
