#!/bin/bash

# PLOT RD

gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_RD.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot 	"coef_1_RD.dat"		using 2:3 title "1" 	with lines			linetype 1 linewidth 0.1, \
		"coef_1.005_RD.dat"	using 2:3 title "1.005" with lines 			linetype 2 linewidth 0.1, \
		"coef_1.01_RD.dat"	using 2:3 title "1.01" 	with lines 			linetype 3 linewidth 0.1, \
		"coef_1.015_RD.dat"	using 2:3 title "1.015" with lines 			linetype 4 linewidth 0.1, \
		"coef_1.02_RD.dat"	using 2:3 title "1.02" 	with lines 			linetype 5 linewidth 0.1, \
		"coef_1.025_RD.dat"	using 2:3 title "1.025" with lines 			linetype 6 linewidth 0.1, \
		"coef_1.03_RD.dat"	using 2:3 title "1.03" 	with lines 			linetype 7 linewidth 0.1, \
		"coef_1.035_RD.dat"	using 2:3 title "1.035" with lines 			linetype 8 linewidth 0.1
EOF


# PLOT coef

gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_coef.svg"
set grid
set title "urandom_2TRL - PROPORCIONES ENTRE PESOS DE CAPAS"
set xlabel "bit-rate"
set ylabel "coef. entre pesos capas low-high"
plot 	"coef_25%_RD.dat"	using 1:2 title "25% = 1.333"	with lines			linetype 9 linewidth 0.1, \
		"coef_1_RD.dat"		using 2:4 title "1" 			with linespoints 	linetype 1 linewidth 0.1, \
		"coef_1.005_RD.dat"	using 2:4 title "1.005" 		with lines 			linetype 2 linewidth 0.1, \
		"coef_1.01_RD.dat"	using 2:4 title "1.01"			with lines 			linetype 3 linewidth 0.1, \
		"coef_1.015_RD.dat"	using 2:4 title "1.015" 		with lines 			linetype 4 linewidth 0.1, \
		"coef_1.02_RD.dat"	using 2:4 title "1.02" 			with lines 			linetype 5 linewidth 0.1, \
		"coef_1.025_RD.dat"	using 2:4 title "1.025" 		with lines 			linetype 6 linewidth 0.1, \
		"coef_1.03_RD.dat"	using 2:4 title "1.03" 			with lines 			linetype 7 linewidth 0.1, \
		"coef_1.035_RD.dat"	using 2:4 title "1.035" 		with lines 			linetype 8 linewidth 0.1
EOF

# PLOT coef enfocado

gnuplot <<EOF
set yrange [0:5]
set terminal svg
set output "urandom_2TRL_coef_ENFOCADO.svg"
set grid
set title "urandom_2TRL - PROPORCIONES ENTRE PESOS DE CAPAS (ENFOCADO)"
set xlabel "bit-rate"
set ylabel "coef. entre pesos capas low-high"
plot 	"coef_25%_RD.dat"	using 1:2 title "25% = 1.333"	with lines			linetype 9 linewidth 0.1, \
		"coef_1_RD.dat"		using 2:4 title "1" 			with linespoints 	linetype 1 linewidth 0.1, \
		"coef_1.005_RD.dat"	using 2:4 title "1.005" 		with lines 			linetype 2 linewidth 0.1, \
		"coef_1.01_RD.dat"	using 2:4 title "1.01"			with lines 			linetype 3 linewidth 0.1, \
		"coef_1.015_RD.dat"	using 2:4 title "1.015" 		with lines 			linetype 4 linewidth 0.1, \
		"coef_1.02_RD.dat"	using 2:4 title "1.02" 			with lines 			linetype 5 linewidth 0.1, \
		"coef_1.025_RD.dat"	using 2:4 title "1.025" 		with lines 			linetype 6 linewidth 0.1, \
		"coef_1.03_RD.dat"	using 2:4 title "1.03" 			with lines 			linetype 7 linewidth 0.1, \
		"coef_1.035_RD.dat"	using 2:4 title "1.035" 		with lines 			linetype 8 linewidth 0.1
EOF


# PLOT RD y coef

gnuplot <<EOF
set yrange [0:80]
set terminal svg
set output "urandom_2TRL_RDyCoef.svg"
set grid
set title "urandom_2TRL - RD y Coef"
set xlabel "bit-rate"
set ylabel "RMSE y coef"
plot 	"coef_1_RD.dat"		using 2:3 title "1" 			with lines			linetype 1 linewidth 0.1, \
		"coef_1.005_RD.dat"	using 2:3 title "1.005" 		with lines 			linetype 2 linewidth 0.1, \
		"coef_1.01_RD.dat"	using 2:3 title "1.01" 			with lines 			linetype 3 linewidth 0.1, \
		"coef_1.015_RD.dat"	using 2:3 title "1.015" 		with lines 			linetype 4 linewidth 0.1, \
		"coef_1.02_RD.dat"	using 2:3 title "1.02" 			with lines 			linetype 5 linewidth 0.1, \
		"coef_1.025_RD.dat"	using 2:3 title "1.025" 		with lines 			linetype 6 linewidth 0.1, \
		"coef_1.03_RD.dat"	using 2:3 title "1.03" 			with lines 			linetype 7 linewidth 0.1, \
		"coef_1.035_RD.dat"	using 2:3 title "1.035" 		with lines 			linetype 8 linewidth 0.1, \
		"coef_1_RD.dat"		using 2:4 title "1 coef"		with lines			linetype 1 linewidth 0.1, \
		"coef_1.005_RD.dat"	using 2:4 title "1.005 coef" 	with lines 			linetype 2 linewidth 0.1, \
		"coef_1.01_RD.dat"	using 2:4 title "1.01 coef"		with lines 			linetype 3 linewidth 0.1, \
		"coef_1.015_RD.dat"	using 2:4 title "1.015 coef" 	with lines 			linetype 4 linewidth 0.1, \
		"coef_1.02_RD.dat"	using 2:4 title "1.02 coef" 	with lines 			linetype 5 linewidth 0.1, \
		"coef_1.025_RD.dat"	using 2:4 title "1.025 coef" 	with lines 			linetype 6 linewidth 0.1, \
		"coef_1.03_RD.dat"	using 2:4 title "1.03 coef" 	with lines 			linetype 7 linewidth 0.1, \
		"coef_1.035_RD.dat"	using 2:4 title "1.035 coef" 	with lines 			linetype 8 linewidth 0.1
EOF

