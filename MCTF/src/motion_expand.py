#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_expand.py

# Descomprime los datos con el movimiento.
import os
import sys
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

#MOTION_DECODER_NAME = "gzip"
#MOTION_DECODER_NAME = "kdu_v_expand"
MCTF_MOTION_CODEC = os.environ["MCTF_MOTION_CODEC"]

block_size = 16
block_size_min = 16
GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
TRLs = 5

parser = MCTF_parser(description="Expands the motion data.")
parser.block_size(block_size)
parser.block_size_min(block_size_min)
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.TRLs(TRLs)

args = parser.parse_known_args()[0]
if args.block_size:
    block_size = int(args.block_size)
if args.block_size_min:
    block_size_min = int(args.block_size_min)
if args.GOPs:
    GOPs = int(args.GOPs)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.TRLs:
    TRLs = int(args.TRLs)

gop=GOP()
GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

if block_size < block_size_min:
    block_size_min = block_size

# Cálculo del tamaño de bloque usado en el nivel de resolución
# temporal más bajo.
iterations = TRLs - 1
max_block_size = block_size
iters = TRLs - 1
fields = pictures / 2
iteration = 0
while iteration < iterations:

    block_size = block_size / 2
    if (block_size < block_size_min):
        block_size = block_size_min

    fields /= 2
    iteration += 1

blocks_in_y = pixels_in_y / block_size
blocks_in_x = pixels_in_x / block_size

# Descomprimimos los campos de movimiento.
iteration = 1
fields = pictures / 2
while iteration <= iterations:

    try:
        check_call("mctf motion_expand_" + MCTF_MOTION_CODEC
                   + " --file=" + "\"" + "motion_residue_" + str(iteration) + "\""
                   + " --blocks_in_y=" + str(blocks_in_y)
                   + " --blocks_in_x=" + str(blocks_in_x)
                   + " --fields=" + str(fields)
                   + " --pictures=" + str(pictures),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    fields /= 2

#    os.system("svc motion_expand_" + "gzip"
#              + " --blocks_in_x=" + str(blocks_in_x)
#              + " --blocks_in_y=" + str(blocks_in_y)
#              + " --iteration=" + str(iteration)
#              + " --file=" + "\"" + prefix + "_motion_residue_" + str(iteration) + "\""
#              + " --pictures=" + str(pictures)
#              + " --temporal_levels=" + str(temporal_levels)
#              )

    iteration += 1

#fields = pictures / 2

try:
    # Deshacemos la descorrelación bidireccional en el nivel de resolución
    # temporal más bajo.
    check_call("mctf bidirectional_motion_correlate"
               + " --blocks_in_y=" + str(blocks_in_y)
               + " --blocks_in_x=" + str(blocks_in_x)
               + " --fields=" + str(GOPs)
               + " --input=" + "\"" + "motion_residue_" + str(TRLs - 1) + "\""
               + " --output=" + "\"" + "motion_" + str(TRLs - 1) + "\"",
               shell=True)
except CalledProcessError:
    sys.exit(-1)

# Deshacemos la descorrelación interlevel.
iterations = TRLs - 1
iteration = iterations
while iteration > 1:
    
    iteration -= 1   
    fields = pictures / (2**iteration)

    blocks_in_y = pixels_in_y / block_size
    blocks_in_x = pixels_in_x / block_size

    try:
        # Descorrelacionamos los campos de movimiento entre niveles de
        # resolución.
        check_call("mctf interlevel_motion_correlate"
                   + " --blocks_in_x=" + str(blocks_in_x)
                   + " --blocks_in_y=" + str(blocks_in_y)
                   + " --fields_in_predicted=" + str(fields)
                   + " --predicted=" + "\"" + "motion_" + str(iteration) + "\""
                   + " --reference=" + "\"" + "motion_" + str(iteration+1) + "\""
                   + " --residue=" + "\"" + "motion_residue_" + str(iteration) + "\"",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    # Calculamos el tamaño de bloque usado en esta iteración temporal.
    block_size = block_size/2
    if (block_size<block_size_min):
        block_size = block_size_min

