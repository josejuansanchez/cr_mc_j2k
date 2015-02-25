#!/bin/bash


base_dir=$PWD


# Parámetros comunes
CABECERA_H1=9040
CABECERA_H2=4528
CABECERA_H3=2272
CABECERA_H4=1144
CABECERA_L4=9024
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
VIDEO=urandom_352x288x30x420x300.yuv
carpeta="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x300.sh_40000.32.32.2.0.0.1.3"
carpeta2="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x1.sh_40000.32.32.1.0.0.1.3"

RMSE_anterior=0
kbps_anterior=0
##############################	##############################
#			FUNCIONES				#
##############################	##############################

slopesVariables_aTRL(){

# ENTRADA SLOPES
		slope_H1=`echo "$1/$divisor" | bc`
		slope_L=$1
		#slope_L=$2

	comentario(){
		slope_H1=$1
		slope_H2=$2
		slope_H3=$3
		slope_H4=$4
		slope_L=$5
	}


# CARPETA 1: CODIFICACIÓN n SLOPES
	cd $base_dir/$carpeta

		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H1 --subband=1 --temporal_levels=2 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=2 --spatial_levels=3
		
		comentario(){
		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H1 --subband=1 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_2 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H2 --subband=2 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_3 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H3 --subband=3 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H4 --subband=4 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=5 --spatial_levels=3
		}

		rm -rf tmp; mkdir tmp ; cp *.mjc *type* tmp/
		mkdir $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L ; cp *.mjc $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
		cd tmp/

	# info = Calcula bit-kbps
		TotalBytes=0
		for Bytes in `ls -lR | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		kbps=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
		mcj2k expand --block_overlaping=0 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=2 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 #> file 2>&1

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
		

	# Resultado pesos.dat:
		slope_prop_1=`echo "$slope_H1/$slope_L" | bc -l`
		#slope_prop_2=`echo "$slope_H2/$slope_L" | bc -l`
		#slope_prop_3=`echo "$slope_H3/$slope_L" | bc -l`
		#slope_prop_4=`echo "$slope_H4/$slope_L" | bc -l`

		if [ $RMSE_anterior = 0 ] ; then
			pendiente=0
		else
			pendiente=`echo "($RMSE_anterior-$RMSE)/($kbps-$kbps_anterior)" | bc -l`
		fi

		RMSE_anterior=$RMSE
		kbps_anterior=$kbps



		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
		ls -l >> $base_dir/pesos_$subbanda.dat
		ls -l > $base_dir/pantalla_$subbanda.dat

		# coge los pesos
		peso_H1=`ls -l high_1.mjc | awk '{print $5}'`
		peso_L=`ls -l low_1.mjc | awk '{print $5}'`
		#peso_H2=`ls -l high_2.mjc | awk '{print $5}'`
		#peso_H3=`ls -l high_3.mjc | awk '{print $5}'`
		#peso_H4=`ls -l high_4.mjc | awk '{print $5}'`
		#peso_L=`ls -l low_4.mjc | awk '{print $5}'`


		# resta cabeceras
		peso_H1=`echo "$peso_H1-$CABECERA_H1" | bc -l`
		#peso_H2=`echo "$peso_H2-$CABECERA_H2" | bc -l`
		#peso_H3=`echo "$peso_H3-$CABECERA_H3" | bc -l`
		#peso_H4=`echo "$peso_H4-$CABECERA_H4" | bc -l`
		peso_L=`echo "$peso_L-$CABECERA_L" | bc -l`

		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L


# CARPETA 2: CODIFICACIÓN 1 SLOPES
	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
		mcj2k compress --block_overlaping=0 --block_size=32 --block_size_min=32 --slopes=$slope_L --pictures=1 --temporal_levels=1 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		peso_frame1=`ls -l low_0.mjc | awk '{print $5}'`
		peso_L_sinframe1=`echo "$peso_L-$peso_frame1" | bc -l`

		peso_prop_1=`echo "$peso_H1/$peso_L_sinframe1" | bc -l`
		#peso_prop_2=`echo "$peso_H2/$peso_L_sinframe1" | bc -l`
		#peso_prop_3=`echo "$peso_H3/$peso_L_sinframe1" | bc -l`
		#peso_prop_4=`echo "$peso_H4/$peso_L_sinframe1" | bc -l`



	# Resultados pesos.dat:
		echo "PESOS: frame_1= $peso_frame1  low.mcj_sin_frame_1= $peso_L_sinframe1   pesos_prop= $peso_prop_1 $peso_prop_2 $peso_prop_3 $peso_prop_4" >> $base_dir/pesos_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo -e "kbps= $kbps\tRMSE= $RMSE \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo " " >> $base_dir/pesos_$subbanda.dat
		echo " " >> $base_dir/pesos_$subbanda.dat

	# Resultados coef.dat:
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L '\t\t' $kbps '\t' $RMSE '\t\t' $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 '\t\t' $pendiente >> $base_dir/coef_$subbanda.dat

	# Resultados pantalla.dat:
		cat $base_dir/pantalla_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t slope_prop: $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 \t PENDIENTE: $pendiente"
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L '\t\t' $kbps '\t' $RMSE '\t\t' $slope_prop_1 $slope_prop_2 $slope_prop_3 $slope_prop_4 '\t\t' $pendiente
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

#						H1		H2		H3		H4		L
#slopesVariables_aTRL	$1		$2		$3		$4		$5
#slopesVariables_aTRL	65535	65535	65535	65535	65535










#divisores=(1.025	1.0225	1.02	1.0175	1.015	1.0125	1.01	1.0075	1.005	1.0025	1	0.9975	0.995	0.9925	0.99	0.9875	0.985	0.9825	0.98	0.9775	0.975)
divisores=(1.025	1.0225	1.02	1.0175	1.015	1.0125	1.01	1.0075	1.005	1.0025	1	0.9975	0.995	0.9925	0.99	0.9875	0.985	0.9825	0.98	0.9775	0.975)

for divisor in "${divisores[@]}"; do 
RMSE_anterior=0		
kbps_anterior=0		
subbanda=$divisor
slopesVariables_aTRL	43691
slopesVariables_aTRL	43034
slopesVariables_aTRL	42049
slopesVariables_aTRL	40571
done


comentario(){
slopesVariables_aTRL	45000
slopesVariables_aTRL	44998
slopesVariables_aTRL	44994
slopesVariables_aTRL	44989
slopesVariables_aTRL	44982
slopesVariables_aTRL	44970
slopesVariables_aTRL	44953
slopesVariables_aTRL	44928
slopesVariables_aTRL	44889
slopesVariables_aTRL	44832
slopesVariables_aTRL	44745
slopesVariables_aTRL	44615
slopesVariables_aTRL	44421
slopesVariables_aTRL	44129
slopesVariables_aTRL	43691
slopesVariables_aTRL	43034
slopesVariables_aTRL	42049
slopesVariables_aTRL	40571

}
