#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# analyze_step.py
#
# Realiza una iteración de la transformada temporal inversa.

import os
import sys
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

block_overlaping = 0
block_size = 16
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
temporal_subband = 0
update_factor = 0 # 1.0/4

parser = MCTF_parser(description="Performs a step of the temporal synthesis.")
parser.block_overlaping(block_overlaping)
parser.block_size(block_size)
parser.pictures(pictures)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.search_range(search_range)
parser.subpixel_accuracy(subpixel_accuracy)
parser.add_argument("--temporal_subband", help="iteration of the temporal transform. Default = {}".format(temporal_subband))
parser.update_factor(update_factor)

args = parser.parse_known_args()[0]
if args.block_overlaping:
    block_overlaping = int(args.block_overlaping)
if args.block_size:
    block_size = int(args.block_size)
if args.pictures:
    pictures = int(args.pictures)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.search_range:
    search_range = int(args.search_range)
if args.subpixel_accuracy:
    subpixel_accuracy = int(args.subpixel_accuracy)
if args.temporal_subband:
    temporal_subband = int(args.temporal_subband)
if args.update_factor:
    update_factor = float(args.update_factor)

try:
    check_call("mctf un_update"
               + " --block_size=" + str(block_size)
               + " --even_fn=" + "even_" + str(temporal_subband)
               + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
               + " --high_fn=" + "high_" + str(temporal_subband)
               + " --low_fn=" + "low_" + str(temporal_subband)
               + " --motion_fn=" + "motion_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --subpixel_accuracy=" + str(subpixel_accuracy)
               + " --update_factor=" + str(update_factor),
               shell=True)
except CalledProcessError:
            sys.exit(-1)

try:
    check_call("mctf correlate"
               + " --block_overlaping=" + str(block_overlaping)
               + " --block_size=" + str(block_size)
               + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
               + " --high_fn=" + "high_" + str(temporal_subband)
               + " --motion_in_fn=" + "motion_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --predicted_fn=" + "odd_" + str(temporal_subband)
               + " --reference_fn=" + "even_" + str(temporal_subband)
               + " --search_range=" + str(search_range)
               + " --subpixel_accuracy=" + str(subpixel_accuracy),
               shell=True)
except CalledProcessError:
            sys.exit(-1)

try:
    check_call("mctf merge"
               + " --even=" + "even_" + str(temporal_subband)
               + " --low=" + "low_" + str(temporal_subband-1)
               + " --odd=" + "odd_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y),
               shell=True)
except CalledProcessError:
            sys.exit(-1)

