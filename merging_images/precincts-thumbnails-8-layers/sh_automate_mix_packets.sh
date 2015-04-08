#!/bin/bash

set -x

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

CONFIGFILE=$CR_MC_J2K_HOME/config/cr_mc_config.sh
if [ ! -f "$CONFIGFILE" ]; then
	echo "Error reading config file: $CONFIGFILE"
	exit 1
fi

echo "Reading config file: $CONFIGFILE ...."
source "$CONFIGFILE"

# Expand the 3 resolution levels for the image speedway.j2c
kdu_expand -i images_j2c/speedway.j2c -o reduce0_8_layers.pgm
kdu_expand -i images_j2c/speedway.j2c -o reduce1_8_layers.pgm -reduce 1
kdu_expand -i images_j2c/speedway.j2c -o reduce2_8_layers.pgm -reduce 2

# Intial settings
REPORTFILE=report.txt
rm $REPORTFILE
touch $REPORTFILE

for((PACKETS = 29; PACKETS < 720; PACKETS=PACKETS+30)); do

  ./sh_mix_packets.sh $PACKETS
  cat speedway_header.j2c out.j2c > kk.j2c

  kdu_expand -i kk.j2c -o reduce0.pgm
  kdu_expand -i kk.j2c -o reduce1.pgm -reduce 1
  kdu_expand -i kk.j2c -o reduce2.pgm -reduce 2

  PSNR_R0=`$SNR --type=uchar --peak=255 --file_A=reduce0_8_layers.pgm --file_B=reduce0.pgm 2> /dev/null | \
  grep "PSNR\[dB\]" | awk '{print $3}'`

  PSNR_R1=`$SNR --type=uchar --peak=255 --file_A=reduce1_8_layers.pgm --file_B=reduce1.pgm 2> /dev/null | \
  grep "PSNR\[dB\]" | awk '{print $3}'`

  PSNR_R2=`$SNR --type=uchar --peak=255 --file_A=reduce2_8_layers.pgm --file_B=reduce2.pgm 2> /dev/null | \
  grep "PSNR\[dB\]" | awk '{print $3}'`

  BYTES=`ls -la out.j2c | awk '{print $5}'`
  echo -e "$PACKETS \t $BYTES \t $PSNR_R0 \t $PSNR_R1 \t $PSNR_R2" >> $REPORTFILE

  DIRNAME=`printf %03d $PACKETS`
  mkdir report/$DIRNAME-packets

  convert reduce0.pgm reduce0.png
  convert reduce1.pgm reduce1.png
  convert reduce2.pgm reduce2.png
  mv *.png report/$DIRNAME-packets

done
