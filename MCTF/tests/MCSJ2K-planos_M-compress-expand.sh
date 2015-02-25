#!/bin/bash

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_dir=data-${0##*/}


MCSJ2K () {

##############################	##############################
#      		     PARÁMETROS DE ENTRADA		     #
##############################	##############################
GOPs=6
TRLs=6
search_range=4
block_size=16
block_size_min=16
all_SRLs=17         # =16+1
discard_SRLs=0      # <-- DISCARD SRLs

GOP_size=`echo "2^($TRLs-1)" | bc -l`
PICTURES=`echo "$GOPs*$GOP_size+1" | bc -l`
FPS=30
DURATION=`echo "$PICTURES/$FPS" | bc -l` #segundos

q=$1
#mobile_352x288x30x420x300 #akiyo_352x288x30x420x300 #container_352x288x30x420x300 #coastguard_352x288x30x420x300 # ducks_3840x2048x50x420x65
RES_X=352
RES_Y=288
VIDEO=mobile_$RES_X"x"$RES_Y"x"$FPS"x420x300"

#read word ; echo "Pulsa enter para continuar..." #

##############################	##############################
#    	     	     PARÁMETROS CALCULADOS     		     #
##############################	##############################
available_SRLs=`echo "l($search_range)+2" | bc -l`
available_SRLs=`echo "$available_SRLs/1" | bc` # Nº de planos de bits totales a resolución nativa
if [[ $discard_SRLs > $available_SRLs ]]; then
    discard_SRLs=$available_SRLs # Nº de planos de bits descartados o Nº de resoluciones que se downsamplean
fi

RES_X_transcode=`echo "$RES_X/(2^$discard_SRLs)" | bc`
RES_Y_transcode=`echo "$RES_Y/(2^$discard_SRLs)" | bc`
block_size_transcode=`echo "$block_size/(2^$discard_SRLs)" | bc`
block_size_min_transcode=`echo "$block_size_min/(2^$discard_SRLs)" | bc`
SRLs=`echo "$available_SRLs-$discard_SRLs" | bc` # Nº de planos de bits que se envian realmente (+ 1, el signo)

echo "available_SRLs: " $available_SRLs #
#read word ; echo "Pulsa enter para continuar..." #

##############################	##############################
#			     MAIN			     #
##############################	##############################
if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    current_dir=$PWD
    cd $DATA
    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
    ffmpeg -i $VIDEO.avi $VIDEO.yuv
    cd $current_dir
fi

rm -rf $data_dir
mkdir $data_dir
cd $data_dir
mkdir tmp
ln -s $DATA/${VIDEO}.yuv low_0


#############  #################
#        COMPRESION            #
#############  #################
# COMPRIME
mcsj2k compress --quantization=$q --GOPs=$GOPs --TRLs=$TRLs --block_size=$block_size --block_size_min=$block_size_min --search_range=$search_range --pixels_in_x=$RES_X --pixels_in_y=$RES_Y

# TRANSCODE
mcj2k transcode --discard_SRLs=$discard_SRLs --TRLs=$TRLs --GOPs=$GOPs

#############  #################
#           ENVIO              #
#############  #################
# TEXTURAS y FRAME_TYPES
#cp *.j2c *type* tmp # sin transcode
cp extract/*.j2c *type* tmp # con transcode

# VECTORES
if [[ $SRLs -gt 0 ]]; then
    cp trl?_sm0.mjc tmp # Signos
    for (( trl=1 ; trl<$TRLs ; trl++)); do # Magnitudes
	for (( i=1+$discard_SRLs ; i<=$available_SRLs+($trl-1) ; i++)); do # Magnitudes
	    cp trl$trl''_sm$i.mjc tmp
	done
    done
else
    echo "Se ha descartado todo. No se envia información de movimiento."
fi


# info ~ Calcula bit-rate
TotalBytes=0
for Bytes in `ls -l | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`
#read word ; echo "Pulsa enter para continuar..." #

#############  #################
#       DESCOMPRESION          #
#############  #################
cd tmp
mcsj2k expand --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size_transcode --block_size_min=$block_size_min_transcode --search_range=$search_range --pixels_in_x=$RES_X_transcode --pixels_in_y=$RES_Y_transcode

# INFO
# mcsj2k info --GOPs=$GOPs --TRLs=$TRLs

rmse=`snr --file_A=../low_0 --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
echo -e $q'\t'$kbps'\t'$rmse >> $DATA_OUT/MCSJ2K/info_$VIDEO.dat

echo mplayer $data_dir/tmp/low_0 -demuxer rawvideo -rawvideo w=$RES_X_transcode:h=$RES_Y_transcode -loop 0
mplayer low_0 -demuxer rawvideo -rawvideo w=$RES_X_transcode:h=$RES_Y_transcode -loop 0

}

#############  #################
#           MAIN               #
#############  #################

MCSJ2K 41000
MCSJ2K 42000
MCSJ2K 43000
MCSJ2K 44000
MCSJ2K 45000


set +x