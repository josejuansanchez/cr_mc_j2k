#!/bin/bash


MIX=/home/josejuan/experimentos/experimentos_cr/merging_images/8_layers/packets_tree_stock


IMAGE_OUT=out.j2c
rm $IMAGE_OUT
for (( i=0; i<=1439; i++ ))
do
	cat $MIX/$i.j2c >> $IMAGE_OUT
done
