#!/usr/bin/python

import sys
import os
import imp
from subprocess import check_call
from subprocess import CalledProcessError
from decorators import exc_handler

@exc_handler
def execute_command_in_bash(command):
    check_call(bash_command, shell=True)

@exc_handler
def remove_file(path):
    if os.path.isfile(path):
        os.remove(path)

def CleanMeTempFiles():
    remove_file("high")
    remove_file("frame_types")
    remove_file("motion")
    remove_file("motion_out")
    remove_file("prediction_000.pgm")
    remove_file("prediction_temp.pgm")

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
    even_num = int(sys.argv[1])
    odd_num = int(sys.argv[2])

    even = "%03d" % even_num
    odd = "%03d" % odd_num

    # The estimated bitrate
    BITRATE = int(sys.argv[3])

    # Total number of images
    TOTAL_NUMBER_OF_IMAGES = int(sys.argv[4])

    # Temporary directories
    TMP_PGM_IMAGES_DIRECTORY = "_tmp_pgm_images"
    TMP_THUMB_IMAGES_DIRECTORY = "_tmp_thumb_images"
    TMP_PRECINCTS_DIRECTORY = "_tmp_precincts"
    TMP_PREDICTION_IMAGES_DIRECTORY = "_tmp_prediction_images"
    TMP_TRUNC_IMAGES_DIRECTORY = "_tmp_trunc_images"
    TMP_BLOCKS = "_tmp_blocks"
    TMP_BLOCKS_PRECINCTS = "_tmp_blocks_precincts"
    TMP_PREDICTION_DATA_DIRECTORY = "_tmp_prediction_data"

    # Even image
    even_image = even + ".pgm"
    bash_command = "cp " + config.sequence.IMAGES_DIRECTORY + "/" + even_image + " ."
    execute_command_in_bash(bash_command)

    # Odd image
    odd_image = odd + ".pgm"
    bash_command = "cp " + config.sequence.IMAGES_DIRECTORY + "/" + odd_image + " ."
    execute_command_in_bash(bash_command)

    # Next image
    next_index = "%03d" % (odd_num + 1)
    next_image_thumbnail = config.sequence.THUMBNAILS_DIRECTORY + "/" + next_index + ".thumb.pgm"
    next_image_pgm = config.sequence.IMAGES_DIRECTORY + "/" + next_index + ".pgm"
    next_image_j2c = config.sequence.THUMBNAILS_DIRECTORY + "/" + next_index + ".j2c"
    next_image_j2c_cache = config.sequence.THUMBNAILS_DIRECTORY + "/" + next_index + ".j2c.cache"
    next_image_prediction_pgm = next_index + ".pgm"
    next_image_trunc_j2c = next_index + ".trunc.j2c"
    next_image_trunc_pgm = next_index + ".trunc.pgm"

    # Provisional solution:
    # We use this image as reference to know the compression parameters 
    # stored in the header of the codestream.
    REFERENCE_IMAGE_TO_DECODE_FROM_CACHE = config.sequence.THUMBNAILS_DIRECTORY + "/" + even + ".j2c" #000.j2c

    # File that contains the PSNR values obtained in the experiment
    PSNR_FILE = "psnr.txt"
    
    # Remove old file if exists
    remove_file(PSNR_FILE)
    # Create an emtpy file
    open(PSNR_FILE,'a').close()

    # File that contains the SSIM values obtained in the experiment
    SSIM_FILE = "ssim.txt"

    # Remove old file if exists
    remove_file(SSIM_FILE)
    # Create an emtpy file
    open(SSIM_FILE,'a').close()

    # Number of bytes transmitted for each image
    BYTES_FILE = "bytes.txt"

    # Remove old file if exists
    remove_file(BYTES_FILE)
    # Create an emtpy file
    open(BYTES_FILE,'a').close()

    i = 0
    while i < TOTAL_NUMBER_OF_IMAGES:
        CleanMeTempFiles
        print i
        i = i + 1
