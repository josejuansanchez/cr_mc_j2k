#!/bin/bash

set -x

if [ $# -ne 2 ]; then
	echo "Uso: $0 <numero_inicio_secuencia> <numero_fin_secuencia>"
	exit -1
fi

CONFIGFILE=cr_mc_config.cfg
if [ ! -f $CONFIGFILE ]; then
	echo "Error reading config file: $CONFIGFILE"
	exit;
fi

echo "Reading config file: $CONFIGFILE ...."
source "$CONFIGFILE"

START=$1
END=$2
SOURCE_IMAGE_J2C_FILES="$HOME/data/thumbnails"

# Tools
CREATE_WOI_LIST=$HOME/knapsack/j2c_to_knapsack_files/create_woi_list
CREATE_KNAPSACK_JSON_FILE=$HOME/knapsack/j2c_to_knapsack_files/create_knapsack_json_file.sh

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