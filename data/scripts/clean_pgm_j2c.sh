#!/bin/bash

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

rm $CR_MC_J2K_HOME/data/thumbnails/*.j2c
rm $CR_MC_J2K_HOME/data/thumbnails/*.pgm

rm $CR_MC_J2K_HOME/data/thumbnails/*.cache
rm $CR_MC_J2K_HOME/data/thumbnails/*.lrcp
rm $CR_MC_J2K_HOME/data/thumbnails/*.woi
rm $CR_MC_J2K_HOME/data/thumbnails/*.sort
rm $CR_MC_J2K_HOME/data/thumbnails/*.ord