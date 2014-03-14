#!/bin/sh

convert /home/data/imagenes/lena.pgm 1.y; mv 1.y 1
uchar2int < 1 > 2

dwt2d Haar 0 512 512 3 < 2 > 3
dwt2d Haar 1 512 512 3 < 3 > 4
cmp 2 4

dwt2d 5/3 0 512 512 3 < 2 > 3
dwt2d 5/3 1 512 512 3 < 3 > 4
cmp 2 4

dwt2d 13/7 0 512 512 3 < 2 > 3
dwt2d 13/7 1 512 512 3 < 3 > 4
cmp 2 4

rm -f 1 2 3 4
