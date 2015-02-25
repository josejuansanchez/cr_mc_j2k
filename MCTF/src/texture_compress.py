#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# texture_compress.py
#
# Comprime las texturas (subbandas temporales) generadas de la fase de
# análisis. El número de bits asignados a cada subbanda depende del
# parámetro "slopes" que controla la calidad de cada capa de calidad
# (como un factor de cuantificación) de cada imagen de cada
# subbanda. Por tanto, el número de capas de calidad es igual que el
# número de slopes. El control óptimo del bit-rate debe realizarse en
# tiempo de descompresión usando el programa "extract".

import os
import sys
import display
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

MCTF_TEXTURE_CODEC = os.environ["MCTF_TEXTURE_CODEC"]
HIGH = "high"
LOW = "low"

GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
quantizations = "45000"
TRLs = 5
SRLs = 5

parser = MCTF_parser(description="Compress the texture.")
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.quantizations(quantizations)
parser.TRLs(TRLs)
parser.SRLs(SRLs)

args = parser.parse_known_args()[0]
if args.GOPs:
    GOPs = int(args.GOPs)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.quantizations:
    quantizations = args.quantizations
if args.TRLs:
    TRLs = int(args.TRLs)
if args.SRLs:
    SRLs = int(args.SRLs)

# Convertimos la cadena de parámetros en una lista de parámetros.
#slopes_list = eval ( slopes ) # Ojo, respetar espacios por el m4!!!
#TRLs = len ( slopes_list ) - 1 # El último slope es cascarilla.

# Comprimimos las subbandas de alta frecuencia.
#subband = TRLs - 1
gop=GOP()
GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

subband = 1
while subband < TRLs:

    pictures = (pictures + 1) / 2

    try:
        check_call("mctf texture_compress_hfb_" + MCTF_TEXTURE_CODEC
                   + " --file=" + HIGH + "_" + str(subband)
                   + " --pictures=" + str(pictures - 1)
                   + " --pixels_in_x=" + str(pixels_in_x)
                   + " --pixels_in_y=" + str(pixels_in_y)
                   + " --quantizations=\"" + quantizations + "\""
                   + " --subband=" + str(subband)
                   + " --SRLs=" + str(SRLs),
                   shell=True
                   )
    except CalledProcessError:
        sys.exit(-1)

    subband += 1

try:
    # Comprimimos la subbanda de baja frecuencia.
    check_call("mctf texture_compress_lfb_" + MCTF_TEXTURE_CODEC
               + " --file=" + LOW + "_" + str(TRLs - 1)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --quantizations=\"" + quantizations + "\""
               + " --SRLs=" + str(SRLs),
               shell=True
               )
except:
    sys.exit(-1)
