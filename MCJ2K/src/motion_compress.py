#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_compress.py

# Comprime los datos sobre el movimiento. Se elimina la redundancia
# entre bandas temporales y la redundancia bidireccional. La primera
# expresa que si en la subbanda "i+1" una componente de un vector vale
# "2x", en la subbanda "i" dicha componente del correspondiente vector
# debería valer "x". La segunda se debe a que si una componente hacia
# atrás vale "-x", la correspondiente componente hacia adelante
# debería valer "x". Finalmente se utiliza un codificador entrópico
# reversible que comprime los residuos.

import sys
import getopt
import os
import display

#MOTION_CODER_NAME = "gzip"
#MOTION_CODER_NAME = "kdu_v_compress"
MCTF_MOTION_CODEC = os.environ["MCTF_MOTION_CODEC"]

block_size = 16
block_size_min = 16
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
temporal_levels = 5

def usage():
    sys.stderr.write("+----------------------+\n")
    sys.stderr.write("| MCTF motion_compress |\n")
    sys.stderr.write("+----------------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Compress the motion data.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("   -[-b]lock_size=size of the blocks in the motion estimation process (%d)\n" % block_size)
    sys.stderr.write("   -[-]block_si[z]e_min=minimal block size allowed in the motion estimation (%d)\n" % block_size_min)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" % pixels_in_y)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" % pixels_in_x)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % "", temporal_levels)
    sys.stderr.write("\n")

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

opts = ""

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"b:z:p:x:y:t:h",
                                      ["block_size=",
                                       "block_size_min=",
                                       "pictures=",
                                       "pixels_in_y=",
                                       "pixels_in_x=",
                                       "temporal_levels=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)

for o, a in opts:
    if o in ("-b", "--block_size"):
        block_size = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": block_size=" + str(block_size) + '\n')
        )
    if o in ("-z", "--block_size_min"):
        block_size_min = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": block_size_min=" + str(block_size_min) + '\n')
        )
    if o in ("-p", "--pictures"):
        pictures = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pictures=" + str(pictures) + '\n')
        )
    if o in ("-x", "--pixels_in_x"):
        pixels_in_x = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pixels_in_x=" + str(pixels_in_x) + '\n')
        )
    if o in ("-y", "--pixels_in_y"):
        pixels_in_y = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": pixels_in_y=" + str(pixels_in_y) + '\n')
        )
    if o in ("-t", "--temporal_levels"):
        temporal_levels = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": temporal_levels=" + str(temporal_levels) + '\n')
        )
    if o in ("-h", "--help"):
	usage()
	sys.exit()

if block_size < block_size_min:
    block_size_min = block_size

# Los campos de movimiento se comprimen sin pérdida, generando un
# fichero independiente para cada nivel de resolución temporal en un
# stream diferente y para cada GOP. La compresión se realiza pensando
# en cómo el descompresor va a realizar la descompresión. El
# descompresor se va a encontrar en el primer nivel que un campo de
# movimiento bidireccional ha sido, únicamente, descorrelacionado
# bidireccionalmente (la descorrelación bidireccional explota la
# redundancia que existe en un vector bidireccional, donde el vector
# en un sentido suele ser igual que el otro, aunque con signo
# contrario). Una vez que el campo del primer nivel ha sido
# restaurado, puede servir de referencia para dos campos del siguiente
# nivel de resolución (descorrelación interlevel). En concreto,
# dividimos entre dos los vectores de movimiento y ya tenemos la
# predicción. En este segundo nivel de resolución (y los siguientes)
# no es necesario descorrelacionarlo(s) bidireccionalmente ya que la
# descorrelación interlevel, al partir de campos bidireccionales
# correlacionados, va a provocar la descorrelación bidireccional de
# forma automática.

# Comenzamos aplicando la descorrelacion interlevel.
iterations = temporal_levels - 1
iteration = 1
fields = pictures / 2
blocks_in_y = pixels_in_y / block_size
blocks_in_x = pixels_in_x / block_size

while iteration < iterations:

    # Descorrelacionamos los campos de movimiento entre niveles de
    # resolución.
    os.system("mctf interlevel_motion_decorrelate"
              + " --blocks_in_x=" + str(blocks_in_x)
              + " --blocks_in_y=" + str(blocks_in_y)
              + " --fields_in_predicted=" + str(fields)
              + " --predicted=" + "motion_filtered_" + str(iteration)
              + " --reference=" + "motion_filtered_" + str(iteration+1)
              + " --residue=" + "motion_residue_" + str(iteration)
              )

    # Calculamos el tamaño de bloque usado en esta iteración temporal.
    block_size = block_size / 2
    if (block_size < block_size_min):
        block_size = block_size_min

    fields /= 2
    iteration += 1
    blocks_in_y = pixels_in_y / block_size
    blocks_in_x = pixels_in_x / block_size

# Ahora descorrelacionamos bidireccionalmente el nivel de resolución
# temporal más bajo. El último número de bloques en X y en Y calculado
# en el lazo anterior debería servir en este instante. Lo mismo ocurre
# con la variable "iteration".
os.system("mctf bidirectional_motion_decorrelate"
          + " --blocks_in_x=" + str(blocks_in_x)
          + " --blocks_in_y=" + str(blocks_in_y)
          + " --fields=" + str(fields)
          + " --input=" + "motion_filtered_" + str(iteration)
          + " --output=" + "motion_residue_" + str(iteration)
          )

# Eliminamos del flujo de campos de movimiento aquellos campos que ya
# no se utilizan porque hacen referencia a imágenes I.

# Finalmente, comprimimos. 
iteration = 1
fields = pictures / 2
while iteration <= iterations:

    os.system("mctf motion_compress_" + MCTF_MOTION_CODEC
              + " --blocks_in_x=" + str(blocks_in_x)
              + " --blocks_in_y=" + str(blocks_in_y)
              + " --iteration=" + str(iteration)
              + " --fields=" + str(fields)
              + " --file=" + "motion_residue_" + str(iteration)
              )

    fields /= 2

#    os.system("svc motion_compress_" + "gzip"
#              + " --blocks_in_x=" + str(blocks_in_x)
#              + " --blocks_in_y=" + str(blocks_in_y)
#              + " --iteration=" + str(iteration)
#              + " --file=" + "_motion_residue_" + str(iteration)
#              + " --pictures=" + str(pictures)
#              + " --temporal_levels=" + str(temporal_levels)
#              )

    iteration += 1
