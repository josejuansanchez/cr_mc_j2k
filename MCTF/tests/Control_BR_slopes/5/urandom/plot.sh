#!/bin/bash

# PLOT RD

gnuplot <<EOF
#set terminal svg
#set output "container_5TRL_RD.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat" using 6:7 title "slopes constantes" with linespoints linetype 1 linewidth 2, \
"coef__250.dat" using 6:7 title "_250" with linespoints linetype 1 linewidth 0.5, \
"coef__275.dat" using 6:7 title "_275" with linespoints linetype 2 linewidth 0.5, \
"coef__300.dat" using 6:7 title "_300" with linespoints linetype 3 linewidth 0.5, \
"coef__325.dat" using 6:7 title "_325" with linespoints linetype 4 linewidth 0.5, \
"coef__350.dat" using 6:7 title "_350" with linespoints linetype 5 linewidth 0.5, \
"coef__300_275_250_225.dat" using 6:7 title "_300_275_250_225" with linespoints linetype 6 linewidth 0.5, \
"coef__300_250_200_150.dat" using 6:7 title "_300_250_200_150" with linespoints linetype 7 linewidth 0.5, \
"coef__300_325_350_375.dat" using 6:7 title "_300_325_350_375" with linespoints linetype 8 linewidth 0.5, \
"coef__300_350_400_450.dat" using 6:7 title "_300_350_400_450" with linespoints linetype 9 linewidth 0.5,\
"coef__300_225_150_75.dat" using 6:7 title "_300_225_150_75" with linespoints linetype 8 linewidth 0.5, \
"coef__275_225_175_125.dat" using 6:7 title "_275_225_175_125" with linespoints linetype 8 linewidth 0.5, \
"coef__275_200_125_50.dat" using 6:7 title "_275_200_125_50" with linespoints linetype 8 linewidth 0.5, \
EOF
