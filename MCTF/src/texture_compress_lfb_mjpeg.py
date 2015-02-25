#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
import display
import getopt

COMPONENTS = 3
BYTES_PER_COMPONENT = 1

file = ""
slopes = "31"
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
temporal_levels = 5

def usage():
    sys.stderr.write("+---------------------------------+\n")
    sys.stderr.write("| MCTF texture_compress_lfb_mjpeg |\n")
    sys.stderr.write("+---------------------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("   Compress the LFB texture data using Motion JPEG.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-f]ile = file that contains the LFB data (\"%s\")\n" % file)
    sys.stderr.write("   -[-p]ictures = number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n" % pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n" % pixels_in_y)
    sys.stderr.write("   -[-s]lopes = distortion-length slope value for the only quality layer (%s)\n" % "", slopes)
    sys.stderr.write("   -[-t]emporal_levels = number of temporal levels (%d)\n" % temporal_levels)

opts = ""

display.info(str(sys.argv[0:]) + '\n')

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"f:p:x:y:s:t:h",
                                      ["file=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "slopes=",
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

    if o in ("-p", "--pictures"):
        pictures = int(a)
        display.info(sys.argv[0] + ": pictures=" + str(pictures) + '\n')

    if o in ("-x", "--pixels_in_x"):
        pixels_in_x = int(a)
        display.info(sys.argv[0] + ": pixels_in_x=" + str(pixels_in_x) + '\n')

    if o in ("-y", "--pixels_in_y"):
        pixels_in_y = int(a)
        display.info(sys.argv[0] + ": pixels_in_y=" + str(pixels_in_y) + '\n')

    if o in ("-s", "--slopes"):
        slopes = a
        display.info(sys.argv[0] + ": slopes=" + slopes + '\n')

    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')

    if o in ("-h", "--help"):
	usage()
	sys.exit()

trace = open ("trace", 'a')

command = "mv " + file + " " + file + ".yuv"
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)

command = "(ffmpeg"\
    + " " + "-y " \
    + " " + "-qscale " + slopes \
    + " " + "-s " + str(pixels_in_x) + "x" + str(pixels_in_y) \
    + " " + "-i " + file + ".yuv" \
    + " " + file + ".mjpeg >&2) 2> /dev/null"

trace.write(sys.argv[0] + ": " + command + "\n")
ifdef({{DEBUG}},
os.system(command)
,
os.system(command + " > /dev/null")
)

command = "mv " + file + ".yuv " + file
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)
