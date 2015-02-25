# int to ascii : unichr()
# ascii to int : ord()
import math

f_raw = open ("imagen.raw", 'rb')
f_rawDIV = open ("imagenDIV.raw", 'w')


try:
    byte = f_raw.read(1)
    while byte != "" :
        out = ord(byte) / math.sqrt(2)
        print "byte: " + str(ord(byte)) + " -> " + str(int(out))
        #f_rawDIV.write(str(int(out)))
        f_rawDIV.write('%c' % int(out))
        byte = f_raw.read(1)

finally:
    f_raw.close()
    f_rawDIV.close()


raw_input("")
# COMPROBAR

f_rawDIV = open ("imagenDIV.raw", 'rb')

try:
    byte = f_rawDIV.read(1)
    while byte != "" :
        print "byte: " + str(ord(byte))
        byte = f_rawDIV.read(1)
finally:
    f_rawDIV.close()



# rawtopgm 288 352 < imagenDIV.raw > imagenDIV.pgm
# kdu_compress -i imagen.pgm -o imagen.j2c -no_weights Clevels=4 -slope 40100 Clayers=1
