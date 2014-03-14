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
    sys.stderr.write("+------------------------+\n")
    sys.stderr.write("| MCTF motion_expand_j2k |\n")
    sys.stderr.write("+------------------------+\n")
#    sys.stderr.write("   -[-i]teration = temporal iteration (%d)\n" % iterationi)
    sys.stderr.write("   -[-f]ile=name of the file with the motion fields (\"%s\")\n" % file)
    
ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],
                                      "f:h",
                                      ["file=",
                                       "help"
                                       ])

except getopt.GetoptError, exc:
    display.info(sys.argv[0] + ": " + exc.msg + "\n")

for o, a in opts:
    if o in ("-f", "--file"):
        file = a
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": file=" + file + '\n')
        )
    if o in ("-h", "--help"):
        usage()
        sys.exit()

trace = open ("trace", 'a')

command = "kdu_v_expand -i " + file + ".mjc -o " + file + ".vix"

ifdef({{DEBUG}},
# Comprimimos mostrando la salida estándar.
trace.write(sys.argv[0] + ": " + command + "\n")
os.system(command)
,
# Comprimimos redirigiendo la salida estándar hacia "/dev/null".
trace.write(sys.argv[0] + ": " + command + " > /dev/null\n")
os.system(command + " > /dev/null")
)

# Eliminamos la cabecera .vix
command = "mctf vix2raw < " + file + ".vix > " + file
trace.write(command + "\n")
os.system(command) 
