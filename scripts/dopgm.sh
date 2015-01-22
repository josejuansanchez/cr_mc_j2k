#!/bin/bash

if [ $# -ne 3 ]; then
	echo -e "\nUso: $0 <Block Size> <Height> <Weight>\n"
	exit 1
fi

/home/josejuan/MCJ2K/bin/me_xfield_topgm me_vectors/prev.dat $1 $2 $3
mv prueba.pgm x.pgm

/home/josejuan/MCJ2K/bin/me_yfield_topgm me_vectors/prev.dat $1 $2 $3
mv prueba.pgm y.pgm