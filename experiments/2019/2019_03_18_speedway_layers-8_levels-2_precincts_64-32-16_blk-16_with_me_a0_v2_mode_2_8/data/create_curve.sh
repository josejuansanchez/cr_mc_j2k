#!/bin/bash
gnuplot < todo_1K_5K.gpt 
convert -density 300 todo.eps -resize 1024x1024 todo.png