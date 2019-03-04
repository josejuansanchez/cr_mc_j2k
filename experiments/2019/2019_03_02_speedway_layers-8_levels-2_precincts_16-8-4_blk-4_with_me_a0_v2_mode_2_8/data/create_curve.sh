#!/bin/bash
gnuplot < todo.gpt 
convert -density 300 todo.eps -resize 1024x1024 todo.png