#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# synthesize.py
#
# Deshace la transformación temporal.

import os
import sys
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

SEARCH_RANGE_MAX = 128

block_overlaping = 0
block_size = 16
border_size = 0
block_size_min = 16
GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
TRLs = 5
update_factor = 0 # 1.0/4
search_factor = 2

parser = MCTF_parser(description="Performs the temporal synthesis of a picture sequence.")
parser.block_overlaping(block_overlaping)
parser.block_size(block_size)
parser.block_size_min(block_size_min)
parser.border_size(border_size)
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.search_range(search_range)
parser.subpixel_accuracy(subpixel_accuracy)
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
if args.TRLs:
    TRLs = int(args.TRLs)
if args.update_factor:
    update_factor = float(args.update_factor)


#block_overlaping >>= int(number_of_discarded_spatial_levels)
#max_block_size >>= int(number_of_discarded_spatial_levels)
#min_block_size >>= int(number_of_discarded_spatial_levels)
#pixels_in_x >>= int(number_of_discarded_spatial_levels)
#pixels_in_y >>= int(number_of_discarded_spatial_levels)
#interpolation_factor += int(number_of_discarded_spatial_levels)
#interpolation_factor -= int(number_of_discarded_spatial_levels)

gop=GOP()
GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

if block_size < block_size_min:
    block_size_min = block_size

_search_range = search_range
_pictures = pictures
block_size_max = block_size

if TRLs>1:
    
    temporal_subband = 1

    while temporal_subband < (TRLs - 1):

        search_range = search_range * search_factor
        if ( search_range > SEARCH_RANGE_MAX ):
            search_range = SEARCH_RANGE_MAX

        block_size = block_size/2
        if ( block_size < block_size_min ):
            block_size = block_size_min

        pictures = (pictures + 1) / 2

        temporal_subband += 1

    while temporal_subband > 0:
        try:
            check_call("mctf synthesize_step"
                       + " --block_overlaping=" + str(block_overlaping)
                       + " --block_size=" + str(block_size)
                       + " --pictures=" + str(pictures)
                       + " --pixels_in_x=" + str(pixels_in_x)
                       + " --pixels_in_y=" + str(pixels_in_y)
                       + " --search_range=" + str(search_range)
                       + " --subpixel_accuracy=" + str(subpixel_accuracy)
                       + " --temporal_subband=" + str(temporal_subband)
                       + " --update_factor=" + str(update_factor),
                       shell=True)
        except CalledProcessError:
            sys.exit(-1)

        temporal_subband -= 1
        pictures = _pictures
        j = 1
        block_size = block_size_max
        search_range = _search_range
        while j < temporal_subband:

            search_range = search_range * search_factor
            if ( search_range > SEARCH_RANGE_MAX ):
                search_range = SEARCH_RANGE_MAX

            block_size = block_size/2
            if ( block_size < block_size_min ):
                block_size = block_size_min

            pictures = ( pictures + 1 ) / 2
            j += 1

