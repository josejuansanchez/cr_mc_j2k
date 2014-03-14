#!/bin/bash

if [ $# -ne 1 ]; then
	echo -e "\nUso: $0 <BITRATE>\n";
	exit;
fi

MODE="1024"

case $MODE in
     "1024" )
		PRECINT_SIZE=32
		PRECINT_SIZE_THUMBNAIL=`echo "64/($MODE/$PRECINT_SIZE)" | bc`
		OFFSET=`echo "$PRECINT_SIZE/$PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/originalespgm_1024x1024"
		WIDTH_RECONS=1024
		HEIGHT_RECONS=1024
		RESOLUTION_LEVEL=3		# Niveles de resolución
		QLU=8				# Capas de calidad
           ;;

     "4096" )
		PRECINT_SIZE=128
		PRECINT_SIZE_THUMBNAIL=`echo "64/($MODE/$PRECINT_SIZE)" | bc`
		OFFSET=`echo "$PRECINT_SIZE/$PRECINT_SIZE_THUMBNAIL" | bc`
		IMAGES_ORIGINALES_PGM="../data/thumbnails/originalespgm_4096x4096"
		WIDTH_RECONS=4096
		HEIGHT_RECONS=4096
		RESOLUTION_LEVEL=7		# Niveles de resolución
		QLU=8				# Capas de calidad
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

# Volcamos todo el contenido de la imagen background.j2c a un archivo de caché
cp $IMAGES/000.j2c $IMAGES/background.j2c
Code/CR/j2ctocache $IMAGES/background.j2c $WIDTH_RECONS $HEIGHT_RECONS $RESOLUTION_LEVEL $QLU
cp $IMAGES/background.j2c.packets.cache $IMAGES/background.j2c.cache

MAXBYTES=$1

i=0

while [ $i -le 4 ]; do

  i_index=`printf %03d $i`
  i_next_index=`printf %03d $(($i+1))`

tools/print_all_wois $HEIGHT_RECONS $WIDTH_RECONS $PRECINT_SIZE > ../data/precincts/${i_next_index}.todos.txt

# Solicitamos las WOIs de la imagen siguiente y guardamos los datos en un archivo de caché
Code/CR/woistocache $IMAGES/${i_next_index}.j2c ../data/precincts/${i_next_index}.todos.txt $PRECINT_SIZE $RESOLUTION_LEVEL $QLU $MAXBYTES

# Extraemos los datos que nos interesan del background y los volcamos en temp_aux.cache
tools/extractcache $IMAGES/${i_next_index}.j2c.cache $IMAGES/background.j2c.cache temp_aux.cache

# Concatenamos los datos de las WOIs que hemos solicitado con los datos del background que nos interesan
cat $IMAGES/${i_next_index}.j2c.cache >> temp_aux.cache
mv temp_aux.cache $IMAGES/background.j2c.cache

# Ordenamos la caché según el id de precinto
tools/sortcache $IMAGES/background.j2c.cache

# Descomprimimos la caché
Code/CR/decodefromcache $IMAGES/background.j2c.cache.ord ../data/imagesprecincts/${i_next_index}.pgm $WIDTH_RECONS $HEIGHT_RECONS ../data/thumbnails/000.j2c


  PSNR_PRECI=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/${i_next_index}.pgm  --file_B=../data/imagesprecincts/${i_next_index}.pgm 2> /dev/null  | grep "PSNR\[dB\]" | awk '{print $3}'`

  # Tamaño en bytes de la cabecera de los archivos .J2C
  HEADER_SIZE=`tools/get_header_size_j2c $IMAGES/${i_next_index}.j2c | grep Bytes | awk '{print $3}'`

  (dd if=$IMAGES/${i_next_index}.j2c of=../data/imagestrunc/${i_next_index}.trunc.j2c bs=$(($MAXBYTES+$HEADER_SIZE)) count=1 2>&1) > /dev/null

  (kdu_expand -i ../data/imagestrunc/${i_next_index}.trunc.j2c -o ../data/imagestrunc/${i_next_index}.trunc.pgm 2>&1) > /dev/null

  PSNR_TRUNC=`tools/snr --type=uchar --peak=255 --file_A=$IMAGES_ORIGINALES_PGM/${i_next_index}.pgm  --file_B=../data/imagestrunc/${i_next_index}.trunc.pgm 2> /dev/null | grep "PSNR\[dB\]" | awk '{print $3}'`

  echo -e "\nPrecintos: \t $PSNR_PRECI"
  echo -e "Trunc: \t\t $PSNR_TRUNC"

  echo "$i $PSNR_PRECI $PSNR_TRUNC" >> $PSNR_DATA

  # Eliminamos las líneas duplicadas del archivo *.woi
  uniq ../data/thumbnails/${i_next_index}.j2c.woi > ../data/thumbnails/temp.woi
  mv ../data/thumbnails/temp.woi ../data/thumbnails/${i_next_index}.j2c.woi

  # PRUEBA
  # Cambiamos las coordenadas X por Y
  cat ../data/thumbnails/${i_next_index}.j2c.woi | awk '{print $2 " " $1}' > ../data/thumbnails/temp.woi
  mv ../data/thumbnails/temp.woi ../data/thumbnails/${i_next_index}.j2c.woi
  #

  tools/drawblocks_txt ../data/imagesprecincts/${i_next_index}.pgm ../data/thumbnails/${i_next_index}.j2c.woi $PRECINT_SIZE ../data/imagesdrawblocks/${i_next_index}.draw.pgm
  #display ../data/imagesdrawblocks/${i_next_index}.draw.pgm

  i=$(($i+1))
done

