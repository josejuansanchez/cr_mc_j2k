#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_expand_j2k.py

import os
import sys
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

blocks_in_x = 0
blocks_in_y = 0
fields = 0
file = "nombre_inicial"

parser = MCTF_parser(description="Expands the motion data using JPEG 2000.")
parser.add_argument("--blocks_in_x",
                    help="number of blocks in the X direction. (Default = {})".format(blocks_in_x))
parser.add_argument("--blocks_in_y",
                    help="number of blocks in the Y direction. (Default = {})".format(blocks_in_y))
parser.add_argument("--fields",
                    help="number of fields in to compress. (Default = {})".format(fields))
parser.add_argument("--file",
                    help="name of the file with the motion fields. (Default = {})".format(file))

args = parser.parse_known_args()[0]
if args.blocks_in_x:
    blocks_in_x = int(args.blocks_in_x)
if args.blocks_in_y:
    blocks_in_y = int(args.blocks_in_y)
if args.fields:
    fields = int(args.fields)
if args.file:
    file = args.file

# Jse. Sino existe se crea a movimiento lineal 
# (no se comprueba si existe el H_maximo donde apoyar dicho movimiento):

try:
    f = open(file + ".mjc", "rb")
    f.close()
except:
    byte = 0
    f = open(file, "wb")
    for a in xrange(fields):
        for b in xrange(blocks_in_y):
            for c in xrange(blocks_in_x):
                for d in xrange(8): # 2 bits x componente (-1,0,1)
                    f.write('%c' % byte)
    f.close()
    exit(1)

try:
    check_call("trace kdu_v_expand -i " + file + ".mjc -o " + file + ".vix", shell=True)
except CalledProcessError:
    sys.exit(-1)

try:
    # Eliminamos la cabecera .vix
    check_call("mctf vix2raw < " + file + ".vix > " + file, shell=True)

except CalledProcessError:
    sys.exit(-1)
