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

EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2015/2015_02_18_stockholm_layers-8_levels-2_precincts-32-16-8_blk-8_with_me_a_0_v_0_mode_1

# tree
#IMAGE_N=0
#IMAGE_N1=1

# stockholm
IMAGE_N=4
IMAGE_N1=5

# big buck bunny
#IMAGE_N=100
#IMAGE_N1=101

#for((BITRATE=1000; BITRATE<=51000; BITRATE=BITRATE+5000))
for((BITRATE=11000; BITRATE<=51000; BITRATE=BITRATE+10000))
do
    ./cr_mc.sh $IMAGE_N $IMAGE_N1 $BITRATE
    CheckExitStatusCode	
    ./generate_graph.sh $BITRATE
    CheckExitStatusCode	

    cp bytes_$BITRATE.png $EXPERIMENTS
    cp psnr_$BITRATE.png $EXPERIMENTS
    cp ssim_$BITRATE.png $EXPERIMENTS
    cp paste_$BITRATE.txt $EXPERIMENTS

    # TODO: Temporal solution - 0 and 90 are values hardcoded
    #./create_ogv_and_gif.sh 0 90
    ./create_ogv_and_gif.sh 6 90

    mv all.ogv all_$BITRATE.ogv
    mv all.gif all_$BITRATE.gif

    ./clean.sh
done