#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

file = ""
pictures = 33

parser = MCTF_parser(description="Expands the the LFB texture data using LTW.")
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
        check_call("trace ltw -D "
                   + " -i " + image_filename + ".ltw"
                   + " -o " + image_filename + ".raw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-lfb.txt"
                   + " -a 0"
                   + " -s 0",
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
        check_call("trace ltw -D "
                   + " -i " + image_filename + ".ltw"
                   + " -o " + image_filename + ".raw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-lfb.txt"
                   + " -a 0"
                   + " -s 0",
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
        check_call("trace ltw -D "
                   + " -i " + image_filename + ".ltw"
                   + " -o " + image_filename + ".raw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-lfb.txt"
                   + " -a 0"
                   + " -s 0",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace cat " + image_filename + ".raw >> " + file, shell=True)
    except CalledProcessError:
        sys.exit(-1)

    image_number += 1
