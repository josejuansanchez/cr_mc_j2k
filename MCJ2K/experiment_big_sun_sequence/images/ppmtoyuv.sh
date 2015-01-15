#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Uso: $0 <# LAST_FRAME>"
	exit -1
fi

LAST_FRAME=$1
i=0

while [ $i -le $LAST_FRAME ]; do

  i_index=`printf %03d $i`
  
  ppmtoyuv sunppm/sun${i_index}.ppm > yuv/sun${i_index}.yuv

  i=$(($i+1))
done

