#!/bin/bash

set -x

if [ $# -ne 1 ]; then
	echo -e "\nUso: $0 <BITRATE>\n";
	exit;
fi

BITRATE=$1
PSNR_FILE=psnr.txt
SSIM_FILE=ssim.txt
BYTES_FILE=bytes.txt
PASTE_FILE=paste.txt

# BYTES_FILE Columns
# <N. Frame>   <N. Bytes>

# PSNR_FILE Colummns
# <PSNR_ME_PRECI> <PSNR_TRUNC>

# PASTE_FILE Columns
# <N. Frame>   <N. Bytes>   <PSNR_ME_PRECI>   <PSNR_TRUNC>

# Unimos las columnas de los archivos bytes.txt, psnr.txt y ssim.txt
paste $BYTES_FILE $PSNR_FILE $SSIM_FILE | awk '{ print $1 " " $2 " " $3 " " $4 " " $5 " " $6 }' > $PASTE_FILE

# Creamos las gráficas con gnuplot
gnuplot < create_bytes_graph.gpt
gnuplot < create_psnr_graph.gpt 
gnuplot < create_ssim_graph.gpt 

# Cambiamos el nombre de los archivos de las imágenes
mv bytes.png bytes_$BITRATE.png
mv psnr.png psnr_$BITRATE.png
mv ssim.png ssim_$BITRATE.png

# Cambiamos el nombre del archivo de datos utilizado para generar la gráfica
mv paste.txt paste_$BITRATE.txt