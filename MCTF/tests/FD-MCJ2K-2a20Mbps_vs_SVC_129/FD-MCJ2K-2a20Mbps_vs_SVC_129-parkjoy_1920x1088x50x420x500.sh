#!/bin/bash

# AVISO: En caso de cambiar las cuantificaciones, es necesario eliminar/reubicar los codestream svc en $in. Para que el script no los encuentre y vuelva a generarlos.
set -x

out=data-${0##*/}
in=$PWD/SVC_4CGS_cfg/1080p/parkjoy

# DATA declarada la variable DATA en el shell
#VIDEO=parkjoy_1920x1080x50x420x500
VIDEO=parkjoy_1920x1088x50x420x500

# Parámetros video
IBS=32 # Initial block_size
FBS=32 # Final block size
X_DIM=1920
Y_DIM=1088
FPS=50
PICTURES=129
DURATION=`echo "$PICTURES/$FPS" | bc -l` 	#segundos


# Parámetros experimentos para X gops
GOPS=4
GOPSsvc=1
GOPsize32=32
GOPsize16=16
	#MCJ2K
	TRL=6
	BLOCK_SIZE=3133440 # 3110440>1088p		3110400>1080p	152064>CIF
	CAPAS=32
		#SLOPES para CIF entre KBPS_MIN y KBPS_MAX (Se pueden adaptar estos valores a cualquier resolución)
		slope_ini=44700 #rate_mcj2k=2069.9375
		slope_fin=43800 #rate_mcj2k=20364.9625 + coste capas

		slope_corte1=44260 #rate_mcj2k=6130.40625
		slope_corte2=44038 #rate_mcj2k=10211.875
		slope_corte3=43800 #rate_mcj2k=20364.9625

	#SVC
	CUANTIFICACION_0=50
	CUANTIFICACION_1=46
	CUANTIFICACION_2=42
	CUANTIFICACION_3=38
	E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS

# Variables de referencia a la curva
KBPS_MIN=2045 #100
KBPS_MAX=20450 #1000

KBPS_CORTE_1=6135 #300
KBPS_CORTE_2=10225 #500
KBPS_CORTE_3=20450 #1000



#Comprueba que está o descarga el video
if [[ ! -e $DATA/$VIDEO.yuv ]]; then
	current_dir=$PWD
	cd $DATA
	wget http://media.xiph.org/video/derf/y4m/park_joy_1080p50.y4m
	mencoder park_joy_1080p50.y4m -ovc raw -of rawvideo -vf format=i420 -o $VIDEO.yuv
	cd $current_dir
fi

# Prepara espacio de trabajo
rm -rf $out
mkdir $out ; mkdir $out/testeo ; mkdir $out/gops ; mkdir $out/MCJ2K ; mkdir $out/SVC
cd $out

base_dir=$PWD # $out

cd $base_dir

comentario () {
	ln -s $DATA/$VIDEO.yuv low_0
	#compresion
	mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'43797'"' --pictures=$PICTURES --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM #> outcompress
    rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRL --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3` #> outinfo
}




##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

############################## corta_gops. Comentarios ej = 32
corta_gops () {
	n_gop=0
	count=`echo "$2+1" | bc` # count = 33
	while [ $n_gop -lt $3 ]; do
		skip=`echo "$2*$n_gop" | bc` # skip = 0, 32, 64, 96, ...
		let n_gop=n_gop+1
		dd if=$1 of=gops/$VIDEO.$n_gop.$2.yuv count=$count bs=$BLOCK_SIZE skip=$skip
	done
}

############################## MCJ2K
funcion_mcj2k () { echo "Encoding with J2K for slope $2 and $TRL TRLs"
	rm *

	#localiza el video
	ln -s $1 low_0

	#compresion
	mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$2'"' --pictures=$PICTURES --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM #> outcompress
    rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRL --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3` #> outinfo

	#expansión
	rm -rf tmp ; mkdir tmp ; cp *.mjc *type* tmp ; cd tmp
	mcj2k expand --block_size=$IBS --block_size_min=$FBS --pictures=$PICTURES --layers=$3 --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM #> outexpand
	#mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
	cd ..

	#FD
	#snr --file_A=$1 --file_B=tmp/low_0 2> PSNR_mcj2k_gop$n_gop.dat
	#RD
	#rmse_mcj2k=`snr --file_A=$1 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
    #echo -e $rate_mcj2k'\t'$rmse_mcj2k > mcj2k.dat
}

############################## SVC
funcion_svc(){

	#Extrae la capa n
	BitStreamExtractorStatic $in/$2 extracted_e -e $E_PARAMETROS:$3 #> infos/info_extracted$n

	#Reconstruye el .yuv
	H264AVCDecoderLibTestStatic extracted_e e.yuv #> infos/info_yuv$n

	#Calcula bit-rate
	bytes=`wc -c < extracted_e`
	rate_svc=`echo "$bytes*8/$DURATION/1000" | bc -l`

	#testeo
	#echo -e extracted_e_gop$n_gop.corte$3'\t'bytes: $bytes'\t'kbps: $rate_svc >> $base_dir/testeo/svc.dat
	#Calcula RMSE
    #snr --file_A=$1 --file_B=e.yuv 2> $base_dir/PSNR_svc_gop$n_gop.corte$3.dat

	#testeo
	echo -e extracted_e_8gops.corte$3'\t'bytes: $bytes'\t'kbps: $rate_svc >> $base_dir/testeo/svc.dat

	#Calcula RMSE
	snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=e.yuv 2> $base_dir/PSNR_svc_gops.corte$3.dat
}

############################## SVC con Quality Layers
funcion_svc_ql(){

	#Extrae la capa n
	BitStreamExtractorStatic $in/$2 extracted_eQL -e $E_PARAMETROS:$3 -ql

	#Reconstruye el .yuv
	H264AVCDecoderLibTestStatic extracted_eQL e.yuv #> infos/info_yuv$n

	#Calcula bit-rate
	bytes=`wc -c < extracted_eQL`
	rate_svc=`echo "$bytes*8/$DURATION/1000" | bc -l`

	#testeo
	#echo -e extracted_eQL_gop$n_gop.corte$3' \t'bytes: $bytes'\t'kbps: $rate_svc >> $base_dir/testeo/svcQL.dat
	#Calcula RMSE
    #snr --file_A=$1 --file_B=e.yuv 2> $base_dir/PSNR_svcQL_gop$n_gop.corte$3.dat

	#testeo
	echo -e extracted_eQL_8gops.corte$3' \t'bytes: $bytes'\t'kbps: $rate_svc >> $base_dir/testeo/svcQL.dat
	
	#Calcula RMSE
    snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=e.yuv 2> $base_dir/PSNR_svcQL_gops.corte$3.dat

}

############################## Establece la posición de capas (slopes equidistantes)  # Los slopes son los mismos para todos los gops 
cortes_kbps_mcj2k () {

	distancia_slopes=`echo "($slope_ini-$slope_fin)/($CAPAS)" | bc`
	siguiente_slope=$slope_ini
	slopes_max=$slope_ini
	n_capa=1
	while [ $n_capa -le $CAPAS ]; do

		funcion_mcj2k $1 $slopes_max $CAPAS
		rate_mcj2k=`echo "$rate_mcj2k/1" | bc` # Quita decimales que dan error con el if

			#testeo	
			echo -e capa: $n_capa '\t'kbps: $rate_mcj2k >> $base_dir/testeo/slopes_mcj2k.dat

		if [ $rate_mcj2k -lt $2 ]; then
			slopes_1=$slopes_max
			snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_gops.corte$2.dat
		fi
		if [ $rate_mcj2k -lt $3 ]; then
			slopes_2=$slopes_max
			snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_gops.corte$3.dat
		fi
		if [ $rate_mcj2k -lt $4 ]; then
			slopes_3=$slopes_max
			snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_gops.corte$4.dat
		fi

		# Añade capa
		if [ $n_capa -lt $CAPAS ]; then
			siguiente_slope=`echo "($siguiente_slope-$distancia_slopes)" | bc`
			slopes_max="$slopes_max,$siguiente_slope"
		fi
	let n_capa=n_capa+1
	done
}

############################## secuenciador_gops
secuenciador_gops () {
	frame_suelto=2
	contador=0
	columna=1
	n_gop=1
	while [ $n_gop -le $4 ]; do
		for cifra in $(cat $1""$n_gop.corte$2.dat); do
			if [ $frame_suelto -ge 2 ]; then
				if [ $columna -eq 2 ]; then
					echo -e $contador'\t'$cifra >> $3
					let contador=contador+1
					columna=1
				else
					columna=2
				fi
			fi
			let frame_suelto=frame_suelto+1
		done
	let n_gop=n_gop+1
	frame_suelto=0
	done
}







##############################	##############################
#							 MAIN							 #
##############################	##############################

############################## corta
cd $base_dir
corta_gops $DATA/$VIDEO.yuv 128 1

############################## cortes_kbps_mcj2k() para X capas para X gops
cd MCJ2K
# Clasifica los slopes para cada corte
n_gop=1

cortes_kbps_mcj2k $base_dir/gops/$VIDEO.1.128.yuv $KBPS_CORTE_1 $KBPS_CORTE_2 $KBPS_CORTE_3
#testeo	
echo -e "n capa:   1     2     3     4     5     6     7     8     9     10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32"  >> $base_dir/testeo/slopes_mcj2k.dat
echo -e slopes 1: $slopes_1'\n'slopes 2: $slopes_2'\n'slopes 3: $slopes_3 '\n' >> $base_dir/testeo/slopes_mcj2k.dat


############################## cortes_kbps_mcj2k() para X capas para X gops

funcion_mcj2k $base_dir/gops/$VIDEO.1.128.yuv $slope_corte1 1
echo -e capa: 1 '\t'kbps: $rate_mcj2k >> $base_dir/testeo/slope_mcj2k.dat #testeo
snr --block_size=$BLOCK_SIZE --file_A=$base_dir/gops/$VIDEO.1.128.yuv --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_1.dat

funcion_mcj2k $base_dir/gops/$VIDEO.1.128.yuv $slope_corte2 1
echo -e capa: 2 '\t'kbps: $rate_mcj2k >> $base_dir/testeo/slope_mcj2k.dat #testeo
snr --block_size=$BLOCK_SIZE --file_A=$base_dir/gops/$VIDEO.1.128.yuv --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_2.dat

funcion_mcj2k $base_dir/gops/$VIDEO.1.128.yuv $slope_corte3 1
echo -e capa: 3 '\t'kbps: $rate_mcj2k >> $base_dir/testeo/slope_mcj2k.dat #testeo
snr --block_size=$BLOCK_SIZE --file_A=$base_dir/gops/$VIDEO.1.128.yuv --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_3.dat


cd $base_dir

############################## Genera la compresion SVC para 129 frames
cd $in

if [[ ! -e CGS_4layers.8gops.16 ]]; then
	H264AVCEncoderLibTestStatic -pf main_8gops.cfg -lqp 0 $CUANTIFICACION_0 -lqp 1 $CUANTIFICACION_1 -lqp 2 $CUANTIFICACION_2 -lqp 3 $CUANTIFICACION_3 > outdisplay_8gops # Unas cuantificaciones a máximo TRL sale de 100 a 1000 Kbps para el gop 1
fi

if [[ ! -e CGS_4layers_QL.8gops.16 ]]; then
	QualityLevelAssignerStatic -in CGS_4layers.8gops.16 -org 0 $base_dir/gops/$VIDEO.1.128.yuv -out CGS_4layers_QL.8gops.16
fi

#testeo
BitStreamExtractorStatic CGS_4layers.8gops.16 > $base_dir/testeo/outinfo_$CUANTIFICACION_0.$CUANTIFICACION_1.$CUANTIFICACION_2.$CUANTIFICACION_3 # info del primer gop de container: cuantificaciones vs kbps. Interesante primera capa máx TRL = 100. Última capa = 1000
BitStreamExtractorStatic CGS_4layers_QL.8gops.16 > $base_dir/testeo/outinfo_QL_$CUANTIFICACION_0.$CUANTIFICACION_1.$CUANTIFICACION_2.$CUANTIFICACION_3

cd $base_dir

############################## Cortes kbps para SVC en los 129 frames
cd SVC

funcion_svc $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers.8gops.16 $KBPS_CORTE_1
funcion_svc $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers.8gops.16 $KBPS_CORTE_2
funcion_svc $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers.8gops.16 $KBPS_CORTE_3

funcion_svc_ql $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers_QL.8gops.16 $KBPS_CORTE_1
funcion_svc_ql $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers_QL.8gops.16 $KBPS_CORTE_2
funcion_svc_ql $base_dir/gops/$VIDEO.1.128.yuv CGS_4layers_QL.8gops.16 $KBPS_CORTE_3

cd $base_dir


############################## Gráficas MCJ2K vs SVC vs SVCql
gnuplot <<EOF
set terminal svg
set output "$KBPS_CORTE_1.svg"
set grid
set title "$VIDEO a corte $KBPS_CORTE_1"
set xtics "16,32,48,64,80,96,112,128,144"
set xlabel "Frames"
set ylabel "PSNR [dB]"
plot	"PSNR_mcj2k_gops.corte$KBPS_CORTE_1.dat"		with linespoints title "MCJ2K 32 slopes", \
		"PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_1.dat"	with linespoints title "MCJ2K 1 slope", \
		"PSNR_svc_gops.corte$KBPS_CORTE_1.dat"			with linespoints title "SVC", \
		"PSNR_svcQL_gops.corte$KBPS_CORTE_1.dat"		with linespoints title "SVC_QL"
EOF

gnuplot <<EOF
set terminal svg
set output "$KBPS_CORTE_2.svg"
set grid
set title "$VIDEO a corte $KBPS_CORTE_2"
set xtics "16,32,48,64,80,96,112,128,144"
set xlabel "Frames"
set ylabel "PSNR [dB]"
plot	"PSNR_mcj2k_gops.corte$KBPS_CORTE_2.dat"		with linespoints title "MCJ2K 32 slopes", \
		"PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_2.dat"	with linespoints title "MCJ2K 1 slope", \
		"PSNR_svc_gops.corte$KBPS_CORTE_2.dat"			with linespoints title "SVC", \
		"PSNR_svcQL_gops.corte$KBPS_CORTE_2.dat"		with linespoints title "SVC_QL"
EOF

gnuplot <<EOF
set terminal svg
set output "$KBPS_CORTE_3.svg"
set grid
set title "$VIDEO a corte $KBPS_CORTE_3"
set xtics "16,32,48,64,80,96,112,128,144"
set xlabel "Frames"
set ylabel "PSNR [dB]"
plot	"PSNR_mcj2k_gops.corte$KBPS_CORTE_3.dat"		with linespoints title "MCJ2K 32 slopes", \
		"PSNR_mcj2k_1slope_gops.corte$KBPS_CORTE_3.dat"	with linespoints title "MCJ2K 1 slope", \
		"PSNR_svc_gops.corte$KBPS_CORTE_3.dat"			with linespoints title "SVC", \
		"PSNR_svcQL_gops.corte$KBPS_CORTE_3.dat"		with linespoints title "SVC_QL"
EOF


set +x


#firefox file://`pwd`/output.svg &
