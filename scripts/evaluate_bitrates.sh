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

EXPERIMENTS=$CR_MC_J2K_HOME/experiments/2015/2015_01_30_stockholm_layers-8_levels-5_precincts-128-64-32_blk-32_no_me_mode_0

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
    ./clean.sh
done