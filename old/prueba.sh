#!/bin/bash

function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

#set -x

#################################################################################

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <BITRATE> <NUMERO_FIN_SECUENCIA>\n";
	exit;
fi

NUMERO_FIN_SECUENCIA=$2

#MODE="CIF"
MODE="512"

case $MODE in
     "512" )
		WIDTH_RECONS=512
		HEIGHT_RECONS=512
		W_PRECINT_SIZE=32
		H_PRECINT_SIZE=32
		W_PRECINT_SIZE_THUMBNAIL=`echo "64/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
		H_PRECINT_SIZE_THUMBNAIL=`echo "64/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`
		W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
		H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/originalespgm_512x512"
		#IMAGES_ORIGINALES_PGM="../data/thumbnails/delphi_512x512"
		RESOLUTION_LEVEL=5		# Niveles de resolución
		QL=1				# Capas de calidad
           	;;


     "1024" )
		WIDTH_RECONS=1024
		HEIGHT_RECONS=1024
		W_PRECINT_SIZE=32
		H_PRECINT_SIZE=32
		W_PRECINT_SIZE_THUMBNAIL=`echo "64/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
		H_PRECINT_SIZE_THUMBNAIL=`echo "64/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`
		W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
		H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/originalespgm_1024x1024"
		RESOLUTION_LEVEL=5		# Niveles de resolución
		QL=1				# Capas de calidad
           	;;

     "4096" )
		WIDTH_RECONS=4096
		HEIGHT_RECONS=4096
		W_PRECINT_SIZE=128
		H_PRECINT_SIZE=128
		W_PRECINT_SIZE_THUMBNAIL=`echo "64/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
		H_PRECINT_SIZE_THUMBNAIL=`echo "64/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`
		W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
		H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/originalespgm_4096x4096"
		RESOLUTION_LEVEL=8		# Niveles de resolución
		QL=8				# Capas de calidad
           	;;

     "CIF" )
		WIDTH_RECONS=352
		HEIGHT_RECONS=288
		W_PRECINT_SIZE=8
		H_PRECINT_SIZE=8
		W_PRECINT_SIZE_THUMBNAIL=`echo "88/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
		H_PRECINT_SIZE_THUMBNAIL=`echo "72/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`
		W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
		H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/akiyo_352x288"
		RESOLUTION_LEVEL=4		# Niveles de resolución
		QL=8				# Capas de calidad
           	;;

     * )
           	echo -e "Modo incorrecto.\n";
	   	exit;
           	;;
esac

IMAGES="../data/thumbnails"

PSNR_DATA="../data/graficas/psnr.dat"
INFO_DATA="../data/graficas/info.dat"
cat /dev/null > $PSNR_DATA
cat /dev/null > $INFO_DATA

#################################################################################

# Actualizamos el valor de MAXBYTES con el parámetro de entrada $1
#
MAXBYTES=$1

# Volcamos todo el contenido de la imagen background.j2c a un archivo de caché
#
cp $IMAGES/$QL.j2c $IMAGES/background.j2c

####################################################

echo "0 0" > ../data/precincts/uno.txt
#Code/CR/woistocache  $IMAGES/background.j2c ../data/precincts/uno.txt $WIDTH_RECONS $HEIGHT_RECONS $RESOLUTION_LEVEL $QL $MAXBYTES
Code/CR/woistocache  $IMAGES/background.j2c ../data/precincts/uno.txt $WIDTH_RECONS $HEIGHT_RECONS $RESOLUTION_LEVEL $QL 999999999
CheckExitStatusCode
BYTES_READED=`cat bytes.readed`

# Ordenamos la caché
tools/sortcache $IMAGES/background.j2c.cache
CheckExitStatusCode

# Descomprimimos la caché
Code/CR/decodefromcache $IMAGES/background.j2c.cache.ord ../data/imagesprecincts/000.pgm $WIDTH_RECONS $HEIGHT_RECONS ../data/thumbnails/000.j2c
CheckExitStatusCode

PSNR_PRECI=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/000.pgm  --file_B=../data/imagesprecincts/000.pgm 2> /dev/null | \
grep "PSNR\[dB\]" | awk '{print $3}'`

# Intercambiamos las coordenadas x, y
cat ../data/thumbnails/background.j2c.woi | awk '{print $2 " " $1}' > ../data/thumbnails/temp.woi
mv ../data/thumbnails/temp.woi ../data/thumbnails/background.j2c.woi
#

####################################################

# Tamaño en bytes de la cabecera de los archivos .J2C
HEADER_SIZE=`tools/get_header_size_j2c $IMAGES/000.j2c | grep Bytes | awk '{print $3}'`
(dd if=$IMAGES/000.j2c of=../data/imagestrunc/000.trunc.j2c bs=$(($BYTES_READED+$HEADER_SIZE)) count=1 2>&1) > /dev/null
(kdu_expand -i ../data/imagestrunc/000.trunc.j2c -o ../data/imagestrunc/000.trunc.pgm 2>&1) > /dev/null
PSNR_TRUNC=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/000.pgm  --file_B=../data/imagestrunc/000.trunc.pgm 2> /dev/null | \
grep "PSNR\[dB\]" | awk '{print $3}'`

echo -e "\nPrecintos: \t $PSNR_PRECI"
echo -e "Trunc: \t\t $PSNR_TRUNC"

echo "0 $PSNR_PRECI $PSNR_TRUNC" >> $PSNR_DATA
echo "0 $BYTES_READED $(($BYTES_READED+$HEADER_SIZE))" >> $INFO_DATA

####################################################

i=0

while [ $i -le $NUMERO_FIN_SECUENCIA ]; do

  i_index=`printf %03d $i`
  i_next_index=`printf %03d $(($i+1))`

  ###
  echo "------------------------------> i: $i"
  let MODULUS=$i%20
  if [ $MODULUS -eq 0 ]; then
	cp $IMAGES/${i_index}.j2c $IMAGES/background.j2c

	echo "0 0" > ../data/precincts/uno.txt
	Code/CR/woistocache  $IMAGES/background.j2c ../data/precincts/uno.txt $WIDTH_RECONS $HEIGHT_RECONS $RESOLUTION_LEVEL $QL 999999999
	CheckExitStatusCode

	# Ordenamos la caché
	tools/sortcache $IMAGES/background.j2c.cache
	CheckExitStatusCode

	BYTES_BACKGROUND=`cat bytes.readed`
  else
	BYTES_BACKGROUND=0
  fi
  ###

  # Calculamos las diferencias a partir de los thumbnails
  #
  tools/differencesthumbnails $IMAGES/${i_index}.thumb.pgm $IMAGES/${i_next_index}.thumb.pgm ../data/precincts/${i_next_index}.todos.dat ../data/precincts/${i_next_index}.todos.txt \
  $W_PRECINT_SIZE_THUMBNAIL $H_PRECINT_SIZE_THUMBNAIL $W_OFFSET $H_OFFSET > /dev/null
  CheckExitStatusCode

  # PROVISIONAL ########################
  # Intercambiamos las coordenadas x, y
  #
  cat ../data/precincts/${i_next_index}.todos.txt | awk '{print $2 " " $1}' > ../data/precincts/${i_next_index}.temp.woi.txt
  mv ../data/precincts/${i_next_index}.temp.woi.txt ../data/precincts/${i_next_index}.todos.txt
  ######################################

  # Solicitamos las WOIs de la imagen siguiente y guardamos los datos en un archivo de caché
  Code/CR/woistocache $IMAGES/${i_next_index}.j2c ../data/precincts/${i_next_index}.todos.txt $W_PRECINT_SIZE $H_PRECINT_SIZE $RESOLUTION_LEVEL $QL $MAXBYTES
  CheckExitStatusCode
  BYTES_READED=`cat bytes.readed`
  echo -e "\t*** WOIs: $BYTES_READED"

  # Extraemos los datos que nos interesan del background y los volcamos en temp_aux.cache
  tools/extractcache $IMAGES/${i_next_index}.j2c.cache $IMAGES/background.j2c.cache temp_aux.cache
  CheckExitStatusCode

  # Concatenamos los datos de las WOIs que hemos solicitado con los datos del background que nos interesan
  cat $IMAGES/${i_next_index}.j2c.cache >> temp_aux.cache
  mv temp_aux.cache $IMAGES/background.j2c.cache

  # Ordenamos la caché
  tools/sortcache $IMAGES/background.j2c.cache
  CheckExitStatusCode

  # Descomprimimos la caché
  Code/CR/decodefromcache $IMAGES/background.j2c.cache.ord ../data/imagesprecincts/${i_next_index}.pgm $WIDTH_RECONS $HEIGHT_RECONS ../data/thumbnails/000.j2c
  CheckExitStatusCode

  PSNR_PRECI=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/${i_next_index}.pgm  --file_B=../data/imagesprecincts/${i_next_index}.pgm 2> /dev/null | \
  grep "PSNR\[dB\]" | awk '{print $3}'`

  # Tamaño en bytes de la cabecera de los archivos .J2C
  HEADER_SIZE=`tools/get_header_size_j2c $IMAGES/${i_next_index}.j2c | grep Bytes | awk '{print $3}'`

  #(dd if=$IMAGES/${i_next_index}.j2c of=../data/imagestrunc/${i_next_index}.trunc.j2c bs=$(($BYTES_READED+$HEADER_SIZE)) count=1 2>&1) > /dev/null
  (dd if=$IMAGES/${i_next_index}.j2c of=../data/imagestrunc/${i_next_index}.trunc.j2c bs=$(($BYTES_READED+$HEADER_SIZE+$BYTES_BACKGROUND)) count=1 2>&1) > /dev/null

  (kdu_expand -i ../data/imagestrunc/${i_next_index}.trunc.j2c -o ../data/imagestrunc/${i_next_index}.trunc.pgm 2>&1) > /dev/null

  PSNR_TRUNC=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/${i_next_index}.pgm  --file_B=../data/imagestrunc/${i_next_index}.trunc.pgm 2> /dev/null | \
  grep "PSNR\[dB\]" | awk '{print $3}'`

  echo -e "\nPrecintos: \t $PSNR_PRECI"
  echo -e "Trunc: \t\t $PSNR_TRUNC"

  echo "$i $PSNR_PRECI $PSNR_TRUNC" >> $PSNR_DATA
  echo "$i $BYTES_READED $(($BYTES_READED+$HEADER_SIZE))" >> $INFO_DATA

  # Eliminamos las líneas duplicadas del archivo *.woi
  uniq ../data/thumbnails/${i_next_index}.j2c.woi > ../data/thumbnails/temp.woi
  mv ../data/thumbnails/temp.woi ../data/thumbnails/${i_next_index}.j2c.woi

  # PROVISIONAL ########################
  # Intercambiamos las coordenadas x, y
  #
  cat ../data/thumbnails/${i_next_index}.j2c.woi | awk '{print $2 " " $1}' > ../data/thumbnails/temp.woi
  mv ../data/thumbnails/temp.woi ../data/thumbnails/${i_next_index}.j2c.woi
  ######################################

  tools/drawblocks_txt ../data/imagesprecincts/${i_next_index}.pgm ../data/thumbnails/${i_next_index}.j2c.woi $W_PRECINT_SIZE $H_PRECINT_SIZE ../data/imagesdrawblocks/${i_next_index}.draw.pgm
  CheckExitStatusCode


  i=$(($i+1))
done

