#!/bin/bash

MODE=ssim #psnr | bytes
INC=1000
GPT=test.gpt

for((START=6000; START<=56000; START=START+5000))
do
  END=$(($START+4000))

  python /home/josejuan/cr_mc_j2k/pytools/create_gnuplot_graph.py $START $END $INC $MODE > $GPT
  gnuplot < $GPT

  START_IN_K=`echo "$START/$INC" | bc`
  END_IN_K=`echo "$END/$INC" | bc`

  mv ${MODE}.png ${MODE}-${START_IN_K}k-${END_IN_K}k.png
done

rm $GPT