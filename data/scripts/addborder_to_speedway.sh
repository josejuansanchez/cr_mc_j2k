#!/bin/bash

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

if [ $# -ne 2 ]; then
	echo "Uso: $0 <initial frame #> <final frame #>"
	exit -1
fi

INICIO=$1
FIN=$2
IMAGES_ORIGINALES_PGM="$CR_MC_J2K_HOME/data/sequences/speedway_352x288"
IMAGES_DESTINO_PGM="$CR_MC_J2K_HOME/data/sequences/speedway_384x320"

i=$INICIO
while [ $i -le $FIN ]; do

  i_index=`printf %03d $i`

  echo "Processing image: $i_index"
  convert -bordercolor black -border 16x16 $IMAGES_ORIGINALES_PGM/${i_index}.pgm $IMAGES_DESTINO_PGM/${i_index}.pgm
  
  i=$(($i+1))

done