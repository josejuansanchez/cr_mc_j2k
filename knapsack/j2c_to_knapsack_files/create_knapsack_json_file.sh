#!/bin/bash

#set -x

# Tools
WOISTOCACHE=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/Code/CR/woistocache
DECODEFROMCACHE=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/Code/CR/decodefromcache
SNR=/home/josejuan/experimentos/experimentos_cr/conditional_replenishment/tools/snr

#################################################

# Precinct size at the maximum resolution level
W_PRECINT_SIZE=128
H_PRECINT_SIZE=128

# Compression parameters used in Kakadu
CLEVELS=2
CLAYERS=8

# Original image dimension
WIDTH_RECONS=1280
HEIGHT_RECONS=768

#Type of output
OUTPUT=JSON
#OUTPUT=TEXT

#################################################

# Functions
function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

function clean_temp_files()
{
	rm *.cache > /dev/null 2>&1
	rm *.lrcp  > /dev/null 2>&1
	rm *.sort  > /dev/null 2>&1
	rm *.woi   > /dev/null 2>&1
	rm *.pgm   > /dev/null 2>&1
	rm bytes.readed > /dev/null 2>&1
}

function check_psnr_mode {

	MODE=$1
	IMAGE_J2C=$2
	IMAGE_J2C_CACHE=${2}.cache
	WOI_COORDINATES=$3
	PRECINCT_ID=$4
	NUMBER_OF_WOIS=$5

	# Get the x,y coordinates from the file
	COORD_X=`cat $WOI_COORDINATES | awk '{print $1}'`
	COORD_Y=`cat $WOI_COORDINATES | awk '{print $2}'`

	if [ $OUTPUT = "JSON" ]; then
		echo -e "{"
		echo -e "\"id\": $PRECINCT_ID,"
		echo -e "\"coord_x\": $COORD_X,"
		echo -e "\"coord_y\": $COORD_Y,"
		echo -e "\"layers\": ["
	fi

	for ((LAYER=1; LAYER <= CLAYERS ; LAYER++))
	do
		# Cleaning temporary files
		clean_temp_files

		$WOISTOCACHE $IMAGE_J2C $WOI_COORDINATES $W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $LAYER 999999999 $MODE > /dev/null 2>&1
		CheckExitStatusCode
		BYTES_READED=`cat bytes.readed`

		$DECODEFROMCACHE $IMAGE_J2C_CACHE out.pgm $WIDTH_RECONS $HEIGHT_RECONS $IMAGE_J2C > /dev/null 2>&1
		CheckExitStatusCode

		#display out.pgm
		pamcut -left $COORD_X -top $COORD_Y -width $W_PRECINT_SIZE -height $H_PRECINT_SIZE out.pgm > out_cut.pgm
		CheckExitStatusCode
		
		# TEST
		#KK=`printf %03d $PRECINCT_ID`
		#cp out_cut.pgm out_cut_${KK}_${COORD_X}_${COORD_Y}.pgm

		#display out_cut.pgm 
		kdu_expand -i $IMAGE_J2C -o 1ql.pgm -layers $LAYER > /dev/null 2>&1
		CheckExitStatusCode
		
		pamcut -left $COORD_X -top $COORD_Y -width $W_PRECINT_SIZE -height $H_PRECINT_SIZE 1ql.pgm > 1ql_cut.pgm
		CheckExitStatusCode
		
		#cmp out_cut.pgm 1ql_cut.pgm

		PSNR_VS_SAME_QL=`$SNR --type=uchar --peak=255 --file_A=1ql_cut.pgm --file_B=out_cut.pgm 2> /dev/null | \
		grep "PSNR\[dB\]" | awk '{print $3}'`
		CheckExitStatusCode

		# Compare with the original image
		IMAGE_ALL_QL=all_ql.pgm
		IMAGE_ALL_QL_CUT=all_ql_cut.pgm

		kdu_expand -i $IMAGE_J2C -o $IMAGE_ALL_QL > /dev/null 2>&1
		CheckExitStatusCode
		
		pamcut -left $COORD_X -top $COORD_Y -width $W_PRECINT_SIZE -height $H_PRECINT_SIZE $IMAGE_ALL_QL > $IMAGE_ALL_QL_CUT
		CheckExitStatusCode

		PSNR_VS_ALL_QL=`$SNR --type=uchar --peak=255 --file_A=$IMAGE_ALL_QL_CUT --file_B=out_cut.pgm 2> /dev/null | \
		grep "PSNR\[dB\]" | awk '{print $3}'`
		CheckExitStatusCode

		if [ $OUTPUT = "JSON" ]; then
			OUT="{\"ql\": $LAYER, \"bytes\": $BYTES_READED, \"psnr\": $PSNR_VS_ALL_QL}"

			if [ $LAYER != $CLAYERS ]; then
				OUT=${OUT}","
			fi
			echo -e "\t$OUT"
		else
			echo -e "Layer: $LAYER \t PSNR_VS_SAME_QL: $PSNR_VS_SAME_QL \t PSNR_VS_ALL_QL: $PSNR_VS_ALL_QL \t BYTES_READED: $BYTES_READED"		
		fi
	done

	if [ $OUTPUT = "JSON" ]; then
		echo -e "\t]"

		if [ $PRECINCT_ID -lt $(($NUMBER_OF_WOIS-1)) ]; then
			echo -e "},"
		else
			echo -e "}"		
		fi
	fi

	# Cleaning temporary files
	clean_temp_files
}  

#################################################

# Tests
#
# 1) Mode 0 (Kakadu Mode)
#echo -e "\nTest Mode 0 (Kakadu Mode)"
#check_psnr_mode 0 image.j2c wois.txt

# 2) Mode 1 (Exact WOI)
#echo -e "\nTest Mode 1 (Exact WOI)"
#check_psnr_mode 1 image.j2c wois.txt

#################################################

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <IMAGE.J2C> <WOI_LIST>\n";
	exit;
fi

IMAGE_J2C=$1
WOI_LIST=$2
PRECINCT_ID=0

NUMBER_OF_WOIS=`wc -l $WOI_LIST | awk '{print $1}'`

if [ $OUTPUT = "JSON" ]; then
	echo -e "{ \"number_of_precincts\": $NUMBER_OF_WOIS,";
	echo -e "\"precincts\": ["
fi

TEMP_WOI=`pwd`/temp_woi.txt

while read WOI_COORDINATES
do
	# Create a temp file with the coordinates
	echo $WOI_COORDINATES > $TEMP_WOI

	# Mode 1 (Exact WOI)
	check_psnr_mode 1 $IMAGE_J2C $TEMP_WOI $PRECINCT_ID $NUMBER_OF_WOIS
	
	PRECINCT_ID=$(($PRECINCT_ID+1))
done < $WOI_LIST

if [ $OUTPUT = "JSON" ]; then
	echo -e "]}"
fi