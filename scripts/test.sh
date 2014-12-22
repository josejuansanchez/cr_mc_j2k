#!/bin/bash

function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

TEST=_test_2014_06_16_blk_16_mode_2_8
#TEST=_test_2014_06_12_blk_16_mode_2_8

# tree
#IMAGE_N=0
#IMAGE_N1=1

# stockholm
IMAGE_N=3
IMAGE_N1=4

# big buck bunny
#IMAGE_N=100
#IMAGE_N1=101

#for((BITRATE=1000; BITRATE<=51000; BITRATE=BITRATE+5000))
for((BITRATE=1000; BITRATE<=51000; BITRATE=BITRATE+10000))
do
    ./cr_me.sh $IMAGE_N $IMAGE_N1 $BITRATE
    CheckExitStatusCode	
    ./generate_graph.sh $BITRATE
    CheckExitStatusCode	

    cp bytes_$BITRATE.png $TEST    
    cp psnr_$BITRATE.png $TEST
    cp ssim_$BITRATE.png $TEST    
    cp paste_$BITRATE.txt $TEST
    ./clean.sh
done