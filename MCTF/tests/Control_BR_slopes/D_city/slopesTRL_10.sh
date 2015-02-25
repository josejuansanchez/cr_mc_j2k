#!/bin/bash

# TRL = 4

#set -x

base_dir=$PWD


# Parámetros comunes
CABECERA_H1=9040
CABECERA_H2=4528
CABECERA_H3=2272
CABECERA_H4=1144
CABECERA_L=1144
PICTURES=129

# Parámetros video
parametrosCIFx30 () {
	X_DIM=352
	Y_DIM=288
	FPS=30
	BLOCK_SIZE=152064
	DURATION=`echo "$PICTURES/$FPS" | bc -l` #segundos
}

parametros4CIFx30 () { 
	X_DIM=704
	Y_DIM=576
	FPS=30
	BLOCK_SIZE=608256
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros720px50 () { # 736 p
	X_DIM=1280
	Y_DIM=736
	FPS=50
	BLOCK_SIZE=1413120
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros1080px50 () { # 1088 p
	X_DIM=1920
	Y_DIM=1088
	FPS=50
	BLOCK_SIZE=3133440
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros1080px25 () { # 1088 p
	X_DIM=1920
	Y_DIM=1088
	FPS=25
	BLOCK_SIZE=3133440
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}


parametrosCIFx30
#parametros4CIFx30
#parametros720px50
#parametros1080px50
#parametros1080px25
VIDEO=city_704x576x30x420x300.yuv
carpeta="codestream_10/data-FD-MCJ2K-buscaRate_129-city_704x576x30x420x300.sh_44000.32.32.5.2.2.16.3"
carpeta2="codestream_10/data-FD-MCJ2K-buscaRate_129-city_704x576x30x420x300.sh_44000.32.32.1.2.2.16.3"


##############################	##############################
#			FUNCIONES				#
##############################	##############################

slopesVariables_aTRL(){

# ENTRADA SLOPES

	slope_H1=$1
	slope_H2=$2
	slope_H3=$3
	slope_H4=$4
	slope_L=$5


# CARPETA 1: CODIFICACIÓN n SLOPES
	cd $base_dir/$carpeta


		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_H1 --subband=1 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_2 --pictures=129 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_H2 --subband=2 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_3 --pictures=129 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_H3 --subband=3 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_4 --pictures=129 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_H4 --subband=4 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_4 --pictures=129 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_L --temporal_levels=5 --spatial_levels=3


		rm -rf tmp; mkdir tmp ; cp *.mjc *type* tmp/
		mkdir $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L ; cp *.mjc $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
#		mkdir $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_L ; cp *.mjc $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_L
		cd tmp/

	# info = Calcula bit-kbps
		TotalBytes=0
		for Bytes in `ls -lR | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		kbps=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
# !
		mcj2k expand --block_overlaping=2 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=5 --pixels_in_x=704 --pixels_in_y=576 --subpixel_accuracy=2 --search_range=16

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`

	# Resultado pesos.dat:
		slope_prop_1=`echo "$slope_H1/$slope_H2" | bc -l`
		slope_prop_2=`echo "$slope_H2/$slope_H3" | bc -l`
#		slope_prop_3=`echo "$slope_H3/$slope_L" | bc -l`
		slope_prop_3=`echo "$slope_H3/$slope_H4" | bc -l`
		slope_prop_4=`echo "$slope_H4/$slope_L" | bc -l`

		if [ $RMSE_anterior = 0 ] ; then
			pendiente=0
		else
			diferencia_RMSE=`echo "$RMSE_anterior-$RMSE" | bc -l`
			diferencia_kbps=`echo "$kbps-$kbps_anterior" | bc -l`
			if [ $diferencia_kbps != 0 ] ; then
				pendiente=`echo "$diferencia_RMSE/$diferencia_kbps" | bc -l`
			fi

		fi
		RMSE_anterior=$RMSE
		kbps_anterior=$kbps



		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
#		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_L
		ls -l >> $base_dir/pesos_$subbanda.dat
		ls -l > $base_dir/pantalla_$subbanda.dat

		# coge los pesos
		peso_H1=`ls -l high_1.mjc | awk '{print $5}'`	#peso_L=`ls -l low_1.mjc | awk '{print $5}'`
		peso_H2=`ls -l high_2.mjc | awk '{print $5}'`
		peso_H3=`ls -l high_3.mjc | awk '{print $5}'`
#		peso_L=`ls -l low_3.mjc | awk '{print $5}'`
		peso_H4=`ls -l high_4.mjc | awk '{print $5}'`
		peso_L=`ls -l low_4.mjc | awk '{print $5}'`


		# resta cabeceras
		let peso_H1=$peso_H1-$CABECERA_H1
		let peso_H2=$peso_H2-$CABECERA_H2
		let peso_H3=$peso_H3-$CABECERA_H3
		let peso_H4=$peso_H4-$CABECERA_H4
		let peso_L=$peso_L-$CABECERA_L

		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
#		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_L


# CARPETA 2: CODIFICACIÓN 1 SLOPES
	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
# !
		mcj2k compress --block_overlaping=2 --block_size=32 --block_size_min=32 --slopes=$slope_L --pictures=1 --temporal_levels=1 --pixels_in_x=704 --pixels_in_y=576 --subpixel_accuracy=2 --search_range=16 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=704 --pixels_in_y=576 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		frame1=`ls -l low_0.mjc | awk '{print $5}'`
		let L_sinframe1=$peso_L-$frame1

		peso_prop_1=`echo "$peso_H1/$peso_H2" | bc -l`
		peso_prop_2=`echo "$peso_H2/$peso_H3" | bc -l`
#		peso_prop_3=`echo "$peso_H3/$L_sinframe1" | bc -l`
		peso_prop_3=`echo "$peso_H3/$peso_H4" | bc -l`
		peso_prop_4=`echo "$peso_H4/$L_sinframe1" | bc -l`


	# Resultados pesos.dat:
		echo "PESOS: frame_1: $frame1  low.mcj_sin_frame_1: $L_sinframe1  pesos_prop: $peso_prop_1 $peso_prop_2 $peso_prop_3 $peso_prop_4" >> $base_dir/pesos_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat

#		echo "PESOS: frame_1: $frame1  low.mcj_sin_frame_1: $L_sinframe1  pesos_prop: $peso_prop_1 $peso_prop_2 $peso_prop_3" >> $base_dir/pesos_$subbanda.dat
#		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_L \t slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat

		echo -e "kbps= $kbps\tRMSE= $RMSE \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo " " >> $base_dir/pesos_$subbanda.dat
		echo " " >> $base_dir/pesos_$subbanda.dat

	# Resultados coef.dat:
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L '\t\t' $kbps '\t' $RMSE '\t\t' $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 '\t\t' $pendiente >> $base_dir/coef_$subbanda.dat
#		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_L '\t\t' $kbps '\t' $RMSE '\t\t' $slope_prop_1 $slope_prop_2 $slope_prop_3 '\t\t' $pendiente >> $base_dir/coef_$subbanda.dat

	# Resultados pantalla.dat:
		cat $base_dir/pantalla_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \n slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 \n PENDIENTE: $pendiente"
#		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_L \n slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 \n PENDIENTE: $pendiente"
		echo " "; echo " "; echo " "

		rm $base_dir/pantalla_$subbanda.dat
}



##############################	##############################
#			MAIN					#
##############################	##############################
# $1 slope_inicial
# $2 coeficiente
# $3 siguiente coeficiente...


# LIMPIA

#rm *.dat
#echo "======================================== ARCHIVO DE PESOS ===================================" > pesos_$2.dat
rm -rf tmps; mkdir tmps;


# LLAMADAS

#			H1		H2		H3		H4		L
#slopesVariables_aTRL	$1		$2		$3		$4		$5
#slopesVariables_aTRL	65535	65535	65535	65535	65535


comentario(){

RMSE_anterior=0
kbps_anterior=0
subbanda=constantes
slopesVariables_aTRL	45000	45000	45000	45000	45000
slopesVariables_aTRL	44900	44900	44900	44900	44900
slopesVariables_aTRL	44800	44800	44800	44800	44800
slopesVariables_aTRL	44700	44700	44700	44700	44700
slopesVariables_aTRL	44600	44600	44600	44600	44600
slopesVariables_aTRL	44500	44500	44500	44500	44500
slopesVariables_aTRL	44400	44400	44400	44400	44400
slopesVariables_aTRL	44300	44300	44300	44300	44300
slopesVariables_aTRL	44200	44200	44200	44200	44200
slopesVariables_aTRL	44100	44100	44100	44100	44100
slopesVariables_aTRL	44000	44000	44000	44000	44000
slopesVariables_aTRL	43900	43900	43900	43900	43900
slopesVariables_aTRL	43800	43800	43800	43800	43800
slopesVariables_aTRL	43700	43700	43700	43700	43700
slopesVariables_aTRL	43600	43600	43600	43600	43600
slopesVariables_aTRL	43500	43500	43500	43500	43500
slopesVariables_aTRL	43400	43400	43400	43400	43400
slopesVariables_aTRL	43300	43300	43300	43300	43300
slopesVariables_aTRL	43200	43200	43200	43200	43200
slopesVariables_aTRL	43100	43100	43100	43100	43100
slopesVariables_aTRL	43000	43000	43000	43000	43000
slopesVariables_aTRL	42900	42900	42900	42900	42900
slopesVariables_aTRL	42800	42800	42800	42800	42800
slopesVariables_aTRL	42700	42700	42700	42700	42700
slopesVariables_aTRL	42600	42600	42600	42600	42600
slopesVariables_aTRL	42500	42500	42500	42500	42500
slopesVariables_aTRL	42400	42400	42400	42400	42400
slopesVariables_aTRL	42300	42300	42300	42300	42300
slopesVariables_aTRL	42200	42200	42200	42200	42200
slopesVariables_aTRL	42100	42100	42100	42100	42100
slopesVariables_aTRL	42000	42000	42000	42000	42000
slopesVariables_aTRL	41900	41900	41900	41900	41900
slopesVariables_aTRL	41800	41800	41800	41800	41800
slopesVariables_aTRL	41700	41700	41700	41700	41700
slopesVariables_aTRL	41600	41600	41600	41600	41600
slopesVariables_aTRL	41500	41500	41500	41500	41500
slopesVariables_aTRL	41400	41400	41400	41400	41400
slopesVariables_aTRL	41300	41300	41300	41300	41300
slopesVariables_aTRL	41200	41200	41200	41200	41200
slopesVariables_aTRL	41100	41100	41100	41100	41100
slopesVariables_aTRL	41000	41000	41000	41000	41000
slopesVariables_aTRL	40900	40900	40900	40900	40900
slopesVariables_aTRL	40800	40800	40800	40800	40800
slopesVariables_aTRL	40700	40700	40700	40700	40700
slopesVariables_aTRL	40600	40600	40600	40600	40600
slopesVariables_aTRL	40500	40500	40500	40500	40500
slopesVariables_aTRL	40400	40400	40400	40400	40400
slopesVariables_aTRL	40300	40300	40300	40300	40300
slopesVariables_aTRL	40200	40200	40200	40200	40200
slopesVariables_aTRL	40100	40100	40100	40100	40100
slopesVariables_aTRL	40000	40000	40000	40000	40000


RMSE_anterior=0
kbps_anterior=0
subbanda=L
slopesVariables_aTRL	65535	65535	65535	65535	45000
slopesVariables_aTRL	65535	65535	65535	65535	44900
slopesVariables_aTRL	65535	65535	65535	65535	44800
slopesVariables_aTRL	65535	65535	65535	65535	44700
slopesVariables_aTRL	65535	65535	65535	65535	44600
slopesVariables_aTRL	65535	65535	65535	65535	44500
slopesVariables_aTRL	65535	65535	65535	65535	44400
slopesVariables_aTRL	65535	65535	65535	65535	44300
slopesVariables_aTRL	65535	65535	65535	65535	44200
slopesVariables_aTRL	65535	65535	65535	65535	44100
slopesVariables_aTRL	65535	65535	65535	65535	44000
slopesVariables_aTRL	65535	65535	65535	65535	43900
slopesVariables_aTRL	65535	65535	65535	65535	43800
slopesVariables_aTRL	65535	65535	65535	65535	43700
slopesVariables_aTRL	65535	65535	65535	65535	43600
slopesVariables_aTRL	65535	65535	65535	65535	43500
slopesVariables_aTRL	65535	65535	65535	65535	43400
slopesVariables_aTRL	65535	65535	65535	65535	43300
slopesVariables_aTRL	65535	65535	65535	65535	43200
slopesVariables_aTRL	65535	65535	65535	65535	43100
slopesVariables_aTRL	65535	65535	65535	65535	43000
slopesVariables_aTRL	65535	65535	65535	65535	42900
slopesVariables_aTRL	65535	65535	65535	65535	42800
slopesVariables_aTRL	65535	65535	65535	65535	42700
slopesVariables_aTRL	65535	65535	65535	65535	42600
slopesVariables_aTRL	65535	65535	65535	65535	42500
slopesVariables_aTRL	65535	65535	65535	65535	42400
slopesVariables_aTRL	65535	65535	65535	65535	42300
slopesVariables_aTRL	65535	65535	65535	65535	42200
slopesVariables_aTRL	65535	65535	65535	65535	42100
slopesVariables_aTRL	65535	65535	65535	65535	42000
slopesVariables_aTRL	65535	65535	65535	65535	41900
slopesVariables_aTRL	65535	65535	65535	65535	41800
slopesVariables_aTRL	65535	65535	65535	65535	41700
slopesVariables_aTRL	65535	65535	65535	65535	41600
slopesVariables_aTRL	65535	65535	65535	65535	41500
slopesVariables_aTRL	65535	65535	65535	65535	41400
slopesVariables_aTRL	65535	65535	65535	65535	41300
slopesVariables_aTRL	65535	65535	65535	65535	41200
slopesVariables_aTRL	65535	65535	65535	65535	41100
slopesVariables_aTRL	65535	65535	65535	65535	41000
slopesVariables_aTRL	65535	65535	65535	65535	40900
slopesVariables_aTRL	65535	65535	65535	65535	40800
slopesVariables_aTRL	65535	65535	65535	65535	40700
slopesVariables_aTRL	65535	65535	65535	65535	40600
slopesVariables_aTRL	65535	65535	65535	65535	40500
slopesVariables_aTRL	65535	65535	65535	65535	40400
slopesVariables_aTRL	65535	65535	65535	65535	40300
slopesVariables_aTRL	65535	65535	65535	65535	40200
slopesVariables_aTRL	65535	65535	65535	65535	40100
slopesVariables_aTRL	65535	65535	65535	65535	40000
}







divisores=(0.999	0.998	0.997	0.996	0.995	0.994	0.993)
decrementores=(0.0005	0.001	0.002)

#slopes_L=(45000	44800	44600	44300	44000	43700	43400	43100	42800	42500	42200	41800	41400	41000)
#slopes_L=(45000)	;	iteraciones=2	# 1		codestream ; iteraciones
#slopes_L=(44800)	;	iteraciones=2	# 2		codestream ; iteraciones
#slopes_L=(44600)	;	iteraciones=2	# 3		codestream ; iteraciones
#slopes_L=(44300)	;	iteraciones=2	# 4		codestream ; iteraciones
#slopes_L=(44000)	;	iteraciones=2	# 5		codestream ; iteraciones
#slopes_L=(43700)	;	iteraciones=2	# 6		codestream ; iteraciones
#slopes_L=(43400)	;	iteraciones=3	# 7		codestream ; iteraciones
#slopes_L=(43100)	;	iteraciones=3	# 8		codestream ; iteraciones
#slopes_L=(42800)	;	iteraciones=4	# 9		codestream ; iteraciones
slopes_L=(42500)	;	iteraciones=4	# 10	codestream ; iteraciones
#slopes_L=(42200)	;	iteraciones=5	# 11	codestream ; iteraciones
#slopes_L=(41800)	;	iteraciones=5	# 12	codestream ; iteraciones
#slopes_L=(41400)	;	iteraciones=6	# 13	codestream ; iteraciones
#slopes_L=(41000)	;	iteraciones=6	# 14	codestream ; iteraciones


for L in "${slopes_L[@]}"; do

	# El mismo divisor para cada subbanda.
	for divisor in "${divisores[@]}"; do
		RMSE_anterior=0
		kbps_anterior=0
		subbanda=$L'_'$divisor

		H4=`echo "$L/$divisor" | bc`
		H3=`echo "$H4/$divisor" | bc`
		H2=`echo "$H3/$divisor" | bc`
		H1=`echo "$H2/$divisor" | bc`

		for (( i=0; i <= $iteraciones; i++ )) ; do
			slopesVariables_aTRL	$H1	$H2	$H3	$H4	$L

			H4=`echo "$H4/$divisor" | bc`
			H3=`echo "$H3/$divisor" | bc`
			H2=`echo "$H2/$divisor" | bc`
			H1=`echo "$H1/$divisor" | bc`
		done

	done

	# Distinto divisor para cada subbanda.
	for divisor in "${divisores[@]}"; do

		for decrementor in "${decrementores[@]}"; do
			RMSE_anterior=0
			kbps_anterior=0
			subbanda=$L'_'$divisor'_'$decrementor

			divi1=`echo "$divisor-$decrementor" | bc -l`
			divi2=`echo "$divi1-$decrementor" | bc -l`
			divi3=`echo "$divi2-$decrementor" | bc -l`
			divi4=`echo "$divi3-$decrementor" | bc -l`
		
			H4=`echo "$L/$divi1" | bc`
			H3=`echo "$H4/$divi2" | bc`
			H2=`echo "$H3/$divi3" | bc`
			H1=`echo "$H2/$divi4" | bc`

			for (( i=0; i <= $iteraciones; i++ )) ; do
				slopesVariables_aTRL	$H1	$H2	$H3	$H4	$L

				H4=`echo "$H4/$divi1" | bc`
				H3=`echo "$H3/$divi2" | bc`
				H2=`echo "$H2/$divi3" | bc`
				H1=`echo "$H1/$divi4" | bc`
			done

		done

	done

done


#set +x

