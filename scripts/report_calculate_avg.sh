#!/bin/bash

function CheckExitStatusCode()
{
    if [ $? -ne 0 ]; then
        echo "Error"
        exit
    fi
}

if [[ $CR_MC_J2K_HOME = "" ]]; then
    echo "Error. CR_MC_J2K_HOME is not defined"
    exit 1
fi

AVG=$CR_MC_J2K_HOME/pytools/avg.py

for((BITRATE=1000; BITRATE<=60000; BITRATE=BITRATE+1000))
do
    echo -e "\n* $BITRATE bytes"
    python $AVG paste_$BITRATE.txt
done