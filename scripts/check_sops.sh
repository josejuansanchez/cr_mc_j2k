#!/bin/bash

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        echo "Error"
        exit
    fi
}

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <First Image> <Last Image>\n";
	exit 1;
fi

if [[ $CR_MC_J2K_HOME = "" ]]; then
    echo "Error. CR_MC_J2K_HOME is not defined"
    exit 1
fi

CONFIGFILE=$CR_MC_J2K_HOME/config/cr_mc_config.sh
if [ ! -f "$CONFIGFILE" ]; then
    echo "Error reading config file: $CONFIGFILE"
    exit 1
fi

echo "Reading config file: $CONFIGFILE ...."
source "$CONFIGFILE"
CheckExitStatusCode

FIRST=$1
LAST=$2

i=$FIRST
while [ "$i" -le "$LAST" ]; do

	imagej2c=$(printf %03d "$i")

	SOPS=$($COUNTSOPS "$THUMBNAILS_DIRECTORY"/"$imagej2c".j2c | grep "SOPs" | awk '{print $3}')
	echo -e "Image: [$i] - SOPs: $SOPS"

	i=$((i+1))
done