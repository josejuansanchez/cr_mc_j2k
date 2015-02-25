#!/bin/bash

# AVISO: En caso de cambiar las cuantificaciones, es necesario eliminar/reubicar los codestream svc en $in. Para que el script no los encuentre y vuelva a generarlos.
set -x

out=data-${0##*/}

#Comprueba que está o descarga el video
# ... para los 12 videos

# Prepara espacio de trabajo
rm -rf $out
mkdir $out ; mkdir $out/testeo ; mkdir $out/MCJ2K ; mkdir $out/SVC
cd $out
base_dir=$PWD # $out
cd ..


##############################	##############################
#						  LISTADO VIDEOS				 	 #
##############################	##############################

video_CIF_1=$DATA/VIDEOS/coastguard_352x288x30x420x300.yuv
video_CIF_2=$DATA/VIDEOS/container_352x288x30x420x300.yuv
video_CIF_3=$DATA/VIDEOS/crew_352x288x30x420x300.yuv

video_4CIF_1=$DATA/VIDEOS/city_704x576x30x420x300.yuv
video_4CIF_2=$DATA/VIDEOS/harbour_704x576x30x420x300.yuv
video_4CIF_3=$DATA/VIDEOS/crew_704x576x30x420x300.yuv

video_720p_1=$DATA/VIDEOS/mobcal_1280x736x50x420x504.yuv
video_720p_2=$DATA/VIDEOS/parkrun_1280x736x50x420x504.yuv
video_720p_3=$DATA/VIDEOS/shields_1280x736x50x420x504.yuv

video_1080p_1=$DATA/VIDEOS/ducks_1920x1088x50x420x500.yuv
video_1080p_2=$DATA/VIDEOS/parkjoy_1920x1088x50x420x500.yuv
video_1080p_3=$DATA/VIDEOS/pedestrian_1920x1088x25x420x375.yuv


##############################	##############################
#						  PARÁMETROS GENERALES			 	 #
##############################	##############################

# Parámetros comunes
IBS=32
FBS=32
TRL=6
PICTURES=129

# Parámetros por video
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


# kbps de corte
KBPS_CIF=(100 200 300 400 500 600 700 800 900 1000)
KBPS_4CIF=(400 800 1200 1600 2000 2400 2800 3200 3600 4000)
KBPS_720p=(900 1800 2700 3600 4500 5400 6300 7200 8100 9000)
KBPS_1080p=(2000 4055 6110 8165 10220 12275 14330 16385 18440 20500)



##############################	##############################
#						  PARÁMETROS SVC				 	 #
##############################	##############################

svcQL_CIF_1=$PWD/SVC_4CGS_cfg/CIF/coastguard/CGSql_43.38.33.28
svcQL_CIF_2=$PWD/SVC_4CGS_cfg/CIF/container/CGSql_34.29.24.19
svcQL_CIF_3=$PWD/SVC_4CGS_cfg/CIF/crew/CGSql_43.38.33.28

svcQL_4CIF_1=$PWD/SVC_4CGS_cfg/4CIF/city/CGSql_39.34.29.24
svcQL_4CIF_2=$PWD/SVC_4CGS_cfg/4CIF/harbour/CGSql_44.39.34.29
svcQL_4CIF_3=$PWD/SVC_4CGS_cfg/4CIF/crew/CGSql_41.36.31.26

svcQL_720p_1=$PWD/SVC_4CGS_cfg/720p/mobcal/CGSql_38.34.30.26
svcQL_720p_2=$PWD/SVC_4CGS_cfg/720p/parkrun/CGSql_50.46.42.38
svcQL_720p_3=$PWD/SVC_4CGS_cfg/720p/shields/CGSql_41.36.31.26

svcQL_1080p_1=$PWD/SVC_4CGS_cfg/1080p/ducks/CGSql_51.46.41.36
svcQL_1080p_2=$PWD/SVC_4CGS_cfg/1080p/parkjoy/CGSql_52.47.42.37
svcQL_1080p_3=$PWD/SVC_4CGS_cfg/1080p/pedestrian/CGSql_36.31.26.21


##############################	##############################
#						  PARÁMETROS MCJ2K				 	 #
##############################	##############################

SLOPES_CIF_1=(44760 44083 43855 43717 43610 43534 43463 43376 43328 43278)
SLOPES_CIF_2=(44070	43290 43000	42759 42577 42503 42380 42286 42222 42148)
SLOPES_CIF_3=(45112 43976 43716 43538 43458 43324 43261 43191 43088 43047)


SLOPES_4CIF_1=(44226 43871 43698 43569 43490 43358 43300 43255 43196 43112)
SLOPES_4CIF_2=(44283 43928 43748 43564 43509 43384 43325 43251 43147 43078)
SLOPES_4CIF_3=(44201 43778 43536 43419 43270 43161 43047 43015 42989 42924)

SLOPES_720p_1=(44257 43943 43764 43627 43547 43502 43427 43339 43303 43274)
SLOPES_720p_2=(44577 44350 44238 44094 44049 44015 43973 43893 43854 43824)
SLOPES_720p_3=(44346 44044 43850 43757 43626 43550 43520 43487 43373 43320)

SLOPES_1080p_1=(44653 44292 44085 43989 43860 43783 43684 43612 43576 43551)
SLOPES_1080p_2=(44721 44411 44262 44087 44038 44001 43942 43867 43831 43799)
SLOPES_1080p_3=(43794 43272 43034 42789 42693 42583 42532 42501 42473 42446)


##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

############################## MCJ2K
funcion_mcj2k () { #video $1	slope $2	kbps $3		resolution_videoref $4  	.$TRL=6"
	rm *

	# localiza el video
	ln -s $1 low_0

	# compresion
	mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$2'"' --pictures=$PICTURES --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM #> outcompress
    rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRL --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3` #> outinfo

	# testeo
	echo -e expand.corte$3'\t'kbps: $rate_mcj2k >> $base_dir/testeo/mcj2k.dat

	# expansión
	rm -rf tmp ; mkdir tmp ; cp *.mjc *type* tmp ; cd tmp
	mcj2k expand --block_size=$IBS --block_size_min=$FBS --pictures=$PICTURES --layers=1 --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM #> outexpand
	#mplayer low_0 -demuxer rawvideo -rawvideo w=$X_DIM:h=$Y_DIM > /dev/null 2> /dev/null &
	cd ..

	# FD
	snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=tmp/low_0 2> $base_dir/PSNR_mcj2k.$4.$3""kbps.dat

	# plot
	echo -e PSNR_mcj2k.$4.$3""kbps.dat >> $base_dir/testeo/listado_mcj2k.dat
}

############################## SVC con Quality Layers
funcion_svc_ql(){ # $1=video	$2=PWD_code-stream		$3=kbps_corte	$4=resolution

	# Extrae la capa n
	BitStreamExtractorStatic $2 extracted_eQL -e $E_PARAMETROS:$3 -ql

	# Reconstruye el .yuv
	H264AVCDecoderLibTestStatic extracted_eQL e.yuv #> infos/info_yuv$n

	# Calcula bit-rate
	bytes=`wc -c < extracted_eQL`
	rate_svc=`echo "$bytes*8/$DURATION/1000" | bc -l`

	# testeo
	echo -e extracted_eQL.corte$3' \t'bytes: $bytes'\t'kbps: $rate_svc >> $base_dir/testeo/svcQL.dat
	
	# Calcula RMSE
    snr --block_size=$BLOCK_SIZE --file_A=$1 --file_B=e.yuv 2> $base_dir/PSNR_svcQL.$4.$3""kbps.dat

	# plot
	echo -e PSNR_svcQL.$4.$3""kbps.dat >> $base_dir/testeo/listado_svcQL.dat
}


##############################	##############################
#							 MAIN							 #
##############################	##############################

# Para mcj2k le doy los slopes directamente.
# Para svc le doy los cortes en kbps y el trunca capas.

cd $base_dir/MCJ2K

parametrosCIFx30
n=0 ; for slope in "${SLOPES_CIF_1[@]}"; 	do funcion_mcj2k  $video_CIF_1 	 $slope ${KBPS_CIF[$n]}		CIF_1	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_CIF_2[@]}";	do funcion_mcj2k  $video_CIF_2	 $slope	${KBPS_CIF[$n]}		CIF_2	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_CIF_3[@]}";	do funcion_mcj2k  $video_CIF_3	 $slope	${KBPS_CIF[$n]}		CIF_3	;  let n=n+1  ;  done

parametros4CIFx30
n=0 ; for slope in "${SLOPES_4CIF_1[@]}";	do funcion_mcj2k  $video_4CIF_1	 $slope	${KBPS_4CIF[$n]}	4CIF_1	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_4CIF_2[@]}";	do funcion_mcj2k  $video_4CIF_2	 $slope	${KBPS_4CIF[$n]}	4CIF_2	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_4CIF_3[@]}";	do funcion_mcj2k  $video_4CIF_3	 $slope	${KBPS_4CIF[$n]}	4CIF_3	;  let n=n+1  ;  done

parametros720px50
n=0 ; for slope in "${SLOPES_720p_1[@]}";	do funcion_mcj2k  $video_720p_1	 $slope	${KBPS_720p[$n]}	720p_1	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_720p_2[@]}";	do funcion_mcj2k  $video_720p_2	 $slope	${KBPS_720p[$n]}	720p_2	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_720p_3[@]}";	do funcion_mcj2k  $video_720p_3	 $slope	${KBPS_720p[$n]}	720p_3	;  let n=n+1  ;  done

parametros1080px50
n=0 ; for slope in "${SLOPES_1080p_1[@]}";	do funcion_mcj2k  $video_1080p_1 $slope	${KBPS_1080p[$n]}	1080p_1	;  let n=n+1  ;  done
n=0 ; for slope in "${SLOPES_1080p_2[@]}";	do funcion_mcj2k  $video_1080p_2 $slope	${KBPS_1080p[$n]}	1080p_2	;  let n=n+1  ;  done
parametros1080px25
n=0 ; for slope in "${SLOPES_1080p_3[@]}";	do funcion_mcj2k  $video_1080p_3 $slope	${KBPS_1080p[$n]}	1080p_3	;  let n=n+1  ;  done



cd $base_dir/SVC

parametrosCIFx30
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
for kbps in "${KBPS_CIF[@]}"; do 
	funcion_svc_ql $video_CIF_1		$svcQL_CIF_1 	$kbps	CIF_1
	funcion_svc_ql $video_CIF_2		$svcQL_CIF_2 	$kbps	CIF_2
	funcion_svc_ql $video_CIF_3		$svcQL_CIF_3 	$kbps	CIF_3
done

parametros4CIFx30
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
for kbps in "${KBPS_4CIF[@]}"; do 
	funcion_svc_ql $video_4CIF_1	$svcQL_4CIF_1 	$kbps	4CIF_1
	funcion_svc_ql $video_4CIF_2	$svcQL_4CIF_2 	$kbps	4CIF_2
	funcion_svc_ql $video_4CIF_3	$svcQL_4CIF_3 	$kbps	4CIF_3
done

parametros720px50
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
for kbps in "${KBPS_720p[@]}"; do 
	funcion_svc_ql $video_720p_1	$svcQL_720p_1 	$kbps	720p_1
	funcion_svc_ql $video_720p_2	$svcQL_720p_2 	$kbps	720p_2
	funcion_svc_ql $video_720p_3	$svcQL_720p_3 	$kbps	720p_3
done

for kbps in "${KBPS_1080p[@]}"; do
parametros1080px50
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
	funcion_svc_ql $video_1080p_1	$svcQL_1080p_1 	$kbps	1080p_1
	funcion_svc_ql $video_1080p_2	$svcQL_1080p_2 	$kbps	1080p_2
parametros1080px25
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
	funcion_svc_ql $video_1080p_3	$svcQL_1080p_3 	$kbps	1080p_3
done




set +x
#firefox file://`pwd`/output.svg &

