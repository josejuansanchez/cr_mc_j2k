#!/bin/bash

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <First Image> <Last Image>\n";
	exit 1;
fi

FIRST=$1
LAST=$2

DIRECTORY=/home/josejuan/experimentos/experimentos_cr/data/thumbnails
COUNTSOPS=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/tools/countsops

i=$FIRST
while [ $i -le $LAST ]; do

	imagej2c=`printf %03d $i`

	SOPS=`$COUNTSOPS $DIRECTORY/$imagej2c.j2c | grep "SOPs" | awk '{print $3}'`
	echo -e "Image: [$i] - SOPs: $SOPS"

	i=$(($i+1))
done