#!/usr/bin/python

import sys
import os
import imp
from subprocess import check_call

def main():
	print "main"

if __name__ == '__main__':

	# Checking command line arguments
	if len(sys.argv) != 5:
		print "\nUsage: %s <IMAGE N> <IMAGE N+1> <BITRATE> <TOTAL # of IMAGES>\n" % sys.argv[0]	
		sys.exit(-1)

	# Checking the environment variable CR_MC_J2K_HOME
	if not os.environ["CR_MC_J2K_HOME"]:
		print "Error. CR_MC_J2K_HOME is not defined"
		sys.exit(-1)

	CR_MC_J2K_HOME = os.environ["CR_MC_J2K_HOME"]

	config_file_path = CR_MC_J2K_HOME + "/config/config.py"
	config = imp.load_source("config", config_file_path)

	# Initial images
	even_num=sys.argv[1]
	odd_num=sys.argv[2]

	# The estimated bitrate
	BITRATE=sys.argv[3]

	# Total number of images
	TOTAL_NUMBER_OF_IMAGES=sys.argv[4]

	print "even_num: %d" % int(even_num)
	print "odd_num: %d" % int(odd_num)
	print "bitrate: %d" % int(BITRATE)
	print "total_number_of_images: %d" % int(TOTAL_NUMBER_OF_IMAGES)

	# Temporary directories
	TMP_PGM_IMAGES_DIRECTORY="_tmp_pgm_images"
	TMP_THUMB_IMAGES_DIRECTORY="_tmp_thumb_images"
	TMP_PRECINCTS_DIRECTORY="_tmp_precincts"
	TMP_PREDICTION_IMAGES_DIRECTORY="_tmp_prediction_images"
	TMP_TRUNC_IMAGES_DIRECTORY="_tmp_trunc_images"
	TMP_BLOCKS="_tmp_blocks"
	TMP_BLOCKS_PRECINCTS="_tmp_blocks_precincts"
	TMP_PREDICTION_DATA_DIRECTORY="_tmp_prediction_data"

	main()