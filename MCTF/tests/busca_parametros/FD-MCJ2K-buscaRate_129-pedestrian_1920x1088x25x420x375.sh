#!/bin/bash
set -x

base_dir=$PWD

# Parámetros comunes
PICTURES=1

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


#parametrosCIFx30
#parametros4CIFx30
#parametros720px50
#parametros1080px50
parametros1080px25
VIDEO=pedestrian_1920x1088x25x420x375.yuv
#VIDEO=1080px25.yuv
slope=$1

##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

# compresion
busca_parametros () { # $1=IBS		$2=FBS		$3=TRL		$4=block_overlaping		$5=subpixel		$6=search_rang		$7=spatial_levels
	# Prepara espacio de trabajo
	out=data-${0##*/}_$slope.$1.$2.$3.$4.$5.$6.$7
	codestream=codestream-${0##*/}$slope.$1.$2.$3.$4.$5.$6.$7
	rm -rf $out ; rm -rf $codestream ; mkdir $codestream
	mkdir $out ; cd $out


	ln -s $DATA/$VIDEO low_0
	mcj2k compress 	--block_overlaping=$4 	--block_size=$1 --block_size_min=$2 --slopes='"'$slope'"' 	--pictures=$PICTURES --temporal_levels=$3 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --subpixel_accuracy=$5 --search_range=$6 --spatial_levels=$7 #> file 2>&1
	#rate_mcj2k=`mcj2k info --pictures=$PICTURES --temporal_levels=$3 --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3` #> outinfo

	# La media de todos los frames del SNR-FD
	#expansión
	rm -rf tmp ; mkdir tmp ; cp *.mjc *type* tmp ; cp -r tmp $base_dir/$codestream
	cd tmp

		# info = Calcula bit-rate
		TotalBytes=0
		for Bytes in `ls -l | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		rate_mcj2k=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`

	mcj2k expand	--block_overlaping=$4 	--block_size=$1 --block_size_min=$2 --layers=10 			--pictures=$PICTURES --temporal_levels=$3 --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM --subpixel_accuracy=$5 --search_range=$6 # > file 2>&1

	#FD
	snr		--block_size=$BLOCK_SIZE --file_A=$DATA/$VIDEO --file_B=low_0 2> tempFFTno.dat										# no FFT
	snr2D	--block_size=$BLOCK_SIZE --dim_X=$X_DIM --dim_Y=$Y_DIM --file_A=$DATA/$VIDEO --file_B=low_0 --FFT 2> tempFFT2D.dat	# FFT en 2D
	snr3D	--block_size=$BLOCK_SIZE --dim_X=$X_DIM --dim_Y=$Y_DIM --file_A=$DATA/$VIDEO --file_B=low_0 --FFT 2> tempFFT3D.dat	# FFT en 3D

	cp tempFFTno.dat tempFFT2D.dat tempFFT3D.dat $base_dir/$codestream

	#RD
	RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
	echo -e $rate_mcj2k'\t'$RMSE >> $base_dir/$VIDEO.RD.dat

	# Media
	fd_media_fftno=`echo "" | awk '{SUM+=$2} END {print SUM/NR}' tempFFTno.dat`
	fd_media_fft2D=`echo "" | awk '{SUM+=$2} END {print SUM/NR}' tempFFT2D.dat`
	fd_media_fft3D=`echo "" | awk '{SUM+=$2} END {print SUM/NR}' tempFFT3D.dat`

	# Indice
	indice_FFTno=`echo "$fd_media_fftno/$rate_mcj2k" | bc -l`
	indice_FFT2D=`echo "$fd_media_fft2D/$rate_mcj2k" | bc -l`
	indice_FFT3D=`echo "$fd_media_fft3D/$rate_mcj2k" | bc -l`

	cd .. ; cd ..
	#rm -rf $out
	rm -rf $codestream

	# Resultado:
	echo -e "$slope \t$1 \t\t$2 \t\t$3 \t\t$4 \t\t$5 \t\t$6 \t\t$7 \t\t\tno \t\t\t$rate_mcj2k \t\t$fd_media_fftno \t$fd_media_fft2D \t$fd_media_fft3D \t\t$indice_FFTno \t\t$indice_FFT2D \t\t$indice_FFT3D" >> $VIDEO.FD$slope.dat
}




##############################	##############################
#			 MAIN				#
##############################	##############################

echo -e "slope \tIBS \tFBS \tTRL \tB_over \tSubp \tSearch_R \tClevels \tAntialiasing \tkbps \t\t\tFD(noFFT) \tFD(FFT2D) \tFD(FFT3D) \tindice(noFFT) \t\tindice(FFT2D) \t\tindice(FFT3D)\n" > $VIDEO.FD$slope.dat

# $1=IBS $2=FBS $3=TRL $4=block_overlaping $5=subpixel $6=search_rang $7=spatial_levels



# 0, 1, 2	-[-]block_o[v]erlaping=number of overlaped pixels between the blocks in the motion estimation (0)
# 0, 1, 2	-[-]subpixel_[a]ccuracy=sub-pixel accuracy of the motion estimation (0)

# $4=block_overlaping	$5=subpixel

# El mejor es:
busca_parametros 64 64 1 2 2 2 5

comentario(){
busca_parametros 64 64 4 2 2 2 1
busca_parametros 64 64 4 2 2 2 2
busca_parametros 64 64 4 2 2 2 3
busca_parametros 64 64 4 2 2 2 4
busca_parametros 64 64 4 2 2 2 5
busca_parametros 64 64 4 2 2 2 6
busca_parametros 64 64 4 2 2 2 7
busca_parametros 64 64 4 2 2 2 8
busca_parametros 64 64 4 2 2 2 9


busca_parametros 64 64 4 0 0 2
busca_parametros 64 64 4 0 1 2
busca_parametros 64 64 4 0 2 2

busca_parametros 64 64 4 1 0 2
busca_parametros 64 64 4 1 1 2
busca_parametros 64 64 4 1 2 2

busca_parametros 64 64 4 2 0 2
busca_parametros 64 64 4 2 1 2
busca_parametros 64 64 4 2 2 2
}
#busca_parametros 64 64 6 3 0 1
#busca_parametros 64 64 6 3 1 1
#busca_parametros 64 64 6 3 2 1
#busca_parametros 64 64 6 3 3 1


comentario(){ # $6=search_rang
busca_parametros 64 64 4 0 0 1
busca_parametros 64 64 4 0 0 2
busca_parametros 64 64 4 0 0 4
busca_parametros 64 64 4 0 0 8
busca_parametros 64 64 4 0 0 16
busca_parametros 64 64 4 0 0 32
busca_parametros 64 64 4 0 0 64
}


comentario(){# $1=IBS $2=FBS $3=TRL
busca_parametros 64 64 8 0 0 4
busca_parametros 64 64 7 0 0 4
busca_parametros 64 64 6 0 0 4
busca_parametros 64 64 5 0 0 4
busca_parametros 64 64 4 0 0 4

busca_parametros 64 32 8 0 0 4
busca_parametros 64 32 7 0 0 4
busca_parametros 64 32 6 0 0 4
busca_parametros 64 32 5 0 0 4
busca_parametros 64 32 4 0 0 4

busca_parametros 64 16 8 0 0 4
busca_parametros 64 16 7 0 0 4
busca_parametros 64 16 6 0 0 4
busca_parametros 64 16 5 0 0 4
busca_parametros 64 16 4 0 0 4

busca_parametros 64 8 8 0 0 4
busca_parametros 64 8 7 0 0 4
busca_parametros 64 8 6 0 0 4
busca_parametros 64 8 5 0 0 4
busca_parametros 64 8 4 0 0 4


busca_parametros 32 32 8 0 0 4
busca_parametros 32 32 7 0 0 4
busca_parametros 32 32 6 0 0 4
busca_parametros 32 32 5 0 0 4
busca_parametros 32 32 4 0 0 4

busca_parametros 32 16 8 0 0 4
busca_parametros 32 16 7 0 0 4
busca_parametros 32 16 6 0 0 4
busca_parametros 32 16 5 0 0 4
busca_parametros 32 16 4 0 0 4

busca_parametros 32 8 8 0 0 4
busca_parametros 32 8 7 0 0 4
busca_parametros 32 8 6 0 0 4
busca_parametros 32 8 5 0 0 4
busca_parametros 32 8 4 0 0 4
}

#set +x
#firefox file://`pwd`/output.svg &
