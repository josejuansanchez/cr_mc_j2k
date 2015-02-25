#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_compress_j2k.py

import os
import sys
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

blocks_in_x = 0
blocks_in_y = 0
fields = 0
file = ""

parser = MCTF_parser(description="Compress the motion data using JPEG 2000.")
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

bidirectional_motion_vectors_in_a_field = blocks_in_y * blocks_in_x
components = 4
bits_per_component = 16 #teration + 3

# Generamos la cabecera VIX
fd = open( file + ".vix", 'w' )
fd.write("vix\n")
fd.write(">VIDEO<\n")
fd.write("1.0 0\n")
fd.write(">COLOUR<\n")
fd.write("RGB\n")
fd.write(">IMAGE<\n")
#fd.write("unsigned char 4 little-endian\n")
fd.write("signed word " + str(bits_per_component) + " little-endian\n") 
#fd.write("unsigned char 8 little-endian\n")
# Sí, ya se que es imposible, pero si ponemos signed, el Kakadu no funciona
fd.write("%d " % blocks_in_x)
fd.write("%d " % blocks_in_y)
fd.write("4\n" )
fd.write("1 1\n")
fd.write("1 1\n")
fd.write("1 1\n")
fd.write("1 1\n")
fd.close()

# Concatenamos los campos de movimiento a la cabecera VIX.
try:
    check_call("trace cat " + file + " >> " + file + ".vix", shell=True)
except CalledProcessError:
    sys.exit(-1)

# Comprimimos.
try:
    check_call("trace kdu_v_compress Clevels=0 Creversible=yes Clayers=0 Cblk=\{64,64\}"
               + " -i " + file + ".vix"
               + " -o " + file + ".mjc",
               shell=True)
except CalledProcessError:
    sys.exit(-1)
