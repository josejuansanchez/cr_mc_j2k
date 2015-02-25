#!/bin/bash

# Curva RD para varios niveles de resolución espacial. Sólo
# escalabilidad en resolución.


##############################	##############################
#				  		EJEMPLO DE USO						 #
##############################	##############################

ejemplo_uso () {
# 1920x1080
	nohup ./MCLTW-RD-spatial.sh in_ducks_1920x1088 2.0 > $DATA_OUT/out.MCLTW_ducks_1920x1088 2>&1&
# 3840x2048
	nohup ./MCLTW-RD-spatial.sh in_ducks_3840x2048 2.0 > $DATA_OUT/out.MCLTW_ducks_3840x2048 2>&1&
	nohup ./MCLTW-RD-spatial.sh in_intotree_3840x2048 2.0 > $DATA_OUT/out.MCLTW_intotree_3840x2048 2>&1&
	nohup ./MCLTW-RD-spatial.sh in_intotree_BW_3840x2048 2.0 > $DATA_OUT/out.MCLTW_intotree_BW_3840x2048 2>&1&
	nohup ./MCLTW-RD-spatial.sh in_oldtowncross_3840x2048 2.0 > $DATA_OUT/out.MCLTW_oldtowncross_3840x2048 2>&1&
	nohup ./MCLTW-RD-spatial.sh in_crowdrun_3840x2048 2.0 > $DATA_OUT/out.MCLTW_crowdrun_3840x2048 2>&1&
	nohup ./MCLTW-RD-spatial.sh in_parkjoy_3840x2048 2.0 > $DATA_OUT/out.MCLTW_parkjoy_3840x2048 2>&1&
# 4096x4096
	nohup ./MCLTW-RD-spatial.sh in_sun_4096x4096 2.0 > $DATA_OUT/out.MCLTW_sun_4096x4096 2>&1&
}



##############################	##############################
#				  	DATOS DE ENTRADA - IN - 				 #
##############################	##############################


in_parkjoy_1920x1024 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=1024
	PIXELS_IN_X=1920
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=4
	TEMPORAL_LEVELS=6
	VIDEO=down1920x1024-parkjoy_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}




in_crowdrun_3840x2048 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=crowdrun_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_intotree_3840x2048 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=intotree_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_intotree_BW_3840x2048 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=intotree_BW_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_oldtowncross_3840x2048 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=oldtowncross_3840x2048x50x420x65
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
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=parkjoy_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_sun_4096x4096 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=4096
	PIXELS_IN_X=4096
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=8
	TEMPORAL_LEVELS=6
	VIDEO=sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_coastguard_352x288 () {
	BLOCK_SIZE=16
	PICTURES=5 #289
	PIXELS_IN_Y=288
	PIXELS_IN_X=352
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=3 # 3 is the maximun for this resolution
	TEMPORAL_LEVELS=2
	VIDEO=coastguard_352x288x30x420x300
}

in_stockholm_1280x768 () {
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50 #289
	PICTURES=65
	PIXELS_IN_Y=768
	PIXELS_IN_X=1280
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6 # 3 is the maximun for this resolution
	TEMPORAL_LEVELS=5
	VIDEO=stockholm_1280x768x50x420x578
}



# ducks_3840x2048x50x420x65.yuv
# down1920x1024-ducks_3840x2048x50x420x65.yuv
# down960x512-ducks_3840x2048x50x420x65.yuv
# down480x256-ducks_3840x2048x50x420x65.yuv
# down240x128-ducks_3840x2048x50x420x65.yuv
# down120x64-ducks_3840x2048x50x420x65.yuv
# down60x32-ducks_3840x2048x50x420x65.yuv


in_ducks_3840x2048 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_3840x2048 0.5 &
	BLOCK_SIZE=128
	BLOCK_SIZE_MIN=128
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=3840
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=ducks_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=4
}

in_ducks_1920x1024 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_1920x1024 0.5 &
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=1024
	PIXELS_IN_X=1920
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=5
	TEMPORAL_LEVELS=6
	VIDEO=down1920x1024-ducks_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_960x512 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_960x512 0.5 &
	BLOCK_SIZE=32
	BLOCK_SIZE_MIN=32
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=512
	PIXELS_IN_X=960
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=4
	TEMPORAL_LEVELS=6
	VIDEO=down960x512-ducks_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_480x256 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_480x256 0.5 &
	BLOCK_SIZE=16
	BLOCK_SIZE_MIN=16
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=256
	PIXELS_IN_X=480
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=3
	TEMPORAL_LEVELS=6
	VIDEO=down480x256-ducks_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_240x128 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_240x128 0.5 &
	BLOCK_SIZE=8
	BLOCK_SIZE_MIN=8
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=128
	PIXELS_IN_X=240
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=2
	TEMPORAL_LEVELS=6
	VIDEO=down240x128-ducks_3840x2048x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}


# # # # # SUN # # # # # 

# ./MCLTW-RD-spatial.sh in_sun_4096x4096 13;./MCLTW-RD-spatial.sh in_sun_2048x2048 13;./MCLTW-RD-spatial.sh in_sun_1024x1024 13;./MCLTW-RD-spatial.sh in_sun_512x512 13;./MCLTW-RD-spatial.sh in_sun_256x256 13;./MCLTW-RD-spatial.sh in_sun_128x128 13;./MCLTW-RD-spatial.sh in_sun_64x64 13


in_sun_4096x4096 () { # nohup ./MCLTW-RD-spatial.sh in_sun_4096x4096 13 &
	BLOCK_SIZE=4096
	BLOCK_SIZE_MIN=4096
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=4096
	PIXELS_IN_X=4096
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=8
	TEMPORAL_LEVELS=6
	VIDEO=sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_2048x2048 () { # nohup ./MCLTW-RD-spatial.sh in_sun_2048x2048 13 &
	BLOCK_SIZE=2048
	BLOCK_SIZE_MIN=2048
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=2048
	PIXELS_IN_X=2048
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=7
	TEMPORAL_LEVELS=6
	VIDEO=down2048x2048-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_1024x1024 () { # nohup ./MCLTW-RD-spatial.sh in_sun_1024x1024 13 &
	BLOCK_SIZE=1024
	BLOCK_SIZE_MIN=1024
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=1024
	PIXELS_IN_X=1024
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=6
	TEMPORAL_LEVELS=6
	VIDEO=down1024x1024-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_512x512 () { # nohup ./MCLTW-RD-spatial.sh in_sun_512x512 13 &
	BLOCK_SIZE=512
	BLOCK_SIZE_MIN=512
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=512
	PIXELS_IN_X=512
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=5
	TEMPORAL_LEVELS=6
	VIDEO=down512x512-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_256x256 () { # nohup ./MCLTW-RD-spatial.sh in_sun_256x256 13 &
	BLOCK_SIZE=256
	BLOCK_SIZE_MIN=256
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=256
	PIXELS_IN_X=256
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=4
	TEMPORAL_LEVELS=6
	VIDEO=down256x256-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_128x128 () { # nohup ./MCLTW-RD-spatial.sh in_sun_128x128 13 &
	BLOCK_SIZE=128
	BLOCK_SIZE_MIN=128
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=128
	PIXELS_IN_X=128
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=3
	TEMPORAL_LEVELS=6
	VIDEO=down128x128-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

in_sun_64x64 () { # nohup ./MCLTW-RD-spatial.sh in_sun_64x64 13 &
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=30
	PICTURES=65
	PIXELS_IN_Y=64
	PIXELS_IN_X=64
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=2
	TEMPORAL_LEVELS=6
	VIDEO=down64x64-sun_4096x4096x30x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=1
}

# # # # # DUCKS fullHD # # # # #		# 6 subresoluciones: DONT WORK pq esta resolucion en luma si es par al ir dividiendo (60x34), pero en color no (30x17).

in_ducks_1920x1088 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_1920x1088 7.5 & 
	BLOCK_SIZE=64
	BLOCK_SIZE_MIN=64
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=1088
	PIXELS_IN_X=1920
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=4
	TEMPORAL_LEVELS=6
	VIDEO=ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_960x544 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_960x544 7.5 & 
	BLOCK_SIZE=32
	BLOCK_SIZE_MIN=32
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=544
	PIXELS_IN_X=960
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=3
	TEMPORAL_LEVELS=6
	VIDEO=down960x544-ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_480x272 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_480x272 7.5 &
	BLOCK_SIZE=16
	BLOCK_SIZE_MIN=16
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=272
	PIXELS_IN_X=480
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=2
	TEMPORAL_LEVELS=6
	VIDEO=down480x272-ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

# # # # # # # 

in_ducks_240x136 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_240x136 7.5 &
	BLOCK_SIZE=8
	BLOCK_SIZE_MIN=8
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=136
	PIXELS_IN_X=240
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=3
	TEMPORAL_LEVELS=6
	VIDEO=down240x136-ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
}

in_ducks_120x68 () { # nohup ./MCLTW-RD-spatial.sh in_ducks_120x68 7.5 &
	BLOCK_SIZE=4
	BLOCK_SIZE_MIN=4
	FPS=50
	PICTURES=65
	PIXELS_IN_Y=68
	PIXELS_IN_X=120
	IMAGE_SIZE=`echo "($PIXELS_IN_X*$PIXELS_IN_Y*1.5)/1" | bc`
	SPATIAL_LEVELS=2
	TEMPORAL_LEVELS=6
	VIDEO=down120x68-ducks_1920x1088x50x420x65
	OVERLAPING=0
	SUBPIXEL=0
	SEARCH_RANGE=2
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

set -x

script_name_with_extension=${0##*/}
script_name=(${script_name_with_extension//./ })
data_dir=$DATA_OUT/data-$script_name.$VIDEO""_$2
gpt_file=$data_dir/$script_name.$VIDEO.gpt


##############################	##############################
#				  			DESCARGA	 					 #
##############################	##############################

if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    current_dir=$PWD
    cd $DATA
    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
    ffmpeg -i $VIDEO.avi $VIDEO.yuv
    cd $current_dir
fi

rm -rf $data_dir
mkdir $data_dir ; mkdir $data_dir/TIMES
cd $data_dir
ln -s $DATA/${VIDEO}.yuv low_0


##############################	##############################
#				  			FUNCIONES	 					 #
##############################	##############################


LTW () {
    (time mcltw compress --block_size=$BLOCK_SIZE --block_size_min=$BLOCK_SIZE_MIN --pictures=$PICTURES --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --slopes='"'$1'"' --spatial_levels=$SPATIAL_LEVELS --temporal_levels=$TEMPORAL_LEVELS --update_factor=0 --block_overlaping=$OVERLAPING --subpixel_accuracy=$SUBPIXEL --search_range=$SEARCH_RANGE) 2>> $data_dir/TIMES/compress.$PIXELS_IN_X""x$PIXELS_IN_Y.dat
    rm -rf tmp
    mkdir tmp
    cp *.mjc *.ltw *type* tmp
    cd tmp
    # Note: LTW's expand also transcode the input files
    (time mcltw expand --block_size=$BLOCK_SIZE --block_size_min=$BLOCK_SIZE_MIN --pictures=$PICTURES  --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --temporal_levels=$TEMPORAL_LEVELS --resolutions=$2 --update_factor=0 --block_overlaping=$OVERLAPING --subpixel_accuracy=$SUBPIXEL --search_range=$SEARCH_RANGE) 2>> $data_dir/TIMES/expand.$PIXELS_IN_X""x$PIXELS_IN_Y.dat
    #mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null &
	RMSE=`snr --file_A=../low_0 --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcltw info --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    cd ..
    echo -e $rate'\t'$RMSE >> MCLTW_$1.dat
}


##############################	##############################
#				  			MAIN		 					 #
##############################	##############################
#LTW $2 0

#resolution=$SPATIAL_LEVELS
#while [ $resolution -ge 0 ]
#do

#    LTW $2 $resolution
#    let resolution=resolution-1
#done




##############################	##############################
#				  			PLOT		 					 #
##############################	##############################
cd $data_dir

rm -f $gpt_file
cat >> $gpt_file << EOF
set terminal fig color fontsize 12
set output "$script_name.fig"
set yrange [0:]
set xrange[0:]
set title "$script_name"
set xlabel "Kbps"
set ylabel "RMSE"
plot "$data_dir/MCLTW.dat" title "MCLTW" with linespoints
EOF


#exit 0 # Esto se ejecuta en una carpeta ya exa con mcltw compress
# Subbanda 1 a 1. Los vectores deben haberse sacado ya (usando el codigo anterior por ejemplo)
# ./MCLTW-RD-spatial.sh in_ducks_240x128 2.0
##############################	##############################
#				  			Qs			 					 ##########################################
##############################	##############################
export SLOPES="caracola"
export MCTF_TEXTURE_CODEC="ltw"
export MCTF_MOTION_CODEC="j2k"

H1=10
H2=8
H3=6
H4=4
H5=2
L=1

##############################	##############################
#  			COMPRESION			 #
##############################	##############################

cd $data_dir
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_hfb_ltw --file=high_1 --pictures=32 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$H1 --subband=1 --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_hfb_ltw --file=high_2 --pictures=16 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$H2 --subband=2 --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_hfb_ltw --file=high_3 --pictures=8 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$H3 --subband=3 --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_hfb_ltw --file=high_4 --pictures=4 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$H4 --subband=4 --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_hfb_ltw --file=high_5 --pictures=2 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$H5 --subband=5 --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS
/home/cmaturana/QSVC/MCTF/branches/ScalableMotionVectors/bin/texture_compress_lfb_ltw --file=low_5 --pictures=3 --pixels_in_x=$PIXELS_IN_X --pixels_in_y=$PIXELS_IN_Y --slopes=$L --temporal_levels=6 --spatial_levels=$SPATIAL_LEVELS


##############################	##############################
#            		DESCOMPRESIONES			     #
##############################	##############################

rm $data_dir/MCLTW_Qs$H1-$H2-$H3-$H4-$H5-$L.dat

resolucion=0
#while [ $SPATIAL_LEVELS -ge $resolucion ]
#do
	cd $data_dir; rm -rf tmp; mkdir tmp; cp *.mjc *.ltw *type* tmp; cd tmp
	/home/cmaturana/QSVC/MCTF/branches/J2K/bin/expand --block_size=$BLOCK_SIZE --block_size_min=$BLOCK_SIZE_MIN --pictures=$PICTURES --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --temporal_levels=6 --resolutions=$resolucion --update_factor=0 --block_overlaping=$OVERLAPING --subpixel_accuracy=$SUBPIXEL --search_range=$SEARCH_RANGE
		

	# upsamplin
	DownConvertStatic $PIXELS_IN_X $PIXELS_IN_Y low_0 1920 1088 uplow_0

	RMSE=`snr --file_A=$DATA/ducks_1920x1088x50x420x65.yuv --file_B=uplow_0 2> /dev/null | grep RMSE | cut -f 3`
    rate=`mcltw info --pictures=$PICTURES --temporal_levels=6 --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
    echo -e $rate'\t'$RMSE >> $data_dir/MCLTW_Qs$H1-$H2-$H3-$H4-$H5-$L.dat
	echo -e $rate'\t'$RMSE >> $DATA_OUT/CARMELO.dat
#    let resolucion=resolucion+1
#done


set +x
