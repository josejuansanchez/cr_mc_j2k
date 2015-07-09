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

if [ $# -ne 4 ]; then
	echo -e "\nUso: $0 <IMAGE N> <IMAGE N+1> <BITRATE> <TOTAL # of IMAGES>\n"
	exit 1
fi

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

# Total number of images
TOTAL_NUMBER_OF_IMAGES=$4

# The estimated bitrate
BITRATE=$3

# Initial images
even_num=$1
odd_num=$2

even=$(printf %03d $even_num)
odd=$(printf %03d $odd_num)

# Even image
cp ${IMAGES_DIRECTORY}/${even}.pgm .
even_image=${even}.pgm

# Odd image
cp ${IMAGES_DIRECTORY}/${odd}.pgm .
odd_image=${odd}.pgm

# Next image
next_index=`printf %03d $(($odd_num+1))`
next_image_thumbnail=${THUMBNAILS_DIRECTORY}/${next_index}.thumb.pgm
next_image_pgm=${IMAGES_DIRECTORY}/${next_index}.pgm
next_image_j2c=${THUMBNAILS_DIRECTORY}/${next_index}.j2c
next_image_j2c_cache=${THUMBNAILS_DIRECTORY}/${next_index}.j2c.cache
next_image_prediction_pgm=${next_index}.pgm
next_image_trunc_j2c=${next_index}.trunc.j2c
next_image_trunc_pgm=${next_index}.trunc.pgm

# Provisional solution:
# We use this image as reference to know the compression parameters 
# stored in the header of the codestream.
REFERENCE_IMAGE_TO_DECODE_FROM_CACHE=${THUMBNAILS_DIRECTORY}/$even.j2c #000.j2c

# File that contains the PSNR values obtained in the experiment
PSNR_FILE=psnr.txt
rm ${PSNR_FILE}
touch ${PSNR_FILE}

# File that contains the SSIM values obtained in the experiment
SSIM_FILE=ssim.txt
rm ${SSIM_FILE}
touch ${SSIM_FILE}

# Number of bytes transmitted for each image
BYTES_FILE=bytes.txt
rm ${BYTES_FILE}
touch ${BYTES_FILE}

i=0
while [ $i -lt $TOTAL_NUMBER_OF_IMAGES ]; do
	echo -e "\t ************************************************* Iteration: $i \n"

	# Cleaning temporary files from previous execution
	CleanMeTempFiles

	# WITH MC
	# *************************
	# Calculating movement vectors
	#$ME -p 2 -x $X -y $Y -b $B -s $S -e $even_image -o $odd_image -a $A -d $D
	#CheckExitStatusCode

	#
	# WITHOUT MC
	# *************************
	# ¡WARNING!: - We use the same image twice ($odd_image)
	# 			 - This is a trick to use the same code in both cases (with an without mc)
	#
	$ME -p 2 -x $X -y $Y -b $B -s $S -e $odd_image -o $odd_image -a $A -d $D
	CheckExitStatusCode

	# This program only needs one image as input (the image specified with the -e modifier).
	# The output will be the prediction image named as 'prediction_temp.pgm'
	# Note: This program requires that the input image is in the same working directory.
	$DECORRELATE -p 2 -x $X -y $Y -b $B -s $S -e $odd_image -o $odd_image -i motion -v $V -a $A
	CheckExitStatusCode

	# Remove the temporal image generated in the previous step
	echo "Removing: prediction_$odd_image"
	rm prediction_$odd_image

	# Get the thumbnail from the prediction image	
	cp prediction_temp.pgm prediction_thumb.pgm
	mogrify -resize ${XTHUMB}x${YTHUMB} prediction_thumb.pgm
	CheckExitStatusCode

	# TODO: Improve this step (Provisional solution)
	# *************************
	# In this step we need to get the thumbnail from the next image of the sequence.
	# We are using a provisional solution, which consist in copy the thubmnail
	# of the next image in our working directory. 
	# This step try to simulate a client request to the server.
	cp $next_image_thumbnail .
	CheckExitStatusCode

	# We calculate the differences between the thubmnails (predicted and next image)
	$DIFFERENCES prediction_thumb.pgm $next_image_thumbnail $TMP_PRECINCTS_DIRECTORY/${next_index}.some.dat \
	$TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt $W_PRECINT_SIZE_THUMBNAIL $H_PRECINT_SIZE_THUMBNAIL \
	$W_OFFSET $H_OFFSET > /dev/null
	CheckExitStatusCode

	# *************************
	# In this step we try to know what is the best method to send the WOIs.
	# We use the 'knapsack' tool to evaluate all the possibilities.
	rm knapsack_solution.txt
	$KNAPSACK $KNAPSACK_JSON_FILES/${next_index}.json $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt $BITRATE > knapsack_solution.txt
	KNAPSACK_SOLUTION_METHOD=`grep "\"method\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1`
	echo "KNAPSACK_SOLUTION_METHOD: $KNAPSACK_SOLUTION_METHOD"

	if [ $KNAPSACK_SOLUTION_METHOD -eq 2 ]; then
		KNAPSACK_SOLUTION_QL=`grep "\"ql\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1 | head -1`
		echo "KNAPSACK_SOLUTION_QL: $KNAPSACK_SOLUTION_QL"
	fi
	# *************************


	# TODO: This section of code is under construction
	# *************************
	#
	# This step try to simulate the client request(s) to the server in order to get
	# the WOIs (precincts) needed to carry out the reconstruction of the next image
	# that will be displayed.
	# The tool used for this purpose ('woistocache') have three modes of operation.
	# - Precinct selection mode 0 = Selects the precincts in the same way as Kakadu does.
	# - Precinct selection mode 1 = Only selects the precincts that match exactly with the WOI.	
	# - Precinct selection mode 2 = We can specify the maximun number of quality layers that
	#								will be included in the precincts.	
	#
	# The 'woistocache' tool generates three output files:
	#
	# 1) xxx.j2c.cache
	# This file contains the JPEG2000 codestream for the requested WOIs (precincts).
	#
	# The codestream is stored as packets and the structure for this packets is
	# detailed below:
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
	# This file contains a list with the LRCP values and size for all
	# the WOIs (precincts) specified in the input list.
	#
	# 3) xxx.j2c.woi
	# This file contains a list with the (x,y) coordinates for the WOIs (precincts)
	# that have been included in the response taking into account the bitrate
	# specified as input parameter.

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 0

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 1

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#\$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 1

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 2

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 3

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 4

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 5

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 6

	$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 7

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 3 7

	#$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
	#$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE \
	#$KNAPSACK_SOLUTION_METHOD $KNAPSACK_SOLUTION_QL
	# *************************

	CheckExitStatusCode
	BYTES_READED=`cat bytes.readed`

	# Update the number of bytes transmitted for the WOIs requested	
	echo -e "${next_index} \t $BYTES_READED" >> $BYTES_FILE

	# Sort the cache
	echo -e " ### Ordenamos los precintos de la siguiente imagen ###"
	$SORTCACHE $next_image_j2c_cache
	CheckExitStatusCode


	# TODO: Improve this step (Provisional solution)
	# In this step we compress the prediction image, from .pgm to .j2c
	# The compression parameters used in this step have to match with the parameters
	# used for the reference images.
	# Note that this step is performed at the client side and could be slow.
	kdu_compress -i prediction_temp.pgm -o prediction_temp.j2c Cuse_sop=yes Corder=$CORDER Clayers=$CLAYERS \
	Clevels=$CLEVELS Cprecincts=$CPRECINCTS Cblk=$CBLK Creversible=yes #"Cmodes=RESTART|ERTERM" Cuse_eph=yes
	CheckExitStatusCode

	# En este punto quizás sería interesante comparar el número de paquetes
	# que tienen las dos imágenes que se quieren fusionar, para garantizar que
	# no vamos a tener ningún problema a la hora de realizar la fusión.
	# El número de paquetes de una imagen es determinista y depende de los
	# parámetros con los que se ha comprimido así que las imágenes siempre
	# deberían tener el mismo número de paquetes.

	# Our image fusion process is packet based so that, is necessary that both
	# images had been compressed using the same compression parameters and
	# to have the same number of packets.
	SOPS_IN_PREDICTION=`$COUNTSOPS prediction_temp.j2c | grep "SOPs" | awk '{print $3}'`
	SOPS_IN_NEXTIMAGE=`$COUNTSOPS $next_image_j2c | grep "SOPs" | awk '{print $3}'`
	CheckExitStatusCode
	echo -e "SOPS_IN_PREDICTION: $SOPS_IN_PREDICTION \n"
	echo -e "SOPS_IN_NEXTIMAGE: $SOPS_IN_NEXTIMAGE \n"

	if [ $SOPS_IN_PREDICTION -ne $SOPS_IN_NEXTIMAGE ]; then
		echo -e " ### Diffent number of SOPs ###"
		exit 1
	fi


	# Create a file that contains a list with all the non-overlapped WOIS that 
	# can be selected at the maximun resolution level of the image.
	$PRINT_ALL_WOI_LIST $WIDTH_RECONS $HEIGHT_RECONS $W_PRECINT_SIZE $H_PRECINT_SIZE > /tmp/all.txt

	# Convert from .j2c to .cache, for the prediction image
	# In order to extract all the precincts of the image we use the 'woistocache' tool
	# to request all the non-overlapped WOIS of the image.
	# To achieve this, we use the precincts selection mode 0, which selects the precincts 
	# in the same way as Kakadu does.
	$WOISTOCACHE prediction_temp.j2c /tmp/all.txt \
	$WIDTH_RECONS $HEIGHT_RECONS $(($CLEVELS+1)) $CLAYERS 999999999 0 > /dev/null
	CheckExitStatusCode

	# We extract the data that we need from the prediction image cache and store it
	# in a temporary cache ('temp_aux.cache').
	$EXTRACTCACHE $next_image_j2c_cache prediction_temp.j2c.cache temp_aux.cache
	CheckExitStatusCode

	# Concat both cache files (prediction and next image)
	cat $next_image_j2c_cache >> temp_aux.cache
	mv temp_aux.cache prediction_plus_next.j2c.cache
	CheckExitStatusCode

	# Sort the cache
	echo -e " ### Ordenamos la caché: prediction + next ###"
	$SORTCACHE prediction_plus_next.j2c.cache
	CheckExitStatusCode

	# Empty Packets + Prediction + Next
	# In this step we create the empty packets needed to have a complete codestream.
	echo -e " ### Empty Packets + Prediction + Next ###"
	$COOKCACHE prediction_plus_next.j2c.cache.ord prediction_temp.j2c.cache
	CheckExitStatusCode
	cat emptypackets.j2c.cache >> prediction_plus_next.j2c.cache.ord
	CheckExitStatusCode

	# Sort the cache
	echo -e " ### Ordenamos la caché: Empty Packets + Prediction + Next ###"
	mv prediction_plus_next.j2c.cache.ord prediction_plus_next_plus_empty.j2c.cache
	$SORTCACHE prediction_plus_next_plus_empty.j2c.cache
	CheckExitStatusCode

	####################################################################################################
	# TODO: This section has not beed tested (Code under construction)
	#
	#echo "0 0" > woi_for_thumbnail.txt
	# Nota: Para traer el thumbnail hay que pedir el nivel de resolución 1
	#$WOISTOCACHE $next_image_j2c woi_for_thumbnail.txt $WIDTH_RECONS $HEIGHT_RECONS 1 $CLAYERS 99999999999 0
	#
	#PRECINCTS_TEMP=precincts_temp.pgm
	#
	# Descomprimimos la caché de la imagen donde sólo se tienen en cuenta los nuevos precintos solicitados
	#$DECODEFROMCACHE $next_image_j2c_cache $PRECINCTS_TEMP $WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_TO_DECODE_FROM_CACHE}
	#CheckExitStatusCode
	#
	# TEST
	#mv precincts_temp.pgm precincts_temp_${i}.pgm
	####################################################################################################

	# Decompress the cache
	$DECODEFROMCACHE prediction_plus_next_plus_empty.j2c.cache.ord $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} \
	$WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_TO_DECODE_FROM_CACHE}
	CheckExitStatusCode

	PSNR_ME_PRECI=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm --file_B=$TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# Study: Only for the new WOIs received from the next image
	#----------------------------
	PRECINCTS_TEMP=precincts_temp.pgm

	# Decompress the cache that holds only the new precincts (WOIs)
	$DECODEFROMCACHE $next_image_j2c_cache $PRECINCTS_TEMP $WIDTH_RECONS $HEIGHT_RECONS ${REFERENCE_IMAGE_TO_DECODE_FROM_CACHE}
	CheckExitStatusCode

	PSNR_PRECI=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm  --file_B=$PRECINCTS_TEMP 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# Stydu: Using only MC
	#----------------------------
	PSNR_MC=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm  --file_B=prediction_temp.pgm 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# Study: Simulate a server that truncates the codestream
	#----------------------------
	# TODO: Take into account the number of bytes of the thumbnail for the next image.
	#		In the current solution this value is not taken into account.

	# Header size for the .j2c files
	HEADER_SIZE=`$GETHEADERSIZE $next_image_j2c | grep Bytes | awk '{print $3}'`

	(dd if=$next_image_j2c of=$next_image_trunc_j2c bs=$(($BYTES_READED+$HEADER_SIZE)) count=1 2>&1) > /dev/null
	(kdu_expand -i $next_image_trunc_j2c -o $next_image_trunc_pgm 2>&1) > /dev/null
	PSNR_TRUNC=`$SNR --type=uchar --peak=255 --file_A=$next_image_pgm --file_B=$next_image_trunc_pgm 2> /dev/null | \
	grep "PSNR\[dB\]" | awk '{print $3}'`
	CheckExitStatusCode

	#----------------------------
	# Summary table
	#----------------------------

	echo -e "BYTES_READED: $BYTES_READED"
	echo -e "me + precints \t precincts \t me \t trunc\n"
	#echo -e "$PSNR_ME_PRECI \t $PSNR_PRECI \t $PSNR_MC \t $PSNR_TRUNC \n"
	#echo -e "$PSNR_ME_PRECI \t $PSNR_PRECI \t $PSNR_MC \t $PSNR_TRUNC" >> ${PSNR_FILE}
	echo -e "$PSNR_ME_PRECI \t $PSNR_TRUNC \n"
	echo -e "$PSNR_ME_PRECI \t $PSNR_TRUNC" >> ${PSNR_FILE}

	#----------------------------

	# Calculate the SSIM (the Structural SIMilarity (SSIM) index)
	SSIM_ME_PRECI=`$SSIM $next_image_pgm $TMP_PREDICTION_IMAGES_DIRECTORY/${next_image_prediction_pgm} 2> /dev/null | awk '{print $3}'`
	CheckExitStatusCode

	SSIM_TRUNC=`$SSIM $next_image_pgm $next_image_trunc_pgm 2> /dev/null | awk '{print $3}'`
	CheckExitStatusCode

	echo -e "$SSIM_ME_PRECI \t $SSIM_TRUNC \n"
	echo -e "$SSIM_ME_PRECI \t $SSIM_TRUNC" >> ${SSIM_FILE}

	#----------------------------
	
	# Draw blocks which match with the requested WOIs.
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

	# Copy the used files in this iteration in an auxiliar directory in order to debug the results
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

	# Update the variables for the next iteration
	even_num=$((even_num+1))
	odd_num=$((odd_num+1))

	even=`printf %03d $even_num`
	odd=`printf %03d $odd_num`

	# even image
	# The 'odd_image' will be the 'even_imagen' in the next iteration
	even_image=$odd_image

	# odd image
	# The predicted image will be the 'odd_image' in the next iteration.
	# We need to copy this image to the current working directory.
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
