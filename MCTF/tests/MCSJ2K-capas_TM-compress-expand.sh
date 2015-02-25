#!/bin/bash

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x


data_dir=$PWD/data-${0##*/}

##############################	##############################
#                            VÍDEO                           #
##############################	##############################
#mobile_352x288x30x420x300.yuv
#coastguard_352x288x30x420x300.yuv
#crowd_run_3840x2160x50x420x500.yuv
#ducks_3840x2160x50x420x500.yuv
#oldTownCross_1280x720x50x420x500.yuv
#oldTownCross_3840x2160x50x420x500.yuv
#parkJoy_3840x2160x50x420x500.yuv


comentario(){

NAME=oldTownCross
RES_X=3840
RES_Y=2160
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1408
RES_Y=1152
FPS=50
TOTAL_PICTURES=500

NAME=crowd_run
RES_X=3840
RES_Y=2160
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1280
RES_Y=720
FPS=50
TOTAL_PICTURES=500
}

NAME=mobile
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

##############################	##############################
#      		       PARÁMETROS ENTRADA  		     #
##############################	##############################
GOPs=5
TRLs=5
search_range=4
block_size=16
block_size_min=16
all_SRLs=17           # =16+1
discard_SRLs_Tex=0    # <-- DISCARD SRLs TEXTURES
discard_SRLs_Mot=0    # <-- DISCARD SRLs MOTIONS. (Parece que mejor siempre = 0)

#############  #################
#    PARÁMETROS CALCULADOS     #
#############  #################
GOP_size=`echo "2^($TRLs-1)" | bc -l`
PICTURES=`echo "$GOPs*$GOP_size+1" | bc -l`
DURATION=`echo "$PICTURES/$FPS" | bc -l` #segundos

if [[ $PICTURES -gt $TOTAL_PICTURES ]]; then
    echo "Insuficientes frames en el video original ($TOTAL_PICTURES) para --GOPs=$GOPs --TRLs=$TRLs ($PICTURES frames)."
    exit 0
fi

available_SRLs=`echo "l($search_range)+2" | bc -l`
available_SRLs=`echo "$available_SRLs/1" | bc` # Nº de planos de bits totales a resolución nativa
if [[ $discard_SRLs_Tex > $available_SRLs ]]; then
    discard_SRLs_Tex=$available_SRLs # Nº de planos de bits descartados o Nº de resoluciones que se downsamplean
fi

block_size_snr=`echo "($RES_X*$RES_Y*1.5)/1" | bc` #block_size_snr=`echo "($RES_X*$RES_Y*1.5*$GOP_size)/1" | bc`
RES_X_transcode=`echo "$RES_X/(2^$discard_SRLs_Tex)" | bc`
RES_Y_transcode=`echo "$RES_Y/(2^$discard_SRLs_Tex)" | bc`
block_size_transcode=`echo "$block_size/(2^$discard_SRLs_Tex)" | bc`
block_size_min_transcode=`echo "$block_size_min/(2^$discard_SRLs_Tex)" | bc`
search_range_transcode=`echo "$search_range/(2^$discard_SRLs_Tex)" | bc`
SRLs=5 #`echo "$available_SRLs-$discard_SRLs_Tex" | bc` # Nº de planos de bits que se envian realmente (+ 1, el signo)

VIDEO=$NAME'_'$RES_X'x'$RES_Y'x'$FPS'x420x'$TOTAL_PICTURES
VIDEOdown=$NAME'_'$RES_X_transcode'x'$RES_Y_transcode'x'$FPS'x420x'$TOTAL_PICTURES
INFO=$data_dir'/../info_'$discard_SRLs_Tex'_'$discard_SRLs_Mot'.dat'

#echo "available_SRLs: " $available_SRLs #
#read word ; echo "Pulsa enter para continuar..." #

#############  #################
#          DESCARGA            #
#############  #################
if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    echo "no esta"
else
    echo "si esta"
#    current_dir=$PWD
#    cd $DATA
#    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
#    ffmpeg -i $VIDEO.avi $VIDEO.yuv
#    cd $current_dir
fi

##############################	##############################
#      		           FUNCION: compress  		     #
##############################	##############################
MCSJ2K_COMPRESS () {

rm -rf $data_dir
mkdir $data_dir
ln -s $DATA/${VIDEO}.yuv $data_dir/low_0
cd $data_dir

# Con SLOPES manuales (quantization) // Con SLOPES automáticos (clayers)
mcj2k compress --clayers_motion=$1 --quantization_motion=$2 --quantization_texture=$3 --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size --block_size_min=$block_size_min --search_range=$search_range --pixels_in_x=$RES_X --pixels_in_y=$RES_Y


# INFO
echo -e "\n\n\n# "$1'\t'$2'\t'$3'\t'$VIDEO" -> "$RES_X_transcode"x"$RES_Y_transcode'('$discard_SRLs_Tex//$discard_SRLs_Mot')''\t'GOPs=$GOPs TRLs=$TRLs PICTURES=$PICTURES >> $INFO
echo -e "# "L_mot'\t'L_tex'\t'kbps_MJC'\t'kbps_J2C'\t'KBPS'\t'RMSE_1D'\t'RMSE_2D'\t'RMSE_3D >> $INFO
}


##############################	##############################
#      		           FUNCION: expand    		     #
##############################	##############################
MCSJ2K_EXPAND () {

cd $data_dir
rm -rf extract
rm -rf tmp
mkdir tmp


#############  #################
#         TRANSCODE            #
#############  #################
mcj2k transcode --Clayers_motion=$1 --Clayers_texture=$2 --discard_SRLs_Tex=$discard_SRLs_Tex --discard_SRLs_Mot=$discard_SRLs_Mot --TRLs=$TRLs --GOPs=$GOPs


#############  #################
#           ENVIO              #
#############  #################
# TEXTURAS y FRAME_TYPES
#cp *.j2c *type* tmp # sin transcode
cp extract/*.j2c *type* tmp # con transcode

# VECTORES
#cp *.mjc tmp # sin transcode
cp extract/*.mjc tmp # con transcode


#############  #################
#     Calcula bit-rate         #
#############  #################
cd tmp

TotalBytes=0
for Bytes in `ls -l *.mjc | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps_MJC=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`

TotalBytes=0
for Bytes in `ls -l *.j2c | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps_J2C=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`

TotalBytes=0
for Bytes in `ls -l | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`


#############  #################
#       DESCOMPRESION          #
#############  #################
mcj2k expand --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size_transcode --block_size_min=$block_size_min_transcode --search_range=$search_range_transcode --pixels_in_x=$RES_X_transcode --pixels_in_y=$RES_Y_transcode --subpixel_accuracy=$discard_SRLs_Tex


# INFO # mcsj2k info --GOPs=$GOPs --TRLs=$TRLs
DownConvertStatic $RES_X_transcode $RES_Y_transcode low_0 $RES_X $RES_Y low_0_UP

rmse1D=`snr --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP 2> /dev/null | grep RMSE | cut -f 3`
rmse2D=`snr2D --block_size=$block_size_snr --dim_X=$RES_X --dim_Y=$RES_Y --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP --FFT 2>  /dev/null | grep RMSE | cut -f 3` # FFT en 3D
rmse3D=`snr3D --block_size=$block_size_snr --dim_X=$RES_X --dim_Y=$RES_Y --dim_Z=5 --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP --FFT 2> /dev/null | grep RMSE | cut -f 3` # FFT en 3D

echo -e $1'\t'$2'\t'$kbps_MJC'\t'$kbps_J2C'\t'$kbps'\t'$rmse1D'\t'$rmse2D'\t'$rmse3D >> $INFO

}


##############################	##############################
#      		             MAIN        		     #
##############################	##############################

# MCSJ2K_COMPRESS()  Q_clayers_motion Q_motion Q_texture
# MCSJ2K_EXPAND()    Clayers_motion Clayers_texture

MCSJ2K_COMPRESS 8 55000,50000,45000 45000,44750,44500,44250,44000,43750,43500,43250
MCSJ2K_EXPAND 1 1
MCSJ2K_EXPAND 2 1
MCSJ2K_EXPAND 3 1
MCSJ2K_EXPAND 4 1
MCSJ2K_EXPAND 5 1
MCSJ2K_EXPAND 6 1
MCSJ2K_EXPAND 7 1
MCSJ2K_EXPAND 8 1

MCSJ2K_EXPAND 1 2
MCSJ2K_EXPAND 2 2
MCSJ2K_EXPAND 3 2
MCSJ2K_EXPAND 4 2
MCSJ2K_EXPAND 5 2
MCSJ2K_EXPAND 6 2
MCSJ2K_EXPAND 7 2
MCSJ2K_EXPAND 8 2

MCSJ2K_EXPAND 1 3
MCSJ2K_EXPAND 2 3
MCSJ2K_EXPAND 3 3
MCSJ2K_EXPAND 4 3
MCSJ2K_EXPAND 5 3
MCSJ2K_EXPAND 6 3
MCSJ2K_EXPAND 7 3
MCSJ2K_EXPAND 8 3

MCSJ2K_EXPAND 1 4
MCSJ2K_EXPAND 2 4
MCSJ2K_EXPAND 3 4
MCSJ2K_EXPAND 4 4
MCSJ2K_EXPAND 5 4
MCSJ2K_EXPAND 6 4
MCSJ2K_EXPAND 7 4
MCSJ2K_EXPAND 8 4

MCSJ2K_EXPAND 1 5
MCSJ2K_EXPAND 2 5
MCSJ2K_EXPAND 3 5
MCSJ2K_EXPAND 4 5
MCSJ2K_EXPAND 5 5
MCSJ2K_EXPAND 6 5
MCSJ2K_EXPAND 7 5
MCSJ2K_EXPAND 8 5

MCSJ2K_EXPAND 1 6
MCSJ2K_EXPAND 2 6
MCSJ2K_EXPAND 3 6
MCSJ2K_EXPAND 4 6
MCSJ2K_EXPAND 5 6
MCSJ2K_EXPAND 6 6
MCSJ2K_EXPAND 7 6
MCSJ2K_EXPAND 8 6

MCSJ2K_EXPAND 1 7
MCSJ2K_EXPAND 2 7
MCSJ2K_EXPAND 3 7
MCSJ2K_EXPAND 4 7
MCSJ2K_EXPAND 5 7
MCSJ2K_EXPAND 6 7
MCSJ2K_EXPAND 7 7
MCSJ2K_EXPAND 8 7

MCSJ2K_EXPAND 1 8
MCSJ2K_EXPAND 2 8
MCSJ2K_EXPAND 3 8
MCSJ2K_EXPAND 4 8
MCSJ2K_EXPAND 5 8
MCSJ2K_EXPAND 6 8
MCSJ2K_EXPAND 7 8
MCSJ2K_EXPAND 8 8




comentario(){
MCSJ2K_COMPRESS 8 55000,50000,45000 44000,43000,42000
MCSJ2K_EXPAND 1 3
MCSJ2K_EXPAND 2 3
MCSJ2K_EXPAND 3 3
MCSJ2K_EXPAND 4 3
MCSJ2K_EXPAND 5 3
MCSJ2K_EXPAND 6 3
MCSJ2K_EXPAND 7 3
MCSJ2K_EXPAND 8 3
MCSJ2K_EXPAND 9 3
MCSJ2K_EXPAND 10 3
MCSJ2K_EXPAND 11 3
MCSJ2K_EXPAND 12 3
}


# Al chocar por arriba: devuelve los mismos vectores. Al chocar por abajo: violación segmento.

##################### MPLAYER
echo "mplayer low_0 -demuxer rawvideo -rawvideo w=$RES_X_transcode:h=$RES_Y_transcode -loop 0"

##################### GNUPLOT
comentario(){

gnuplot <<EOF
set terminal svg
set output "out.svg"
set grid
set title "CIF_mobile. T=44000 & M=1..8(clayers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_0_0.dat" using 5:6 title "Descarte SRL = 0" with linespoints, \
"info_1_0.dat" using 5:6 title "= 1" with linespoints, \
"info_2_0.dat" using 5:6 title "= 2" with linespoints
EOF

gnuplot <<EOF
set terminal svg
set output "out.svg"
set grid
set title "CIF_mobile. T=1..8 & M=1..8 (clayers)"
set xlabel "Kbps"
set ylabel "RMSE"
set logscale x
plot "info_0_0 T1.dat" using 5:6 title "T1" with linespoints, \
"info_0_0 T2.dat" using 5:6 title "T2" with linespoints, \
"info_0_0 T3.dat" using 5:6 title "T3" with linespoints, \
"info_0_0 T4.dat" using 5:6 title "T4" with linespoints, \
"info_0_0 T5.dat" using 5:6 title "T5" with linespoints, \
"info_0_0 T6.dat" using 5:6 title "T6" with linespoints, \
"info_0_0 T7.dat" using 5:6 title "T7" with linespoints, \
"info_0_0 T8.dat" using 5:6 title "T8" with linespoints
EOF

}

set +x
