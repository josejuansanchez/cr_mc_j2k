#!/bin/bash

if [ -f motion ]
then
    rm motion
fi

if [ -f tiempo ]
then
    rm tiempo
fi

if [ -f log.txt ]
then
    rm log.txt
fi

rm gnuplot/*.dat
rm gnuplot/*.svg
rm vectors/*.dat
rm -rf images_test/*
rm *.jp2
