#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# motion_compress.py

# Comprime los datos sobre el movimiento. Se elimina la redundancia
# entre bandas temporales y la redundancia bidireccional. La primera
# expresa que si en la subbanda "i+1" una componente de un vector vale
# "2x", en la subbanda "i" dicha componente del correspondiente vector
# deber�a valer "x". La segunda se debe a que si una componente hacia
# atr�s vale "-x", la correspondiente componente hacia adelante
# deber�a valer "x". Finalmente se utiliza un codificador entr�pico
# reversible que comprime los residuos.

import os
import sys
from GOP import GOP
from subprocess import check_call
from subprocess import CalledProcessError
from MCTF_parser import MCTF_parser

#MOTION_CODER_NAME = "gzip"
#MOTION_CODER_NAME = "kdu_v_compress"
MCTF_MOTION_CODEC = os.environ["MCTF_MOTION_CODEC"]

block_size = 16
block_size_min = 16
GOPs = 1
pixels_in_x = 352
pixels_in_y = 288
TRLs = 5

parser = MCTF_parser(description="Compress the motion data.")
parser.block_size(block_size)
parser.block_size_min(block_size_min)
parser.GOPs(GOPs)
parser.pixels_in_x(pixels_in_x)
parser.pixels_in_y(pixels_in_y)
parser.TRLs(TRLs)

args = parser.parse_known_args()[0]
if args.block_size:
    block_size = int(args.block_size)
if args.block_size_min:
    block_size_min = int(args.block_size_min)
if args.GOPs:
    GOPs = int(args.GOPs)
if args.pixels_in_x:
    pixels_in_x = int(args.pixels_in_x)
if args.pixels_in_y:
    pixels_in_y = int(args.pixels_in_y)
if args.TRLs:
    TRLs = int(args.TRLs)

if block_size < block_size_min:
    block_size_min = block_size

# Los campos de movimiento se comprimen sin p�rdida, generando un
# fichero independiente para cada nivel de resoluci�n temporal en un
# stream diferente y para cada GOP. La compresi�n se realiza pensando
# en c�mo el descompresor va a realizar la descompresi�n. El
# descompresor se va a encontrar en el primer nivel que un campo de
# movimiento bidireccional ha sido, �nicamente, descorrelacionado
# bidireccionalmente (la descorrelaci�n bidireccional explota la
# redundancia que existe en un vector bidireccional, donde el vector
# en un sentido suele ser igual que el otro, aunque con signo
# contrario). Una vez que el campo del primer nivel ha sido
# restaurado, puede servir de referencia para dos campos del siguiente
# nivel de resoluci�n (descorrelaci�n interlevel). En concreto,
# dividimos entre dos los vectores de movimiento y ya tenemos la
# predicci�n. En este segundo nivel de resoluci�n (y los siguientes)
# no es necesario descorrelacionarlo(s) bidireccionalmente ya que la
# descorrelaci�n interlevel, al partir de campos bidireccionales
# correlacionados, va a provocar la descorrelaci�n bidireccional de
# forma autom�tica.

gop=GOP()
GOP_size = gop.get_size(TRLs)
pictures = GOPs * GOP_size + 1

# Comenzamos aplicando la descorrelacion interlevel.
iterations = TRLs - 1
iteration = 1
fields = pictures / 2
blocks_in_y = pixels_in_y / block_size
blocks_in_x = pixels_in_x / block_size


while iteration < iterations:

    # Descorrelacionamos los campos de movimiento entre niveles de
    # resoluci�n.        
    try:
        check_call("mctf interlevel_motion_decorrelate"
                   + " --blocks_in_x=" + str(blocks_in_x)
                   + " --blocks_in_y=" + str(blocks_in_y)
                   + " --fields_in_predicted=" + str(fields)
                   + " --predicted=" + "motion_filtered_" + str(iteration)
                   + " --reference=" + "motion_filtered_" + str(iteration+1)
                   + " --residue=" + "motion_residue_" + str(iteration),
                   shell=True)
    except CalledProcessError:
        sys.exit(-1)

# Calculamos el tama�o de bloque usado en esta iteraci�n temporal.
    block_size = block_size / 2
    if (block_size < block_size_min):
        block_size = block_size_min

        fields /= 2
        iteration += 1
        blocks_in_y = pixels_in_y / block_size
        blocks_in_x = pixels_in_x / block_size

# Ahora descorrelacionamos bidireccionalmente el nivel de resoluci�n
# temporal m�s bajo. El �ltimo n�mero de bloques en X y en Y calculado
# en el lazo anterior deber�a servir en este instante. Lo mismo ocurre
# con la variable "iteration".
try:
    check_call("mctf bidirectional_motion_decorrelate"
               + " --blocks_in_x=" + str(blocks_in_x)
               + " --blocks_in_y=" + str(blocks_in_y)
               + " --fields=" + str(fields)
               + " --input=" + "motion_filtered_" + str(iteration)
               + " --output=" + "motion_residue_" + str(iteration),
               shell=True
               )
except CalledProcessError:
    sys.exit(-1)

# Eliminamos del flujo de campos de movimiento aquellos campos que ya
# no se utilizan porque hacen referencia a im�genes I.

# Finalmente, comprimimos. 
iteration = 1
fields = pictures / 2
while iteration <= iterations:

    try:
        check_call("mctf motion_compress_" + MCTF_MOTION_CODEC
                   + " --blocks_in_x=" + str(blocks_in_x)
                   + " --blocks_in_y=" + str(blocks_in_y)
                   + " --iteration=" + str(iteration)
                   + " --fields=" + str(fields)
                   + " --file=" + "motion_residue_" + str(iteration),
                   shell=True
                   )
    except CalledProcessError:
        sys.exit(-1)

    fields /= 2

    iteration += 1

