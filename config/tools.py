#!/usr/bin/python

import sys
import os

# Checking the environment variable CR_MC_J2K_HOME
if not os.environ["CR_MC_J2K_HOME"]:
	print "Error. CR_MC_J2K_HOME is not defined"
	sys.exit(-1)

CR_MC_J2K_HOME = os.environ["CR_MC_J2K_HOME"]

# Tools
DIFFERENCES               = CR_MC_J2K_HOME + "/tools/bin/differencesthumbnails"
WOISTOCACHE               = CR_MC_J2K_HOME + "/src/CR/bin/woistocache"
GETHEADERSIZE             = CR_MC_J2K_HOME + "/tools/bin/get_header_size_j2c"
EXTRACTCACHE              = CR_MC_J2K_HOME + "/tools/bin/extractcache"
DECODEFROMCACHE           = CR_MC_J2K_HOME + "/src/CR/bin/decodefromcache"
SORTCACHE                 = CR_MC_J2K_HOME + "/tools/bin/sortcache"
SNR                       = CR_MC_J2K_HOME + "/tools/bin/snr"
GETHEADERSIZE             = CR_MC_J2K_HOME + "/tools/bin/get_header_size_j2c"
DRAWBLOCKS                = CR_MC_J2K_HOME + "/tools/bin/drawblocks_txt"
COUNTSOPS                 = CR_MC_J2K_HOME + "/tools/bin/countsops"
COOKCACHE                 = CR_MC_J2K_HOME + "/tools/bin/cookcache"
KNAPSACK                  = CR_MC_J2K_HOME + "/knapsack/tools/knapsack/bin/knapsack"
ME                        = CR_MC_J2K_HOME + "/MCJ2K/bin/me"
DECORRELATE               = CR_MC_J2K_HOME + "/MCJ2K/bin/decorrelate"
CREATE_WOI_LIST           = CR_MC_J2K_HOME + "/knapsack/tools/j2c_to_knapsack_files/bin/create_woi_list"
CREATE_KNAPSACK_JSON_FILE = CR_MC_J2K_HOME + "/knapsack/tools/j2c_to_knapsack_files/create_knapsack_json_file.sh"
KNAPSACK_JSON_FILES       = CR_MC_J2K_HOME + "/knapsack/files"
PRINT_ALL_WOI_LIST        = CR_MC_J2K_HOME + "/tools/bin/print_wois_list"

# TODO: Improve this section
# Configuramos el path de Octave para que encuentre nuestros archivos .m
#os.system("octave --eval \"addpath('%s/tools/ssim/');savepath;\" &> /dev/null" % CR_MC_J2K_HOME)
#SSIM = CR_MC_J2K_HOME + "/tools/ssim/compute_ssim.sh"