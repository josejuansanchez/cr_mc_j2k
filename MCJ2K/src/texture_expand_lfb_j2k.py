#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
import display
import getopt

file = ""
layers = 3
pictures = 33
temporal_levels = 6

def usage():
    sys.stderr.write("+-------------------------------+\n")
    sys.stderr.write("| MCTF texture_compress_lfb_j2k |\n")
    sys.stderr.write("+-------------------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("   Compress the LFB texture data.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-f]ile = file that contains the LFB data (\"%s\")\n" % file)
    sys.stderr.write("   -[-l]layers = number of quality layers to decode (%d)\n" % layers)
    sys.stderr.write("   -[-p]ictures = number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-t]emporal_levels = number of temporal levels (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],
                                      "f:l:p:t:h",
                                      ["file=",
                                       "layers=",
                                       "pictures=",
                                       "temporal_levels=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

for o, a in opts:
    if o in ("-f", "--file"):
        file = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": file=" + file + '\n')
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
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

command = "kdu_v_expand" + " -i " + file + ".mjc" + " -o " + file + ".vix" + " -layers " + str(layers)

ifdef({{DEBUG}},
sys.stdout.write(command + "\n")

# Descomprimimos
os.system(command)
,
os.system(command + " > /dev/null")
)

command = "mctf vix2raw < " + file + ".vix > " + file

ifdef({{DEBUG}},
sys.stdout.write(command + "\n")
)

# Eliminamos la cabecera .vix
os.system(command)
