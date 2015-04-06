#!/bin/bash


MIX=/home/josejuan/cr_mc_j2k/merging_images/1_layer/packets_tree_stock


IMAGE_OUT=out.j2c
rm $IMAGE_OUT
for (( i=0; i<=179; i++ ))
do
	#echo "[$i] Copying..."
	cat $MIX/$i.j2c >> $IMAGE_OUT
done
