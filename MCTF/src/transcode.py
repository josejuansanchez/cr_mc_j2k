#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
#
# extract.py
#
# Extracts a codestream from a bigger codestream, discarding a number
# of temporal, resolution or/and quality levels. The number of temporal
# resolution levels that is going to be discardes must be >= 0 (0 = no
# discarding). Something similar happens with the number of discardes
# spatial resolutions. The last parameter is controlled by means of a
# slope, a value between 0 a 65535 where 0 means no discarding and
# 65535 implies a null output video, but notice that if the input
# video was quantized using a slope X and we select a new slope where
# Y <= X, then, this extraction will not have any effect (the output
# will be identical to the input). These parameters can not be used
# simultaneously, but obviously, they can be concatenated. The output
# sequence will overwrite the input sequence.
#
# Examples:
#
# mcj2k transcode --discard_TRLs=1 # Divides the frame-rate by two.
# mcj2k transcode --discard_SRLs=2 # Divides the spatial resolution of the video by 2^2 in each dimmension
# mcj2k transcode --new_slope=45000 # Selects the new slope (quality) 45000
# mcj2k transcode --GOPs=1 # Outputs only the first GOP (only one image)
#

import sys
import getopt
import os
import array
import display
import string
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser
HIGH = "high"
LOW = "low"

GOPs = 1
discarded_TRLs = 0
discarded_SRLs = 0
quantization = "45000"
TRLs = 6
GOPs = 1

parser = MCTF_parser(description="Transcodes a code-stream.")
parser.GOPs(GOPs)
parser.add_argument("--discarded_SRLs", help="number of discarded spatial resolution levels. Default = {}".format(discarded_parser.add_argument("--discarded_TRLs", help="number of discarded temporal resolution levels. Default = {}".format(discarded_TRLs))
SRLs))
parser.quantization(quantization)
parser.TRLs(TRLs)
parser.SRLs(SRLs)

args = parser.parse_known_args()[0]
if args.discarded_SRLs:
    discarded_SRLs = int(args.discarded_SRLs)
if args.discarded_TRLs:
    discarded_TRLs = int(args.discarded_TRLs)
if args.quantization:
    quantization = args.quantization
if args.SRLs:
    SRLs = int(args.SRLs)
if args.TRLs:
    TRLs = int(args.TRLs)

GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

# Ahora mismo solo implementa la extracción por niveles de resolución

# Procesamos las subbandas de alta frecuencia.
subband = 1
while subband < TRLs:

    ifdef({{DEBUG}},
    display.info(sys.argv[0] + ": processing high-pass subband " + str(subband) + " of " + str(TRLs) + "\n")
    )

    # Open the file with the size of each color image
    file_sizes = open ("tmp/" + HIGH + "_" + str(subband) + ".j2c", 'w')
    total = 0

    pictures = (pictures + 1) / 2

    image_number = 0
    while image_number < (pictures - 1):

        str_image_number = '%04d' % image_number

        # Y
        image_filename = HIGH + "_" + str(subband) + "_Y_" + str_image_number

        command = "kdu_transcode" \
            + " -i " + image_filename + ".j2c" \
            + " -o tmp/" + image_filename + ".j2c" \
            + " -reduce " + str(resolutions)
        trace.write(sys.argv[0] + ": " + command + "\n")
        ifdef({{DEBUG}},
        os.system(command)
        ,
        os.system(command + " > /dev/null")
        )

        # Recompute file-size
        Ysize = os.path.getsize("tmp/" + image_filename + ".j2c")

        # U
        image_filename = HIGH + "_" + str(subband) + "_U_" + str_image_number

        command = "kdu_transcode" \
            + " -i " + image_filename + ".j2c" \
            + " -o tmp/" + image_filename + ".j2c" \
            + " -reduce " + str(resolutions)
        trace.write(sys.argv[0] + ": " + command + "\n")
        ifdef({{DEBUG}},
        os.system(command)
        ,
        os.system(command + " > /dev/null")
        )

        # Recompute file-size
        Usize = os.path.getsize("tmp/" + image_filename + ".j2c")

        # V
        image_filename = HIGH + "_" + str(subband) + "_V_" + str_image_number

        command = "kdu_transcode" \
            + " -i " + image_filename + ".j2c" \
            + " -o tmp/" + image_filename + ".j2c" \
            + " -reduce " + str(resolutions)
        trace.write(sys.argv[0] + ": " + command + "\n")
        ifdef({{DEBUG}},
        os.system(command)
        ,
        os.system(command + " > /dev/null")
        )

        # Recompute file-size
        Vsize = os.path.getsize("tmp/" + image_filename + ".j2c")

        # Total file-sizes
        size = Ysize + Usize + Vsize
        total += size
        file_sizes.write(str(total) + "\n")


        image_number += 1

    file_sizes.close()

    subband += 1

subband -= 1


# Procesamos la subbanda de baja frecuencia.
ifdef({{DEBUG}},
display.info(sys.argv[0] + ": processing low-pass subband " + str(subband) + " of " + str(TRLs) + "\n")
)

# Open the file with the size of each color image
file_sizes = open ("tmp/" + LOW + "_" + str(subband) + ".j2c", 'w')
total = 0

image_number = 0
while image_number < pictures:

    str_image_number = '%04d' % image_number

    # Y
    image_filename = LOW + "_" + str(subband) + "_Y_" + str_image_number

    command = "kdu_transcode" \
        + " -i " + image_filename + ".j2c" \
        + " -o tmp/" + image_filename + ".j2c" \
        + " -reduce " + str(resolutions)
    trace.write(sys.argv[0] + ": " + command + "\n")
    ifdef({{DEBUG}},
    os.system(command)
    ,
    os.system(command + " > /dev/null")
    )

    # Recompute file-size
    Ysize = os.path.getsize("tmp/" + image_filename + ".j2c")

    # U
    image_filename = LOW + "_" + str(subband) + "_U_" + str_image_number

    command = "kdu_transcode" \
        + " -i " + image_filename + ".j2c" \
        + " -o tmp/" + image_filename + ".j2c" \
        + " -reduce " + str(resolutions)
    trace.write(sys.argv[0] + ": " + command + "\n")
    ifdef({{DEBUG}},
    os.system(command)
    ,
    os.system(command + " > /dev/null")
    )

    # Recompute file-size
    Usize = os.path.getsize("tmp/" + image_filename + ".j2c")

    # V
    image_filename = LOW + "_" + str(subband) + "_V_" + str_image_number

    command = "kdu_transcode" \
        + " -i " + image_filename + ".j2c" \
        + " -o tmp/" + image_filename + ".j2c" \
        + " -reduce " + str(resolutions)
    trace.write(sys.argv[0] + ": " + command + "\n")
    ifdef({{DEBUG}},
    os.system(command)
    ,
    os.system(command + " > /dev/null")
    )

    # Recompute file-size
    Vsize = os.path.getsize("tmp/" + image_filename + ".j2c")

    # Total file-sizes
    size = Ysize + Usize + Vsize
    total += size
    file_sizes.write(str(total) + "\n")

    image_number += 1

file_sizes.close()
