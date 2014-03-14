#!/bin/bash

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <START> <END>\n";
	exit;
fi

START=$1
END=$2
INC=1000

IMG_OUT=psnr_type2.png
rm $IMG_OUT

echo "set terminal png"
echo "set output \"$IMG_OUT\""

echo "set title ''"
echo "set xlabel 'Frame Number'"
echo "set ylabel 'PSNR [dB]'"
echo "set key out right"

echo "plot \"paste_${START}.txt\" using 1:3 with lines title 'T2. cr + me (${START} Bytes)'  axes x1y1, \\"
echo -e "\t \"paste_${START}.txt\" using 1:4 with lines title 'trunc (${START} Bytes)'  axes x1y1, \\"

START=$(($START+$INC))

for((BITRATE=START; BITRATE<=END; BITRATE=BITRATE+INC))
do
     echo -e "\t \"paste_${BITRATE}.txt\" using 1:3 with lines title 'T2. cr + me (${BITRATE} Bytes)' axes x1y1, \\"     
     echo -e "\t \"paste_${BITRATE}.txt\" using 1:4 with lines title 'trunc (${BITRATE} Bytes)' axes x1y1, \\"          
done

echo -e "\t \"paste_${END}.txt\" using 1:3 with lines title 'T2. cr + me (${END} Bytes)' axes x1y1, \\"          
echo -e "\t \"paste_${END}.txt\" using 1:4 with lines title 'trunc (${END} Bytes)' axes x1y1"