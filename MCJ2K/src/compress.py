#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
#
# compress.py
#
# Comprime el v�deo llamado "low_0.yuv".
#
# # Comprimimos usando 3 capas de calidad:
# mctf compress --slopes="44000,43000,42000"
#
# # El primer slope representa la calidad de la subbanda L1,
# # el segundo la calidad de ls subbanda H1, y el tercero
# # el de la subbanda H0. A mayor slope, menor calidad.
#
# # Obtenemos informaci�n sobre el code-stream:
# mctf info --temporal_levels=3
#
# # Descomprimimos:
# mkdir decompression_dir
# cp *.mj2 decompression_dir; cp *.gz decompression_dir
# cd decompresion_dir
# mctf expand --temporal_levels=3
#
# Para conocer los diferentes par�metros, escribir:
#
# mctf compress --help

import sys
import getopt
import os
import array
import display
import string

block_overlaping = 0
block_size = 16
block_size_min = 16
border_size = 0
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
slopes = os.environ["SLOPES"]
subpixel_accuracy = 0
temporal_levels = 6

def usage():
    sys.stderr.write("+---------------+\n")
    sys.stderr.write("| MCTF compress |\n")
    sys.stderr.write("+---------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Encodes a picture sequence.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-]block_o[v]erlaping=number of overlaped pixels between the blocks in the motion estimation (%d)\n" % block_overlaping)
    sys.stderr.write("   -[-b]lock_size=size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-]block_si[z]e_min=minimal block size allowed in the motion estimation (%d)\n" % block_size_min)
    sys.stderr.write("   -[-]bor[d]der_size=size of the border of the blocks in the motion estimation process (%d)\n" % border_size)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-s]earch_range=size of the searching area of the motion estimation (%d)\n" % search_range)
    sys.stderr.write("   -[-]s[l]opes=distortion-length slope for each quality layer (\"%s\")\n" % slopes)
    sys.stderr.write("   -[-]subpixel_[a]ccuracy=sub-pixel accuracy of the motion estimation (%d)\n" % subpixel_accuracy)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")
    
opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"v:b:z:d:p:x:y:l:p:a:t:h",
                                      ["block_overlaping=",
                                       "block_size=",
                                       "block_size_min=",
                                       "border_size=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "search_range=",
                                       "slopes=",
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
    if o in ("-l", "--slopes"):
        slopes = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": slopes=" + slopes + '\n')
        )
#        slopes += ",65535"
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

#temporal_levels = len ( eval ( slopes ) ) - 1

if temporal_levels > 1:
    # An�lisis temporal de la secuencia de im�genes. Descorrelaci�n temporal.
    os.system("mctf analyze"
              + " --block_overlaping=" + str(block_overlaping)
              + " --block_size=" + str(block_size)
              + " --block_size_min=" + str(block_size_min)
              + " --border_size=" + str(border_size)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --search_range=" + str(search_range)
              + " --subpixel_accuracy=" + str(subpixel_accuracy)
              + " --temporal_levels=" + str(temporal_levels)
              )

    # Comprimimos los campos de movimiento. Una capa de calidad, sin p�rdida.
    os.system("mctf motion_compress"
              + " --block_size=" + str(block_size)
              + " --block_size_min=" + str(block_size_min)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --temporal_levels=" + str(temporal_levels)
              )

# Comprimimos las texturas. Una capa de calidad (por ahora), con p�rdida.
os.system("mctf texture_compress"
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          + " --slopes=\"" + slopes + "\""
          + " --temporal_levels=" + str(temporal_levels)
          )
