#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# Antes de comprimir separamos en ficheros independientes los campos
# de movimiento que pertenecen a GOPs distintos. Los ficheros se
# llaman "*_motion_residue_i_j.*" donde i=iteración temporal y
# j=GOP. El formato exacto de cómo se organiza la información en uno
# de estos ficheros depende de la implementación de motion.cpp. Sin
# embargo, figurarán tantos campos bidireccionales de movimiento como
# imágenes hay en ese nivel de resolución temporal, para ese GOP, pero
# dividiendo entre 2.

import sys
import getopt
import os
import display
from GOP import GOP

blocks_in_x = 0
blocks_in_y = 0
iteration = 1
file = ""
pictures = 33
temporal_levels = 5

def usage():
    sys.stderr.write("+---------------------------+\n")
    sys.stderr.write("| MCTF motion_compress_gzip |\n")
    sys.stderr.write("+---------------------------+\n")
    sys.stderr.write("   -[-]blocks_in_[x]=number of blocks in the X direction (%d)\n" % blocks_in_x)
    sys.stderr.write("   -[-]blocks_in_[y]=number of blocks in the Y direction (%d)\n" % blocks_in_y)
    sys.stderr.write("   -[-i]iteration=temporal iteration (%d)\n" % iterationi)
    sys.stderr.write("   -[-f]ile=name of the file with the motion fields (\"%s\")\n" % file)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-t]emporal_levels=number of temporal levels (%d)\n" % temporal_levels)

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],
                                      "x:y:i:f:p:t:h",
                                      ["blocks_in_x=",
                                       "blocks_in_y=",
                                       "iteration=",
                                       "file=",
                                       "pictures=",
                                       "temporal_levels=",
                                       "help"
                                       ])

except getopt.GetoptError, exc:
    display.info(sys.argv[0] + ": " + exc.msg + "\n")

for o, a in opts:
    if o in ("-x", "--blocks_in_x"):
        blocks_in_x = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": blocks_in_x=" + str(blocks_in_x) + '\n')
        )
    if o in ("-y", "--blocks_in_y"):
        blocks_in_y = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": blocks_in_y=" + str(blocks_in_y) + '\n')
        )
    if o in ("-i", "--iteration"):
        iteration = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": iteration=" + str(iteration) + '\n')
        )
    if o in ("-f", "--file"):
        file = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": file=" + file + '\n')
        )
    if o in ("-p", "--pictures"):
        pictures = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pictures=" + str(pictures) + '\n')
        )
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
        usage()
        sys.exit()

bidirectional_motion_vectors_in_a_field = blocks_in_y * blocks_in_x
components = 4
bytes_per_component = 1
field_size_in_bytes = bidirectional_motion_vectors_in_a_field * components * bytes_per_component

gop = GOP();
GOP_size = gop.get_size(temporal_levels)
ifdef({{DEBUG}},
sys.stdout.write(sys.argv[0] + ": GOP_size=" + str(GOP_size) + '\n')
)
number_of_GOPs = pictures / GOP_size
ifdef({{DEBUG}},
sys.stdout.write(sys.argv[0] + ": number_of_GOPs=" + str(number_of_GOPs) + '\n')
)

fields_per_GOP = GOP_size / (2 ** iteration)
ifdef({{DEBUG}},
sys.stdout.write(sys.argv[0] + ": fields_per_GOP=" + str(fields_per_GOP) + '\n')
)

print field_size_in_bytes * fields_per_GOP

# Probar flag -n
command = "gzip -9nf " + file

ifdef({{DEBUG}},
sys.stdout.write(sys.argv[0] + ": " + command + "\n")
)

os.system(command)

