#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
#
# expand.py
#
# Reconstruye una secuencia de imágenes a partir de los ficheros
# generados por "compress" o por "extract".

import sys
import getopt
import os
import display

block_overlaping = 0
block_size = 16
block_size_min = 16
border_size = 0
layers = 3
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
temporal_levels = 6

def usage():
    sys.stderr.write("+-------------+\n")
    sys.stderr.write("| MCTF expand |\n")
    sys.stderr.write("+-------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Decompress a sequence of pictures.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-]block_o[v]erlaping=number of overlaped pixels between the blocks in the motion estimation (%d)\n" % block_overlaping)
    sys.stderr.write("   -[-b]lock_size=size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-]block_si[z]e_min=minimal block size allowed in the motion estimation (%d)\n" % block_size_min)
    sys.stderr.write("   -[-l]layers=number of quality layers to decode (%d)\n" % layers)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-s]earch_range=size of the searching area of the motion estimation (%d)\n" % search_range)
    sys.stderr.write("   -[-]subpixel_[a]ccuracy=sub-pixel accuracy of the motion estimation (%d)\n" % subpixel_accuracy)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")
    
opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"v:b:z:l:p:x:y:s:a:t:h",
                                      ["block_overlaping=",
                                       "block_size=",
                                       "block_size_min=",
                                       "layers=",
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
    if o in ("-l", "--layers"):
        layers = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": layers=" + str(layers) + '\n')
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

# Descomprimimos las texturas.
os.system("mctf texture_expand"
          + " --layers=" + str(layers)
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          + " --temporal_levels=" + str(temporal_levels)
          )

if temporal_levels > 1:

    # Descomprimimos los datos del movimiento.
    os.system("mctf motion_expand"
              + " --block_size=" + str(block_size)
              + " --block_size_min=" + str(block_size_min)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --temporal_levels=" + str(temporal_levels)
              )

    # Sintetizamos el vídeo.
    os.system("mctf synthesize"
              + " --block_overlaping=" + str(block_overlaping)
              + " --block_size=" + str(block_size)
              + " --block_size_min=" + str(block_size_min)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --search_range=" + str(search_range)
              + " --subpixel_accuracy=" + str(subpixel_accuracy)
              + " --temporal_levels=" + str(temporal_levels)
              )
