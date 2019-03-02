#!/bin/bash

TAG="[evaluate-bitrates]"

function log()
{
    echo "$TAG $1"
}

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        log "$TAG Error"
        exit 1
    fi
}

if [[ $CR_MC_J2K_HOME = "" ]]; then
    log "Error. CR_MC_J2K_HOME is not defined"
    exit 1
fi

EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2019/2019_03_01_speedway_layers-8_levels-2_precincts_16-16-16_blk-16_with_me_a0_v2_mode_0
#EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2018/2018_11_05_speedway_layers-8_levels-2_precincts_64-32-16_blk-16_with_me_a0_v2_mode_0
#EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2018/2018_11_03_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_a0_v2_mode_0

# speedway
IMAGE_N=0
IMAGE_N1=1
TOTAL_NUMBER_OF_IMAGES=50

# stockholm
#IMAGE_N=3
#IMAGE_N1=4
#TOTAL_NUMBER_OF_IMAGES=100

# big buck bunny
#IMAGE_N=100
#IMAGE_N1=101

for((BITRATE=1000; BITRATE<=5000; BITRATE=BITRATE+1000))
#for((BITRATE=11000; BITRATE<=510000; BITRATE=BITRATE+10000))
do
    ./sequential.sh $IMAGE_N $IMAGE_N1 $BITRATE $TOTAL_NUMBER_OF_IMAGES
    CheckExitStatusCode

    ./report_generate_graph.sh $BITRATE
    CheckExitStatusCode

    cp bytes_$BITRATE.png $EXPERIMENTS
    cp psnr_$BITRATE.png $EXPERIMENTS
    cp ssim_$BITRATE.png $EXPERIMENTS
    cp paste_$BITRATE.txt $EXPERIMENTS

    ./report_create_ogv_and_gif.sh $((IMAGE_N1+1)) $TOTAL_NUMBER_OF_IMAGES

    mv all.ogv all_$BITRATE.ogv
    mv all.gif all_$BITRATE.gif

    cp all_$BITRATE.ogv $EXPERIMENTS
    cp all_$BITRATE.gif $EXPERIMENTS

    ./clean.sh
done