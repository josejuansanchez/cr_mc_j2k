#!/bin/bash

set -x



##############################	##############################
#						  PARÁMETROS ESPECÍFICOS		 	 #
##############################	##############################

resoluciones=(parametros4096x4096x30 parametros2048x2048x30 parametros1024x1024x30 parametros512x512x30 parametros256x256x30)
cuantificaciones=(40 36 32 28 24)

VIDEO_NAME=sun
X_NATIVE=4096
Y_NATIVE=4096
FPS_NATIVE=30
PICTURES_TOTAL=129
VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS_NATIVE""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m


##############################	##############################
#						  ESPACIO DE TRABAJO				 #
##############################	##############################

base_dir=$PWD
out=data-${0##*/}-$VIDEO_NATIVE
rm -rf $out ; mkdir $out ; cd $out
base_data=$PWD

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

PICTURES=129

# Parámetros por vídeo
parametros4096x4096x30 () {
	X_DIM=4096
	Y_DIM=4096
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros2048x2048x30 () {
	X_DIM=2048
	Y_DIM=2048
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros1024x1024x30 () {
	X_DIM=1024
	Y_DIM=1024
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros512x512x30 () {
	X_DIM=512
	Y_DIM=512
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros256x256x30 () {
	X_DIM=256
	Y_DIM=256
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros128x128x30 () {
	X_DIM=128
	Y_DIM=128
	FPS=30
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

#
parametros2048x50 () {
	X_DIM=3840
	Y_DIM=2048
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros1024x50 () {
	X_DIM=1920
	Y_DIM=1024
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros512x50 () {
	X_DIM=960
	Y_DIM=512
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros256x50 () {
	X_DIM=480
	Y_DIM=256
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros128x50 () {
	X_DIM=240
	Y_DIM=128
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

#
parametros288x50 () {
	X_DIM=352
	Y_DIM=288
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l` # segundos
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros576x50 () {
	X_DIM=704
	Y_DIM=576
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros736x50 () { # 720 p
	X_DIM=1280
	Y_DIM=736
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros768x50 () { # 720 p
	X_DIM=1280
	Y_DIM=768
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros1080x50 () { # 1080 p
	X_DIM=1920
	Y_DIM=1080
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros1088x50 () { # 1080 p
	X_DIM=1920
	Y_DIM=1088
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros1088x25 () { # 1080 p
	X_DIM=1920
	Y_DIM=1088
	FPS=25
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros2160x50 () { # 4k
	X_DIM=3840
	Y_DIM=2160
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}

parametros2048x50 () { # 4k
	X_DIM=3840
	Y_DIM=2048
	FPS=50
	BLOCK_SIZE=`echo "$X_DIM*$Y_DIM*1.5" | bc -l`
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	VIDEO=$VIDEO_NAME""_$X_DIM""x$Y_DIM""x$FPS""x420x$PICTURES_TOTAL.yuv
	VIDEOup=up$X_NATIVE""x$Y_NATIVE_$VIDEO
}


##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

cfg_create() { # Crea los ficheros de configuración de codificación y capa para H.264/SVC

for r in "${resoluciones[@]}"; do
	$r
	for c in "${cuantificaciones[@]}"; do
		
		mkdir $base_data/$r.$c ; cd $base_data/$r.$c

		# Crea los ficheros de capas (aquí sólo una)
		echo "# JSVM Layer Configuration File." 			> layer.$r.$c.cfg
		echo "" 											>> layer.$r.$c.cfg
		echo "InputFile		$DATA/$VIDEO # Input file" 		>> layer.$r.$c.cfg
		echo "SourceWidth	$X_DIM # Input frame width" 	>> layer.$r.$c.cfg
		echo "SourceHeight	$Y_DIM # Input frame height" 	>> layer.$r.$c.cfg
		echo "FrameRateIn	$FPS # Input frame rate [Hz]" 	>> layer.$r.$c.cfg
		echo "FrameRateOut	$FPS # Output frame rate [Hz]"	>> layer.$r.$c.cfg

		# Crea los ficheros de codificación
		echo "# JSVM Main Configuration File." 													> main.$r.$c.cfg
		echo "#============================== GENERAL" 											>> main.$r.$c.cfg
		echo "OutputFile 		$r.$c.264 # Bitstream file" 									>> main.$r.$c.cfg
		echo "FrameRate 		$FPS # Maximum frame rate [Hz]" 								>> main.$r.$c.cfg
		echo "FramesToBeEncoded 129 # Number of frames (at input frame rate)" 					>> main.$r.$c.cfg
		echo "#============================== CODING STRUCTURE" 								>> main.$r.$c.cfg
		echo "GOPSize			16 # GOP Size (at maximum frame rate)" 							>> main.$r.$c.cfg
		echo "BaseLayerMode		2 # Base layer mode (0,1: AVC compatible, 2: AVC w subseq SEI)" >> main.$r.$c.cfg
		echo "SearchMode		4 # Search mode (0:BlockSearch, 4:FastSearch)" 					>> main.$r.$c.cfg
		echo "SearchRange		32 # Search range (Full Pel)" 									>> main.$r.$c.cfg
		echo "#============================== LAYER DEFINITION" 								>> main.$r.$c.cfg
		echo "NumLayers			1 # Number of layers" 											>> main.$r.$c.cfg
		echo "LayerCfg			layer.$r.$c.cfg # Layer configuration file" 					>> main.$r.$c.cfg

	done
done
}


plot_create() { # Crea el fichero de presentación

	cd $base_data

	echo "gnuplot <<EOF"									> plot.sh
	echo "set terminal svg"									>> plot.sh
	echo "set output \"MULTICASTING.$VIDEO_NAME.svg\""		>> plot.sh
	echo "set grid"											>> plot.sh
	echo "set title \"$VIDEO_NATIVE\""						>> plot.sh
	echo "set xlabel \"bit-rate\""							>> plot.sh
	echo "set ylabel \"RMSE\""								>> plot.sh
	echo "set xrange [0:]"									>> plot.sh
	echo "set yrange [0:]"									>> plot.sh
	echo "plot \"resultadoSimulcasting.dat\" using 1:2 title \"SIMULCAST x264\"  with linespoints linewidth 2, \\"	>> plot.sh
	for r in "${resoluciones[@]}"; do
		$r
		echo "\"$r.dat\" using 3:4 title \"$r x264\"  with linespoints linewidth 1, \\"									>> plot.sh
	done
	echo "\"MCLTW.dat\" using 1:2 title \"MULTICAST MCLTW\"  with linespoints linewidth 2 "							>> plot.sh
	echo "EOF"																											>> plot.sh
	chmod 777 plot.sh
}

##############################	##############################
#							 MAIN							 #
##############################	##############################


# Downsampling. Reescalado del vídeo.
for r in "${resoluciones[@]}"; do
	$r

	if [[ ! -e $DATA/$VIDEO ]]; then
		DownConvertStatic $X_NATIVE $Y_NATIVE $DATA/$VIDEO_NATIVE $X_DIM $Y_DIM $DATA/$VIDEO
	fi
done



# Crea los ficheros de configuración de codificación y capa para H.264/SVC
cfg_create


# Codificaciones H.264/AVC
declare -a array_rate
declare -a array_rmse

contador_c=0
for c in "${cuantificaciones[@]}"; do

	contador_r=0
	for r in "${resoluciones[@]}"; do
	$r

		cd $base_data/$r.$c

		# Codificación
		H264AVCEncoderLibTestStatic -pf main.$r.$c.cfg -lqp 0 $c > outdisplay_$r.$c
		mv rec.yuv $r.$c.yuv

		# Upsampling.
		DownConvertStatic $X_DIM $Y_DIM $r.$c.yuv $X_NATIVE $Y_NATIVE $DATA/$VIDEOup # samplear a la misma resolución no reporta cambios.
		

		# Cálculo bit-rate y RMSE
		bytes=`wc -c < $r.$c.264`
		rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
		rmse=`snr --file_A=$DATA/$VIDEO_NATIVE --file_B=$DATA/$VIDEOup 2> /dev/null | grep RMSE | cut -f 3`

		rm $base_data/$r.$c/*.yuv # Libera espacio

		# Cálculo bit-rate y RMSE acumulados
		array_rate[$contador_r]=$rate
		array_rmse[$contador_r]=$rmse

		# Resultados
		echo -e $r.$c' \t\t'$bytes' \t'$rate' \t'$rmse >> $base_data/$r.dat
		
		let contador_r=contador_r+1
	done

	# RATE acumulado
	E_rate=0
	for i in "${array_rate[@]}"; do 
		E_rate=`echo "$E_rate+$i" | bc -l`
	done

	# RMSE promedio
	E_rmse=0
	for i in "${array_rmse[@]}"; do 
		E_rmse=`echo "$E_rmse+$i" | bc -l`
	done
	E_rmse=`echo "$E_rmse/${#array_rmse[@]}" | bc -l`

	# Resultados
	echo -e $E_rate'\t'$E_rmse >> $base_data/resultadoSimulcasting.dat

	let contador_c=contador_c+1
done


# Crea el fichero de presentación
plot_create

./plot.sh

echo ""
echo " Para una gráfica comparativa de AVC y LTW, copie su MCLTW.dat en: $base_data"
echo " y ejecute > ./plot.sh"
echo ""

set +x
#firefox file://`pwd`/output.svg &

