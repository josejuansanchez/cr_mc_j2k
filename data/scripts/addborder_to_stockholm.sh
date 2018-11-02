#!/bin/bash

set -x

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

if [ $# -ne 3 ]; then
	echo "Uso: $0 <initial frame #> <final frame #> <border-width x border-weight>"
	exit -1
fi

INITIAL=$1
FINAL=$2
BORDER=$3
IMAGES_PGM_SOURCE="$CR_MC_J2K_HOME/data/sequences/stockholm_1280x720"
IMAGES_PGM_DESTINATION="$CR_MC_J2K_HOME/data/sequences/stockholm_1280x768"

i=$INITIAL
while [ $i -le $FINAL ]; do

  i_index=`printf %03d $i`

  echo "Processing image: $i_index"
  convert -bordercolor black -border $BORDER $IMAGES_PGM_SOURCE/${i_index}.pgm $IMAGES_PGM_DESTINATION/${i_index}.pgm
  
  i=$(($i+1))

done