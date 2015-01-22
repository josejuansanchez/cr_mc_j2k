#!/bin/bash

#set -x

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        echo "Error"
        exit
    fi
}

if [ $# -ne 1 ]; then
    echo -e "\nUso: $0 <IMAGE N>\n"
    exit 1
fi

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
CheckExitStatusCode

IMAGE=`printf %03d $1`

echo -e "\n* Note: The resolution level 0 is the level with the bigger size of the image"

for((R=0; R<=CLEVELS; R=R+1))
do
    echo -e "\nResolution level: $R"
    for((L=1; L<=CLAYERS; L=L+1))
    do
        LAYER_SIZE=`kdu_expand -i $THUMBNAILS_DIRECTORY/$IMAGE.j2c -o aux.pgm -layers $L -reduce $R \
         | grep "codestream bytes" | awk '{print $2}'`
        CheckExitStatusCode
    
        echo -e "Layer: $L \t Size: $LAYER_SIZE"
        rm aux.pgm
    done
done