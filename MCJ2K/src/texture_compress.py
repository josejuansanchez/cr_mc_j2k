#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# texture_compress.py
#
# Comprime las texturas (subbandas temporales) generadas de la fase de
# an�lisis. El n�mero de bits asignados a cada subbanda depende del
# par�metro "slopes" que controla la calidad de cada capa de calidad
# (como un factor de cuantificaci�n) de cada imagen de cada
# subbanda. Por tanto, el n�mero de capas de calidad es igual que el
# n�mero de slopes. El control �ptimo del bit-rate debe realizarse en
# tiempo de descompresi�n usando el programa "extract".

import sys
import getopt
import os
import display

MCTF_TEXTURE_CODEC = os.environ["MCTF_TEXTURE_CODEC"]
HIGH = "high"
LOW = "low"

pictures = 33
pixels_in_x = 352
pixels_in_y = 288
slopes = os.environ["SLOPES"]
temporal_levels = 6

def usage():
    sys.stderr.write("+-----------------------+\n")
    sys.stderr.write("| MCTF texture_compress |\n")
    sys.stderr.write("+-----------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Compress the texture data.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-]s[l]opes=distortion-length slope for each quality layer (\"%s\")" % slopes)
    sys.stderr.write("   -[-]subpixel_[a]ccuracy=sub-pixel accuracy of the motion estimation (%d)\n" % subpixel_accuracy)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"p:x:y:s:t:h",
                                      ["pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "slopes=",
                                       "temporal_levels=",
                                       "help"])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

for o, a in opts:
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
    if o in ("-l", "--slopes"):
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


# Convertimos la cadena de par�metros en una lista de par�metros.
#slopes_list = eval ( slopes ) # Ojo, respetar espacios por el m4!!!
#temporal_levels = len ( slopes_list ) - 1 # El �ltimo slope es cascarilla.

# Comprimimos las subbandas de alta frecuencia.
#subband = temporal_levels - 1
subband = 1
while subband < temporal_levels:
    os.system("mctf texture_compress_hfb_" + MCTF_TEXTURE_CODEC
              + " --file=" + HIGH + "_" + str(subband)
              + " --pictures=" + str(pictures)
              + " --pixels_in_x=" + str(pixels_in_x)
              + " --pixels_in_y=" + str(pixels_in_y)
              + " --slopes=\"" + slopes + "\""
              + " --subband=" + str(subband)
              + " --temporal_levels=" + str(temporal_levels)
              )
    subband += 1

# Comprimimos la subbanda de baja frecuencia.
os.system("mctf texture_compress_lfb_" + MCTF_TEXTURE_CODEC
          + " --file=" + LOW + "_" + str(temporal_levels - 1)
          + " --pictures=" + str(pictures)
          + " --pixels_in_x=" + str(pixels_in_x)
          + " --pixels_in_y=" + str(pixels_in_y)
          + " --slopes=\"" + slopes + "\""
          + " --temporal_levels=" + str(temporal_levels)
          )

