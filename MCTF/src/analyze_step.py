#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# analyze_step.py
#
# Realiza una iteración de la transformada temporal.

import sys
import os
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

always_B=0
block_overlaping = 0
block_size = 16
border_size = 0
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
search_range = 4
subpixel_accuracy = 0
temporal_subband = 1
update_factor = 0 # 1.0/4

parser = MCTF_parser(description="Performs a temporal analysis step.")
parser.always_B(always_B)
parser.block_overlaping(block_overlaping)
parser.block_size(block_size)
parser.border_size(border_size)
parser.pictures(pictures)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.search_range(search_range)
parser.subpixel_accuracy(subpixel_accuracy)
parser.add_argument("--temporal_subband", help="iteration of the temporal transform.".format(temporal_subband))
parser.update_factor(update_factor)

args = parser.parse_known_args()[0]
if args.always_B:
    always_B = int(args.always_B)
if args.block_overlaping:
    block_overlaping = int(args.block_overlaping)
if args.block_size:
    block_size = int(args.block_size)
if args.border_size:
    border_size = int(args.border_size)
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
    # Transformada Lazzy.
    check_call("mctf split"
               + " --even_fn=" + "even_" + str(temporal_subband)
               + " --low_fn=" + "low_" + str(temporal_subband-1)
               + " --odd_fn=" + "odd_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y),
               shell=True
               )
except CalledProcessError:
    sys.exit(-1)

try:
    # Estimamos el movimiento.
    check_call("mctf motion_estimate"
               + " --block_size=" + str(block_size)
               + " --border_size=" + str(border_size)
               + " --imotion_fn=" + "imotion_" + str(temporal_subband)
               + " --motion_fn=" + "motion_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --predicted_fn=" + "odd_" + str(temporal_subband)
               + " --reference_fn=" + "even_" + str(temporal_subband)
               + " --search_range=" + str(search_range)
               + " --subpixel_accuracy=" + str(subpixel_accuracy),
               shell=True
               )
except CalledProcessError:
    sys.exit(-1)

try:
    # Compensamos el movimiento.
    check_call("mctf decorrelate"
               + " --block_overlaping=" + str(block_overlaping)
               + " --block_size=" + str(block_size)
               + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
               + " --high_fn=" + "high_" + str(temporal_subband)
               + " --motion_in_fn=" + "motion_" + str(temporal_subband)
               + " --motion_out_fn=" + "motion_filtered_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --reference_fn=" + "even_" + str(temporal_subband)
               + " --predicted_fn=" + "odd_" + str(temporal_subband)
               + " --search_range=" + str(search_range)
               + " --subpixel_accuracy=" + str(subpixel_accuracy)
               + " --always_B=" + str(always_B),
               shell=True
               )
except CalledProcessError:
    sys.exit(-1)

try:
    # Eliminamos al aliasing temporal (suavizamos).
    check_call("mctf update"
               + " --block_size=" + str(block_size)
               + " --even_fn=" + "even_" + str(temporal_subband)
               + " --frame_types_fn=" + "frame_types_" + str(temporal_subband)
               + " --high_fn=" + "high_" + str(temporal_subband)
               + " --low_fn=" + "low_" + str(temporal_subband)
               + " --motion_fn=" + "motion_filtered_" + str(temporal_subband)
               + " --pictures=" + str(pictures)
               + " --pixels_in_x=" + str(pixels_in_x)
               + " --pixels_in_y=" + str(pixels_in_y)
               + " --subpixel_accuracy=" + str(subpixel_accuracy)
               + " --update_factor=" + str(update_factor),
               shell=True
               )
except CalledProcessError:
    sys.exit(-1)
