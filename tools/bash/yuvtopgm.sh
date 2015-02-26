#!/bin/bash

IF=speedway.Y
WIDTH=352
HEIGHT=288
NUMBER_OF_FRAMES=192

BYTES=`echo "($WIDTH*$HEIGHT)" | bc`
BYTES_OFFSET=`echo "($WIDTH*$HEIGHT)/2" | bc`
OFFSET=0
CONT=0

while [ $CONT -le $NUMBER_OF_FRAMES ]; do
    OUTPUT=`printf %03d $CONT`
    dd if=$IF of=$OUTPUT.Y skip=$OFFSET count=$BYTES bs=1
    convert -size "$WIDTH"x"$HEIGHT" -depth 8 $OUTPUT.Y $OUTPUT.pgm    
    CONT=$(($CONT+1))
    OFFSET=$(($OFFSET+$BYTES+$BYTES_OFFSET))
done