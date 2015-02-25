#!/bin/bash

set -x

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })

PICTURES=$1
FPS=30
DURATION=`echo "$PICTURES/$FPS" | bc -l`
VIDEO="null_352x288x30x420x300.yuv" #VIDEO="mobile_352x288x30x420x300.yuv"

# 5 imágenes
if [ $PICTURES -eq 5 ]; then
    capaA=2
    capaB=5
    capaC=8
fi

# 17 imágenes
if [ $PICTURES -eq 17 ]; then
    capaA=4
    capaB=9
    capaC=14
fi

read word

##############################	##############################
#							 MAIN							 #
##############################	##############################

# Codificación
H264AVCEncoderLibTestStatic -pf main.cfg -lqp 0 50 -lqp 1 45 -lqp 2 40 > outdisplay

# Información de capas
BitStreamExtractorStatic file.H264 > info.H264

# Extracción de capas
BitStreamExtractorStatic file.H264 extract_$capaA -sl $capaA
BitStreamExtractorStatic file.H264 extract_$capaB -sl $capaB
BitStreamExtractorStatic file.H264 extract_$capaC -sl $capaC

# Reconstruye el .yuv
H264AVCDecoderLibTestStatic extract_$capaA $capaA.yuv
H264AVCDecoderLibTestStatic extract_$capaB $capaB.yuv
H264AVCDecoderLibTestStatic extract_$capaC $capaC.yuv

# Cálculo bit-rate y RMSE
bytes=`wc -c < extract_$capaA`
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=/home/cmaturana/scratch/DATA_IN/$VIDEO --file_B=$capaA.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q50'\t\t'$bytes' \t'$rate' \t'$rmse >> svc_$VIDEO""_$PICTURES""imagenes.dat

bytes=`wc -c < extract_$capaB`
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=/home/cmaturana/scratch/DATA_IN/$VIDEO --file_B=$capaB.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q45'\t\t'$bytes' \t'$rate' \t'$rmse >> svc_$VIDEO""_$PICTURES""imagenes.dat

bytes=`wc -c < extract_$capaC`
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=/home/cmaturana/scratch/DATA_IN/$VIDEO --file_B=$capaC.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q40'\t\t'$bytes' \t'$rate' \t'$rmse >> svc_$VIDEO""_$PICTURES""imagenes.dat



set +x
