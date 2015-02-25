#!/bin/bash

# AVISO: En caso de cambiar las cuantificaciones, es necesario eliminar/reubicar los codestream svc en $in. Para que el script no los encuentre y vuelva a generarlos.
set -x

out=data-${0##*/}

# Comprueba que está o descarga el video
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
#						  FUNCIONES						 	 #
##############################	##############################



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

	fd_media_fftno=`echo "" | awk '{SUM+=$2} END {print SUM/NR}' $base_dir/PSNR_svcQL.$4.$3""kbps.dat`
	indice_FFTno=`echo "$fd_media_fftno/$rate_mcj2k" | bc -l`
	$indice_FFTno >> medias.dat

	# plot
	echo -e PSNR_svcQL.$4.$3""kbps.dat >> $base_dir/testeo/listado_svcQL.dat
}


##############################	##############################
#							 MAIN							 #
##############################	##############################

# Para mcj2k le doy los slopes directamente.
# Para svc le doy los cortes en kbps y el trunca capas.

cd $base_dir/SVC

parametrosCIFx30
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS

	funcion_svc_ql $video_CIF_1		$svcQL_CIF_1 	526	CIF_1
	funcion_svc_ql $video_CIF_2		$svcQL_CIF_2 	530	CIF_2
	funcion_svc_ql $video_CIF_3		$svcQL_CIF_3 	562	CIF_3


parametros4CIFx30
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS

	funcion_svc_ql $video_4CIF_1	$svcQL_4CIF_1 	1577	4CIF_1
	funcion_svc_ql $video_4CIF_2	$svcQL_4CIF_2 	2079	4CIF_2
	funcion_svc_ql $video_4CIF_3	$svcQL_4CIF_3 	2123	4CIF_3


parametros720px50
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS

	funcion_svc_ql $video_720p_1	$svcQL_720p_1 	3082	720p_1
	funcion_svc_ql $video_720p_2	$svcQL_720p_2 	4347	720p_2
	funcion_svc_ql $video_720p_3	$svcQL_720p_3 	3880	720p_3



parametros1080px50
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
	funcion_svc_ql $video_1080p_1	$svcQL_1080p_1 	11227	1080p_1
	funcion_svc_ql $video_1080p_2	$svcQL_1080p_2 	10742	1080p_2

parametros1080px25
E_PARAMETROS=$X_DIM"x"$Y_DIM@$FPS
	funcion_svc_ql $video_1080p_3	$svcQL_1080p_3 	10890	1080p_3





set +x
#firefox file://`pwd`/output.svg &

