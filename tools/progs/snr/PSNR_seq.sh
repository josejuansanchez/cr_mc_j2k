#!/bin/sh
#
# Calcula el PSNR entre dos secuencias de imágenes PGM
#
# $1: path de la secuencia original (/home1/videos/Foreman/CIF/30Hz/original/)
# $2: path de la secuencia reconstruida (./))
# $3: número de pictures

path_original=$1
path_recons=$2
pics=$3

echo -n "Original path = "
echo $path_original
echo -n "Recons path = "
echo $path_recons
echo -n "Number of pictures = "
echo $pics

rm -f PSNR_seq.tmp

count=0

while [ $count -le $pics ]
do
  original_pic=`printf $path_original/%03d.pgm $count`
  recons_pic=`printf $path_recons/%03d.pgm $count`
  snr uchar 255 $original_pic $recons_pic 2> /dev/null | awk {'print $16'} >> PSNR_seq.tmp
  echo -n $count
  echo -n " "
  count=$[$count+1]
done
echo ""
echo -n "PSNR[db]="
awk -f /usr/local/bin/average.awk PSNR_seq.txt
