#!/bin/bash

# Curva RD para varios niveles de resolución espacial. Sólo
# escalabilidad en resolución.



set -x


##############################	##############################
#				  		EJEMPLO DE USO						 #
##############################	##############################

ejemplo_uso () {
# 1920x1088
	nohup ./spatial_scalability_mj2k.sh in_ducks_1920x1088 > $DATA_OUT/out.spatial_scalability_mj2k_ducks_1920x1088 2>&1&
}



##############################	##############################
#				  	DATOS DE ENTRADA - IN - 				 #
##############################	##############################

in_ducks_1920x1088 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=1088
	PIXELS_IN_X=1920
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
#	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	#SPATIAL_LEVELS=4
	TEMPORAL_LEVELS=1
	VIDEO=ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_parkjoy_3840x2048 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
#	DURATION=`echo "$PICTURES/$FPS" | bc -l`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=1
	VIDEO=parkjoy_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

# Llamada al dato de entrada concreto
$1

##############################	##############################
#						  ESPACIO DE TRABAJO				 #
##############################	##############################
export DATA=~/scratch/DATA_IN/
export DATA_OUT=~/scratch/DATA_OUT/

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi
if [ -z $DATA_OUT ]; then echo "Hi! \$DATA_OUT undefined!"; exit; fi
echo "MCTF: "$MCTF

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })
data_dir=$DATA_OUT/data-${0##*/}_$1
gpt_file=$data_dir/$script_name.gpt

comentario() {
	if [[ ! -e $DATA/$VIDEO.yuv ]]; then
		current_dir=$PWD
		cd $DATA
		wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
		ffmpeg -i $VIDEO.avi $VIDEO.yuv
		cd $current_dir
	fi
}

rm -rf $data_dir
mkdir $data_dir; mkdir $data_dir/TIMES

cd $data_dir
ln -s $DATA/${VIDEO}.yuv low_0


##############################	##############################
#						  FUNCIONES						 	 #
##############################	##############################

J2K () {
	cd $data_dir

    # Compress
	(time mcjm2k compress --slopes='"'$1'"' --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --block_size=$BLOCK_SIZE) 2>> $data_dir/TIMES/mcj2k_$2.dat

    rm -rf tmp ; mkdir tmp ; cp *.mjc *type* tmp

	# Extract
    (time mcjm2k extract --temporal_levels=$TEMPORAL_LEVELS --pictures=$PICTURES --resolutions=$2) 2>> $data_dir/TIMES/extract_$2.dat

	# Expand
    piy=`echo "$PIXELS_IN_Y/(2^$2)" | bc`
    pix=`echo "$PIXELS_IN_X/(2^$2)" | bc`
    bs=`echo "$BLOCK_SIZE/(2^$2)" | bc`

	cd $data_dir/tmp	
	(time mcmj2k expand --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$piy --pixels_in_x=$pix --subpixel_accuracy=$2 --block_size=$bs) 2>> $data_dir/TIMES/expand_$2.$pix""x$piy.dat

	# Upsampling.
	(time DownConvertStatic $pix $piy low_0 $PIXELS_IN_X $PIXELS_IN_Y uplow_0) 2>> $data_dir/TIMES/upSamplin_$2.$pix""x$piy.dat

	# Cálculo: rate rmse
    RMSE=`snr --block_size=$IMAGE_SIZE --file_A=$data_dir/low_0 --file_B=uplow_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcmj2k info --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $pix"x"$piy":"'\t'$rate'\t'$rate_mj2k'\t'$RMSE >> $data_dir/MCMJ2K.dat
}

##############################	##############################
#							 MAIN							 #
##############################	##############################

#J2K 43700 0
J2K 43700 1
J2K 43700 2
J2K 43700 3
J2K 43700 4
J2K 43700 5


set +x
