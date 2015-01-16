#!/bin/bash

# Platform
# LINUX
CR_MC_J2K_HOME=/home/josejuan/cr_mc_j2k
# MAC
#CR_MC_J2K_HOME=/Users/josejuansanchez/UAL/git/cr_mc_j2k

export CR_MC_J2K_HOME

# Tools
DIFFERENCES=$CR_MC_J2K_HOME/tools/bin/differencesthumbnails
WOISTOCACHE=$CR_MC_J2K_HOME/src/CR/bin/woistocache
GETHEADERSIZE=$CR_MC_J2K_HOME/tools/bin/get_header_size_j2c
EXTRACTCACHE=$CR_MC_J2K_HOME/tools/bin/extractcache
DECODEFROMCACHE=$CR_MC_J2K_HOME/src/CR/bin/decodefromcache
SORTCACHE=$CR_MC_J2K_HOME/tools/bin/sortcache
SNR=$CR_MC_J2K_HOME/tools/bin/snr
GETHEADERSIZE=$CR_MC_J2K_HOME/tools/bin/get_header_size_j2c
DRAWBLOCKS=$CR_MC_J2K_HOME/tools/bin/drawblocks_txt
COUNTSOPS=$CR_MC_J2K_HOME/tools/bin/countsops
COOKCACHE=$CR_MC_J2K_HOME/tools/bin/cookcache
KNAPSACK=$CR_MC_J2K_HOME/knapsack/knapsack
ME=$CR_MC_J2K_HOME/MCJ2K/bin/me
DECORRELATE=$CR_MC_J2K_HOME/MCJ2K/bin/decorrelate
CREATE_WOI_LIST=$CR_MC_J2K_HOME/knapsack/tools/j2c_to_knapsack_files/bin/create_woi_list
CREATE_KNAPSACK_JSON_FILE=$CR_MC_J2K_HOME/knapsack/tools/j2c_to_knapsack_files/create_knapsack_json_file.sh
KNAPSACK_JSON_FILES=$CR_MC_J2K_HOME/knapsack/files

# Configuramos el path de Octave para que encuentre nuestros archivos .m
octave --eval "addpath('$CR_MC_J2K_HOME/tools/ssim/');savepath;"
SSIM=$CR_MC_J2K_HOME/tools/ssim/compute_ssim.sh

#SEQUENCE=foreman
#SEQUENCE=stockholm
SEQUENCE=stockholm3dwt
#SEQUENCE=stockholm6dwt
#SEQUENCE=tree
#SEQUENCE=bigbuckbunny

case $SEQUENCE in

    "foreman" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/foreman_352x288
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=3
	CPRECINCTS="{32,32},{16,16},{8,8}"
	CBLK="{32,32}"

	# Parámetros para la estimación de movimiento
	X=352
	Y=288
	B=16
	A=0
	D=0
	S=16
	V=2 # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension	
	WIDTH_RECONS=352
	HEIGHT_RECONS=288

	# Precinct size at the maximum resolution level
	W_PRECINT_SIZE=16
	H_PRECINT_SIZE=16

	# Dimensiones del thumbnail
	XTHUMB=88
	YTHUMB=72
    ;;

    "stockholm" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/stockholm_1280x768
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=2
	CPRECINCTS="{128,128},{64,64},{32,32}"
	CBLK="{32,32}"

	# Parámetros para la estimación de movimiento
	X=1280
	Y=768
	B=128   # block size
	A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
	D=0     # border size = size of the border of the blocks in the motion estimation process
	S=4     # search range = size of the searching area of the motion estimation
	V=2     # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension
	WIDTH_RECONS=1280
	HEIGHT_RECONS=768

	# Precinct size at the maximum resolution level	
	W_PRECINT_SIZE=128
	H_PRECINT_SIZE=128

	# Dimensiones del thumbnail
	XTHUMB=160
	YTHUMB=96
    ;;    

    "tree" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/tree_1280x768
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=2
	CPRECINCTS="{128,128},{64,64},{32,32}"
	CBLK="{8,8}"

	# Parámetros para la estimación de movimiento
	X=1280
	Y=768
	B=128   # block size
	A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
	D=0     # border size = size of the border of the blocks in the motion estimation process
	S=4     # search range = size of the searching area of the motion estimation
	V=2     # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension	
	WIDTH_RECONS=1280
	HEIGHT_RECONS=768

	# Precinct size at the maximum resolution level
	W_PRECINT_SIZE=128
	H_PRECINT_SIZE=128

	# Dimensiones del thumbnail
	XTHUMB=160
	YTHUMB=96
    ;;

    "stockholm3dwt" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/stockholm_1280x768
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=2
	CPRECINCTS="{128,128},{64,64},{32,32}"
	CBLK="{32,32}"

	# Parámetros para la estimación de movimiento
	X=1280
	Y=768
	B=128   # block size
	A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
	D=0     # border size = size of the border of the blocks in the motion estimation process
	S=4     # search range = size of the searching area of the motion estimation
	V=2     # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension
	WIDTH_RECONS=1280
	HEIGHT_RECONS=768

	# Precinct size at the maximum resolution level	
	W_PRECINT_SIZE=128
	H_PRECINT_SIZE=128

	# Dimensiones del thumbnail
	XTHUMB=160
	YTHUMB=96
    ;;

    "stockholm6dwt" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/stockholm_1280x768
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=5
	CPRECINCTS="{128,128},{64,64},{32,32},{16,16},{8,8}"
	CBLK="{8,8}"

	# Parámetros para la estimación de movimiento
	X=1280
	Y=768
	B=128   # block size
	A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
	D=0     # border size = size of the border of the blocks in the motion estimation process
	S=4     # search range = size of the searching area of the motion estimation
	V=2     # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension	
	WIDTH_RECONS=1280
	HEIGHT_RECONS=768

	# Precinct size at the maximum resolution level	
	W_PRECINT_SIZE=128
	H_PRECINT_SIZE=128

	# Dimensiones del thumbnail
	XTHUMB=160
	YTHUMB=96
    ;;

    "bigbuckbunny" )
	IMAGES_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails/big_buck_bunny_1280x768
	THUMBNAILS_DIRECTORY=$CR_MC_J2K_HOME/data/thumbnails

	# Parámetros utilizados en kdu_compress
	CLAYERS=8
	CLEVELS=2
	CPRECINCTS="{128,128},{64,64},{32,32}"
	CBLK="{32,32}"

	# Parámetros para la estimación de movimiento
	X=1280
	Y=768
	B=128   # block size
	A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
	D=0     # border size = size of the border of the blocks in the motion estimation process
	S=4     # search range = size of the searching area of the motion estimation
	V=2     # Overlapping. Para difuminar los bordes de los bloques.

	# Original image dimension	
	WIDTH_RECONS=1280
	HEIGHT_RECONS=768

	# Precinct size at the maximum resolution level		
	W_PRECINT_SIZE=128
	H_PRECINT_SIZE=128

	# Dimensiones del thumbnail
	XTHUMB=160
	YTHUMB=96
    ;;    
esac

# Calculamos las dimensiones de los precintos del thumbnail
W_PRECINT_SIZE_THUMBNAIL=`echo "$XTHUMB/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
H_PRECINT_SIZE_THUMBNAIL=`echo "$YTHUMB/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`

# Calculamos el offset que hay aplicar a las coordenadas de los precintos del thumbnail
# para encontrar su equivalente en la imagen con dimensión original
W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`