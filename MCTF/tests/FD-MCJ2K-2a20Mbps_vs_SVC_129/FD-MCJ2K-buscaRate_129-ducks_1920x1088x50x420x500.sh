#!/bin/bash

# AVISO: En caso de cambiar las cuantificaciones, es necesario eliminar/reubicar los codestream svc en $in. Para que el script no los encuentre y vuelva a generarlos.
#set -x

out=data-${0##*/}$1

# Parámetros comunes
IBS=64
FBS=64
TRL=4
PICTURES=129

# Prepara espacio de trabajo
rm -rf $out
mkdir $out
cd $out

# coastguard_352x288x30x420x300.yuv
# container_352x288x30x420x300.yuv
# crew_352x288x30x420x300.yuv

# city_704x576x30x420x300.yuv        
# harbour_704x576x30x420x300.yuv
# crew_704x576x30x420x300.yuv

# mobcal_1280x736x50x420x504.yuv
# parkrun_1280x736x50x420x504.yuv
# shields_1280x736x50x420x504.yuv

# ducks_1920x1088x50x420x500.yuv
# parkjoy_1920x1088x50x420x500.yuv
# pedestrian_1920x1088x25x420x375.yuv



# Parámetros video
parametrosCIFx30 () {
	X_DIM=352
	Y_DIM=288
	FPS=30
}

parametros4CIFx30 () {
	X_DIM=704
	Y_DIM=576
	FPS=30
}

parametros720px50 () {
	X_DIM=1280
	Y_DIM=736
	FPS=50
}

parametros1080px50 () {
	X_DIM=1920
	Y_DIM=1088
	FPS=50	
}

parametros1080px25 () {
	X_DIM=1920
	Y_DIM=1088
	FPS=25
}


#parametrosCIFx30
#parametros4CIFx30
#parametros720px50
parametros1080px50
#parametros1080px25
VIDEO=ducks_1920x1088x50x420x500.yuv
slope=$1

#compresion
ln -s $DATA/VIDEOS/$VIDEO low_0
mcj2k compress --block_size=$IBS --block_size_min=$FBS --slopes='"'$slope'"' --pictures=$PICTURES --temporal_levels=$TRL --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM > file 2>&1
rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$TRL --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3` #> outinfo

cd ..
rm -rf $out

# Resultado:
echo -e "$VIDEO\tslope:$1\tkbps:$rate_mcj2k"




#set +x
#firefox file://`pwd`/output.svg &
