#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Uso: $0 <numero_inicio_secuencia> <numero_fin_secuencia>"
	exit -1
fi

INICIO=$1
FIN=$2

i=$INICIO
while [ $i -le $FIN ]; do

	i_index=`printf %03d $i`

	tools/countsops ../data/tiff/${i_index}.j2c

	i=$(($i+1))
done


i=$INICIO
i_index=`printf %03d $i`

SOP_INICIAL=`tools/countsops ../data/tiff/${i_index}.j2c | grep "SOPs" | awk '{print $3}'`

while [ $i -le $FIN ]; do

	i_index=`printf %03d $i`

	SOP=`tools/countsops ../data/tiff/${i_index}.j2c | grep "SOPs" | awk '{print $3}'`

	if [ $SOP_INICIAL -ne $SOP ]; then
		echo -e "\nSOP Distintos: ${i_index}.j2c \t #SOPs: $SOP \t#SOP_INICIAL: $SOP_INICIAL"
	fi

	i=$(($i+1))
done