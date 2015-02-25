#!/bin/bash

# PLOT RD

gnuplot <<EOF
#set terminal svg
#set output "container_2TRL_RD.svg"
set grid
set title "container_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat" using 3:4 title "slopes constantes" with linespoints linetype 0 linewidth 0.5, \
"coef_L1.dat" using 3:4 title "L1" with linespoints linetype 1 linewidth 0.5, \
"coef_H1_1.dat" using 3:4 title "H1_1" with linespoints linetype 2 linewidth 0.5, \
"coef_H1_2.dat" using 3:4 title "H1_2" with linespoints linetype 3 linewidth 0.5, \
"coef_H1_3.dat" using 3:4 title "H1_3" with linespoints linetype 4 linewidth 0.5, \
"coef_H1_4.dat" using 3:4 title "H1_4" with linespoints linetype 5 linewidth 0.5, \
"coef_H1_5.dat" using 3:4 title "H1_5" with linespoints linetype 7 linewidth 0.5, \
"coef_H1_6.dat" using 3:4 title "H1_6" with linespoints linetype 8 linewidth 0.5, \
"coef_H1_7.dat" using 3:4 title "H1_7" with linespoints linetype 9 linewidth 0.5
EOF
