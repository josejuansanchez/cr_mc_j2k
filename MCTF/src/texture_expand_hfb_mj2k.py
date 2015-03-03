#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

file = ""
pictures = 33

parser = MCTF_parser(description="Expands the the LFB texture data using JPEG 2000.")
parser.add_argument("--file", help="file that contains the LFB data. Default = {})".format(file))
parser.pictures(pictures)

args = parser.parse_known_args()[0]
if args.file:
    file = args.file
if args.pictures:
    pictures = int(args.pictures)

# Jse. Sino existe se crea a color neutro.
try:
    f = open(file + ".mjc", "rb")
    f.close()
    print "EXISTE:", file + ".mjc"
except:
    print "NO EXISTE, se crea:", file
    byte = 128
    f = open(file, "wb")
    for a in xrange (int(math.floor(pictures * pixels_in_x * pixels_in_y * 1.5))):
        f.write('%c' % byte)
    f.close()
    exit(1)

try:
    check_call("trace kdu_v_expand" +
               " -i " + file + ".mjc" +
               " -o " + file + ".vix",
               shell=True)
except CalledProcessError:
        sys.exit(-1)

try:
    check_call("trace vix2raw < " + file + ".vix > " + file, shell=True)
except CalledProcessError:
        sys.exit(-1)