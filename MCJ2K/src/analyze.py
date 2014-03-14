#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# analyze.py
#
# Aplica la transformada temporal y genera una serie de ficheros que
# m�s tarde ser�n codificados.

import sys
import getopt
import os
from GOP import GOP
import display

SEARCH_RANGE_MAX = 128

block_overlaping = 0
block_size = 16
border_size = 0
block_size_min = 16
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
temporal_levels = 5

def usage():
    sys.stderr.write("+--------------+\n")
    sys.stderr.write("| MCTF analyze |\n")
    sys.stderr.write("+------.-------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("    Performs the temporal analysis of a picture sequence.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-]block_o[v]erlaping = number of overlaped pixels between the blocks in the motion estimation (%d)\n" % block_overlaping)
    sys.stderr.write("   -[-b]lock_size = size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-]block_si[z]e_min = minimal block size allowed in the motion estimation (%d)\n" % block_size_mim)
    sys.stderr.write("   -[-]bor[d]der_size = size of the border of the blocks in the motion estimation process (%d)\n" % border_size)
    sys.stderr.write("   -[-p]ictures = number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-s]earch_range = size of the searching area of the motion estimation (%d)\n" % search_range)
    sys.stderr.write("   -[-]subpixel_[a]ccuracy = sub-pixel accuracy of the motion estimation (%d)\n" % subpixel_accuracy)
    sys.stderr.write("   -[-t]emporal_levels = number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"v:b:z:d:p:x:y:s:a:t:h",
                                      ["block_overlaping=",
                                       "block_size=",
                                       "block_size_min=",
                                       "border_size=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "search_range=",
                                       "subpixel_accuracy=",
                                       "temporal_levels=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

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
    if o in ("-z", "--block_size_min"):
        block_size_min = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": block_size_min=" + str(block_size_min) + '\n')
        )
    if o in ("-d", "--border_size"):
        border_size = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": border_size=" + str(border_size) + '\n')
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
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

gop=GOP()
GOP_size = gop.get_size(temporal_levels)
number_of_GOPs = pictures / GOP_size
search_factor = 2
temporal_subband = 1

if block_size < block_size_min:
    block_size_min = block_size

while temporal_subband < temporal_levels:

    ifdef({{DEBUG}},
    display.info(sys.argv[0] + ": analyzing temporal level " + str(temporal_subband) + " of " + str(temporal_levels) + "\n")
    )

    os.system("mctf analyze_step"
              + " --block_overlaping=" + str(block_overlaping)
              + " --block_size=" + str(block_size)
              + " --border_size=" + str(border_size)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --search_range=" + str(search_range)
              + " --subpixel_accuracy=" + str(subpixel_accuracy)
              + " --temporal_subband=" + str(temporal_subband)
              )

    pictures = (pictures + 1) / 2

    search_range = search_range * search_factor
    if ( search_range > SEARCH_RANGE_MAX ):
        sys.stdout.write(sys.argv[0] + ": " + str(SEARCH_RANGE_MAX) + " reached!\n")
        search_range = SEARCH_RANGE_MAX

    block_size = block_size / 2
    if ( block_size < block_size_min ):
        block_size = block_size_min
        
    temporal_subband += 1

