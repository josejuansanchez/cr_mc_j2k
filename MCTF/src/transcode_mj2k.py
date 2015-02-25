#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
#
# extract.py
#
# Extrae un n�mero de capas de calidad de un v�deo codificado con m�s
# de una capa de calidad. El resultado es el mismo que haber
# especificado menos capas de calidad (a trav�s de sus
# correspondientes "slopes") en el comando "compress".
#
# Secuencia t�pica de comandos:
#
# > mctf compress --slopes="44000,43500,43000"
# > mctf extract --layers=2
# > mctf expand

# Nota: SOC = 0xFF4F
#       EOC = 0xFFD9

# La opci�n de extraer las im�genes, transcodificarlas
# independientemente y volverlas a unir parece no funcionar. Probar
# opci�n parsear stream .mj2 directamente, dejando de copiar a la
# salida aquellos datos que pertenecen a capas de calidad que no deben
# ser extra�das. Adem�s, esta opci�n es m�s eficiente y puede ser
# aplicada sobre pipes.
import sys
import getopt
import os
import array
import display
import string

HIGH = "high"
LOW = "low"

layers = 1
pictures = 33
pixels_in_x = 352
pixels_in_y = 288
temporal_levels = 6

def usage():
    sys.stderr.write("+--------------+\n")
    sys.stderr.write("| MCTF extract |\n")
    sys.stderr.write("+--------------+\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Description:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   Extracts a number of quality layers.\n")
    sys.stderr.write("\n")
    sys.stderr.write("  Parameters:\n")
    sys.stderr.write("\n")
    sys.stderr.write("   -[-l]ayers=number of extracted quality layers (\"%d\")\n" % layers)
    sys.stderr.write("   -[-p]ictures=number of images to process (%d)\n" % pictures)
    sys.stderr.write("   -[-]pixels_in_[x]=size of the X dimension of the pictures (%d)\n" %  pixels_in_x)
    sys.stderr.write("   -[-]pixels_in_[y]=size of the Y dimension of the pictures (%d)\n" %  pixels_in_y)
    sys.stderr.write("   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (%d)\n" % temporal_levels)
    sys.stderr.write("\n")

opts = ""

ifdef({{DEBUG}},
display.info(str(sys.argv[0:]) + '\n')
)

try:
    opts, extraparams = getopt.getopt(sys.argv[1:],"l:p:x:y:t:h",
                                      ["layers=",
                                       "pictures=",
                                       "pixels_in_x=",
                                       "pixels_in_y=",
                                       "temporal_levels=",
                                       "help"
                                       ])
except getopt.GetoptError, exc:
    sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
    sys.exit(2)
    
params = ""
    
for o, a in opts:
    if o in ("-l", "--layers"):
        layers = int(a)
        ifdef({{DEBUG}},
        display.info(sys.argv[0] + ": layers=" + str(layers) + '\n')
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

subband = 1

command = "mkdir extract"
ifdef({{DEBUG}},
display.info(sys.argv[0] + ": " + command + "\n")
)
os.system(command)

# Procesamos las subbandas de alta frecuencia.
while subband < temporal_levels:

    ifdef({{DEBUG}},
    display.info(sys.argv[0] + ": processing high-pass subband " + str(subband) + " of " + str(temporal_levels) + "\n")
    )

    # Nombre del fichero entrada.
    entrada = HIGH + "_" + str(subband) + ".mj2"

    # Nombre del fichero de salida.
    salida = "extract/" + entrada

    # Copiamos la cabecera del fichero .mj2.
    command = "dd if=" + entrada + " of=" + salida + " skip=0 ibs=1 count=20"
    ifdef({{DEBUG}},
    display.info(sys.argv[0] + ": " + command + "\n")
    )
    os.system(command)

    # Abrimos el fichero de entrada, ahora para buscar el EOC (0xFFD9)
    # de cada imagen
    f = open(entrada, "r")

    # Saltamos los 20 bytes de la cabecera .mj2
    startImage = 20
    f.seek(startImage, 0)

    # Comanzamos la extracci�n de bytes:
    byte = f.read(1)
    while byte != '':
        if byte == '\xff':
            byte = f.read(1)
            if byte == '\xd9':
                endImage = f.tell()

                # Extraemos la imagen.
                command = "dd if=" + entrada + " of=image_Aux.j2c skip=" + str(startImage) + " ibs=1 count=" + str(endImage - startImage)
                ifdef({{DEBUG}},
                display.info(sys.argv[0] + ": " + command + "\n")
                )
                os.system(command)

                # Extraemos la(s) primera(s) capa(s) de calidad.
                command = "kdu_transcode -i image_Aux.j2c -o image_Out.j2c Clayers=" + str(layers)
                ifdef({{DEBUG}},
                display.info(sys.argv[0] + ": " + command + "\n")
                )
                os.system(command)

                # A�adimos la imagen generada.
                command = "cat image_Out.j2c >> " + salida
                ifdef({{DEBUG}},
                display.info(sys.argv[0] + ": " + command + "\n")
                )
                os.system(command)
            
                # Concatenamos 0x0000179A al final de "salida"
                command = "dd if=" + entrada + " of=/tmp/extract.tmp skip=" + str(endImage) + " bs=1 count=4" 
                ifdef({{DEBUG}},
                display.info(sys.argv[0] + ": " + command + "\n")
                )
                os.system(command)
                command = "cat /tmp/extract.tmp >> " + salida
                ifdef({{DEBUG}},
                display.info(sys.argv[0] + ": " + command + "\n")
                )
                os.system(command)

                # Nos saltamos los 4 �ltimos bytes de relleno.
                startImage = endImage + 4

        byte = f.read(1)

    f.close

    subband += 1

subband -= 1

# Procesamos la subbanda de baja frecuencia.
ifdef({{DEBUG}},
display.info(sys.argv[0] + ": processing low-pass subband " + str(subband) + " of " + str(temporal_levels) + "\n")
)

# Nombre del fichero entrada.
entrada = LOW + "_" + str(subband) + ".mj2"

# Nombre del fichero de salida.
salida = "extract/" + entrada

# Copiamos la cabecera del fichero .mj2.
command = "dd if=" + entrada + " of=" + salida + " skip=0 ibs=1 count=20"
ifdef({{DEBUG}},
display.info(sys.argv[0] + ": " + command + "\n")
)
os.system(command)

# Abrimos el fichero de entrada, ahora para buscar el EOC (0xFFD9)
# de cada imagen
f = open(entrada, "r")

# Saltamos los 20 bytes de la cabecera .mj2
startImage = 20
f.seek(startImage, 0)

# Comanzamos la extracci�n de bytes:
byte = f.read(1)
while byte != '':
    if byte == '\xff':
        byte = f.read(1)
        if byte == '\xd9':
            endImage = f.tell()

            # Extraemos la imagen.
            command = "dd if=" + entrada + " of=image_Aux.j2c skip=" + str(startImage) + " ibs=1 count=" + str(endImage - startImage)
            ifdef({{DEBUG}},
            display.info(sys.argv[0] + ": " + command + "\n")
            )
            os.system(command)

            # Extraemos la(s) primera(s) capa(s) de calidad.
            command = "kdu_transcode -i image_Aux.j2c -o image_Out.j2c Clayers=" + str(layers)
            ifdef({{DEBUG}},
            display.info(sys.argv[0] + ": " + command + "\n")
            )
            os.system(command)

            # A�adimos la imagen generada.
            command = "cat image_Out.j2c >> " + salida
            ifdef({{DEBUG}},
            display.info(sys.argv[0] + ": " + command + "\n")
            )
            os.system(command)

            # Concatenamos 0x0000179A al final de "salida"
            command = "dd if=" + entrada + " of=/tmp/extract.tmp skip=" + str(endImage) + " bs=1 count=4" 
            ifdef({{DEBUG}},
            display.info(sys.argv[0] + ": " + command + "\n")
            )
            os.system(command)
            command = "cat /tmp/extract.tmp >> " + salida
            ifdef({{DEBUG}},
            display.info(sys.argv[0] + ": " + command + "\n")
            )
            os.system(command)

            # Nos saltamos los 4 �ltimos bytes de relleno.
            startImage = endImage + 4

    byte = f.read(1)

f.close
