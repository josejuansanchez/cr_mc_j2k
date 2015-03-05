#!/bin/bash

if [ $# -ne 3 ]; then
    echo -e "\nUsage: $0 <LOWER BOUND> <UPPER BOUND> <psnr | ssim | bytes>\n"
    exit 1
fi

LOWER_BOUND=$1
UPPER_BOUND=$2
MODE=$3             #psnr | ssim | bytes
INC=1000
GPT=test.gpt

for((START=$LOWER_BOUND; START<=$UPPER_BOUND; START=START+5000))
do
  END=$(($START+4000))

  python /home/josejuan/cr_mc_j2k/pytools/create_gnuplot_graph.py $START $END $INC $MODE > $GPT
  gnuplot < $GPT

  START_IN_K=`echo "$START/$INC" | bc`
  END_IN_K=`echo "$END/$INC" | bc`

  mv ${MODE}.png ${MODE}-${START_IN_K}k-${END_IN_K}k.png
done

rm $GPT