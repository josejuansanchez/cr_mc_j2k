#!/bin/bash
set -x

# ::::::::::::::
# : La llamada :
# ::::::::::::::


# Codificaciones MCJ2K
	comentario(){
		# Parametros
		$1=VIDEO
		$2=slope
		$3=IBS
		$4=FBS
		$5=TRL
		$6=block_overlaping
		$7=subpixel
		$8=search_rang
		$9=spatial_levels

	}
slopes=(45000 44000 43000 42000 41000)

for s in "${slopes[@]}"; do
	./MCJ2K.sh $VIDEO_4k $slope $IBS $FBS $TRL $OVERLAPING $SUBPIXEL $SEARCH_RANGE $SPATIAL_LEVELS



# ::::::::::::::
# : El script  :
# ::::::::::::::

VIDEO=ducks_1920x1088x50x420x500.yuv
slope=$1

comentario(){
	# Parametros
	$1=VIDEO
	$2=slope
	$3=IBS
	$4=FBS
	$5=TRL
	$6=block_overlaping
	$7=subpixel
	$8=search_rang
	$9=spatial_levels

}


	# Prepara espacio de trabajo
	out=data-${0##*/}_$slope.$1.$2.$3.$4.$5.$6.$7
	codestream=codestream-${0##*/}$slope.$1.$2.$3.$4.$5.$6.$7
	rm -rf $out ; rm -rf $codestream ; mkdir $codestream
	mkdir $out ; cd $out


	ln -s $DATA/VIDEOS/$VIDEO low_0
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
	snr		--block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> tempFFTno.dat										# no FFT
	snr2D	--block_size=$BLOCK_SIZE --dim_X=$X_DIM --dim_Y=$Y_DIM --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 --FFT 2> tempFFT2D.dat	# FFT en 2D
	snr3D	--block_size=$BLOCK_SIZE --dim_X=$X_DIM --dim_Y=$Y_DIM --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 --FFT 2> tempFFT3D.dat	# FFT en 3D

	cp tempFFTno.dat tempFFT2D.dat tempFFT3D.dat $base_dir/$codestream

	#RD
	RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
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

# $4=block_overlaping	$5=subpixel

# El mejor es:
busca_parametros 64 64 4 0 2 2 4




#set +x

