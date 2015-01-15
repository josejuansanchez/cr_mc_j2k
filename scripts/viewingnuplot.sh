#!/bin/bash

IMG_OUT=$1
DATA=$1

(echo "set term svg";
echo "set output '${IMG_OUT}.svg'";
echo "set nokey";
echo "plot '$DATA' using 1:2:3:4  with vec";
echo "exit") | gnuplot

cp ${IMG_OUT}.svg temp.svg

display ${IMG_OUT}.svg