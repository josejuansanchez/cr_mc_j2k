#!/bin/bash

#set -x

# Functions
function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

if [ $# -ne 2 ]; then
	echo "Uso: $0 <numero_inicio_secuencia> <numero_fin_secuencia>"
	exit 1
fi

START=$1
END=$2

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

CONFIGFILE=$CR_MC_J2K_HOME/config/cr_mc_config.sh
if [ ! -f $CONFIGFILE ]; then
	echo "Error reading config file: $CONFIGFILE"
	exit 1
fi

echo "Reading config file: $CONFIGFILE ...."
source "$CONFIGFILE"

# Archivo que contiene toda la lista de WOIs
WOIS_LIST_FILE=wois.txt

# Creamos un archivo de texto con toda la lista de WOIs
$CREATE_WOI_LIST $WIDTH_RECONS $HEIGHT_RECONS $W_PRECINT_SIZE $H_PRECINT_SIZE > $WOIS_LIST_FILE
CheckExitStatusCode

i=$START
while [ $i -le $END ]; do
	i_index=`printf %03d $i`

	$CREATE_KNAPSACK_JSON_FILE $THUMBNAILS_DIRECTORY/${i_index}.j2c $WOIS_LIST_FILE > files/${i_index}.json
	CheckExitStatusCode

	i=$(($i+1))
done