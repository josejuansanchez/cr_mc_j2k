#!/bin/bash

function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

function CleanMeTempFiles()
{
	rm high
 	rm frame_types
 	rm motion
 	rm motion_out
 	rm prediction_000.pgm
 	rm prediction_temp.pgm
}

function CleanAllTempFiles()
{
	rm *.pgm
	rm *.cache
	rm *.ord
	rm *.lrcp
	rm *.woi
	rm *.j2c
	rm bytes.readed
}

set -x

if [ $# -ne 3 ]; then
	echo -e "\nUso: $0 <IMAGEN N> <IMAGEN N+1> <BITRATE>\n"
	exit 1
fi

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

CONFIGFILE=$CR_MC_J2K_HOME/config/cr_mc_config.sh
if [ ! -f $CONFIGFILE ]; then
	echo "Error reading config file: $CONFIGFILE"
	exit 1
fi

echo "Reading config file: $CONFIGFILE ...."
source "$CONFIGFILE"
CheckExitStatusCode

# Temporary directories
TMP_PGM_IMAGES_DIRECTORY=_tmp_pgm_images
TMP_THUMB_IMAGES_DIRECTORY=_tmp_thumb_images
TMP_PRECINCTS_DIRECTORY=_tmp_precincts
TMP_PREDICTION_IMAGES_DIRECTORY=_tmp_prediction_images
TMP_TRUNC_IMAGES_DIRECTORY=_tmp_trunc_images
TMP_BLOCKS=_tmp_blocks
TMP_BLOCKS_PRECINCTS=_tmp_blocks_precincts
TMP_PREDICTION_DATA_DIRECTORY=_tmp_prediction_data

# The estimated bitrate
BITRATE=$3

# Initial images
even_num=$1
odd_num=$2

even=`printf %03d $even_num`
odd=`printf %03d $odd_num`

# even image
cp ${IMAGES_DIRECTORY}/${even}.pgm .
even_image=${even}.pgm

# odd image
cp ${IMAGES_DIRECTORY}/${odd}.pgm .
odd_image=${odd}.pgm

# next image
next_index=`printf %03d $(($odd_num+1))`
next_image_thumbnail=${THUMBNAILS_DIRECTORY}/${next_index}.thumb.pgm
next_image_pgm=${IMAGES_DIRECTORY}/${next_index}.pgm
next_image_j2c=${THUMBNAILS_DIRECTORY}/${next_index}.j2c
next_image_j2c_cache=${THUMBNAILS_DIRECTORY}/${next_index}.j2c.cache
next_image_prediction_pgm=${next_index}.pgm
next_image_trunc_j2c=${next_index}.trunc.j2c
next_image_trunc_pgm=${next_index}.trunc.pgm

# Esta imagen es necesaria porque se utiliza como referencia a la hora de
# hacer el decode de la caché. Se utiliza para consultar cuáles son los
# parámetros de configuración del codestream.
REFERENCE_IMAGE_FOR_DECODE_FROM_CACHE=${THUMBNAILS_DIRECTORY}/$even.j2c #000.j2c

# Archivo con el cálculo de todos los PSNRs
PSNR_FILE=psnr.txt
rm ${PSNR_FILE}
touch ${PSNR_FILE}

# Archivo con el cálculo de todos los SSIMs
SSIM_FILE=ssim.txt
rm ${SSIM_FILE}
touch ${SSIM_FILE}

# Número de bytes transmitidos de cada imagen
BYTES_FILE=bytes.txt
rm ${BYTES_FILE}
touch ${BYTES_FILE}

i=0
while [ $i -le 90 ]; do
	echo -e "\t ************************************************* i: $i \n"

	# Eliminamos los archivos temporales de ejecuciones anteriores
	CleanMeTempFiles

	# WITH MC
	# **********************************************************************
	#
	# Calculamos los vectores de movimiento
	$ME -p 2 -x $X -y $Y -b $B -s $S -e $even_image -o $odd_image -a $A -d $D
	CheckExitStatusCode	

	#
	# WITHOUT MC
	# **********************************************************************	
	# ¡OJO!: UTILIZAMOS LA MISMA IMAGEN: $odd_image
	# 
	#$ME -p 2 -x $X -y $Y -b $B -s $S -e $odd_image -o $odd_image -a $A -d $D
	#CheckExitStatusCode			
	# ************************************************************************	

	# Sólo es necesario una imagen como entrada. La que indicamos con el parámetro -e
	# Como salida genera la imagen: prediction_temp.pgm
	# Nota: "decorrelate" necesita que la imagen de entrada esté en el directorio local
	$DECORRELATE -p 2 -x $X -y $Y -b $B -s $S -e $odd_image -o $odd_image -i motion -v $V	
	CheckExitStatusCode	

	# Eliminamos la imagen temporal que se genera
	echo "Removing: prediction_$odd_image"
	rm prediction_$odd_image

	# Obtenemos el thumbnail de la imagen que acabamos de predecir
	cp prediction_temp.pgm prediction_thumb.pgm
	mogrify -resize ${XTHUMB}x${YTHUMB} prediction_thumb.pgm
	CheckExitStatusCode	

	# TODO: Improve this
	# ************************************************************************
	# Obtenemos el thumbnail de la siguiente imagen de la secuencia TEMP:
	# Copiamos el thumbnail de la siguiente imagen en el directorio local Esta
	# operación simula una petición al servidor donde se traería el thumbnail
	# de la siguiente imagen
	cp $next_image_thumbnail .
	CheckExitStatusCode	

	# Calculamos las diferencias a partir de los thumbnails (predicción y siguiente imagen)
	$DIFFERENCES prediction_thumb.pgm $next_image_thumbnail $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.dat \
	$TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt $W_PRECINT_SIZE_THUMBNAIL $H_PRECINT_SIZE_THUMBNAIL \
	$W_OFFSET $H_OFFSET > /dev/null
	CheckExitStatusCode

# *************************
	# Calculamos qué método debemos utilizar para obtener las WOIs
	rm knapsack_solution.txt
	$KNAPSACK $KNAPSACK_JSON_FILES/${next_index}.json $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt $BITRATE > knapsack_solution.txt
	KNAPSACK_SOLUTION_METHOD=`grep "\"method\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1`
	echo "KNAPSACK_SOLUTION_METHOD: $KNAPSACK_SOLUTION_METHOD"

	if [ $KNAPSACK_SOLUTION_METHOD -eq 2 ]; then
		KNAPSACK_SOLUTION_QL=`grep "\"ql\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1 | head -1`
		echo "KNAPSACK_SOLUTION_QL: $KNAPSACK_SOLUTION_QL"
	fi	
# *************************

	# Obtenemos los precintos de la siguiente imagen en función del "bitrate" estimado.
	# Esta operación simula una serie de peticiones al servidor para
	# obtener los precintos que nos interesan de la siguiente imagen
	# Precincts Selection Mode = 1 (Seleccionamos los precintos sólo cuando coinciden con la WOI)

	# TODO: Esta sección está en fase de pruebas
	# *************************
	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 0

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 1
	
	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \ 
	#\$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 1
	
	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \ 
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 2

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 3

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 4

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \ 
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 5

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \ 
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 6

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 7

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 8
	
	$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE \
	$KNAPSACK_SOLUTION_METHOD $KNAPSACK_SOLUTION_QL
	# *************************

	CheckExitStatusCode
	BYTES_READED=`cat bytes.readed`

	# Actualizamos el archivo de bytes leídos para imagen de la secuencia
	echo -e "${next_index} \t $BYTES_READED" >> $BYTES_FILE

	echo -e " ### Ordenamos los precintos de la siguiente imagen ###"
	$SORTCACHE $next_image_j2c_cache
	CheckExitStatusCode

	# WOISTOCACHE, genera 3 archivos de salida:
	#
	# 1) xxx.j2c.cache
	# Devuelve un archivo con el stream JPEG2000 de los precintos/packets solicitados
	#
	# La estructura de los paquetes en este archivo es la siguiente
	#
	# --------------------------------------------------------------------
	# | precinct id (4 bytes) | l (4 bytes)  | r (4 bytes) | c (4 bytes) |
	# --------------------------------------------------------------------
	# | py (4 bytes)          | px (4 bytes) | packet length (4 bytes)   | 
	# --------------------------------------------------------------------
	# | packet                                                           |
	# --------------------------------------------------------------------
	#
	# 2) xxx.j2c.lrcp
	# Devuelve una lista donde se indica las coordenadas lrcp y el tamaño en
	# bytes para cada uno de los precintos de la lista de entrada
	#
	# 3) xxx.j2c.woi
	# Devuelve una lista donde se indican los precintos que se han podido
	# transmitir teniendo en cuenta el valor del BITRATE establecido

	# Comprimimos la imagen predicción de .pgm a .j2c
	# Los parámetros de compresión deben coincidir con los parámetros de compresión iniciales
	# Esta operación debe realizarse en el cliente y puede ser un poco lenta.
	kdu_compress -i prediction_temp.pgm -o prediction_temp.j2c Cuse_sop=yes Corder=LRCP Clayers=$CLAYERS \
	Clevels=$CLEVELS Cprecincts=$CPRECINCTS Cblk=$CBLK Creversible=yes #"Cmodes=RESTART|ERTERM" Cuse_eph=yes
	CheckExitStatusCode

	# En este punto quizás sería interesante comparar el número de paquetes
	# que tienen las dos imágenes que se quieren fusionar. para garantizar que
	# no vamos a tener ningún problema a la hora de realizar la fusión.	
	# El número de paquetes de una imagen es determinista y depende de los
	# parámetros con los que se ha comprimido así que las imágenes siempre
	# deberían tener el mismo número de paquetes.

	SOPS_IN_PREDICTION=`$COUNTSOPS prediction_temp.j2c | grep "SOPs" | awk '{print $3}'`
	SOPS_IN_NEXTIMAGE=`$COUNTSOPS $next_image_j2c | grep "SOPs" | awk '{print $3}'`
	CheckExitStatusCode
	echo -e "SOPS_IN_PREDICTION: $SOPS_IN_PREDICTION \n"
	echo -e "SOPS_IN_NEXTIMAGE: $SOPS_IN_NEXTIMAGE \n"

	if [ $SOPS_IN_PREDICTION -ne $SOPS_IN_NEXTIMAGE ]; then
		echo -e " ### Diffent number of SOPs ###"
		exit 1
	fi

	# Convertimos el archivo .j2c a .cache
	# Pedimos una lista con todos los precintos de la imagen. 
	# Hay que tener en cuenta que la división de los precintos para toda la imagen sea exacta.
	# Precincts Selection Mode = 0 (Seleccionamos los precintos tal y como lo hace KAKADU)
	$WOISTOCACHE prediction_temp.j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.todos.txt \
	$WIDTH_RECONS $HEIGHT_RECONS $(($CLEVELS+1)) $CLAYERS 999999999 0 > /dev/null
	CheckExitStatusCode

	# Extraemos los datos que nos interesan de la imagen predicción y los
	# volcamos en temp_aux.cache
	$EXTRACTCACHE $next_image_j2c_cache prediction_temp.j2c.cache temp_aux.cache
	CheckExitStatusCode

	# Concatenamos los datos de las WOIs que hemos solicitado con los datos de
	# la predicción que nos interesan
	cat $next_image_j2c_cache >> temp_aux.cache
	mv temp_aux.cache prediction_plus_next.j2c.cache
	CheckExitStatusCode

	# Ordenamos la caché
	echo -e " ### Ordenamos la caché: prediction + next ###"
	$SORTCACHE prediction_plus_next.j2c.cache
	CheckExitStatusCode

	# Empty Packets + Prediction + Next
	echo -e " ### Empty Packets + Prediction + Next ###"
	$COOKCACHE prediction_plus_next.j2c.cache.ord prediction_temp.j2c.cache
	CheckExitStatusCode
	cat emptypackets.j2c.cache >> prediction_plus_next.j2c.cache.ord
	CheckExitStatusCode
	
	# Ordenamos la caché	
	echo -e " ### Ordenamos la caché: Empty Packets + Prediction + Next ###"
	mv prediction_plus_next.j2c.cache.ord prediction_plus_next_plus_empty.j2c.cache
	$SORTCACHE prediction_plus_next_plus_empty.j2c.cache
	CheckExitStatusCode

	####################################################################################################
	# TESTs TEMPORALES (Revisar esta sección)
	#
	#echo "0 0" > woi_for_thumbnail.txt
	# Nota: Para traer el thumbnail hay que pedir el nivel de resolución 1
	#$WOISTOCACHE $next_image_j2c woi_for_thumbnail.txt $WIDTH_RECONS $HEIGHT_RECONS 1 $CLAYERS 99999999999 0
	#
	#PRECINCTS_TEMP=precincts_temp.pgm
	#
	# Descomprimimos la caché de la imagen donde sólo se tienen en cuenta los nuevos precintos solicitados
	#$DECODEFROMCACHE $next_image_j2c_cache $PRECINCTS_TEMP $WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_FOR_DECODE_FROM_CACHE}
	#CheckExitStatusCode
	#
	# TEST
	#mv precincts_temp.pgm precincts_temp_${i}.pgm
	####################################################################################################

	# Descomprimimos la caché
	$DECODEFROMCACHE prediction_plus_next_plus_empty.j2c.cache.ord $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} \
	$WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_FOR_DECODE_FROM_CACHE}
	CheckExitStatusCode

	PSNR_ME_PRECI=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm --file_B=$TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# ESTUDIO SÓLO CON LOS NUEVOS PRECINTOS
	#----------------------------		
	PRECINCTS_TEMP=precincts_temp.pgm
	
	# Descomprimimos la caché de la imagen donde sólo se tienen en cuenta los nuevos precintos solicitados
	$DECODEFROMCACHE $next_image_j2c_cache $PRECINCTS_TEMP $WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_FOR_DECODE_FROM_CACHE}
	CheckExitStatusCode
	
	PSNR_PRECI=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm  --file_B=$PRECINCTS_TEMP 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode
	
	#----------------------------
	# ESTUDIO SÓLO CON MC
	#----------------------------
	PSNR_MC=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm  --file_B=prediction_temp.pgm 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode
	
	#----------------------------
	# ESTUDIO CON EL MODO DE FUNCIONAMIENTO DEL SERVIDOR ACTUAL (TRUNCANDO)
	#----------------------------
    # TODO: Habría que tener en cuenta el número de bytes del thumbnail que nos hemos traído de la siguiente imagen.
    #       Actualmente no se está teniendo en cuenta.

	# Tamaño en bytes de la cabecera de los archivos .J2C
	HEADER_SIZE=`$GETHEADERSIZE $next_image_j2c | grep Bytes | awk '{print $3}'`

	(dd if=$next_image_j2c of=$next_image_trunc_j2c bs=$(($BYTES_READED+$HEADER_SIZE)) count=1 2>&1) > /dev/null
	(kdu_expand -i $next_image_trunc_j2c -o $next_image_trunc_pgm 2>&1) > /dev/null
	PSNR_TRUNC=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm --file_B=$next_image_trunc_pgm 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# TABLA RESUMEN
	#----------------------------

	echo -e "BYTES_READED: $BYTES_READED"
	echo -e "me + precints \t precincts \t me \t trunc\n"
	echo -e "$PSNR_ME_PRECI \t $PSNR_PRECI \t $PSNR_MC \t $PSNR_TRUNC \n"
	#echo -e "$PSNR_ME_PRECI \t $PSNR_PRECI \t $PSNR_MC \t $PSNR_TRUNC" >> ${PSNR_FILE}
	echo -e "$PSNR_ME_PRECI \t $PSNR_TRUNC \n"
	echo -e "$PSNR_ME_PRECI \t $PSNR_TRUNC" >> ${PSNR_FILE}

	#----------------------------	

	# Calculamos el SSIM (the Structural SIMilarity (SSIM) index)
	SSIM_ME_PRECI=`$SSIM $next_image_pgm $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} 2> /dev/null | awk '{print $3}'`
	CheckExitStatusCode

	SSIM_TRUNC=`$SSIM $next_image_pgm $next_image_trunc_pgm 2> /dev/null | awk '{print $3}'`
	CheckExitStatusCode

	echo -e "$SSIM_ME_PRECI \t $SSIM_TRUNC \n"
	echo -e "$SSIM_ME_PRECI \t $SSIM_TRUNC" >> ${SSIM_FILE}

	#----------------------------
	# Dibujamos los bloques que se ha pedido de la siguiente imagen sobre la imagen predicha
	
	$DRAWBLOCKS $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} ${THUMBNAILS_DIRECTORY}/${next_index}.j2c.woi \
	${W_PRECINT_SIZE} ${H_PRECINT_SIZE} $TMP_BLOCKS/${next_index}.blocks.pgm
	CheckExitStatusCode

	#----------------------------
	# Guardamos las imágenes que se obtienen al descomprimir sólo los precintos que pedimos de la siguiente imagen
	#
	#cp precincts_temp.pgm _precinctsimages/${next_index}.pgm
	#CheckExitStatusCode
	#
	#----------------------------
	# Dibujamos los bloques que se ha pedido de la siguiente imagen sobre la imagen de los precintos
	#
	#$DRAWBLOCKS _precinctsimages/${next_index}.pgm ${THUMBNAILS_DIRECTORY}/${next_index}.j2c.woi ${W_PRECINT_SIZE} ${H_PRECINT_SIZE} $TMP_BLOCKS_PRECINCTS/${next_index}.blocks.pgm
	#CheckExitStatusCode
	#
	#----------------------------	

	# Copiamos los archivos temporales en directorios auxilares para depurar
	cp $even_image $TMP_PGM_IMAGES_DIRECTORY
	cp $odd_image $TMP_PGM_IMAGES_DIRECTORY
	cp prediction_thumb.pgm $TMP_THUMB_IMAGES_DIRECTORY
	cp $next_image_thumbnail $TMP_THUMB_IMAGES_DIRECTORY
	cp $next_image_trunc_j2c $TMP_TRUNC_IMAGES_DIRECTORY
	cp $next_image_trunc_pgm $TMP_TRUNC_IMAGES_DIRECTORY
	cp prediction_plus_next.j2c.cache $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_plus_next.j2c.cache
	cp prediction_plus_next_plus_empty.j2c.cache $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_plus_next_plus_empty.j2c.cache
	cp prediction_plus_next_plus_empty.j2c.cache.ord $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_plus_next_plus_empty.j2c.cache.ord
	cp prediction_temp.j2c $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_temp.j2c
	cp prediction_temp.j2c.cache $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_temp.j2c.cache
	cp prediction_temp.j2c.lrcp $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_temp.j2c.lrcp
	cp prediction_temp.j2c.woi $TMP_PREDICTION_DATA_DIRECTORY/${next_index}_prediction_temp.j2c.woi

	# Actualizamos las variables para la próxima iteración
	even_num=$((even_num+1))
	odd_num=$((odd_num+1))

	even=`printf %03d $even_num`
	odd=`printf %03d $odd_num`

	# even image
	# La imagen odd pasa a ser la nueva imagen even
	even_image=$odd_image

	# odd image
	# La imagen que hemos predicho pasa a ser la nueva imagen odd. Necesitamos
	# copiar la imagen que hemos predicho (la nueva imagen odd) al directorio
	# local
	cp $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} ${odd}.pgm
	CheckExitStatusCode
	odd_image=${odd}.pgm

	# next image
	next_index=`printf %03d $(($odd_num+1))`
	next_image_thumbnail=${THUMBNAILS_DIRECTORY}/${next_index}.thumb.pgm
	next_image_pgm=${IMAGES_DIRECTORY}/${next_index}.pgm
	next_image_j2c=${THUMBNAILS_DIRECTORY}/${next_index}.j2c
	next_image_j2c_cache=${THUMBNAILS_DIRECTORY}/${next_index}.j2c.cache
	next_image_prediction_pgm=${next_index}.pgm
	next_image_trunc_j2c=${next_index}.trunc.j2c
	next_image_trunc_pgm=${next_index}.trunc.pgm	

	i=$(($i+1))

done

CleanMeTempFiles
CleanAllTempFiles