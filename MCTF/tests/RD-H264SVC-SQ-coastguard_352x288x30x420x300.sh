#!/bin/bash

source ./test_DATA.sh
source ./test_ffmpeg.sh
source ./test_H264AVCEncoderLibTestStatic.sh
source ./test_wget.sh

VIDEO=coastguard_352x288x30x420x300
PICTURES=33
Y_DIM=288
X_DIM=352
FPS=30
MAX_Q_SCALE=50
GOP_SIZE=16

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

Q_SCALE=$MAX_Q_SCALE
while [ $Q_SCALE -ge 1 ]
do
    ../RD-H264SVC-SQ.sh -v $VIDEO -p $PICTURES -y $Y_DIM -x $X_DIM -f $FPS -q $Q_SCALE -g $GOP_SIZE >> RD-H264SVC-SQ-$VIDEO.dat
    let Q_SCALE=Q_SCALE-10
done

set +x
