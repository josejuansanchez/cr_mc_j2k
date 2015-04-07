#!/bin/bash

set -x

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <IMAGE .J2C> <DIRECTORY OUTPUT>\n";
	exit;
fi

IMAGE_J2C=$1
DIRECTORY_OUT=$2

COUNTSOPS=/home/josejuan/cr_mc_j2k/tools/bin/countsops
TEMP_FILE=out.txt

$COUNTSOPS $IMAGE_J2C > $TEMP_FILE

cat $TEMP_FILE | grep "Cont" | awk -v "IF=${IMAGE_J2C}" -v "OF=${DIRECTORY_OUT}" '{print "dd if="IF" of="OF"/"$2".j2c skip="$6 " count="$12 " bs=1"}'
