#!/bin/bash

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        echo "Error"
        exit
    fi
}

if [ $# -ne 2 ]; then
    echo -e "\nUso: $0 <# First Frame> <# Last Frame>\n"
    exit 1
fi

FIRST_FRAME=$1
LAST_FRAME=$2

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

## 1. Prediction sequence
## ----------------------

TMP_PREDICTION_DIR=/tmp/prediction

if [ -d "$TMP_PREDICTION_DIR" ]; then
    rm $TMP_PREDICTION_DIR/*
else
    mkdir $TMP_PREDICTION_DIR
fi

cp _tmp_prediction_images/*.pgm $TMP_PREDICTION_DIR
mogrify -resize ${WIDTH}x${HEIGHT} $TMP_PREDICTION_DIR/*.pgm
convert $TMP_PREDICTION_DIR/*.pgm $TMP_PREDICTION_DIR/%d.png
#ffmpeg2theora $TMP_PREDICTION_DIR/%d.png -o prediction.ogv
#convert -delay 2 -loop 0 $TMP_PREDICTION_DIR/*.pgm prediction.gif

## 2. Blocks sequence
## ------------------

TMP_BLOCKS_DIR=/tmp/blocks

if [ -d "$TMP_BLOCKS_DIR" ]; then
    rm $TMP_BLOCKS_DIR/*
else
    mkdir $TMP_BLOCKS_DIR
fi

cp _tmp_blocks/*.pgm $TMP_BLOCKS_DIR
mogrify -resize ${WIDTH}x${HEIGHT} $TMP_BLOCKS_DIR/*.pgm
convert $TMP_BLOCKS_DIR/*.pgm $TMP_BLOCKS_DIR/%d.png
#ffmpeg2theora $TMP_BLOCKS_DIR/%d.png -o blocks.ogv
#convert -delay 25 -loop 0 $TMP_BLOCKS_DIR/*.png blocks.gif

## 3. MJ2K sequence
## ----------------

TMP_TRUNC_DIR=/tmp/trunc

if [ -d "$TMP_TRUNC_DIR" ]; then
    rm $TMP_TRUNC_DIR/*
else
    mkdir $TMP_TRUNC_DIR
fi

cp _tmp_trunc_images/*.pgm $TMP_TRUNC_DIR
mogrify -resize ${WIDTH}x${HEIGHT} $TMP_TRUNC_DIR/*.pgm
convert $TMP_TRUNC_DIR/*.pgm $TMP_TRUNC_DIR/%d.png
#ffmpeg2theora $TMP_TRUNC_DIR/%d.png -o trunc.ogv
#convert -delay 2 -loop 0 $TMP_TRUNC_DIR/*.pgm trunc.gif

## 4. Original sequence
## --------------------

TMP_ORIGINAL_DIR=/tmp/original

if [ -d "$TMP_ORIGINAL_DIR" ]; then
    rm $TMP_ORIGINAL_DIR/*
else
    mkdir $TMP_ORIGINAL_DIR
fi

cp ${IMAGES_DIRECTORY}/*.pgm $TMP_ORIGINAL_DIR
mogrify -resize ${WIDTH}x${HEIGHT} $TMP_ORIGINAL_DIR/*.pgm
convert $TMP_ORIGINAL_DIR/*.pgm $TMP_ORIGINAL_DIR/%d.png
#ffmpeg2theora $TMP_ORIGINAL_DIR/%d.png -o original.ogv
#convert -delay 2 -loop 0 $TMP_ORIGINAL_DIR/*.pgm original.gif

## 5. Create a montage with all the above frames using this layout:
#    -------------------------
#    | Prediction |  Blocks  |
#    -------------------------
#    | MJ2K       | Original |
#    -------------------------

# I have had to change the image format because when I use .png the images
# obtained seems to be darker.

TMP_ALL_DIR=/tmp/all

if [ -d "$TMP_ALL_DIR" ]; then
    rm $TMP_ALL_DIR/*
else
    mkdir $TMP_ALL_DIR
fi

for (( FRAME=$FIRST_FRAME; FRAME<=$LAST_FRAME; FRAME++ ))
do
    montage $TMP_PREDICTION_DIR/$FRAME.png $TMP_BLOCKS_DIR/$FRAME.png \
      $TMP_TRUNC_DIR/$FRAME.png $TMP_ORIGINAL_DIR/$FRAME.png \
      -tile 2x2 -geometry +1+1 $TMP_ALL_DIR/$FRAME.jpg
done

ffmpeg2theora $TMP_ALL_DIR/%d.jpg -o all.ogv
convert -delay 2 -loop 0 $TMP_ALL_DIR/*.jpg all.gif