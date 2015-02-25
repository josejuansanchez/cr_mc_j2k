#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# texture_expand.py
#
# Decompress the texture. There are a different number of (compressed)
# texture streams called "low_X", "high_X", "high_X-1", ..., where X
# is the bumber of temporal resolution levels - 1.

import sys
import os
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

MCTF_TEXTURE_CODEC = os.environ["MCTF_TEXTURE_CODEC"]
LOW = "low"
HIGH = "high"

GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
TRLs = 5
SRLs = 5

parser = MCTF_parser(description="Expands the texture.")
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.SRLs(TRLs)
parser.TRLs(TRLs)

args = parser.parse_known_args()[0]
if args.GOPs:
    GOPs = int(args.GOPs)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.SRLs:
    SRLs = int(args.SRLs)
if args.TRLs:
    TRLs = int(args.TRLs)

gop=GOP()
GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

_pictures = pictures
subband = 0
while subband < (TRLs - 1):
    pictures = (pictures + 1) / 2
    subband += 1

try:
    # Descompresión de la banda de baja frecuencia
    check_call("mctf texture_expand_lfb_" + MCTF_TEXTURE_CODEC
               + " --file=" + "\"" + LOW + "_" + str(TRLs - 1) + "\""
               + " --pictures=" + str(pictures)
               + " --pictures=" + str(pictures)
               + " --SRLs=" + str(SRLs),
               shell=True)
except CalledProcessError:
    sys.exit(-1)

if TRLs>1:

    # Descomprimimos las subbandas de alta frecuencia.
    subband = TRLs - 1
    while subband > 0:

        pictures = _pictures
        j = 0
        while j < subband:
            pictures = ( pictures + 1 ) / 2
            j += 1

        try:
            check_call("mctf texture_expand_hfb_" + MCTF_TEXTURE_CODEC
                       + " --file=" + "\"" + HIGH + "_" + str(subband) + "\""
                       + " --pictures=" + str(pictures - 1)
                       + " --pixels_in_x=" + str(pixels_in_x)
                       + " --pixels_in_y=" + str(pixels_in_y)
                       + " --SRLs=" + str(SRLs),
                       shell=True)
        except CalledProcessError:
            sys.exit(-1)

        subband -= 1
