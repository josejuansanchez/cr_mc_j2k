#!/bin/bash


base_dir=$PWD



# Parámetros comunes
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
VIDEO=container_352x288x30x420x300.yuv
carpeta="codestream_1/data-FD-MCJ2K-buscaRate_129-container_352x288x30x420x300.sh_44000.32.32.2.0.0.1.3"
carpeta2="codestream_1/data-FD-MCJ2K-buscaRate_129-container_352x288x30x420x300.sh_44000.32.32.1.0.0.1.3"

RMSE_anterior=0
kbps_anterior=0
##############################	##############################
#			FUNCIONES				#
##############################	##############################

slopesVariables_aTRL(){

# ENTRADA SLOPES
		slope_H1=$1
		slope_L=$2

	comentario(){
		slope_H1=$1
		slope_H2=$2
		slope_H3=$3
		slope_H4=$4
		slope_L=$5
	}

	comentario(){
		#slope2=`echo "$1/$2" | bc`
		slope2=`echo "$1 $2 $3" | bc`

		#slope3=`echo "$1/$3" | bc`
		slope3=`echo "$slope2 $4 $5" | bc`

		#slope4=`echo "$1/$4" | bc`
		slope4=`echo "$slope3 $6 $7" | bc`

		#slope5=`echo "$1/$5" | bc`
		slope5=`echo "$slope4 $8 $9" | bc`
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
		kbps=`echo "scale=6;$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
		mcj2k expand --block_overlaping=0 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=2 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 #> file 2>&1

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
		

	# Resultado pesos_$2.dat:
		prop_1=`echo "scale=4;$slope_H1/$slope_L" | bc -l`
comentario(){		
		prop_2=`echo "scale=4;$slope_H2/$slope_L" | bc -l`
		prop_3=`echo "scale=4;$slope_H3/$slope_L" | bc -l`
		prop_4=`echo "scale=4;$slope_H4/$slope_L" | bc -l`
}
		if [ $RMSE_anterior = 0 ] ; then
			pendiente=0
		else
			pendiente=`echo "scale=4;($RMSE_anterior-$RMSE)/($kbps-$kbps_anterior)" | bc -l`
		fi

		RMSE_anterior=$RMSE
		kbps_anterior=$kbps


		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente"> $base_dir/pantalla.dat
		echo -e "kbps= $kbps\tRMSE= $RMSE \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat

		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
		ls -l >> $base_dir/pesos_$subbanda.dat
		ls -l >> $base_dir/pantalla.dat

		# coge los pesos
		peso_high1mcj=`ls -l high_1.mjc | awk '{print $5}'`
		peso_lowmcj=`ls -l low_1.mjc | awk '{print $5}'`
comentario(){
		peso_high2mcj=`ls -l high_2.mjc | awk '{print $5}'`
		peso_high3mcj=`ls -l high_3.mjc | awk '{print $5}'`
		peso_high4mcj=`ls -l high_4.mjc | awk '{print $5}'`
		peso_lowmcj=`ls -l low_4.mjc | awk '{print $5}'`
}

		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L

# CARPETA 2: CODIFICACIÓN 1 SLOPES
	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
		mcj2k compress --block_overlaping=0 --block_size=32 --block_size_min=32 --slopes=$slope_L --pictures=1 --temporal_levels=1 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		peso_Frame1=`ls -l low_0.mjc | awk '{print $5}'`
		peso_lowmcj_sinFrame1=`echo "scale=4;$peso_lowmcj-$peso_Frame1" | bc -l`
		prop_1=`echo "scale=4;$peso_high1mcj/$peso_lowmcj_sinFrame1" | bc -l`
comentario(){
		prop_2=`echo "scale=4;$peso_high2mcj/$peso_lowmcj_sinFrame1" | bc -l`		
		prop_3=`echo "scale=4;$peso_high3mcj/$peso_lowmcj_sinFrame1" | bc -l`
		prop_4=`echo "scale=4;$peso_high4mcj/$peso_lowmcj_sinFrame1" | bc -l`		
}
		echo "PESOS: frame_1= $peso_Frame1  low.mcj_sin_frame_1= $peso_lowmcj_sinFrame1   PROPORCIONES= $prop_1 $prop_2 $prop_3 $prop_4 1" >> $base_dir/pesos_$subbanda.dat

	# Resultado coef_.dat:
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '1 \t\t' $pendiente >> $base_dir/coef_$subbanda.dat
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '1 \t\t' $pendiente >> $base_dir/pantalla.dat

	# Resultado separador:
	echo " " >> $base_dir/pesos_$subbanda.dat
	echo " " >> $base_dir/pesos_$subbanda.dat


	# Pantalla
	echo " "; echo " "; echo " "
	cat $base_dir/pantalla.dat
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


#comentario(){
RMSE_anterior=0
kbps_anterior=0
subbanda=L1
slopesVariables_aTRL	65535	65535
slopesVariables_aTRL	65535	50000
slopesVariables_aTRL	65535	45000
slopesVariables_aTRL	65535	40000
slopesVariables_aTRL	65535	0

RMSE_anterior=0
kbps_anterior=0
subbanda=H1
slopesVariables_aTRL	0	65535
slopesVariables_aTRL	0	50000
slopesVariables_aTRL	0	45000
slopesVariables_aTRL	0	40000
slopesVariables_aTRL	0	20000
#}





comentario(){ # H1 H2 H3 H4 L

RMSE_anterior=0
kbps_anterior=0
subbanda=H1_1
slopesVariables_aTRL	45000	44000
slopesVariables_aTRL	44500	44000
slopesVariables_aTRL	44000	44000
slopesVariables_aTRL	43500	44000
slopesVariables_aTRL	43000	44000
slopesVariables_aTRL	42500	44000
slopesVariables_aTRL	42000	44000
slopesVariables_aTRL	41500	44000
slopesVariables_aTRL	41000	44000


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_2
slopesVariables_aTRL	45000	43500
slopesVariables_aTRL	44500	43500
slopesVariables_aTRL	44000	43500
slopesVariables_aTRL	43500	43500
slopesVariables_aTRL	43000	43500
slopesVariables_aTRL	42500	43500
slopesVariables_aTRL	42000	43500
slopesVariables_aTRL	41500	43500
slopesVariables_aTRL	41000	43500


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_3
slopesVariables_aTRL	45000	43000
slopesVariables_aTRL	44500	43000
slopesVariables_aTRL	44000	43000
slopesVariables_aTRL	43500	43000
slopesVariables_aTRL	43000	43000
slopesVariables_aTRL	42500	43000
slopesVariables_aTRL	42000	43000
slopesVariables_aTRL	41500	43000
slopesVariables_aTRL	41000	43000


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_4
slopesVariables_aTRL	45000	42500
slopesVariables_aTRL	44500	42500
slopesVariables_aTRL	44000	42500
slopesVariables_aTRL	43500	42500
slopesVariables_aTRL	43000	42500
slopesVariables_aTRL	42500	42500
slopesVariables_aTRL	42000	42500
slopesVariables_aTRL	41500	42500
slopesVariables_aTRL	41000	42500


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_5
slopesVariables_aTRL	45000	42000
slopesVariables_aTRL	44500	42000
slopesVariables_aTRL	44000	42000
slopesVariables_aTRL	43500	42000
slopesVariables_aTRL	43000	42000
slopesVariables_aTRL	42500	42000
slopesVariables_aTRL	42000	42000
slopesVariables_aTRL	41500	42000
slopesVariables_aTRL	41000	42000


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_6
slopesVariables_aTRL	45000	41500
slopesVariables_aTRL	44500	41500
slopesVariables_aTRL	44000	41500
slopesVariables_aTRL	43500	41500
slopesVariables_aTRL	43000	41500
slopesVariables_aTRL	42500	41500
slopesVariables_aTRL	42000	41500
slopesVariables_aTRL	41500	41500
slopesVariables_aTRL	41000	41500


RMSE_anterior=0
kbps_anterior=0
subbanda=H1_7
slopesVariables_aTRL	45000	41000
slopesVariables_aTRL	44500	41000
slopesVariables_aTRL	44000	41000
slopesVariables_aTRL	43500	41000
slopesVariables_aTRL	43000	41000
slopesVariables_aTRL	42500	41000
slopesVariables_aTRL	42000	41000
slopesVariables_aTRL	41500	41000
slopesVariables_aTRL	41000	41000





}






comentario(){ # L

RMSE_anterior=0
kbps_anterior=0
subbanda=L1
slopesVariables_aTRL	65535	45000
slopesVariables_aTRL	65535	44900
slopesVariables_aTRL	65535	44800
slopesVariables_aTRL	65535	44700
slopesVariables_aTRL	65535	44600
slopesVariables_aTRL	65535	44500
slopesVariables_aTRL	65535	44400
slopesVariables_aTRL	65535	44300
slopesVariables_aTRL	65535	44200
slopesVariables_aTRL	65535	44100
slopesVariables_aTRL	65535	44000
slopesVariables_aTRL	65535	43900
slopesVariables_aTRL	65535	43800
slopesVariables_aTRL	65535	43700
slopesVariables_aTRL	65535	43600
slopesVariables_aTRL	65535	43500
slopesVariables_aTRL	65535	43400
slopesVariables_aTRL	65535	43300
slopesVariables_aTRL	65535	43200
slopesVariables_aTRL	65535	43100
slopesVariables_aTRL	65535	43000
slopesVariables_aTRL	65535	42900
slopesVariables_aTRL	65535	42800
slopesVariables_aTRL	65535	42700
slopesVariables_aTRL	65535	42600
slopesVariables_aTRL	65535	42500
slopesVariables_aTRL	65535	42400
slopesVariables_aTRL	65535	42300
slopesVariables_aTRL	65535	42200
slopesVariables_aTRL	65535	42100
slopesVariables_aTRL	65535	42000
slopesVariables_aTRL	65535	41900
slopesVariables_aTRL	65535	41800
slopesVariables_aTRL	65535	41700
slopesVariables_aTRL	65535	41600
slopesVariables_aTRL	65535	41500
slopesVariables_aTRL	65535	41400
slopesVariables_aTRL	65535	41300
slopesVariables_aTRL	65535	41200
slopesVariables_aTRL	65535	41100
slopesVariables_aTRL	65535	41000
slopesVariables_aTRL	65535	40900
slopesVariables_aTRL	65535	40800
slopesVariables_aTRL	65535	40700
slopesVariables_aTRL	65535	40600
slopesVariables_aTRL	65535	40500
slopesVariables_aTRL	65535	40400
slopesVariables_aTRL	65535	40300
slopesVariables_aTRL	65535	40200
slopesVariables_aTRL	65535	40100
slopesVariables_aTRL	65535	40000
}
