#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Uso: $0 <# LAST_FRAME>"
	exit -1
fi

##############################
FIRST_FRAME=2		# <---
OUT="odd.yuv"		# <---
##############################

LAST_FRAME=$1
i=$FIRST_FRAME

while [ $i -le $LAST_FRAME ]; do

  i_index=`printf %03d $i`
  
  LIST="$LIST yuv/sun${i_index}.yuv"

  i=$(($i+2))
done

cat $LIST > $OUT

