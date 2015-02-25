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

# Decode YUV
image_number = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number

    # Y
    image_filename = file + "_Y_" + str_image_number

    try:
        check_call("trace kdu_expand"
                   + " -i " + image_filename + ".j2c"
                   + " -o " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace cat " + image_filename + ".raw >> " + file, shell=True)
    except CalledProcessError:
        sys.exit(-1)

    # U
    image_filename = file + "_U_" + str_image_number

    try:
        check_call("trace kdu_expand"
                   + " -i " + image_filename + ".j2c"
                   + " -o " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace cat " + image_filename + ".raw >> " + file, shell=True)
    except CalledProcessError:
        sys.exit(-1)

    # V
    image_filename = file + "_V_" + str_image_number

    try:
        check_call("trace kdu_expand"
                   + " -i " + image_filename + ".j2c"
                   + " -o " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)
        
    try:
        check_call("trace cat " + image_filename + ".raw >> " + file, shell=True)
    except CalledProcessError:
        sys.exit(-1)

    image_number += 1
