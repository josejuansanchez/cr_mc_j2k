#!/bin/bash

set -x

out=extracted-${0##*/}
in=SVC_4CGS_cfg/1080p

DATA=/home/carmelo/svn_paper/motriz2010/data
VIDEO=parkjoy_1920x1080x50x420x500
ruta_video=$DATA/$VIDEO.yuv

IBS=32 # Initial block_size
FBS=32 # Final block size
X_DIM=1920
Y_DIM=1080
Y_DIMM=1088
FPS=50
PICTURES=160					#!257
DURATION=`echo "$PICTURES/$FPS" | bc -l` 	#segundos

E_PARAMETROS=1920x1088@50
kbps_corte_min=1400
kbps_corte_max=21000

#Comprueba que está o descarga el video
if [[ ! -e $DATA/$VIDEO.yuv ]]; then
	current_dir=$PWD
	cd $DATA
	wget http://media.xiph.org/video/derf/y4m/park_joy_1080p50.y4m
	mencoder park_joy_1080p50.y4m -ovc raw -of rawvideo -vf format=i420 -o $VIDEO.yuv
	cd $current_dir
fi

#Comprueba que está o genera la compresión
if [[ ! -e $in/CGS_4layers.264 ]]; then
	current_dir=$PWD
	cd $in
	H264AVCEncoderLibTestStatic -pf main.cfg -lqp 0 52 -lqp 1 47 -lqp 2 42 -lqp 3 37 > outdisplay
	cd $current_dir
fi

#Comprueba que está o genera la compresión con QL
if [[ ! -e $in/CGS_4layers_QL.264 ]]; then
	current_dir=$PWD
	cd $in
	QualityLevelAssignerStatic -in CGS_4layers.264 -org 0 $ruta_video -out CGS_4layers_QL.264
	cd $current_dir
fi

rm -rf $out
mkdir $out
cd $out
mkdir infos

##################### SVC

kbps_corte=$kbps_corte_min

while [ $kbps_corte -le $kbps_corte_max ]; do
	cd ..
	#Extrae la capa n
	BitStreamExtractorStatic $in/CGS_4layers_QL.264 $out/extracted_eQL -e $E_PARAMETROS:$kbps_corte -ql #> $out/infos/info_extracted$n

	cd $out
	#Reconstruye el .yuv
	H264AVCDecoderLibTestStatic extracted_eQL n.yuv #> infos/info_yuv$n

	#Calcula bit-rate
	bytes=`wc -c < extracted_eQL`
	kbps=`echo "$bytes*8/$DURATION/1000" | bc -l`
	#Calcula RMSE
	RMSE=`snr --file_A=$ruta_video --file_B=n.yuv 2> /dev/null | grep RMSE | cut -d "=" -f 2`

	echo $kbps $RMSE >> dat.dat

let kbps_corte=kbps_corte+100
done


##################### GNUPLOT
gnuplot <<EOF
set terminal svg
set output "output.svg"
set grid
set title "${0##*/}"
set xlabel "Kbps"
set ylabel "RMSE"
plot 	"dat.dat" title "4CGS" with linespoints
EOF

set +x

#firefox file://`pwd`/output.svg &
