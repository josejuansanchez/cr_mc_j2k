#!/bin/bash

if [[ $CR_MC_J2K_HOME = "" ]]; then
	echo "Error. CR_MC_J2K_HOME is not defined"
	exit 1
fi

rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.j2c
rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.pgm

rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.cache
rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.lrcp
rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.woi
rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.sort
rm $CR_MC_J2K_HOME/data/j2c_and_thumbnails/*.ord