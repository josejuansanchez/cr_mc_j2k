#!/usr/bin/python

import sys
import os
import imp
import subprocess

#from subprocess import check_call
from subprocess import CalledProcessError
from decorators import *

@exc_handler
def execute_command_in_bash(command):
    print "Executing: " + command
    output = subprocess.call(command, shell=True, stderr=subprocess.STDOUT)
    print "\nOutput: %d" % output
    return output

@exc_handler
def create_empty_file(path):
    open(path,'a').close()

@exc_handler
def remove_file(path):
    if os.path.isfile(path):
        os.remove(path)

@exc_handler
def read_int_value_from_file(path):
    with open(path) as f:
        value = f.readline()
    return int(value)

@exc_handler
def write_line_into_file(path, line):
    f = open(path,'a')
    f.write(line)
    f.close()

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
    create_empty_file(PSNR_FILE)

    # File that contains the SSIM values obtained in the experiment
    SSIM_FILE = "ssim.txt"

    # Remove old file if exists
    remove_file(SSIM_FILE)
    # Create an emtpy file
    create_empty_file(SSIM_FILE)

    # Number of bytes transmitted for each image
    BYTES_FILE = "bytes.txt"

    # Remove old file if exists
    remove_file(BYTES_FILE)
    # Create an emtpy file
    create_empty_file(BYTES_FILE)

    i = 0
    while i < TOTAL_NUMBER_OF_IMAGES:
        CleanMeTempFiles
        
        print "\nIteration: %d\n" % i

        if config.sequence.USE_MOTION_COMPENSATION:

            # WITH MC
            me = "%s -p 2 -x %d -y %d -b %d -s %d -e %s -o %s -a %d -d %d" % \
                (config.tools.ME,
                 config.sequence.X,
                 config.sequence.Y,
                 config.sequence.B,
                 config.sequence.S, 
                 even_image, 
                 odd_image, 
                 config.sequence.A, 
                 config.sequence.D)

        else:

            # WITHOUT MC
            # WARNING!: - In this case we use the 'odd_image' twice
            #           - This is a trick to use the same code in both cases (with an without mc)
            me = "%s -p 2 -x %d -y %d -b %d -s %d -e %s -o %s -a %d -d %d" % \
                (config.tools.ME,
                 config.sequence.X,
                 config.sequence.Y,
                 config.sequence.B,
                 config.sequence.S, 
                 odd_image, 
                 odd_image, 
                 config.sequence.A, 
                 config.sequence.D)

        # Calculate motion vectors
        execute_command_in_bash(me)

        # This program only needs one image as input (the image specified with the -e modifier).
        # The output will be the prediction image named as 'prediction_temp.pgm'
        # Note: This program requires that the input image is in the same working directory.
        decorrelate = "%s -p 2 -x %d -y %d -b %d -s %d -e %s -o %s -i motion -v %d -a %d" % \
            (config.tools.DECORRELATE,
             config.sequence.X,
             config.sequence.Y,
             config.sequence.B,
             config.sequence.S, 
             odd_image, 
             odd_image, 
             config.sequence.V, 
             config.sequence.A)

        execute_command_in_bash(decorrelate)

        # Remove the temporal image generated in the previous step
        print "Removing: prediction_%s" % odd_image
        remove_file("prediction_%s" % odd_image)

        # Get the thumbnail from the prediction image   
        execute_command_in_bash("cp prediction_temp.pgm prediction_thumb.pgm")
        execute_command_in_bash("mogrify -resize %dx%d prediction_thumb.pgm" % 
            (config.sequence.XTHUMB,
            config.sequence.YTHUMB))

        # TODO: Improve this step (Temporary solution)
        # *************************
        # In this step we need to get the thumbnail from the next image of the sequence.
        # We are using a temporary solution, which consist in copy the thubmnail
        # of the next image in our working directory. 
        # This step try to simulate a client request to the server.
        execute_command_in_bash("cp %s ." % next_image_thumbnail)

        # Calculate the differences between the thubmnails (predicted and next image)
        differences = "%s prediction_thumb.pgm %s %s/%s.some.dat %s/%s.some.txt %s %s %s %s" % \
            (config.tools.DIFFERENCES, 
             next_image_thumbnail, 
             TMP_PRECINCTS_DIRECTORY,
             next_index,
             TMP_PRECINCTS_DIRECTORY,
             next_index,
             config.sequence.W_PRECINT_SIZE_THUMBNAIL,
             config.sequence.H_PRECINT_SIZE_THUMBNAIL,
             config.sequence.W_OFFSET,
             config.sequence.H_OFFSET
             )

        execute_command_in_bash(differences)

        # *************************
        # In this step we try to know what is the best method to send the WOIs.
        # We use the 'knapsack' tool to evaluate all the possibilities.
        #remove_file("knapsack_solution.txt")        
        #$KNAPSACK $KNAPSACK_JSON_FILES/${next_index}.json $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt $BITRATE > knapsack_solution.txt
        #KNAPSACK_SOLUTION_METHOD=`grep "\"method\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1`
        #echo "KNAPSACK_SOLUTION_METHOD: $KNAPSACK_SOLUTION_METHOD"
        #
        #if [ $KNAPSACK_SOLUTION_METHOD -eq 2 ]; then
        #    KNAPSACK_SOLUTION_QL=`grep "\"ql\"" knapsack_solution.txt | awk '{print $2}' | cut -d "," -f1 | head -1`
        #    echo "KNAPSACK_SOLUTION_QL: $KNAPSACK_SOLUTION_QL"
        #fi
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
        #                               will be included in the precincts.  
        #
        # The 'woistocache' tool generates three output files:
        #
        # 1) xxx.j2c.cache
        # This file contains the JPEG2000 codestream for the requested WOIs (precincts)self.
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

        #$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
        #$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 2 7

        #$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
        #$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE 3 7

        #$WOISTOCACHE $next_image_j2c $TMP_PRECINCTS_DIRECTORY/${next_index}.some.txt \
        #$W_PRECINT_SIZE $H_PRECINT_SIZE $(($CLEVELS+1)) $CLAYERS $BITRATE \
        #$KNAPSACK_SOLUTION_METHOD $KNAPSACK_SOLUTION_QL
        # *************************

        precincts_selection_mode = 2
        until_this_quality_layer = 7

        woistocache = "%s %s %s/%s.some.txt %s %s %d %s %d %d %d" % \
            (config.tools.WOISTOCACHE,
             next_image_j2c,
             TMP_PRECINCTS_DIRECTORY,
             next_index,
             config.sequence.W_PRECINT_SIZE,
             config.sequence.H_PRECINT_SIZE,
             config.sequence.CLEVELS + 1,
             config.sequence.CLAYERS,
             BITRATE,
             precincts_selection_mode,
             until_this_quality_layer
             )

        execute_command_in_bash(woistocache)

        # Read the number of bytes readed from the codestream
        BYTES_READED = read_int_value_from_file("bytes.readed")
        print "BYTES_READED: %d" % BYTES_READED

        # Update the number of bytes transmitted for the WOIs requested 
        write_line_into_file(BYTES_FILE, "%s \t %d\n" % (next_index,BYTES_READED))

        # Sort the cache
        print(" ### Sorting the precincts of the next image ###")

        sortcache = "%s %s" % \
            (config.tools.SORTCACHE,
             next_image_j2c_cache
            )

        execute_command_in_bash(sortcache)

        # TODO: Improve this step (Temporary solution)
        # In this step we compress the prediction image, from .pgm to .j2c
        # The compression parameters used in this step have to match with the parameters
        # used for the reference images.
        # Note that this step is performed at the client side and could be slow.

        kdu_compress = "kdu_compress" \
            + " -i prediction_temp.pgm" \
            + " -o prediction_temp.j2c" \
            + " Cuse_sop=yes" \
            + " Corder=" + config.sequence.CORDER \
            + " Clayers=" + str(config.sequence.CLAYERS) \
            + " Clevels=" + str(config.sequence.CLEVELS) \
            + " Cprecincts=" + str(config.sequence.CPRECINCTS) \
            + " Cblk=" + config.sequence.CBLK \
            + " Creversible=yes" 

        execute_command_in_bash(kdu_compress)

        # Our image fusion process is packet based so that, is necessary that both
        # images had been compressed using the same compression parameters and
        # to have the same number of packets.
        countsops = "%s prediction_temp.j2c | grep \"SOPs\" | awk '{print $3}'" % \
            (config.tools.COUNTSOPS)

        SOPS_IN_PREDICTION = execute_command_in_bash(countsops)
        print "SOPS_IN_PREDICTION %d" % SOPS_IN_PREDICTION


        i = i + 1