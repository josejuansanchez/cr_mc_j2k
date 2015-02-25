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
VIDEO=urandom_352x288x30x420x300.yuv
carpeta="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x300.sh_44000.32.32.5.0.0.1.3"
carpeta2="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x1.sh_40000.32.32.1.0.0.1.3"

RMSE_anterior=0
kbps_anterior=0
##############################	##############################
#			FUNCIONES				#
##############################	##############################

slopesVariables_aTRL(){
#	comentario(){
		slope_H1=$1
		slope_H2=$2
		slope_H3=$3
		slope_H4=$4
		slope_L4=$5
#	}

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

	cd $base_dir/$carpeta

		#mcj2k analyze --block_overlaping=0 --block_size=32 --block_size_min=32 --border_size=0 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --search_range=1 --subpixel_accuracy=0 --temporal_levels=5
		#mcj2k motion_compress --block_size=32 --block_size_min=32 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --temporal_levels=5

		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H1 --subband=1 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_2 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H2 --subband=2 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_3 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H3 --subband=3 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H4 --subband=4 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L4 --temporal_levels=5 --spatial_levels=3

		rm -rf tmp; mkdir tmp ; cp *.mjc *type* tmp/
		mkdir $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L4 ; cp *.mjc $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L4
		cd tmp/

	# info = Calcula bit-kbps
		TotalBytes=0
		for Bytes in `ls -lR | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		kbps=`echo "scale=6;$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
		mcj2k expand --block_overlaping=0 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=5 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 #> file 2>&1

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
		

	# Resultado pesos_$2.dat:
		prop_1=`echo "scale=4;$slope_H1/$slope_L4" | bc -l`
		prop_2=`echo "scale=4;$slope_H2/$slope_L4" | bc -l`
		prop_3=`echo "scale=4;$slope_H3/$slope_L4" | bc -l`
		prop_4=`echo "scale=4;$slope_H4/$slope_L4" | bc -l`

	# Pendiente
		if [ $RMSE_anterior = 0 ] ; then
			pendiente=0
		else
			pendiente=`echo "scale=4;($RMSE_anterior-$RMSE)/($kbps-$kbps_anterior)" | bc -l`
		fi
		RMSE_anterior=$RMSE
		kbps_anterior=$kbps


		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L4 \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L4 \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente"> $base_dir/pantalla.dat
		echo -e "kbps= $kbps\tRMSE= $RMSE \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat

		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L4
		ls -l >> $base_dir/pesos_$subbanda.dat
		ls -l >> $base_dir/pantalla.dat

		# coge los pesos
		peso_high1mcj=`ls -l high_1.mjc | awk '{print $5}'`
		peso_high2mcj=`ls -l high_2.mjc | awk '{print $5}'`
		peso_high3mcj=`ls -l high_3.mjc | awk '{print $5}'`
		peso_high4mcj=`ls -l high_4.mjc | awk '{print $5}'`
		peso_low4mcj=`ls -l low_4.mjc | awk '{print $5}'`

		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L4



	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
		mcj2k compress --block_overlaping=0 --block_size=32 --block_size_min=32 --slopes=$slope_L4 --pictures=1 --temporal_levels=1 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L4 --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L4 --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		peso_Frame1=`ls -l low_0.mjc | awk '{print $5}'`
		peso_lowmcj_sinFrame1=`echo "scale=4;$peso_low4mcj-$peso_Frame1" | bc -l`
		prop_1=`echo "scale=4;$peso_high1mcj/$peso_lowmcj_sinFrame1" | bc -l`
		prop_2=`echo "scale=4;$peso_high2mcj/$peso_lowmcj_sinFrame1" | bc -l`		
		prop_3=`echo "scale=4;$peso_high3mcj/$peso_lowmcj_sinFrame1" | bc -l`
		prop_4=`echo "scale=4;$peso_high4mcj/$peso_lowmcj_sinFrame1" | bc -l`		
		
		echo "PESOS: frame_1= $peso_Frame1  low_4.mcj_sin_frame_1= $peso_lowmcj_sinFrame1   PROPORCIONES= $prop_1 $prop_2 $prop_3 $prop_4 1" >> $base_dir/pesos_$subbanda.dat

	# Resultado coef_.dat:
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L4'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '1 \t\t' $pendiente >> $base_dir/coef_$subbanda.dat
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L4'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '1 \t\t' $pendiente >> $base_dir/pantalla.dat

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

#			H1		H2		H3		H4		L4
#slopesVariables_aTRL	$1		$2		$3		$4		$5
#slopesVariables_aTRL	65535	65535	65535	65535	65535




comentario(){

RMSE_anterior=0					
kbps_anterior=0					
subbanda=constantes					
slopesVariables_aTRL	45000	45000	45000	45000	45000
slopesVariables_aTRL	44600	44600	44600	44600	44600
slopesVariables_aTRL	44200	44200	44200	44200	44200
slopesVariables_aTRL	43800	43800	43800	43800	43800
slopesVariables_aTRL	43400	43400	43400	43400	43400
slopesVariables_aTRL	43000	43000	43000	43000	43000
slopesVariables_aTRL	42600	42600	42600	42600	42600
slopesVariables_aTRL	42200	42200	42200	42200	42200
slopesVariables_aTRL	41800	41800	41800	41800	41800
slopesVariables_aTRL	41400	41400	41400	41400	41400
slopesVariables_aTRL	41000	41000	41000	41000	41000
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_250					
slopesVariables_aTRL	45000	44750	44500	44250	44000
slopesVariables_aTRL	44600	44350	44100	43850	43600
slopesVariables_aTRL	44200	43950	43700	43450	43200
slopesVariables_aTRL	43800	43550	43300	43050	42800
slopesVariables_aTRL	43400	43150	42900	42650	42400
slopesVariables_aTRL	43000	42750	42500	42250	42000
slopesVariables_aTRL	42600	42350	42100	41850	41600
slopesVariables_aTRL	42200	41950	41700	41450	41200
slopesVariables_aTRL	41800	41550	41300	41050	40800
slopesVariables_aTRL	41400	41150	40900	40650	40400
slopesVariables_aTRL	41000	40750	40500	40250	40000
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_275					
slopesVariables_aTRL	45000	44725	44450	44175	43900
slopesVariables_aTRL	44600	44325	44050	43775	43500
slopesVariables_aTRL	44200	43925	43650	43375	43100
slopesVariables_aTRL	43800	43525	43250	42975	42700
slopesVariables_aTRL	43400	43125	42850	42575	42300
slopesVariables_aTRL	43000	42725	42450	42175	41900
slopesVariables_aTRL	42600	42325	42050	41775	41500
slopesVariables_aTRL	42200	41925	41650	41375	41100
slopesVariables_aTRL	41800	41525	41250	40975	40700
slopesVariables_aTRL	41400	41125	40850	40575	40300
slopesVariables_aTRL	41000	40725	40450	40175	39900
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300					
slopesVariables_aTRL	45000	44700	44400	44100	43800
slopesVariables_aTRL	44600	44300	44000	43700	43400
slopesVariables_aTRL	44200	43900	43600	43300	43000
slopesVariables_aTRL	43800	43500	43200	42900	42600
slopesVariables_aTRL	43400	43100	42800	42500	42200
slopesVariables_aTRL	43000	42700	42400	42100	41800
slopesVariables_aTRL	42600	42300	42000	41700	41400
slopesVariables_aTRL	42200	41900	41600	41300	41000
slopesVariables_aTRL	41800	41500	41200	40900	40600
slopesVariables_aTRL	41400	41100	40800	40500	40200
slopesVariables_aTRL	41000	40700	40400	40100	39800
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_325					
slopesVariables_aTRL	45000	44675	44350	44025	43700
slopesVariables_aTRL	44600	44275	43950	43625	43300
slopesVariables_aTRL	44200	43875	43550	43225	42900
slopesVariables_aTRL	43800	43475	43150	42825	42500
slopesVariables_aTRL	43400	43075	42750	42425	42100
slopesVariables_aTRL	43000	42675	42350	42025	41700
slopesVariables_aTRL	42600	42275	41950	41625	41300
slopesVariables_aTRL	42200	41875	41550	41225	40900
slopesVariables_aTRL	41800	41475	41150	40825	40500
slopesVariables_aTRL	41400	41075	40750	40425	40100
slopesVariables_aTRL	41000	40675	40350	40025	39700
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_350					
slopesVariables_aTRL	45000	44650	44300	43950	43600
slopesVariables_aTRL	44600	44250	43900	43550	43200
slopesVariables_aTRL	44200	43850	43500	43150	42800
slopesVariables_aTRL	43800	43450	43100	42750	42400
slopesVariables_aTRL	43400	43050	42700	42350	42000
slopesVariables_aTRL	43000	42650	42300	41950	41600
slopesVariables_aTRL	42600	42250	41900	41550	41200
slopesVariables_aTRL	42200	41850	41500	41150	40800
slopesVariables_aTRL	41800	41450	41100	40750	40400
slopesVariables_aTRL	41400	41050	40700	40350	40000
slopesVariables_aTRL	41000	40650	40300	39950	39600
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300_275_250_225					
slopesVariables_aTRL	45000	44700	44425	44175	43950
slopesVariables_aTRL	44600	44300	44025	43775	43550
slopesVariables_aTRL	44200	43900	43625	43375	43150
slopesVariables_aTRL	43800	43500	43225	42975	42750
slopesVariables_aTRL	43400	43100	42825	42575	42350
slopesVariables_aTRL	43000	42700	42425	42175	41950
slopesVariables_aTRL	42600	42300	42025	41775	41550
slopesVariables_aTRL	42200	41900	41625	41375	41150
slopesVariables_aTRL	41800	41500	41225	40975	40750
slopesVariables_aTRL	41400	41100	40825	40575	40350
slopesVariables_aTRL	41000	40700	40425	40175	39950
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300_250_200_150					
slopesVariables_aTRL	45000	44700	44450	44250	44100
slopesVariables_aTRL	44600	44300	44050	43850	43700
slopesVariables_aTRL	44200	43900	43650	43450	43300
slopesVariables_aTRL	43800	43500	43250	43050	42900
slopesVariables_aTRL	43400	43100	42850	42650	42500
slopesVariables_aTRL	43000	42700	42450	42250	42100
slopesVariables_aTRL	42600	42300	42050	41850	41700
slopesVariables_aTRL	42200	41900	41650	41450	41300
slopesVariables_aTRL	41800	41500	41250	41050	40900
slopesVariables_aTRL	41400	41100	40850	40650	40500
slopesVariables_aTRL	41000	40700	40450	40250	40100
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300_325_350_375					
slopesVariables_aTRL	45000	44700	44375	44025	43650
slopesVariables_aTRL	44600	44300	43975	43625	43250
slopesVariables_aTRL	44200	43900	43575	43225	42850
slopesVariables_aTRL	43800	43500	43175	42825	42450
slopesVariables_aTRL	43400	43100	42775	42425	42050
slopesVariables_aTRL	43000	42700	42375	42025	41650
slopesVariables_aTRL	42600	42300	41975	41625	41250
slopesVariables_aTRL	42200	41900	41575	41225	40850
slopesVariables_aTRL	41800	41500	41175	40825	40450
slopesVariables_aTRL	41400	41100	40775	40425	40050
slopesVariables_aTRL	41000	40700	40375	40025	39650
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300_350_400_450					
slopesVariables_aTRL	45000	44700	44350	43950	43500
slopesVariables_aTRL	44600	44300	43950	43550	43100
slopesVariables_aTRL	44200	43900	43550	43150	42700
slopesVariables_aTRL	43800	43500	43150	42750	42300
slopesVariables_aTRL	43400	43100	42750	42350	41900
slopesVariables_aTRL	43000	42700	42350	41950	41500
slopesVariables_aTRL	42600	42300	41950	41550	41100
slopesVariables_aTRL	42200	41900	41550	41150	40700
slopesVariables_aTRL	41800	41500	41150	40750	40300
slopesVariables_aTRL	41400	41100	40750	40350	39900
slopesVariables_aTRL	41000	40700	40350	39950	39500



RMSE_anterior=0					
kbps_anterior=0					
subbanda=_300_225_150_75 					
slopesVariables_aTRL	45000	44700	44475	44325	44250
slopesVariables_aTRL	44600	44300	44075	43925	43850
slopesVariables_aTRL	44200	43900	43675	43525	43450
slopesVariables_aTRL	43800	43500	43275	43125	43050
slopesVariables_aTRL	43400	43100	42875	42725	42650
slopesVariables_aTRL	43000	42700	42475	42325	42250
slopesVariables_aTRL	42600	42300	42075	41925	41850
slopesVariables_aTRL	42200	41900	41675	41525	41450
slopesVariables_aTRL	41800	41500	41275	41125	41050
slopesVariables_aTRL	41400	41100	40875	40725	40650
slopesVariables_aTRL	41000	40700	40475	40325	40250
}				
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_275_225_175_125 					
slopesVariables_aTRL	45000	44725	44500	44325	44200
slopesVariables_aTRL	44600	44325	44100	43925	43800
slopesVariables_aTRL	44200	43925	43700	43525	43400
slopesVariables_aTRL	43800	43525	43300	43125	43000
slopesVariables_aTRL	43400	43125	42900	42725	42600
slopesVariables_aTRL	43000	42725	42500	42325	42200
slopesVariables_aTRL	42600	42325	42100	41925	41800
slopesVariables_aTRL	42200	41925	41700	41525	41400
slopesVariables_aTRL	41800	41525	41300	41125	41000
slopesVariables_aTRL	41400	41125	40900	40725	40600
slopesVariables_aTRL	41000	40725	40500	40325	40200
					
					
					
					
					
RMSE_anterior=0					
kbps_anterior=0					
subbanda=_275_200_125_50					
slopesVariables_aTRL	45000	44725	44525	44400	44350
slopesVariables_aTRL	44600	44325	44125	44000	43950
slopesVariables_aTRL	44200	43925	43725	43600	43550
slopesVariables_aTRL	43800	43525	43325	43200	43150
slopesVariables_aTRL	43400	43125	42925	42800	42750
slopesVariables_aTRL	43000	42725	42525	42400	42350
slopesVariables_aTRL	42600	42325	42125	42000	41950
slopesVariables_aTRL	42200	41925	41725	41600	41550
slopesVariables_aTRL	41800	41525	41325	41200	41150
slopesVariables_aTRL	41400	41125	40925	40800	40750
slopesVariables_aTRL	41000	40725	40525	40400	40350

