#!/bin/bash

# AVISO: En caso de cambiar las cuantificaciones, es necesario eliminar/reubicar los codestream svc en $in. Para que el script no los encuentre y vuelva a generarlos.
set -x

out=data-${0##*/}

#container_352x288x30x420x300.yuv	crew_352x288x30x420x300.yuv			coastguard_352x288x30x420x300.yuv  
#city_704x576x30x420x300.yuv		harbour_704x576x30x420x300.yuv		crew_704x576x30x420x300.yuv
#mobcal_1280x720x50x420x504.yuv		shields_1280x720x50x420x504.yuv		parkrun_1280x720x50x420x504.yuv
#parkjoy_1920x1080x50x420x500.yuv	pedestrian_1920x1080x25x420x375.yuv	ducks_1920x1080x50x420x500.yuv     

VIDEO=ducks_1920x1080x50x420x500
outVIDEO=ducks_1920x1088x50x420x500

# Parámetros video
parametros1080p () { # 1080 to 1088
	X_DIM=1920
	Y_DIM=1080
		
	BLOCK_SIZE=3110400
	cabeceraPPM=17

	# anchura margenes     
	top=4
	bottom=4
}

parametros720p () { # 720 to 736
	X_DIM=1280
	Y_DIM=720
	
	BLOCK_SIZE=1382400
	cabeceraPPM=16

	# anchura margenes     
	top=8
	bottom=8
}

parametros1080p 
#parametros720p

mkdir $out
cd $out

bytesFramePPM=`echo "($BLOCK_SIZE*2)+$cabeceraPPM" | bc -l`

# Convierte a ppm
eyuvtoppm --width $X_DIM --height $Y_DIM $DATA/VIDEOS/$VIDEO.yuv > 1

# Separa el video en frames
/usr/bin/split -a 3 -d -b $bytesFramePPM 1 tmp # un frame más la cabecera ppm

# Añade los margenes a cada frame
for i in tmp*
	do echo $i
	pnmpad -top $top -bottom $bottom $i >> ${i}_padded
done

# Junta los frames en un video
todos_fps() {
	for i in tmp???_padded
	do echo $i
		ppmtoeyuv < $i >> $DATA/VIDEOS/$outVIDEO.yuv
	done
}

mitad_fps() {
	n=0
	for i in tmp???_padded
	do echo $i
		if [ $n -eq 0 ]; then
			ppmtoeyuv < $i >> $DATA/VIDEOS/$outVIDEO.yuv
			n=1
		else
			n=0
		fi
	done
}

todos_fps
#mitad_fps

cd ..
rm -r $out

set +x
