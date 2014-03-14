#!/bin/bash

/home/josejuan/MCJ2K/bin/me_xfield_topgm /home/josejuan/MCJ2K/vectors/avg$1.dat 4 4096 4096
mv prueba.pgm $1_x.pgm

/home/josejuan/MCJ2K/bin/me_yfield_topgm /home/josejuan/MCJ2K/vectors/avg$1.dat 4 4096 4096
mv prueba.pgm $1_y.pgm

