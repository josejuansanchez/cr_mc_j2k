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

EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2015/2015_03_09_speedway_layers-8_levels-2_precincts_64-32-16_blk-16_no_me_mode_2_rlcp

# speedway
IMAGE_N=0
IMAGE_N1=1

# stockholm
#IMAGE_N=4
#IMAGE_N1=5

# big buck bunny
#IMAGE_N=100
#IMAGE_N1=101

for((BITRATE=1000; BITRATE<=20000; BITRATE=BITRATE+1000))
do
    ./sequential.sh $IMAGE_N $IMAGE_N1 $BITRATE
    CheckExitStatusCode 
    ./report_generate_graph.sh $BITRATE
    CheckExitStatusCode 

    cp bytes_$BITRATE.png $EXPERIMENTS
    cp psnr_$BITRATE.png $EXPERIMENTS
    cp ssim_$BITRATE.png $EXPERIMENTS
    cp paste_$BITRATE.txt $EXPERIMENTS

    # TODO: Temporal solution - 0 and 90 are values hardcoded
    #./report_create_ogv_and_gif.sh 0 90
    ./report_create_ogv_and_gif.sh 2 50

    mv all.ogv all_$BITRATE.ogv
    mv all.gif all_$BITRATE.gif

    ./clean.sh
done