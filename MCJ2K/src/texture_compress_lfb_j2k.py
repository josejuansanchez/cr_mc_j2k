#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
import display
import getopt

COMPONENTS = 3
BYTES_PER_COMPONENT = 1

file = ""
slopes = os.environ["SLOPES"]
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
temporal_levels = 5

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
    sys.stderr.write("   -[-p]ictures = number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n" % pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n" % pixels_in_y)
    sys.stderr.write("   -[-s]lopes = distortion-length slope values for each quality layer (%s)\n" % "", slopes)
    sys.stderr.write("   -[-t]emporal_levels = number of temporal levels (%d)\n" % temporal_levels)

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

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
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": file=" + file + '\n')
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
    if o in ("-s", "--slopes"):
        slopes = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": slopes=" + slopes + '\n')
        )
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

trace = open ("trace", 'a')

# Creamos las cabecera VIX.
#fd = open( "head.vix", 'w' )
fd = open( file + ".vix", 'w' )
fd.write("vix\n")
fd.write(">VIDEO<\n")
fd.write("1.0 0\n")
fd.write(">COLOUR<\n")
fd.write("YCbCr\n")
fd.write(">IMAGE<\n")
fd.write("unsigned char 8 little-endian\n")
fd.write("%d " % pixels_in_x)
fd.write("%d " % pixels_in_y)
fd.write("%d\n" % COMPONENTS)
fd.write("1 1\n")
fd.write("2 2\n")
fd.write("2 2\n")
fd.close()

# Concatenamos el fichero YUV a la cabecera VIX.
#command = "cat " + file + " >> head.vix"
command = "cat " + file + " >> " + file + ".vix"
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)

# Comprimimos.
# Haar irreversible
#compressor_params += " "
#compressor_params += "Catk=2 Kextension:I2=CON Kreversible:I2=no Ksteps:I2=\{1,0,0,0\},\{1,0,0,0\} Kcoeffs:I2=-1.0,0.5"

# 5/3 irreversible
#compressor_params += " "
#compressor_params += "Catk=2 Kextension:I2=SYM Kreversible:I2=no Ksteps:I2=\{2,0,0,0\},\{2,-1,0,0\} Kcoeffs:I2=-0.5,-0.5,0.25,0.25"

# 9/7 irreversible
# Ckernels=W9X7

command = "kdu_v_compress" \
    + " -i " + file + ".vix" \
    + " -o " + file + ".mjc" \
    + " -frames " + str(pictures) \
    + " -slope " + slopes \
    + " -no_weights"

ifdef({{DEBUG}},
# Comprimimos mostrando la salida estándar.
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)
,
# Comprimimos redirigiendo la salida estándar hacia "/dev/null".
trace.write(sys.argv[0] + ": " + command + " > /dev/null\n")
os.system(command + " > /dev/null")
)

#command = "rm head.vix"
#trace.write(sys.argv[0] + ": " + command + "\n")
#os.system(command)
