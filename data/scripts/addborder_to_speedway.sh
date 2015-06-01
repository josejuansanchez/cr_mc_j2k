#!/bin/bash

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

if [ $# -ne 2 ]; then
	echo "Uso: $0 <initial frame #> <final frame #>"
	exit -1
fi

INITIAL=$1
FINAL=$2
IMAGES_PGM_SOURCE="$CR_MC_J2K_HOME/data/sequences/speedway_352x288"
IMAGES_PGM_DESTINATION="$CR_MC_J2K_HOME/data/sequences/speedway_384x320"

i=$INITIAL
while [ $i -le $FINAL ]; do

  i_index=`printf %03d $i`

  echo "Processing image: $i_index"
  convert -bordercolor black -border 16x16 $IMAGES_PGM_SOURCE/${i_index}.pgm $IMAGES_PGM_DESTINATION/${i_index}.pgm
  
  i=$(($i+1))

done