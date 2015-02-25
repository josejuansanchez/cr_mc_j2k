#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

COMPONENTS = 3
BYTES_PER_COMPONENT = 1

file = ""
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
quantizations = "45000"
SRLs = 5

parser = MCTF_parser(description="Compress the LFB texture data using LTW")

parser.add_argument("--file", help="file that contains the HFB data. Default = {})".format(file))
parser.pictures(pictures)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.quantizations(quantizations)
parser.SRLs(SRLs)

args = parser.parse_known_args()[0]
if args.file:
    file = args.file
if args.pictures:
    pictures = int(args.pictures)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.quantizations:
    quantizations = args.quantizations
if args.SRLs:
    SRLs = int(args.SRLs)

Y_size = pixels_in_y * pixels_in_x
U_size = V_size = Y_size / 4
YUV_size = Y_size + U_size + V_size

try:
    check_call("trace dd" +
               " if=" + file + 
               " of=" + file + ".tmp"
               " bs=" + str(YUV_size) +
               " count=" + str(pictures),
               shell=True)
except CalledProcessError:
    sys.exit(-1)

# Encode Y
try:
    check_call("trace demux " + str(YUV_size) + " 0 " + str(Y_size)
               + " < " + file
               + ".tmp | /usr/bin/split --numeric-suffixes --suffix-length=4 --bytes="
               + str(Y_size) + " - " + file + "_Y_",
               shell=True)
except CalledProcessError:
    sys.exit(-1)

image_number = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number
    image_filename = file + "_Y_" + str_image_number

    try:
        check_call("trace mv " + image_filename + " " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace ltw -C"
                   + " -i " + image_filename + ".raw"
                   + " -o " + image_filename + ".ltw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-hfb.txt"
                   + " -h " + str(pixels_in_y)
                   + " -w " + str(pixels_in_x) 
                   + " -r 2 "
                   + " -q " + str(quantizations)
                   + " -a 0"
                   + " -l " + str(SRLs),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    image_number += 1

# Encode U
try:
    check_call("trace demux "
               + str(YUV_size) + " " + str(Y_size) + " " + str(U_size)
               + " < " + file
               + ".tmp | /usr/bin/split --numeric-suffixes --suffix-length=4 --bytes="
               + str(U_size) + " - " + file + "_U_",
               shell=True)
except CalledProcessError:
    sys.exit(-1)

image_number = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number
    image_filename = file + "_U_" + str_image_number

    try:
        check_call("trace mv " + image_filename + " " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace ltw -C"
                   + " -i " + image_filename + ".raw"
                   + " -o " + image_filename + ".ltw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-hfb.txt"
                   + " -h " + str(pixels_in_y/2)
                   + " -w " + str(pixels_in_x/2) 
                   + " -r 2 "
                   + " -q " + str(quantizations)
                   + " -a 0"
                   + " -l " + str(SRLs),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    image_number += 1

# Encode V
try:
    check_call("trace demux "
               + str(YUV_size) + " " + str(U_size+Y_size) + " " + str(V_size)
               + " < " + file
               + ".tmp | /usr/bin/split --numeric-suffixes --suffix-length=4 --bytes="
               + str(V_size) + " - " + file + "_V_",
               shell=True)
except CalledProcessError:
    sys.exit(-1)

image_number = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number
    image_filename = file + "_V_" + str_image_number

    try:
        check_call("trace mv " + image_filename + " " + image_filename + ".raw",
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    try:
        check_call("trace ltw -C"
                   + " -i " + image_filename + ".raw"
                   + " -o " + image_filename + ".ltw"
                   + " -c " + os.environ["MCTF"] + "/bin/config-hfb.txt"
                   + " -h " + str(pixels_in_y/2)
                   + " -w " + str(pixels_in_x/2) 
                   + " -r 2 "
                   + " -q " + str(quantizations)
                   + " -a 0"
                   + " -l " + str(SRLs),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

    image_number += 1

# Compute file sizes
file_sizes = open (file + ".ltw", 'w')
image_number = 0
total = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number
    Ysize = os.path.getsize(file + "_Y_" + str_image_number + ".ltw")
    Usize = os.path.getsize(file + "_U_" + str_image_number + ".ltw")
    Vsize = os.path.getsize(file + "_V_" + str_image_number + ".ltw")
    size = Ysize + Usize + Vsize
    total += size
    file_sizes.write(str(total) + "\n")

    image_number += 1
