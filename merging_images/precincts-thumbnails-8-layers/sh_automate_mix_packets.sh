#!/bin/bash

set -x

REPORTFILE=report.txt
rm $REPORTFILE
touch $REPORTFILE

for((PACKETS = 29; PACKETS < 720; PACKETS=PACKETS+30)); do

  ./sh_mix_packets.sh $PACKETS
  cat speedway_header.j2c out.j2c > kk.j2c

  kdu_expand -i kk.j2c -o reduce0.pgm
  kdu_expand -i kk.j2c -o reduce1.pgm -reduce 1
  kdu_expand -i kk.j2c -o reduce2.pgm -reduce 2

  BYTES=`ls -la out.j2c | awk '{print $5}'`
  echo -e "$PACKETS \t $BYTES" >> $REPORTFILE

  DIRNAME=`printf %03d $PACKETS`
  mkdir report/$DIRNAME-packets

  convert reduce0.pgm reduce0.png
  convert reduce1.pgm reduce1.png
  convert reduce2.pgm reduce2.png
  mv *.png report/$DIRNAME-packets

done
