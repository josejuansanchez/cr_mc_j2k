#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
#
# expand.py
#
# Examples:
#
# # Expands using the default parameters:
# mcj2k expand
#
# # Show default parameters
# mcj2k expand --help
#

import sys
import display
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

block_overlaping = 0
block_size = 16
block_size_min = 16
border_size = 0
GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
SRLs = 5
TRLs = 5
update_factor = 0 # 1.0/4

parser = MCTF_parser(description="Decodes a sequence of pictures.")
parser.block_overlaping(block_overlaping)
parser.block_size(block_size)
parser.block_size_min(block_size_min)
parser.border_size(border_size)
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.search_range(search_range)
parser.subpixel_accuracy(subpixel_accuracy)
parser.SRLs(TRLs)
parser.TRLs(TRLs)
parser.update_factor(update_factor)

args = parser.parse_known_args()[0]
if args.block_overlaping:
    block_overlaping = int(args.block_overlaping)
if args.block_size:
    block_size = int(args.block_size)
if args.block_size_min:
    block_size_min = int(args.block_size_min)
if args.border_size:
    border_size = int(args.border_size)
if args.GOPs:
    GOPs = int(args.GOPs)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.search_range:
    search_range = int(args.search_range)
if args.subpixel_accuracy:
    subpixel_accuracy = int(args.subpixel_accuracy)
if args.SRLs:
    SRLs = int(args.SRLs)
if args.TRLs:
    TRLs = int(args.TRLs)
if args.update_factor:
    update_factor = float(args.update_factor)

try:
    # Descomprimimos las texturas.
    check_call("mctf texture_expand"
               + " --GOPs=" + str(GOPs)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --SRLs=" + str(SRLs)
               + " --TRLs=" + str(TRLs),
               shell=True)

except CalledProcessError:
    sys.exit(-1)

if TRLs > 1:

    try:
        # Descomprimimos los datos del movimiento.
        check_call("mctf motion_expand"
                   + " --block_size=" + str(block_size)
                   + " --block_size_min=" + str(block_size_min)
                   + " --GOPs=" + str(GOPs)
                   + " --pixels_in_x=" + str(pixels_in_x)
                   + " --pixels_in_y=" + str(pixels_in_y)
                   + " --TRLs=" + str(TRLs),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        # Sintetizamos el vídeo.
        check_call("mctf synthesize"
                   + " --block_overlaping=" + str(block_overlaping)
                   + " --block_size=" + str(block_size)
                   + " --block_size_min=" + str(block_size_min)
                   + " --GOPs=" + str(GOPs)
                   + " --pixels_in_x=" + str(pixels_in_x)
                   + " --pixels_in_y=" + str(pixels_in_y)
                   + " --search_range=" + str(search_range)
                   + " --subpixel_accuracy=" + str(subpixel_accuracy)
                   + " --TRLs=" + str(TRLs)
                   + " --update_factor=" + str(update_factor),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)
