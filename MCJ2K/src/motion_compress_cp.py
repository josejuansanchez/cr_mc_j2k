#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import getopt
import os
import display

file = ""

def usage():
    sys.stderr.write("+-------------------------+\n")
    sys.stderr.write("| MCTF motion_compress_cp |\n")
    sys.stderr.write("+-------------------------+\n")
    
opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:], "f:h", ["file=", "help"])

except getopt.GetoptError, exc:
    display.info(sys.argv[0] + ": " + exc.msg + "\n")

for o, a in opts:
    if o in ("f", "--file"):
        file = a
        display.info(sys.argv[0] + ": file=" + file + '\n')
    if o in ("h", "--help"):
        usage()
        sys.exit()

os.system("cp " + file + " " + file + ".cp")
