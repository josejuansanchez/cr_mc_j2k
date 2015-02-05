#!/bin/bash

# Platform
# LINUX
export CR_MC_J2K_HOME=/home/josejuan/cr_mc_j2k
# MAC
#export CR_MC_J2K_HOME=/Users/josejuansanchez/UAL/git/cr_mc_j2k

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
KNAPSACK=$CR_MC_J2K_HOME/knapsack/tools/knapsack/bin/knapsack
ME=$CR_MC_J2K_HOME/MCJ2K/bin/me
DECORRELATE=$CR_MC_J2K_HOME/MCJ2K/bin/decorrelate
CREATE_WOI_LIST=$CR_MC_J2K_HOME/knapsack/tools/j2c_to_knapsack_files/bin/create_woi_list
CREATE_KNAPSACK_JSON_FILE=$CR_MC_J2K_HOME/knapsack/tools/j2c_to_knapsack_files/create_knapsack_json_file.sh
KNAPSACK_JSON_FILES=$CR_MC_J2K_HOME/knapsack/files

# Configuramos el path de Octave para que encuentre nuestros archivos .m
octave --eval "addpath('$CR_MC_J2K_HOME/tools/ssim/');savepath;" &> /dev/null
SSIM=$CR_MC_J2K_HOME/tools/ssim/compute_ssim.sh

source $CR_MC_J2K_HOME/config/sequences/stockholm3dwt.cfg
#source $CR_MC_J2K_HOME/config/sequences/stockholm5dwt.cfg
#source $CR_MC_J2K_HOME/config/sequences/foreman.cfg
#source $CR_MC_J2K_HOME/config/sequences/stockholm.cfg
#source $CR_MC_J2K_HOME/config/sequences/stockholm6dwt.cfg
#source $CR_MC_J2K_HOME/config/sequences/tree.cfg
#source $CR_MC_J2K_HOME/config/sequences/bigbuckbunny.cfg

# Calculamos las dimensiones de los precintos del thumbnail
W_PRECINT_SIZE_THUMBNAIL=`echo "$XTHUMB/($WIDTH_RECONS/$W_PRECINT_SIZE)" | bc`
H_PRECINT_SIZE_THUMBNAIL=`echo "$YTHUMB/($HEIGHT_RECONS/$H_PRECINT_SIZE)" | bc`

# Calculamos el offset que hay aplicar a las coordenadas de los precintos del thumbnail
# para encontrar su equivalente en la imagen con dimensión original
W_OFFSET=`echo "$W_PRECINT_SIZE/$W_PRECINT_SIZE_THUMBNAIL" | bc`
H_OFFSET=`echo "$H_PRECINT_SIZE/$H_PRECINT_SIZE_THUMBNAIL" | bc`