#!/bin/bash

set -x

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })


##############################	##############################
#				  		EJEMPLO DE USO						 #
##############################	##############################

ejemplo_uso () {
	nohup ./spatial_scalability_svc.sh in_ducks_1920x1088 > $DATA_OUT/out.spatial_scalability_svc_ducks_1920x1088 2>&1&
}



##############################	##############################
#				  	DATOS DE ENTRADA - IN - 				 #
##############################	##############################

in_ducks_1920x1088 () {
	resoluciones=(parametros120x68 parametros240x136 parametros480x272 parametros960x544 parametros1920x1088)
#	resoluciones=(parametros480x272 parametros960x544 parametros1920x1088)
	cuantificaciones=(40 40 40 40 40)

	VIDEO_NAME=ducks
	X_NATIVE=1920
	Y_NATIVE=1088
	FPS=50
	PICTURES=65
	PICTURES_TOTAL=65
	VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

	#name_original=ducks_take_off_2160p50.y4m
	#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_mobile_352x288 () {
	resoluciones=(parametros352x288 parametros352x288 parametros352x288 parametros352x288 parametros352x288)
	cuantificaciones=(50 45 40 30 25)

	VIDEO_NAME=ducks
	X_NATIVE=1920
	Y_NATIVE=1088
	FPS=50
	PICTURES=65
	PICTURES_TOTAL=65
	VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

	#name_original=ducks_take_off_2160p50.y4m
	#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}


# Llamada al dato de entrada concreto
$1



##############################	##############################
#						  ESPACIO DE TRABAJO				 #
##############################	##############################
if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi
echo $MCTF



base_dir=$PWD
out=$DATA_OUT/data-$script_name.$VIDEO_NATIVE
rm -rf $out ; mkdir $out ; mkdir $out/TIMES ; cd $out
base_data=$PWD

export DATA_OUT=\nfs\cmaturana\$base_data
if [ -z $DATA_OUT ]; then echo "Hi! \$DATA_OUT undefined!"; exit; fi


cd $base_dir

##############################	##############################
#						  DESCARGA DATOS				 	 #
##############################	##############################

# Descarga el vídeo sino lo está ya.
if [[ ! -e $DATA/$VIDEO_NATIVE ]]; then
	current_dir=$PWD
    cd $DATA
    wget $URL
    ffmpeg -i $name_original $VIDEO_NATIVE
    cd $current_dir
fi

##############################	##############################
#						  PARÁMETROS GENERALES			 	 #
##############################	##############################

mas_parametros () {
	IMAGE_SIZE=`echo "($X_DIM*$Y_DIM*1.5)/1" | bc`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOdown=down$X_DIM""x$Y_DIM""-$VIDEO_NATIVE
	VIDEOup=up$X_NATIVE""x$Y_NATIVE""-$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES.yuv
}

# Parámetros por vídeo

parametros4096x4096 () {
	X_DIM=4096
	Y_DIM=4096
	mas_parametros
}

parametros2048x2048 () {
	X_DIM=2048
	Y_DIM=2048
	mas_parametros
}

parametros1024x1024 () {
	X_DIM=1024
	Y_DIM=1024
	mas_parametros
}

parametros512x512 () {
	X_DIM=512
	Y_DIM=512
	mas_parametros
}

parametros256x256 () {
	X_DIM=256
	Y_DIM=256
	mas_parametros
}

parametros128x128 () {
	X_DIM=128
	Y_DIM=128
	mas_parametros
}

parametros64x64 () {
	X_DIM=64
	Y_DIM=64
	mas_parametros
}

parametros32x32 () {
	X_DIM=32
	Y_DIM=32
	mas_parametros
}

parametros16x16 () {
	X_DIM=16
	Y_DIM=16
	mas_parametros
}

parametros8x8 () {
	X_DIM=8
	Y_DIM=8
	mas_parametros
}

#
parametros3840x2048 () {
	X_DIM=3840
	Y_DIM=2048
	mas_parametros
}

parametros1920x1024 () {
	X_DIM=1920
	Y_DIM=1024
	mas_parametros
}

parametros960x512 () {
	X_DIM=960
	Y_DIM=512
	mas_parametros
}

parametros480x256 () {
	X_DIM=480
	Y_DIM=256
	mas_parametros
}

parametros240x128 () {
	X_DIM=240
	Y_DIM=128
	mas_parametros
}

parametros120x64 () {
	X_DIM=120
	Y_DIM=64
	mas_parametros
}

parametros60x32 () {
	X_DIM=60
	Y_DIM=32
	mas_parametros
}

#

parametros3840x2160 () { # 4k
	X_DIM=3840
	Y_DIM=2160
	mas_parametros	
}

#

parametros1920x1088 () { # 1080 p
	X_DIM=1920
	Y_DIM=1088
	mas_parametros
}

parametros960x544 () { # 1080 p
	X_DIM=960
	Y_DIM=544
	mas_parametros
}

parametros480x272 () { # 1080 p
	X_DIM=480
	Y_DIM=272
	mas_parametros
}

parametros240x136 () { # 1080 p
	X_DIM=240
	Y_DIM=136
	mas_parametros
}

parametros120x68 () { # 1080 p
	X_DIM=120
	Y_DIM=68
	mas_parametros
}

parametros60x34 () { # 1080 p
	X_DIM=60
	Y_DIM=34
	mas_parametros
}

#

parametros1280x768 () { # 720 p
	X_DIM=1280
	Y_DIM=768
	mas_parametros
}

parametros1280x736 () { # 720 p
	X_DIM=1280
	Y_DIM=736
	mas_parametros
}

parametros704x576 () {
	X_DIM=704
	Y_DIM=576
	mas_parametros
}

parametros352x288 () {
	X_DIM=352
	Y_DIM=288
	mas_parametros
}



##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

cfg_create() { # Crea los ficheros de configuración de codificación y capa para H.264/SVC
	cd $base_data

	# Crea los ficheros de codificación
	echo "# JSVM Main Configuration File." 										> main.cfg
	echo "#============================== GENERAL" 								>> main.cfg
	echo "OutputFile 		file.H264 # Bitstream file" 						>> main.cfg
	echo "FrameRate 		$FPS # Maximum frame rate [Hz]" 					>> main.cfg
	echo "FramesToBeEncoded $PICTURES # Number of frames (at input frame rate)"	>> main.cfg
	echo "#============================== CODING STRUCTURE" 					>> main.cfg
	echo "GOPSize			16 # GOP Size (at maximum frame rate)" 				>> main.cfg
	echo "BaseLayerMode		2 # Base layer mode" 								>> main.cfg
	echo "SearchMode		4 # Search mode (0:BlockSearch, 4:FastSearch)" 		>> main.cfg
	echo "SearchRange		32 # Search range (Full Pel)" 						>> main.cfg
	echo "#============================== LAYER DEFINITION" 					>> main.cfg
	echo "NumLayers			${#resoluciones[@]} # Number of layers" 			>> main.cfg

	nlayer=0
	for r in "${resoluciones[@]}"; do
		$r

		# Crea los ficheros de capas
		echo "# JSVM Layer Configuration File." 			> layer_$nlayer.cfg
		echo ""												>> layer_$nlayer.cfg
		echo "InputFile		$DATA/$VIDEOdown # Input file"	>> layer_$nlayer.cfg
		echo "SourceWidth	$X_DIM # Input frame width" 	>> layer_$nlayer.cfg
		echo "SourceHeight	$Y_DIM # Input frame height" 	>> layer_$nlayer.cfg
		echo "FrameRateIn	$FPS # Input frame rate [Hz]" 	>> layer_$nlayer.cfg
		echo "FrameRateOut	$FPS # Output frame rate [Hz]"	>> layer_$nlayer.cfg
		
		if [[ $nlayer -ge 1 ]]; then
			echo "InterLayerPred 2 # Inter-layer Pred."		>> layer_$nlayer.cfg
		fi

		echo "LayerCfg		layer_$nlayer.cfg # Layer configuration file"		>> main.cfg

		let nlayer=nlayer+1
	done

}



plot_create () { # Crea el fichero de presentación
	
	cd $base_data

	codec="H264.SVC"
	
	echo "gnuplot <<EOF" > plot.sh
	echo "set terminal svg" >> plot.sh
	echo "set output \"$codec.$VIDEO_NATIVE.svg\"" >> plot.sh
	echo "set grid" >> plot.sh
	echo "set title \"$codec - $VIDEO_NATIVE\"" >> plot.sh
	echo "set xlabel \"bit-rate\"" >> plot.sh
	echo "set ylabel \"RMSE\"" >> plot.sh
	echo "set xrange [0:]" >> plot.sh
	echo "set yrange [0:]" >> plot.sh
	echo "plot \"resultadoFINAL.dat\" using 1:2 title \"$codec\"  with linespoints linewidth 2, \\"	>> plot.sh
	echo "\"MCLTW.dat\" using 1:2 title \"MCLTW\"  with linespoints linewidth 2 " >> plot.sh
	echo "EOF" >> plot.sh
	chmod 777 plot.sh
}

##############################	##############################
#							 MAIN							 #
##############################	##############################



# Crea los ficheros de configuración de codificación y capa para H.264/SVC
cfg_create


plot_create

H264AVCEncoderLibTestStatic -pf main.cfg -lqp 0 50 -lqp 1 45 -lqp 2 40 3 35 -lqp 4 30 > outdisplay


comentario () {
# Downsampling. Reescalado del vídeo.
for r in "${resoluciones[@]}"; do
	$r

	if [[ ! -e $DATA/$VIDEOdown ]]; then
		(time DownConvertStatic $X_NATIVE $Y_NATIVE $DATA/$VIDEO_NATIVE $X_DIM $Y_DIM $DATA/$VIDEOdown) 2>> $base_data/TIMES/DownSamplin.$X_DIM""x$Y_DIM.dat
	fi
done




# Codificación
cd $base_data
#H264AVCEncoderLibTestStatic -pf main.cfg -lqp 0 40 -lqp 1 40 -lqp 2 40 -lqp 3 40 -lqp 4 40 > outdisplay
(time H264AVCEncoderLibTestStatic -pf main.cfg -lqp 0 40 -lqp 1 40 -lqp 2 40) 2>> $base_data/TIMES/H264AVCEncoderLibTestStatic.dat



# Información de capas
BitStreamExtractorStatic file.H264 > info.H264

# Extracción de capas
(time BitStreamExtractorStatic file.H264 extract_capa4 -sl 4) 2>> $base_data/TIMES/extract_capa4.dat # Equivalente a: BitStreamExtractorStatic file.H264 extract_capa4_lt -l 0 -t 4  ///  -sl id_layer  /// -l x -t x columnas DTQ
(time BitStreamExtractorStatic file.H264 extract_capa9 -sl 9) 2>> $base_data/TIMES/extract_capa9.dat
(time BitStreamExtractorStatic file.H264 extract_capa14 -sl 14) 2>> $base_data/TIMES/extract_capa14.dat

	# Extrae la capa n bajo criterios de resolución y bit-rate (truncando capas)
	# BitStreamExtractorStatic file.H264 extracted_eQL -e $E_PARAMETROS:$3 -ql

# Reconstruye el .yuv
(time H264AVCDecoderLibTestStatic extract_capa4 capa4.yuv) 2>> $base_data/TIMES/capa4.yuv.dat
(time H264AVCDecoderLibTestStatic extract_capa9 capa9.yuv) 2>> $base_data/TIMES/capa9.yuv.dat
(time H264AVCDecoderLibTestStatic extract_capa14 capa14.yuv) 2>> $base_data/TIMES/capa14.yuv.dat


# Upsampling.
(time DownConvertStatic 480 272 capa4.yuv 1920 1088 up_capa4.yuv) 2>> $base_data/TIMES/up_capa4.yuv.dat
(time DownConvertStatic 960 544 capa9.yuv 1920 1088 up_capa9.yuv) 2>> $base_data/TIMES/up_capa9.yuv.dat
(time DownConvertStatic 1920 1088 capa14.yuv 1920 1088 up_capa14.yuv) 2>> $base_data/TIMES/up_capa14.yuv.dat

# Cálculo bit-rate y RMSE
bytes=`wc -c < extract_capa4`
DURATION=0.1
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=$DATA/oldTownCross_1280x720x50x420x500.yuv --file_B=capa4.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q50'\t\t'$bytes' \t'$rate' \t'$rmse >> oldTownCross_720.dat
bytes=`wc -c < extract_capa9`
DURATION=0.1
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=$DATA/oldTownCross_1280x720x50x420x500.yuv --file_B=capa9.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q45'\t\t'$bytes' \t'$rate' \t'$rmse >> oldTownCross_720.dat
bytes=`wc -c < extract_capa14`
DURATION=0.1
rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
rmse=`snr --file_A=$DATA/oldTownCross_1280x720x50x420x500.yuv --file_B=capa14.yuv 2> /dev/null | grep RMSE | cut -f 3`
echo -e Q40'\t\t'$bytes' \t'$rate' \t'$rmse >> oldTownCross_720.dat
gedit mobile_cif.dat

rmse=`snr --file_A=$DATA/down1920x1088-ducks_1920x1088x50x420x65.yuv --file_B=up_capa4.yuv 2> /dev/null | grep RMSE | cut -f 3`
rmse=`snr --file_A=$DATA/down1920x1088-ducks_1920x1088x50x420x65.yuv --file_B=up_capa9.yuv 2> /dev/null | grep RMSE | cut -f 3`
rmse=`snr --file_A=$DATA/down1920x1088-ducks_1920x1088x50x420x65.yuv --file_B=up_capa14.yuv 2> /dev/null | grep RMSE | cut -f 3`

# Libera espacio
#rm $base_data/$r.$c/$r.$c.yuv
#rm $DATA/$VIDEOup

# Resultados
echo -e $r.$c' \t\t'$bytes' \t'$rate' \t'$rmse >> $base_data/resultadoFINAL.dat




# Crea el fichero de presentación
plot_create
./plot.sh


# xfig
cat >> $base_data/$VIDEO_NATIVE.gpt << EOF
set terminal fig color fontsize 12
set output "$VIDEO_NATIVE.fig"
set yrange [0:]
set xrange[0:]
set title "SVC - $VIDEO_NATIVE"
set xlabel "Kbps"
set ylabel "RMSE"
plot "resultadoFINAL.dat" using 1:2 title "SVC"  with linespoints linewidth 2, \
"MCLTW.dat" using 1:2 title "MCLTW"  with linespoints linewidth 2 
EOF



echo ""
echo " Para una gráfica comparativa de H264/AVC y LTW, copie su MCLTW.dat en: $base_data"
echo " y ejecute > ./plot.sh"
echo ""



}


set +x
#firefox file://`pwd`/output.svg &

