#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_expand.py

# Descomprime los datos con el movimiento.

import sys
import getopt
import os
import display

#MOTION_DECODER_NAME = "gzip"
#MOTION_DECODER_NAME = "kdu_v_expand"
MCTF_MOTION_CODEC = os.environ["MCTF_MOTION_CODEC"]

block_size = 16
block_size_min = 16
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
subpixel_accuracy = 0
temporal_levels = 5

def usage():
#    sys.stderr.write("[0;32m")
#    print
    sys.stderr.write("+--------------------+\n")
    sys.stderr.write("| MCTF motion_expand |\n")
    sys.stderr.write("+--------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Expand the motion data.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("   -[-b]lock_size=size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-]block_si[z]e_min=minimal block size allowed in the motion estimation (%d)\n" % block_size_min)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" % pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" % pixels_in_y)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"b:z:p:x:y:t:h",
                                      ["block_size=",
                                       "block_size_min=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "temporal_levels=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

for o, a in opts:
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
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

if block_size < block_size_min:
    block_size_min = block_size

# C�lculo del tama�o de bloque usado en el nivel de resoluci�n
# temporal m�s bajo.
iterations = temporal_levels - 1
max_block_size = block_size
iters = temporal_levels - 1
fields = pictures / 2
iteration = 0
while iteration < iterations:

    block_size = block_size / 2
    if (block_size < block_size_min):
        block_size = block_size_min

    fields /= 2
    iteration += 1

blocks_in_y = pixels_in_y / block_size
blocks_in_x = pixels_in_x / block_size

# Descomprimimos los campos de movimiento.
iteration = 1
fields = pictures / 2
while iteration <= iterations:

    os.system("mctf motion_expand_" + MCTF_MOTION_CODEC
              + " --file=" + "\"" + "motion_residue_" + str(iteration) + "\""
              )

    fields /= 2

#    os.system("svc motion_expand_" + "gzip"
#              + " --blocks_in_x=" + str(blocks_in_x)
#              + " --blocks_in_y=" + str(blocks_in_y)
#              + " --iteration=" + str(iteration)
#              + " --file=" + "\"" + prefix + "_motion_residue_" + str(iteration) + "\""
#              + " --pictures=" + str(pictures)
#              + " --temporal_levels=" + str(temporal_levels)
#              )

    iteration += 1

fields = pictures / 2

# Deshacemos la descorrelaci�n bidireccional en el nivel de resoluci�n
# temporal m�s bajo.
os.system("mctf bidirectional_motion_correlate"
          + " --blocks_in_y=" + str(blocks_in_y)
          + " --blocks_in_x=" + str(blocks_in_x)
          + " --fields=" + str(fields)
          + " --input=" + "\"" + "motion_residue_" + str(temporal_levels - 1) + "\""
          + " --output=" + "\"" + "motion_" + str(temporal_levels - 1) + "\""
          )

# Deshacemos la descorrelaci�n interlevel.
iterations = temporal_levels - 1
iteration = iterations
while iteration > 1:
    
    iteration -= 1   
    fields = pictures / (2**iteration)

    blocks_in_y = pixels_in_y / block_size
    blocks_in_x = pixels_in_x / block_size

    # Descorrelacionamos los campos de movimiento entre niveles de
    # resoluci�n.
    os.system("mctf interlevel_motion_correlate"
              + " --blocks_in_x=" + str(blocks_in_x)
              + " --blocks_in_y=" + str(blocks_in_y)
              + " --fields_in_predicted=" + str(fields)
              + " --predicted=" + "\"" + "motion_" + str(iteration) + "\""
              + " --reference=" + "\"" + "motion_" + str(iteration+1) + "\""
              + " --residue=" + "\"" + "motion_residue_" + str(iteration) + "\""
              )

    # Calculamos el tama�o de bloque usado en esta iteraci�n temporal.
    block_size = block_size/2
    if (block_size<block_size_min):
        block_size = block_size_min

