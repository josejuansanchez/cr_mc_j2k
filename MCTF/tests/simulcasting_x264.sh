#!/bin/bash

set -x


##############################	##############################
#				  		EJEMPLO DE USO						 #
##############################	##############################

ejemplo_uso () { 
	nohup ./simulcasting_x264.sh in_ducks_3840x2048 > $DATA_OUT/out.simulcasting_x264_ducks_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_intotree_3840x2048 > $DATA_OUT/out.simulcasting_x264_intotree_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_intotree_BW_3840x2048 > $DATA_OUT/out.simulcasting_x264_intotree_BW_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_oldtowncross_3840x2048 > $DATA_OUT/out.simulcasting_x264_oldtowncross_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_crowdrun_3840x2048 > $DATA_OUT/out.simulcasting_x264_crowdrun_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_parkjoy_3840x2048 > $DATA_OUT/out.simulcasting_x264_parkjoy_3840x2048 2>&1&
	nohup ./simulcasting_x264.sh in_sun_4096x4096 > $DATA_OUT/out.simulcasting_x264_sun_4096x4096 2>&1&

	nohup ./simulcasting_x264.sh in_ducks_1920x1088 > $DATA_OUT/out.simulcasting_x264_ducks_1920x1088 2>&1&
}



##############################	##############################
#				  	DATOS DE ENTRADA - IN - 				 #
##############################	##############################


in_ducks_1920x1088 () {
	# resoluciones=(parametros1920x1088 parametros960x544 parametros480x272 parametros240x136 parametros120x68)
	resoluciones=(parametros1920x1088 parametros960x544 parametros480x272)
	cuantificaciones=(64 60 56 52 48) # (48 44 40 36 32)

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


in_ducks_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(56 52 48 44 42) # (40 36 32 28 24)

    VIDEO_NAME=ducks
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_intotree_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(40 36 32 28 24)

    VIDEO_NAME=intotree
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_intotree_BW_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(40 36 32 28 24)

    VIDEO_NAME=intotree_BW
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_oldtowncross_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(40 36 32 28 24)

    VIDEO_NAME=oldtowncross
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_crowdrun_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(40 36 32 28 24)

    VIDEO_NAME=crowdrun
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_parkjoy_3840x2048 () {
    resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros120x64 parametros60x32)
    cuantificaciones=(40 36 32 28 24)

    VIDEO_NAME=parkjoy
    X_NATIVE=3840
    Y_NATIVE=2048
    FPS=50
    PICTURES=65
    PICTURES_TOTAL=65
    VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m
}

in_sun_4096x4096 () {
	resoluciones=(parametros4096x4096 parametros2048x2048 parametros1024x1024 parametros512x512 parametros256x256 parametros128x128 parametros64x64 parametros32x32 parametros16x16 parametros8x8)
	cuantificaciones=(40 36 32 28 24)

	VIDEO_NAME=sun
	X_NATIVE=4096
	Y_NATIVE=4096
	FPS=30
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
if [ -z $DATA_OUT ]; then echo "Hi! \$DATA_OUT undefined!"; exit; fi
echo $MCTF

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })



lista_cuantificaciones="Q"
ELEMENTS=${#cuantificaciones[@]}
for (( i=0;i<$ELEMENTS;i++)); do
    lista_cuantificaciones=$lista_cuantificaciones"."${cuantificaciones[${i}]}
done



base_dir=$PWD
out=$DATA_OUT/data-$script_name.$VIDEO_NATIVE.$lista_cuantificaciones
rm -rf $out ; mkdir $out ; mkdir $out/TIMES ; cd $out
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


plot_create () { # Crea el fichero de presentación

	cd $base_data

	echo "gnuplot <<EOF" > plot.sh
	echo "set terminal svg" >> plot.sh
	echo "set output \"SIMULTICAST.$VIDEO_NAME.svg\"" >> plot.sh
	echo "set grid" >> plot.sh
	echo "set title \"$VIDEO_NATIVE\"" >> plot.sh
	echo "set xlabel \"bit-rate\"" >> plot.sh
	echo "set ylabel \"RMSE\"" >> plot.sh
	echo "set xrange [0:]" >> plot.sh
	echo "set yrange [0:]" >> plot.sh
	echo "plot \"resultadoFINAL.dat\" using 1:2 title \"SIMULCAST x264\"  with linespoints linewidth 2, \\"	>> plot.sh
	for r in "${resoluciones[@]}"; do
		$r
		echo "\"$r.dat\" using 3:4 title \"$r x264\"  with linespoints linewidth 1, \\"	>> plot.sh
	done
	echo "\"MCLTW.dat\" using 1:2 title \"MCLTW\"  with linespoints linewidth 2 " >> plot.sh
	echo "EOF" >> plot.sh
	chmod 777 plot.sh
}

##############################	##############################
#							 MAIN							 #
##############################	##############################


# Downsampling. Reescalado del vídeo.
for r in "${resoluciones[@]}"; do
	$r

	if [[ ! -e $DATA/$VIDEOdown ]]; then
		(time DownConvertStatic $X_NATIVE $Y_NATIVE $DATA/$VIDEO_NATIVE $X_DIM $Y_DIM $DATA/$VIDEOdown) 2>> $base_data/TIMES/DownSamplin.$X_DIM""x$Y_DIM.dat
		# (time x264 --vf resize )
	fi
done




# Codificaciones x264
declare -a array_rate
declare -a array_rmse

contador_c=0
for c in "${cuantificaciones[@]}"; do

	contador_r=0
	for r in "${resoluciones[@]}"; do
	$r

		mkdir $base_data/$r.$c ; cd $base_data/$r.$c

		# Codificación
		(time x264 --crf $c --sar $X_DIM:$Y_DIM --fps $FPS.0 --frames $PICTURES -o $r.$c.avi $DATA/$VIDEOdown) 2>> $base_data/TIMES/x264.$X_DIM""x$Y_DIM""_$c.dat

		# Reconstrucción
		ffmpeg -y -r $FPS -i $r.$c.avi $r.$c.yuv
		# Hacemos que la primera imagen de la secuencia descomprimida sea igual a a segunda porque ffmpeg inexplicablemente, para este número de imágenes, no genera la imagen 0 en la salida.
		dd if=$r.$c.yuv of=aux bs=$IMAGE_SIZE count=1
		cat $r.$c.yuv >> aux
		mv aux $r.$c.yuv

		# Upsampling.
		(time DownConvertStatic $X_DIM $Y_DIM $r.$c.yuv $X_NATIVE $Y_NATIVE $DATA/$VIDEOup) 2>> $base_data/TIMES/UpSamplin.$X_DIM""x$Y_DIM""_$c.dat

		# Cálculo bit-rate y RMSE
		bytes=`wc -c < $r.$c.avi`
		rate=`echo "$bytes*8/$DURATION/1000" | bc -l`
		rmse=`snr --block_size=$IMAGE_SIZE --file_A=$DATA/$VIDEO_NATIVE --file_B=$DATA/$VIDEOup 2> /dev/null | grep RMSE | cut -f 3`

		# Libera espacio
		#rm $base_data/$r.$c/$r.$c.yuv
		#rm $DATA/$VIDEOup

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
	echo -e $E_rate'\t'$E_rmse >> $base_data/resultadoFINAL.dat

	let contador_c=contador_c+1
done


# Crea el fichero de presentación
plot_create
./plot.sh



# xfig
cat >> $base_data/$VIDEO_NATIVE.gpt << EOF
set terminal fig color fontsize 12
set output "$VIDEO_NATIVE.fig"
set yrange [0:]
set xrange[0:]
set title "x264 - $VIDEO_NATIVE"
set xlabel "Kbps"
set ylabel "RMSE"
plot "resultadoFINAL.dat" using 1:2 title "SIMULCAST x264"  with linespoints linewidth 2, \
"MCLTW.dat" using 1:2 title "MCLTW"  with linespoints linewidth 2 
EOF



echo ""
echo " Para una gráfica comparativa de x264 y LTW, copie su MCLTW.dat en: $base_data"
echo " y ejecute > ./plot.sh"
echo ""

set +x
#firefox file://`pwd`/output.svg &

