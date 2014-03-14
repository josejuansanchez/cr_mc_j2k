#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_compress_j2k.py

import sys
import getopt
import os
import display

blocks_in_x = 0
blocks_in_y = 0
fields = 0
file = ""

def usage():
    sys.stderr.write("+--------------------------+\n")
    sys.stderr.write("| MCTF motion_compress_j2k |\n")
    sys.stderr.write("+--------------------------+\n")
    sys.stderr.write("   -[-]blocks_in_[x]=number of blocks in the X direction (%d)\n" % blocks_in_x)
    sys.stderr.write("   -[-]blocks_in_[y]=number of blocks in the Y direction (%d)\n" % blocks_in_y)
    sys.stderr.write("   -[-i]iteration=temporal iteration (%d)\n" % iterationi)
    sys.stderr.write("   -[-f]ields=number of fields in input (%d)\n" % fields)
    sys.stderr.write("   -f[-i]le=name of the file with the motion fields (\"%s\")\n" % file)

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],
                                      "x:y:t:f:i:h",
                                      ["blocks_in_x=",
                                       "blocks_in_y=",
                                       "iteration=",
                                       "fields=",
                                       "file=",
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
    if o in ("-t", "--iteration"):
        iteration = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": iteration=" + str(iteration) + '\n')
        )
    if o in ("-f", "--fields"):
        fields = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": fields=" + str(fields) + '\n')
        )
    if o in ("-i", "--file"):
        file = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": file=" + file + '\n')
        )
    if o in ("-h", "--help"):
        usage()
        sys.exit()

bidirectional_motion_vectors_in_a_field = blocks_in_y * blocks_in_x
components = 4
bits_per_component = 16 #teration + 3

trace = open ("trace", 'a')

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
command = "cat " + file + " >> " + file + ".vix"
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)

# Comprimimos.
command = "kdu_v_compress Clevels=0 Creversible=yes Clayers=0 Cblk=\{64,64\}" \
    + " -i " + file + ".vix" \
    + " -o " + file + ".mjc"

ifdef({{DEBUG}},
# Comprimimos mostrando la salida estándar.
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)
,
# Comprimimos redirigiendo la salida estándar hacia "/dev/null".
trace.write(sys.argv[0] + ": " + command + " > /dev/null\n")
os.system(command + " > /dev/null")
)

