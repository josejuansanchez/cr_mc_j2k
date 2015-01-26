#!/bin/bash

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        echo "Error"
        exit
    fi
}

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


WIDTH=`echo "$WIDTH_RECONS/2" | bc`
HEIGHT=`echo "$HEIGHT_RECONS/2" | bc`

mkdir /tmp/blocks
cp _tmp_blocks/*.pgm /tmp/blocks
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/blocks/*.pgm
convert -delay 75 -loop 0 /tmp/blocks/*.pgm blocks.gif
#animate blocks.gif

mkdir /tmp/prediction
cp _tmp_prediction_images/*.pgm /tmp/prediction
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/prediction/*.pgm
convert -delay 2 -loop 0 /tmp/prediction/*.pgm prediction.gif
#animate prediction.gif

mkdir /tmp/trunc
cp _tmp_trunc_images/*.pgm /tmp/trunc
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/trunc/*.pgm
convert -delay 2 -loop 0 /tmp/trunc/*.pgm trunc.gif
#animate trunc.gif

mkdir /tmp/original
cp ${IMAGES_DIRECTORY}/*.pgm /tmp/original
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/original/*.pgm
convert -delay 2 -loop 0 /tmp/original/*.pgm original.gif
#animate original.gif