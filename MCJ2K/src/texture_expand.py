#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# texture_expand.py
#
# Decompress the texture. There are a different number of (compressed)
# texture streams called "low_X", "high_X", "high_X-1", ..., where X
# is the bumber of temporal resolution levels - 1.

import sys
import getopt
import os
import display

MCTF_TEXTURE_CODEC = os.environ["MCTF_TEXTURE_CODEC"]
LOW = "low"
HIGH = "high"

layers = 3
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
temporal_levels = 5

def usage():
    sys.stderr.write("+---------------------+\n")
    sys.stderr.write("| MCTF texture_expand |\n")
    sys.stderr.write("+---------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Expand the texture data.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-l]layers=number of quality layers to decode (%d)\n" % layers)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"l:p:x:y:t:h",
                                      ["layers=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "temporal_levels=",
                                       "help"])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

for o, a in opts:
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
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

# Descompresión de la banda de baja frecuencia
os.system("mctf texture_expand_lfb_" + MCTF_TEXTURE_CODEC
          + " --file=" + "\"" + LOW + "_" + str(temporal_levels - 1) + "\""
          + " --layers=" + str(layers)
          + " --pictures=" + str(pictures)
          + " --temporal_levels=" + str(temporal_levels)
          )

# Descomprimimos las subbandas de alta frecuencia.
subband = temporal_levels - 1
while subband > 0:
    os.system("mctf texture_expand_hfb_" + MCTF_TEXTURE_CODEC
              + " --file=" + "\"" + HIGH + "_" + str(subband) + "\""
              + " --layers=" + str(layers)
              + " --pictures=" + str(pictures)
              + " --temporal_levels=" + str(temporal_levels)
              )
    subband -= 1
