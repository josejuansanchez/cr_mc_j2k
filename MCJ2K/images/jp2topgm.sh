#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Uso: $0 <# LAST_FRAME>"
	exit -1
fi

LAST_FRAME=$1
i=0

while [ $i -le $LAST_FRAME ]; do

  i_index=`printf %03d $i`
  
  kdu_expand -i originales/sun${i_index}.jp2 -o sunpgm/sun${i_index}.pgm

  i=$(($i+1))
done

