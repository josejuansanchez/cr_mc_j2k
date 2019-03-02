#!/bin/bash

set -x

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
IMAGES_PGM_SOURCE="$CR_MC_J2K_HOME/data/sequences/speedway_384x320"
IMAGES_J2C_DESTINATION="$CR_MC_J2K_HOME/data/j2c_and_thumbnails"

CLAYERS=8
CLEVELS=2
CPRECINCTS="{16,16},{16,16},{16,16}"
CBLK="{16,16}"
CORDER=LRCP

i=$INITIAL
while [ $i -le $FINAL ]; do

  i_index=`printf %03d $i`

  kdu_compress -i $IMAGES_PGM_SOURCE/${i_index}.pgm -o $IMAGES_J2C_DESTINATION/${i_index}.j2c Cuse_sop=yes \
  Corder=$CORDER Clayers=$CLAYERS Clevels=$CLEVELS Cprecincts=$CPRECINCTS Cblk=$CBLK Creversible=yes

  cp $IMAGES_PGM_SOURCE/${i_index}.pgm $IMAGES_J2C_DESTINATION/${i_index}.thumb.pgm

  i=$(($i+1))

done

# TODO: Improve this step
#
mogrify -resize 96x80 $IMAGES_J2C_DESTINATION/*.pgm

first_image=`printf %03d $INITIAL`
i=1
while [ $i -le $CLAYERS ]; do
  kdu_transcode -i $IMAGES_J2C_DESTINATION/$first_image.j2c -o $IMAGES_J2C_DESTINATION/${i}.j2c Clayers=${i}
  i=$(($i+1))
done