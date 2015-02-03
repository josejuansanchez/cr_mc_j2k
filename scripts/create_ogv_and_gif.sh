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

## 1. Blocks sequence
## ------------------

mkdir /tmp/blocks
cp _tmp_blocks/*.pgm /tmp/blocks
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/blocks/*.pgm
convert /tmp/blocks/*.pgm /tmp/blocks/%d.png
ffmpeg2theora /tmp/blocks/%d.png -o blocks.ogv
convert -delay 25 -loop 0 /tmp/blocks/*.png blocks.gif

## 2. Prediction sequence
## ----------------------

mkdir /tmp/prediction
cp _tmp_prediction_images/*.pgm /tmp/prediction
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/prediction/*.pgm
convert /tmp/prediction/*.pgm /tmp/prediction/%d.png
ffmpeg2theora /tmp/prediction/%d.png -o prediction.ogv
convert -delay 2 -loop 0 /tmp/prediction/*.pgm prediction.gif

## 3. MJ2K sequence
## ----------------

mkdir /tmp/trunc
cp _tmp_trunc_images/*.pgm /tmp/trunc
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/trunc/*.pgm
convert /tmp/trunc/*.pgm /tmp/trunc/%d.png
ffmpeg2theora /tmp/trunc/%d.png -o trunc.ogv
convert -delay 2 -loop 0 /tmp/trunc/*.pgm trunc.gif

## 4. Original sequence
## --------------------

#mkdir /tmp/original
#cp ${IMAGES_DIRECTORY}/*.pgm /tmp/original
#mogrify -resize ${WIDTH}x${HEIGHT} /tmp/original/*.pgm
#convert /tmp/original/*.pgm /tmp/original/%d.png
#ffmpeg2theora /tmp/original/%d.png -o original.ogv
#convert -delay 2 -loop 0 /tmp/original/*.pgm original.gif