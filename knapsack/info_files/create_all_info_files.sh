#!/bin/bash

#set -x

if [ $# -ne 2 ]; then
	echo "Uso: $0 <numero_inicio_secuencia> <numero_fin_secuencia>"
	exit -1
fi

START=$1
END=$2
SOURCE_IMAGE_J2C_FILES="/home/josejuan/experimentos/experimentos_cr/data/thumbnails"

# Tools
CREATE_WOI_LIST=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/knapsack/j2c_to_knapsack_files/create_woi_list
CREATE_KNAPSACK_JSON_FILE=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/knapsack/j2c_to_knapsack_files/create_knapsack_json_file.sh

# Dimensiones de la imagen original
WIDTH_RECONS=1280
HEIGHT_RECONS=768

# Dimensiones de los precintos de la imagen original
W_PRECINT_SIZE=128
H_PRECINT_SIZE=128

# Archivo que contiene toda la lista de WOIs
WOIS_LIST_FILE=wois.txt

# Creamos un archivo de texto con toda la lista de WOIs
$CREATE_WOI_LIST $WIDTH_RECONS $HEIGHT_RECONS $W_PRECINT_SIZE $H_PRECINT_SIZE > $WOIS_LIST_FILE

i=$START
while [ $i -le $END ]; do
	i_index=`printf %03d $i`

	$CREATE_KNAPSACK_JSON_FILE $SOURCE_IMAGE_J2C_FILES/${i_index}.j2c $WOIS_LIST_FILE > files/${i_index}.json

	i=$(($i+1))
done