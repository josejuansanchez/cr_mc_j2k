#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
import display
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

COMPONENTS = 3
BYTES_PER_COMPONENT = 1

file = ""
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
quantizations = 45000
SRLs = 5

parser = MCTF_parser(description="Compress the LFB texture data using Motion JPEG 2000.")

parser.add_argument("--file", help="file that contains the LFB data. Default = {})".format(file))
parser.pictures(pictures)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.quantizations(quantizations)
parser.SRLs(SRLs)

args = parser.parse_known_args()[0]
if args.file:
    file = args.file
if args.pictures:
    pictures = int(args.pictures)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.quantizations:
    quantizations = args.quantizations
if args.SRLs:
    SRLs = int(args.SRLs)

dwt_levels = SRLs - 1

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
try:
    check_call("trace cat " + file + " >> " + file + ".vix", shell=True)
except CalledProcessError:
    sys.exit(-1)

# Comprimimos.
# Haar irreversible
#compressor_params += " "
#compressor_params += "Catk=2 Kextension:I2=CON Kreversible:I2=no Ksteps:I2=\{1,0,0,0\},\{1,0,0,0\} Kcoeffs:I2=-1.0,0.5"

# 5/3 irreversible
#compressor_params += " "
#compressor_params += "Catk=2 Kextension:I2=SYM Kreversible:I2=no Ksteps:I2=\{2,0,0,0\},\{2,-1,0,0\} Kcoeffs:I2=-0.5,-0.5,0.25,0.25"

# 9/7 irreversible
# Ckernels=W9X7

try:
    check_call("trace kdu_v_compress" +
               " -i " + file + ".vix" +
               " -o " + file + ".mjc" +
               " -frames " + str(pictures) +
               " -slope " + quantizations +
               " -no_weights" +
               " Clevels=" + str(dwt_levels),
               shell=True)
except CalledProcessError:
    sys.exit(-1)
