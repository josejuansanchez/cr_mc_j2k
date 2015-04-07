#!/bin/bash

MIX=/home/josejuan/cr_mc_j2k/merging_images/precincts-thumbnails/packets_speedway

if [ $# -ne 1 ]; then
	echo -e "\nUso: $0 <id last precinct>\n";
	exit 1;
fi

IMAGE_OUT=out.j2c
rm $IMAGE_OUT
for (( i=0; i<=$1; i++ ))
do
	#echo "[$i] Copying..."
	cat $MIX/$i.j2c >> $IMAGE_OUT
done
