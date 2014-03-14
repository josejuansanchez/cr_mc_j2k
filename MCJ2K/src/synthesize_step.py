#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# analyze_step.py
#
# Realiza una iteración de la transformada temporal inversa.

import sys
import getopt
import os
import display

block_overlaping = 0
block_size = 16
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
temporal_subband = 0

def usage():
#    sys.stderr.write("[0;32m")
    sys.stderr.write("\n")
    sys.stderr.write("+----------------------+\n")
    sys.stderr.write("| MCTF synthesize_step |\n")
    sys.stderr.write("+----------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Performs a step the temporal synthesis.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-]block_o[v]erlaping = number of overlaped pixels between the blocks in the motion estimation (%d)\n" % block_overlaping)
    sys.stderr.write("   -[-b]lock_size = size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-p]ictures = number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-s]earch_range = size of the searching area of the motion estimation (%d)\n" % search_range)
    sys.stderr.write("   -[-]subpixel_[a]ccuracy = sub-pixel accuracy of the motion estimation (%d)\n" % subpixel_accuracy)
    sys.stderr.write("   -[-t]emporal_subband = iteration of the temporal transform (%d)\n" % temporal_subband)
    sys.stderr.write("\n")

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]))
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"v:b:p:x:y:s:a:t:h",
                                      ["block_overlaping=",
                                       "block_size=",
                                       "iteration=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "search_range=",
                                       "subpixel_accuracy=",
                                       "temporal_subband=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)
    
params = ""
    
for o, a in opts:
    if o in ("-v", "--block_overlaping"):
        block_overlaping = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": block_overlaping=" + str(block_overlaping) + '\n')
        )
    if o in ("-b", "--block_size"):
        block_size = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": block_size=" + str(block_size) + '\n')
        )
    if o in ("-p", "--pictures"):
        pictures = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pictures=" + str(pictures) + '\n')
        )
    if o in ("-x", "--pixels_in_x"):
        pixels_in_x = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pixels_in_x=" + str(pixels_in_x) + '\n')
        )
    if o in ("-y", "--pixels_in_y"):
        pixels_in_y = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pixels_in_y=" + str(pixels_in_y) + '\n')
        )
    if o in ("-s", "--search_range"):
        search_range = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": search_range=" + str(search_range) + '\n')
        )
    if o in ("-a", "--subpixel_accuracy"):
        subpixel_accuracy = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": subpixel_accuracy=" + str(subpixel_accuracy) + '\n')
        )
    if o in ("-t", "--temporal_subband"):
        temporal_subband = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_subband=" + str(temporal_subband) + '\n')
        )
    if o in ("-h", "--help"):
	usage()

os.system("mctf un_update"
          + " --block_size=" + str(block_size)
          + " --even_fn=" + "even_" + str(temporal_subband)
          + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
          + " --high_fn=" + "high_" + str(temporal_subband)
          + " --low_fn=" + "low_" + str(temporal_subband)
          + " --motion_fn=" + "motion_" + str(temporal_subband)
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          + " --subpixel_accuracy=" + str(subpixel_accuracy)
          )

os.system("mctf correlate"
          + " --block_overlaping=" + str(block_overlaping)
          + " --block_size=" + str(block_size)
          + " --even_fn=" + "even_" + str(temporal_subband)
          + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
          + " --high_fn=" + "high_" + str(temporal_subband)
          + " --motion_in_fn=" + "motion_" + str(temporal_subband)
          + " --odd_fn=" + "odd_" + str(temporal_subband)
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          + " --search_range=" + str(search_range)
          + " --subpixel_accuracy=" + str(subpixel_accuracy)
          )

os.system("mctf merge"
          + " --even=" + "even_" + str(temporal_subband)
          + " --low=" + "low_" + str(temporal_subband-1)
          + " --odd=" + "odd_" + str(temporal_subband)
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          )
