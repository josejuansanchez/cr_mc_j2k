#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
import display
import getopt

file = ""
layers = 1
pictures = 33
temporal_levels = 6

def usage():
    sys.stderr.write("+-------------------------------+\n")
    sys.stderr.write("| MCTF texture_expand_hfb_mjepg |\n")
    sys.stderr.write("+-------------------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("   Expand the HFB texture data using Motion JPEG.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-f]ile = file that contains the HFB data (\"%s\")\n" % file)
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
        display.info(sys.argv[0] + ": file=" + file + '\n')

    if o in ("-l", "--layers"):
        layers = int(a)
        display.info(sys.argv[0] + ": layers=" + str(layers) + '\n')

    if o in ("-p", "--pictures"):
        pictures = int(a)
        display.info(sys.argv[0] + ": pictures=" + str(pictures) + '\n')

    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')

    if o in ("-h", "--help"):
	usage()
	sys.exit()

trace = open ("trace", 'a')

command = "(ffmpeg "\
    + " " + "-i " + file + ".mjpeg" \
    + " " + file + ".yuv >&2) 2> /dev/null"

trace.write(sys.argv[0] + ": " + command + "\n")
ifdef({{DEBUG}},
os.system(command)
,
os.system(command + " > /dev/null")
)

command = "mv " + file + ".yuv " + file
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)
