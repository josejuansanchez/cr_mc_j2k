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

mkdir /tmp/prediction
cp _tmp_prediction_images/*.pgm /tmp/prediction
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/prediction/*.pgm
convert /tmp/prediction/*.pgm /tmp/prediction/%d.png
#ffmpeg2theora /tmp/prediction/%d.png -o prediction.ogv
#convert -delay 2 -loop 0 /tmp/prediction/*.pgm prediction.gif

## 2. Blocks sequence
## ------------------

mkdir /tmp/blocks
cp _tmp_blocks/*.pgm /tmp/blocks
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/blocks/*.pgm
convert /tmp/blocks/*.pgm /tmp/blocks/%d.png
#ffmpeg2theora /tmp/blocks/%d.png -o blocks.ogv
#convert -delay 25 -loop 0 /tmp/blocks/*.png blocks.gif

## 3. MJ2K sequence
## ----------------

mkdir /tmp/trunc
cp _tmp_trunc_images/*.pgm /tmp/trunc
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/trunc/*.pgm
convert /tmp/trunc/*.pgm /tmp/trunc/%d.png
#ffmpeg2theora /tmp/trunc/%d.png -o trunc.ogv
#convert -delay 2 -loop 0 /tmp/trunc/*.pgm trunc.gif

## 4. Original sequence
## --------------------

mkdir /tmp/original
cp ${IMAGES_DIRECTORY}/*.pgm /tmp/original
mogrify -resize ${WIDTH}x${HEIGHT} /tmp/original/*.pgm
convert /tmp/original/*.pgm /tmp/original/%d.png
#ffmpeg2theora /tmp/original/%d.png -o original.ogv
#convert -delay 2 -loop 0 /tmp/original/*.pgm original.gif

## 5. Create a montage with all the above frames using this layout:
#    -------------------------
#    | Prediction |  Blocks  |
#    -------------------------
#    | MJ2K       | Original |
#    -------------------------

# I have had to change the image format because when I use .png the images
# obtained seems to be darker.

mkdir /tmp/all

for (( FRAME=$FIRST_FRAME; FRAME<=$LAST_FRAME; FRAME++ ))
do
    montage /tmp/prediction/$FRAME.png /tmp/blocks/$FRAME.png \
      /tmp/trunc/$FRAME.png /tmp/original/$FRAME.png \
      -tile 2x2 -geometry +1+1 /tmp/all/$FRAME.jpg
done

ffmpeg2theora /tmp/all/%d.jpg -o all.ogv
convert -delay 2 -loop 0 /tmp/all/*.jpg all.gif