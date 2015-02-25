#!/bin/bash


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_45000.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_45000_1.025.dat" using 3:4 title "45000_1.025" with linespoints linewidth 0.5, \
"coef_45000_1.0225.dat" using 3:4 title "45000_1.0225" with linespoints linewidth 0.5, \
"coef_45000_1.02.dat" using 3:4 title "45000_1.02" with linespoints linewidth 0.5, \
"coef_45000_1.0175.dat" using 3:4 title "45000_1.0175" with linespoints linewidth 0.5, \
"coef_45000_1.015.dat" using 3:4 title "45000_1.015" with linespoints linewidth 0.5, \
"coef_45000_1.0125.dat" using 3:4 title "45000_1.0125" with linespoints linewidth 0.5, \
"coef_45000_1.01.dat" using 3:4 title "45000_1.01" with linespoints linewidth 0.5, \
"coef_45000_1.0075.dat" using 3:4 title "45000_1.0075" with linespoints linewidth 0.5, \
"coef_45000_1.005.dat" using 3:4 title "45000_1.005" with linespoints linewidth 0.5, \
"coef_45000_1.0025.dat" using 3:4 title "45000_1.0025" with linespoints linewidth 0.5, \
"coef_45000_1.dat" using 3:4 title "45000_1" with linespoints linewidth 2, \
"coef_45000_0.9975.dat" using 3:4 title "45000_0.9975" with linespoints linewidth 0.5, \
"coef_45000_0.995.dat" using 3:4 title "45000_0.995" with linespoints linewidth 0.5, \
"coef_45000_0.9925.dat" using 3:4 title "45000_0.9925" with linespoints linewidth 0.5, \
"coef_45000_0.99.dat" using 3:4 title "45000_0.99" with linespoints linewidth 0.5, \
"coef_45000_0.9875.dat" using 3:4 title "45000_0.9875" with linespoints linewidth 0.5, \
"coef_45000_0.985.dat" using 3:4 title "45000_0.985" with linespoints linewidth 0.5, \
"coef_45000_0.9825.dat" using 3:4 title "45000_0.9825" with linespoints linewidth 0.5, \
"coef_45000_0.98.dat" using 3:4 title "45000_0.98" with linespoints linewidth 0.5, \
"coef_45000_0.9775.dat" using 3:4 title "45000_0.9775" with linespoints linewidth 0.5, \
"coef_45000_0.975.dat" using 3:4 title "45000_0.975" with linespoints linewidth 0.5
EOF

gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44998.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44998_1.025.dat" using 3:4 title "44998_1.025" with linespoints linewidth 0.5, \
"coef_44998_1.0225.dat" using 3:4 title "44998_1.0225" with linespoints linewidth 0.5, \
"coef_44998_1.02.dat" using 3:4 title "44998_1.02" with linespoints linewidth 0.5, \
"coef_44998_1.0175.dat" using 3:4 title "44998_1.0175" with linespoints linewidth 0.5, \
"coef_44998_1.015.dat" using 3:4 title "44998_1.015" with linespoints linewidth 0.5, \
"coef_44998_1.0125.dat" using 3:4 title "44998_1.0125" with linespoints linewidth 0.5, \
"coef_44998_1.01.dat" using 3:4 title "44998_1.01" with linespoints linewidth 0.5, \
"coef_44998_1.0075.dat" using 3:4 title "44998_1.0075" with linespoints linewidth 0.5, \
"coef_44998_1.005.dat" using 3:4 title "44998_1.005" with linespoints linewidth 0.5, \
"coef_44998_1.0025.dat" using 3:4 title "44998_1.0025" with linespoints linewidth 0.5, \
"coef_44998_1.dat" using 3:4 title "44998_1" with linespoints linewidth 2, \
"coef_44998_0.9975.dat" using 3:4 title "44998_0.9975" with linespoints linewidth 0.5, \
"coef_44998_0.995.dat" using 3:4 title "44998_0.995" with linespoints linewidth 0.5, \
"coef_44998_0.9925.dat" using 3:4 title "44998_0.9925" with linespoints linewidth 0.5, \
"coef_44998_0.99.dat" using 3:4 title "44998_0.99" with linespoints linewidth 0.5, \
"coef_44998_0.9875.dat" using 3:4 title "44998_0.9875" with linespoints linewidth 0.5, \
"coef_44998_0.985.dat" using 3:4 title "44998_0.985" with linespoints linewidth 0.5, \
"coef_44998_0.9825.dat" using 3:4 title "44998_0.9825" with linespoints linewidth 0.5, \
"coef_44998_0.98.dat" using 3:4 title "44998_0.98" with linespoints linewidth 0.5, \
"coef_44998_0.9775.dat" using 3:4 title "44998_0.9775" with linespoints linewidth 0.5, \
"coef_44998_0.975.dat" using 3:4 title "44998_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44994.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44994_1.025.dat" using 3:4 title "44994_1.025" with linespoints linewidth 0.5, \
"coef_44994_1.0225.dat" using 3:4 title "44994_1.0225" with linespoints linewidth 0.5, \
"coef_44994_1.02.dat" using 3:4 title "44994_1.02" with linespoints linewidth 0.5, \
"coef_44994_1.0175.dat" using 3:4 title "44994_1.0175" with linespoints linewidth 0.5, \
"coef_44994_1.015.dat" using 3:4 title "44994_1.015" with linespoints linewidth 0.5, \
"coef_44994_1.0125.dat" using 3:4 title "44994_1.0125" with linespoints linewidth 0.5, \
"coef_44994_1.01.dat" using 3:4 title "44994_1.01" with linespoints linewidth 0.5, \
"coef_44994_1.0075.dat" using 3:4 title "44994_1.0075" with linespoints linewidth 0.5, \
"coef_44994_1.005.dat" using 3:4 title "44994_1.005" with linespoints linewidth 0.5, \
"coef_44994_1.0025.dat" using 3:4 title "44994_1.0025" with linespoints linewidth 0.5, \
"coef_44994_1.dat" using 3:4 title "44994_1" with linespoints linewidth 2, \
"coef_44994_0.9975.dat" using 3:4 title "44994_0.9975" with linespoints linewidth 0.5, \
"coef_44994_0.995.dat" using 3:4 title "44994_0.995" with linespoints linewidth 0.5, \
"coef_44994_0.9925.dat" using 3:4 title "44994_0.9925" with linespoints linewidth 0.5, \
"coef_44994_0.99.dat" using 3:4 title "44994_0.99" with linespoints linewidth 0.5, \
"coef_44994_0.9875.dat" using 3:4 title "44994_0.9875" with linespoints linewidth 0.5, \
"coef_44994_0.985.dat" using 3:4 title "44994_0.985" with linespoints linewidth 0.5, \
"coef_44994_0.9825.dat" using 3:4 title "44994_0.9825" with linespoints linewidth 0.5, \
"coef_44994_0.98.dat" using 3:4 title "44994_0.98" with linespoints linewidth 0.5, \
"coef_44994_0.9775.dat" using 3:4 title "44994_0.9775" with linespoints linewidth 0.5, \
"coef_44994_0.975.dat" using 3:4 title "44994_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44989.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44989_1.025.dat" using 3:4 title "44989_1.025" with linespoints linewidth 0.5, \
"coef_44989_1.0225.dat" using 3:4 title "44989_1.0225" with linespoints linewidth 0.5, \
"coef_44989_1.02.dat" using 3:4 title "44989_1.02" with linespoints linewidth 0.5, \
"coef_44989_1.0175.dat" using 3:4 title "44989_1.0175" with linespoints linewidth 0.5, \
"coef_44989_1.015.dat" using 3:4 title "44989_1.015" with linespoints linewidth 0.5, \
"coef_44989_1.0125.dat" using 3:4 title "44989_1.0125" with linespoints linewidth 0.5, \
"coef_44989_1.01.dat" using 3:4 title "44989_1.01" with linespoints linewidth 0.5, \
"coef_44989_1.0075.dat" using 3:4 title "44989_1.0075" with linespoints linewidth 0.5, \
"coef_44989_1.005.dat" using 3:4 title "44989_1.005" with linespoints linewidth 0.5, \
"coef_44989_1.0025.dat" using 3:4 title "44989_1.0025" with linespoints linewidth 0.5, \
"coef_44989_1.dat" using 3:4 title "44989_1" with linespoints linewidth 2, \
"coef_44989_0.9975.dat" using 3:4 title "44989_0.9975" with linespoints linewidth 0.5, \
"coef_44989_0.995.dat" using 3:4 title "44989_0.995" with linespoints linewidth 0.5, \
"coef_44989_0.9925.dat" using 3:4 title "44989_0.9925" with linespoints linewidth 0.5, \
"coef_44989_0.99.dat" using 3:4 title "44989_0.99" with linespoints linewidth 0.5, \
"coef_44989_0.9875.dat" using 3:4 title "44989_0.9875" with linespoints linewidth 0.5, \
"coef_44989_0.985.dat" using 3:4 title "44989_0.985" with linespoints linewidth 0.5, \
"coef_44989_0.9825.dat" using 3:4 title "44989_0.9825" with linespoints linewidth 0.5, \
"coef_44989_0.98.dat" using 3:4 title "44989_0.98" with linespoints linewidth 0.5, \
"coef_44989_0.9775.dat" using 3:4 title "44989_0.9775" with linespoints linewidth 0.5, \
"coef_44989_0.975.dat" using 3:4 title "44989_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44982.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44982_1.025.dat" using 3:4 title "44982_1.025" with linespoints linewidth 0.5, \
"coef_44982_1.0225.dat" using 3:4 title "44982_1.0225" with linespoints linewidth 0.5, \
"coef_44982_1.02.dat" using 3:4 title "44982_1.02" with linespoints linewidth 0.5, \
"coef_44982_1.0175.dat" using 3:4 title "44982_1.0175" with linespoints linewidth 0.5, \
"coef_44982_1.015.dat" using 3:4 title "44982_1.015" with linespoints linewidth 0.5, \
"coef_44982_1.0125.dat" using 3:4 title "44982_1.0125" with linespoints linewidth 0.5, \
"coef_44982_1.01.dat" using 3:4 title "44982_1.01" with linespoints linewidth 0.5, \
"coef_44982_1.0075.dat" using 3:4 title "44982_1.0075" with linespoints linewidth 0.5, \
"coef_44982_1.005.dat" using 3:4 title "44982_1.005" with linespoints linewidth 0.5, \
"coef_44982_1.0025.dat" using 3:4 title "44982_1.0025" with linespoints linewidth 0.5, \
"coef_44982_1.dat" using 3:4 title "44982_1" with linespoints linewidth 2, \
"coef_44982_0.9975.dat" using 3:4 title "44982_0.9975" with linespoints linewidth 0.5, \
"coef_44982_0.995.dat" using 3:4 title "44982_0.995" with linespoints linewidth 0.5, \
"coef_44982_0.9925.dat" using 3:4 title "44982_0.9925" with linespoints linewidth 0.5, \
"coef_44982_0.99.dat" using 3:4 title "44982_0.99" with linespoints linewidth 0.5, \
"coef_44982_0.9875.dat" using 3:4 title "44982_0.9875" with linespoints linewidth 0.5, \
"coef_44982_0.985.dat" using 3:4 title "44982_0.985" with linespoints linewidth 0.5, \
"coef_44982_0.9825.dat" using 3:4 title "44982_0.9825" with linespoints linewidth 0.5, \
"coef_44982_0.98.dat" using 3:4 title "44982_0.98" with linespoints linewidth 0.5, \
"coef_44982_0.9775.dat" using 3:4 title "44982_0.9775" with linespoints linewidth 0.5, \
"coef_44982_0.975.dat" using 3:4 title "44982_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44970.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44970_1.025.dat" using 3:4 title "44970_1.025" with linespoints linewidth 0.5, \
"coef_44970_1.0225.dat" using 3:4 title "44970_1.0225" with linespoints linewidth 0.5, \
"coef_44970_1.02.dat" using 3:4 title "44970_1.02" with linespoints linewidth 0.5, \
"coef_44970_1.0175.dat" using 3:4 title "44970_1.0175" with linespoints linewidth 0.5, \
"coef_44970_1.015.dat" using 3:4 title "44970_1.015" with linespoints linewidth 0.5, \
"coef_44970_1.0125.dat" using 3:4 title "44970_1.0125" with linespoints linewidth 0.5, \
"coef_44970_1.01.dat" using 3:4 title "44970_1.01" with linespoints linewidth 0.5, \
"coef_44970_1.0075.dat" using 3:4 title "44970_1.0075" with linespoints linewidth 0.5, \
"coef_44970_1.005.dat" using 3:4 title "44970_1.005" with linespoints linewidth 0.5, \
"coef_44970_1.0025.dat" using 3:4 title "44970_1.0025" with linespoints linewidth 0.5, \
"coef_44970_1.dat" using 3:4 title "44970_1" with linespoints linewidth 2, \
"coef_44970_0.9975.dat" using 3:4 title "44970_0.9975" with linespoints linewidth 0.5, \
"coef_44970_0.995.dat" using 3:4 title "44970_0.995" with linespoints linewidth 0.5, \
"coef_44970_0.9925.dat" using 3:4 title "44970_0.9925" with linespoints linewidth 0.5, \
"coef_44970_0.99.dat" using 3:4 title "44970_0.99" with linespoints linewidth 0.5, \
"coef_44970_0.9875.dat" using 3:4 title "44970_0.9875" with linespoints linewidth 0.5, \
"coef_44970_0.985.dat" using 3:4 title "44970_0.985" with linespoints linewidth 0.5, \
"coef_44970_0.9825.dat" using 3:4 title "44970_0.9825" with linespoints linewidth 0.5, \
"coef_44970_0.98.dat" using 3:4 title "44970_0.98" with linespoints linewidth 0.5, \
"coef_44970_0.9775.dat" using 3:4 title "44970_0.9775" with linespoints linewidth 0.5, \
"coef_44970_0.975.dat" using 3:4 title "44970_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44953.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44953_1.025.dat" using 3:4 title "44953_1.025" with linespoints linewidth 0.5, \
"coef_44953_1.0225.dat" using 3:4 title "44953_1.0225" with linespoints linewidth 0.5, \
"coef_44953_1.02.dat" using 3:4 title "44953_1.02" with linespoints linewidth 0.5, \
"coef_44953_1.0175.dat" using 3:4 title "44953_1.0175" with linespoints linewidth 0.5, \
"coef_44953_1.015.dat" using 3:4 title "44953_1.015" with linespoints linewidth 0.5, \
"coef_44953_1.0125.dat" using 3:4 title "44953_1.0125" with linespoints linewidth 0.5, \
"coef_44953_1.01.dat" using 3:4 title "44953_1.01" with linespoints linewidth 0.5, \
"coef_44953_1.0075.dat" using 3:4 title "44953_1.0075" with linespoints linewidth 0.5, \
"coef_44953_1.005.dat" using 3:4 title "44953_1.005" with linespoints linewidth 0.5, \
"coef_44953_1.0025.dat" using 3:4 title "44953_1.0025" with linespoints linewidth 0.5, \
"coef_44953_1.dat" using 3:4 title "44953_1" with linespoints linewidth 2, \
"coef_44953_0.9975.dat" using 3:4 title "44953_0.9975" with linespoints linewidth 0.5, \
"coef_44953_0.995.dat" using 3:4 title "44953_0.995" with linespoints linewidth 0.5, \
"coef_44953_0.9925.dat" using 3:4 title "44953_0.9925" with linespoints linewidth 0.5, \
"coef_44953_0.99.dat" using 3:4 title "44953_0.99" with linespoints linewidth 0.5, \
"coef_44953_0.9875.dat" using 3:4 title "44953_0.9875" with linespoints linewidth 0.5, \
"coef_44953_0.985.dat" using 3:4 title "44953_0.985" with linespoints linewidth 0.5, \
"coef_44953_0.9825.dat" using 3:4 title "44953_0.9825" with linespoints linewidth 0.5, \
"coef_44953_0.98.dat" using 3:4 title "44953_0.98" with linespoints linewidth 0.5, \
"coef_44953_0.9775.dat" using 3:4 title "44953_0.9775" with linespoints linewidth 0.5, \
"coef_44953_0.975.dat" using 3:4 title "44953_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44928.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44928_1.025.dat" using 3:4 title "44928_1.025" with linespoints linewidth 0.5, \
"coef_44928_1.0225.dat" using 3:4 title "44928_1.0225" with linespoints linewidth 0.5, \
"coef_44928_1.02.dat" using 3:4 title "44928_1.02" with linespoints linewidth 0.5, \
"coef_44928_1.0175.dat" using 3:4 title "44928_1.0175" with linespoints linewidth 0.5, \
"coef_44928_1.015.dat" using 3:4 title "44928_1.015" with linespoints linewidth 0.5, \
"coef_44928_1.0125.dat" using 3:4 title "44928_1.0125" with linespoints linewidth 0.5, \
"coef_44928_1.01.dat" using 3:4 title "44928_1.01" with linespoints linewidth 0.5, \
"coef_44928_1.0075.dat" using 3:4 title "44928_1.0075" with linespoints linewidth 0.5, \
"coef_44928_1.005.dat" using 3:4 title "44928_1.005" with linespoints linewidth 0.5, \
"coef_44928_1.0025.dat" using 3:4 title "44928_1.0025" with linespoints linewidth 0.5, \
"coef_44928_1.dat" using 3:4 title "44928_1" with linespoints linewidth 2, \
"coef_44928_0.9975.dat" using 3:4 title "44928_0.9975" with linespoints linewidth 0.5, \
"coef_44928_0.995.dat" using 3:4 title "44928_0.995" with linespoints linewidth 0.5, \
"coef_44928_0.9925.dat" using 3:4 title "44928_0.9925" with linespoints linewidth 0.5, \
"coef_44928_0.99.dat" using 3:4 title "44928_0.99" with linespoints linewidth 0.5, \
"coef_44928_0.9875.dat" using 3:4 title "44928_0.9875" with linespoints linewidth 0.5, \
"coef_44928_0.985.dat" using 3:4 title "44928_0.985" with linespoints linewidth 0.5, \
"coef_44928_0.9825.dat" using 3:4 title "44928_0.9825" with linespoints linewidth 0.5, \
"coef_44928_0.98.dat" using 3:4 title "44928_0.98" with linespoints linewidth 0.5, \
"coef_44928_0.9775.dat" using 3:4 title "44928_0.9775" with linespoints linewidth 0.5, \
"coef_44928_0.975.dat" using 3:4 title "44928_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44889.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44889_1.025.dat" using 3:4 title "44889_1.025" with linespoints linewidth 0.5, \
"coef_44889_1.0225.dat" using 3:4 title "44889_1.0225" with linespoints linewidth 0.5, \
"coef_44889_1.02.dat" using 3:4 title "44889_1.02" with linespoints linewidth 0.5, \
"coef_44889_1.0175.dat" using 3:4 title "44889_1.0175" with linespoints linewidth 0.5, \
"coef_44889_1.015.dat" using 3:4 title "44889_1.015" with linespoints linewidth 0.5, \
"coef_44889_1.0125.dat" using 3:4 title "44889_1.0125" with linespoints linewidth 0.5, \
"coef_44889_1.01.dat" using 3:4 title "44889_1.01" with linespoints linewidth 0.5, \
"coef_44889_1.0075.dat" using 3:4 title "44889_1.0075" with linespoints linewidth 0.5, \
"coef_44889_1.005.dat" using 3:4 title "44889_1.005" with linespoints linewidth 0.5, \
"coef_44889_1.0025.dat" using 3:4 title "44889_1.0025" with linespoints linewidth 0.5, \
"coef_44889_1.dat" using 3:4 title "44889_1" with linespoints linewidth 2, \
"coef_44889_0.9975.dat" using 3:4 title "44889_0.9975" with linespoints linewidth 0.5, \
"coef_44889_0.995.dat" using 3:4 title "44889_0.995" with linespoints linewidth 0.5, \
"coef_44889_0.9925.dat" using 3:4 title "44889_0.9925" with linespoints linewidth 0.5, \
"coef_44889_0.99.dat" using 3:4 title "44889_0.99" with linespoints linewidth 0.5, \
"coef_44889_0.9875.dat" using 3:4 title "44889_0.9875" with linespoints linewidth 0.5, \
"coef_44889_0.985.dat" using 3:4 title "44889_0.985" with linespoints linewidth 0.5, \
"coef_44889_0.9825.dat" using 3:4 title "44889_0.9825" with linespoints linewidth 0.5, \
"coef_44889_0.98.dat" using 3:4 title "44889_0.98" with linespoints linewidth 0.5, \
"coef_44889_0.9775.dat" using 3:4 title "44889_0.9775" with linespoints linewidth 0.5, \
"coef_44889_0.975.dat" using 3:4 title "44889_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44832.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44832_1.025.dat" using 3:4 title "44832_1.025" with linespoints linewidth 0.5, \
"coef_44832_1.0225.dat" using 3:4 title "44832_1.0225" with linespoints linewidth 0.5, \
"coef_44832_1.02.dat" using 3:4 title "44832_1.02" with linespoints linewidth 0.5, \
"coef_44832_1.0175.dat" using 3:4 title "44832_1.0175" with linespoints linewidth 0.5, \
"coef_44832_1.015.dat" using 3:4 title "44832_1.015" with linespoints linewidth 0.5, \
"coef_44832_1.0125.dat" using 3:4 title "44832_1.0125" with linespoints linewidth 0.5, \
"coef_44832_1.01.dat" using 3:4 title "44832_1.01" with linespoints linewidth 0.5, \
"coef_44832_1.0075.dat" using 3:4 title "44832_1.0075" with linespoints linewidth 0.5, \
"coef_44832_1.005.dat" using 3:4 title "44832_1.005" with linespoints linewidth 0.5, \
"coef_44832_1.0025.dat" using 3:4 title "44832_1.0025" with linespoints linewidth 0.5, \
"coef_44832_1.dat" using 3:4 title "44832_1" with linespoints linewidth 2, \
"coef_44832_0.9975.dat" using 3:4 title "44832_0.9975" with linespoints linewidth 0.5, \
"coef_44832_0.995.dat" using 3:4 title "44832_0.995" with linespoints linewidth 0.5, \
"coef_44832_0.9925.dat" using 3:4 title "44832_0.9925" with linespoints linewidth 0.5, \
"coef_44832_0.99.dat" using 3:4 title "44832_0.99" with linespoints linewidth 0.5, \
"coef_44832_0.9875.dat" using 3:4 title "44832_0.9875" with linespoints linewidth 0.5, \
"coef_44832_0.985.dat" using 3:4 title "44832_0.985" with linespoints linewidth 0.5, \
"coef_44832_0.9825.dat" using 3:4 title "44832_0.9825" with linespoints linewidth 0.5, \
"coef_44832_0.98.dat" using 3:4 title "44832_0.98" with linespoints linewidth 0.5, \
"coef_44832_0.9775.dat" using 3:4 title "44832_0.9775" with linespoints linewidth 0.5, \
"coef_44832_0.975.dat" using 3:4 title "44832_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44745.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44745_1.025.dat" using 3:4 title "44745_1.025" with linespoints linewidth 0.5, \
"coef_44745_1.0225.dat" using 3:4 title "44745_1.0225" with linespoints linewidth 0.5, \
"coef_44745_1.02.dat" using 3:4 title "44745_1.02" with linespoints linewidth 0.5, \
"coef_44745_1.0175.dat" using 3:4 title "44745_1.0175" with linespoints linewidth 0.5, \
"coef_44745_1.015.dat" using 3:4 title "44745_1.015" with linespoints linewidth 0.5, \
"coef_44745_1.0125.dat" using 3:4 title "44745_1.0125" with linespoints linewidth 0.5, \
"coef_44745_1.01.dat" using 3:4 title "44745_1.01" with linespoints linewidth 0.5, \
"coef_44745_1.0075.dat" using 3:4 title "44745_1.0075" with linespoints linewidth 0.5, \
"coef_44745_1.005.dat" using 3:4 title "44745_1.005" with linespoints linewidth 0.5, \
"coef_44745_1.0025.dat" using 3:4 title "44745_1.0025" with linespoints linewidth 0.5, \
"coef_44745_1.dat" using 3:4 title "44745_1" with linespoints linewidth 2, \
"coef_44745_0.9975.dat" using 3:4 title "44745_0.9975" with linespoints linewidth 0.5, \
"coef_44745_0.995.dat" using 3:4 title "44745_0.995" with linespoints linewidth 0.5, \
"coef_44745_0.9925.dat" using 3:4 title "44745_0.9925" with linespoints linewidth 0.5, \
"coef_44745_0.99.dat" using 3:4 title "44745_0.99" with linespoints linewidth 0.5, \
"coef_44745_0.9875.dat" using 3:4 title "44745_0.9875" with linespoints linewidth 0.5, \
"coef_44745_0.985.dat" using 3:4 title "44745_0.985" with linespoints linewidth 0.5, \
"coef_44745_0.9825.dat" using 3:4 title "44745_0.9825" with linespoints linewidth 0.5, \
"coef_44745_0.98.dat" using 3:4 title "44745_0.98" with linespoints linewidth 0.5, \
"coef_44745_0.9775.dat" using 3:4 title "44745_0.9775" with linespoints linewidth 0.5, \
"coef_44745_0.975.dat" using 3:4 title "44745_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44615.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44615_1.025.dat" using 3:4 title "44615_1.025" with linespoints linewidth 0.5, \
"coef_44615_1.0225.dat" using 3:4 title "44615_1.0225" with linespoints linewidth 0.5, \
"coef_44615_1.02.dat" using 3:4 title "44615_1.02" with linespoints linewidth 0.5, \
"coef_44615_1.0175.dat" using 3:4 title "44615_1.0175" with linespoints linewidth 0.5, \
"coef_44615_1.015.dat" using 3:4 title "44615_1.015" with linespoints linewidth 0.5, \
"coef_44615_1.0125.dat" using 3:4 title "44615_1.0125" with linespoints linewidth 0.5, \
"coef_44615_1.01.dat" using 3:4 title "44615_1.01" with linespoints linewidth 0.5, \
"coef_44615_1.0075.dat" using 3:4 title "44615_1.0075" with linespoints linewidth 0.5, \
"coef_44615_1.005.dat" using 3:4 title "44615_1.005" with linespoints linewidth 0.5, \
"coef_44615_1.0025.dat" using 3:4 title "44615_1.0025" with linespoints linewidth 0.5, \
"coef_44615_1.dat" using 3:4 title "44615_1" with linespoints linewidth 2, \
"coef_44615_0.9975.dat" using 3:4 title "44615_0.9975" with linespoints linewidth 0.5, \
"coef_44615_0.995.dat" using 3:4 title "44615_0.995" with linespoints linewidth 0.5, \
"coef_44615_0.9925.dat" using 3:4 title "44615_0.9925" with linespoints linewidth 0.5, \
"coef_44615_0.99.dat" using 3:4 title "44615_0.99" with linespoints linewidth 0.5, \
"coef_44615_0.9875.dat" using 3:4 title "44615_0.9875" with linespoints linewidth 0.5, \
"coef_44615_0.985.dat" using 3:4 title "44615_0.985" with linespoints linewidth 0.5, \
"coef_44615_0.9825.dat" using 3:4 title "44615_0.9825" with linespoints linewidth 0.5, \
"coef_44615_0.98.dat" using 3:4 title "44615_0.98" with linespoints linewidth 0.5, \
"coef_44615_0.9775.dat" using 3:4 title "44615_0.9775" with linespoints linewidth 0.5, \
"coef_44615_0.975.dat" using 3:4 title "44615_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44421.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44421_1.025.dat" using 3:4 title "44421_1.025" with linespoints linewidth 0.5, \
"coef_44421_1.0225.dat" using 3:4 title "44421_1.0225" with linespoints linewidth 0.5, \
"coef_44421_1.02.dat" using 3:4 title "44421_1.02" with linespoints linewidth 0.5, \
"coef_44421_1.0175.dat" using 3:4 title "44421_1.0175" with linespoints linewidth 0.5, \
"coef_44421_1.015.dat" using 3:4 title "44421_1.015" with linespoints linewidth 0.5, \
"coef_44421_1.0125.dat" using 3:4 title "44421_1.0125" with linespoints linewidth 0.5, \
"coef_44421_1.01.dat" using 3:4 title "44421_1.01" with linespoints linewidth 0.5, \
"coef_44421_1.0075.dat" using 3:4 title "44421_1.0075" with linespoints linewidth 0.5, \
"coef_44421_1.005.dat" using 3:4 title "44421_1.005" with linespoints linewidth 0.5, \
"coef_44421_1.0025.dat" using 3:4 title "44421_1.0025" with linespoints linewidth 0.5, \
"coef_44421_1.dat" using 3:4 title "44421_1" with linespoints linewidth 2, \
"coef_44421_0.9975.dat" using 3:4 title "44421_0.9975" with linespoints linewidth 0.5, \
"coef_44421_0.995.dat" using 3:4 title "44421_0.995" with linespoints linewidth 0.5, \
"coef_44421_0.9925.dat" using 3:4 title "44421_0.9925" with linespoints linewidth 0.5, \
"coef_44421_0.99.dat" using 3:4 title "44421_0.99" with linespoints linewidth 0.5, \
"coef_44421_0.9875.dat" using 3:4 title "44421_0.9875" with linespoints linewidth 0.5, \
"coef_44421_0.985.dat" using 3:4 title "44421_0.985" with linespoints linewidth 0.5, \
"coef_44421_0.9825.dat" using 3:4 title "44421_0.9825" with linespoints linewidth 0.5, \
"coef_44421_0.98.dat" using 3:4 title "44421_0.98" with linespoints linewidth 0.5, \
"coef_44421_0.9775.dat" using 3:4 title "44421_0.9775" with linespoints linewidth 0.5, \
"coef_44421_0.975.dat" using 3:4 title "44421_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_44129.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_44129_1.025.dat" using 3:4 title "44129_1.025" with linespoints linewidth 0.5, \
"coef_44129_1.0225.dat" using 3:4 title "44129_1.0225" with linespoints linewidth 0.5, \
"coef_44129_1.02.dat" using 3:4 title "44129_1.02" with linespoints linewidth 0.5, \
"coef_44129_1.0175.dat" using 3:4 title "44129_1.0175" with linespoints linewidth 0.5, \
"coef_44129_1.015.dat" using 3:4 title "44129_1.015" with linespoints linewidth 0.5, \
"coef_44129_1.0125.dat" using 3:4 title "44129_1.0125" with linespoints linewidth 0.5, \
"coef_44129_1.01.dat" using 3:4 title "44129_1.01" with linespoints linewidth 0.5, \
"coef_44129_1.0075.dat" using 3:4 title "44129_1.0075" with linespoints linewidth 0.5, \
"coef_44129_1.005.dat" using 3:4 title "44129_1.005" with linespoints linewidth 0.5, \
"coef_44129_1.0025.dat" using 3:4 title "44129_1.0025" with linespoints linewidth 0.5, \
"coef_44129_1.dat" using 3:4 title "44129_1" with linespoints linewidth 2, \
"coef_44129_0.9975.dat" using 3:4 title "44129_0.9975" with linespoints linewidth 0.5, \
"coef_44129_0.995.dat" using 3:4 title "44129_0.995" with linespoints linewidth 0.5, \
"coef_44129_0.9925.dat" using 3:4 title "44129_0.9925" with linespoints linewidth 0.5, \
"coef_44129_0.99.dat" using 3:4 title "44129_0.99" with linespoints linewidth 0.5, \
"coef_44129_0.9875.dat" using 3:4 title "44129_0.9875" with linespoints linewidth 0.5, \
"coef_44129_0.985.dat" using 3:4 title "44129_0.985" with linespoints linewidth 0.5, \
"coef_44129_0.9825.dat" using 3:4 title "44129_0.9825" with linespoints linewidth 0.5, \
"coef_44129_0.98.dat" using 3:4 title "44129_0.98" with linespoints linewidth 0.5, \
"coef_44129_0.9775.dat" using 3:4 title "44129_0.9775" with linespoints linewidth 0.5, \
"coef_44129_0.975.dat" using 3:4 title "44129_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_43691.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_43691_1.025.dat" using 3:4 title "43691_1.025" with linespoints linewidth 0.5, \
"coef_43691_1.0225.dat" using 3:4 title "43691_1.0225" with linespoints linewidth 0.5, \
"coef_43691_1.02.dat" using 3:4 title "43691_1.02" with linespoints linewidth 0.5, \
"coef_43691_1.0175.dat" using 3:4 title "43691_1.0175" with linespoints linewidth 0.5, \
"coef_43691_1.015.dat" using 3:4 title "43691_1.015" with linespoints linewidth 0.5, \
"coef_43691_1.0125.dat" using 3:4 title "43691_1.0125" with linespoints linewidth 0.5, \
"coef_43691_1.01.dat" using 3:4 title "43691_1.01" with linespoints linewidth 0.5, \
"coef_43691_1.0075.dat" using 3:4 title "43691_1.0075" with linespoints linewidth 0.5, \
"coef_43691_1.005.dat" using 3:4 title "43691_1.005" with linespoints linewidth 0.5, \
"coef_43691_1.0025.dat" using 3:4 title "43691_1.0025" with linespoints linewidth 0.5, \
"coef_43691_1.dat" using 3:4 title "43691_1" with linespoints linewidth 2, \
"coef_43691_0.9975.dat" using 3:4 title "43691_0.9975" with linespoints linewidth 0.5, \
"coef_43691_0.995.dat" using 3:4 title "43691_0.995" with linespoints linewidth 0.5, \
"coef_43691_0.9925.dat" using 3:4 title "43691_0.9925" with linespoints linewidth 0.5, \
"coef_43691_0.99.dat" using 3:4 title "43691_0.99" with linespoints linewidth 0.5, \
"coef_43691_0.9875.dat" using 3:4 title "43691_0.9875" with linespoints linewidth 0.5, \
"coef_43691_0.985.dat" using 3:4 title "43691_0.985" with linespoints linewidth 0.5, \
"coef_43691_0.9825.dat" using 3:4 title "43691_0.9825" with linespoints linewidth 0.5, \
"coef_43691_0.98.dat" using 3:4 title "43691_0.98" with linespoints linewidth 0.5, \
"coef_43691_0.9775.dat" using 3:4 title "43691_0.9775" with linespoints linewidth 0.5, \
"coef_43691_0.975.dat" using 3:4 title "43691_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_43034.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_43034_1.025.dat" using 3:4 title "43034_1.025" with linespoints linewidth 0.5, \
"coef_43034_1.0225.dat" using 3:4 title "43034_1.0225" with linespoints linewidth 0.5, \
"coef_43034_1.02.dat" using 3:4 title "43034_1.02" with linespoints linewidth 0.5, \
"coef_43034_1.0175.dat" using 3:4 title "43034_1.0175" with linespoints linewidth 0.5, \
"coef_43034_1.015.dat" using 3:4 title "43034_1.015" with linespoints linewidth 0.5, \
"coef_43034_1.0125.dat" using 3:4 title "43034_1.0125" with linespoints linewidth 0.5, \
"coef_43034_1.01.dat" using 3:4 title "43034_1.01" with linespoints linewidth 0.5, \
"coef_43034_1.0075.dat" using 3:4 title "43034_1.0075" with linespoints linewidth 0.5, \
"coef_43034_1.005.dat" using 3:4 title "43034_1.005" with linespoints linewidth 0.5, \
"coef_43034_1.0025.dat" using 3:4 title "43034_1.0025" with linespoints linewidth 0.5, \
"coef_43034_1.dat" using 3:4 title "43034_1" with linespoints linewidth 2, \
"coef_43034_0.9975.dat" using 3:4 title "43034_0.9975" with linespoints linewidth 0.5, \
"coef_43034_0.995.dat" using 3:4 title "43034_0.995" with linespoints linewidth 0.5, \
"coef_43034_0.9925.dat" using 3:4 title "43034_0.9925" with linespoints linewidth 0.5, \
"coef_43034_0.99.dat" using 3:4 title "43034_0.99" with linespoints linewidth 0.5, \
"coef_43034_0.9875.dat" using 3:4 title "43034_0.9875" with linespoints linewidth 0.5, \
"coef_43034_0.985.dat" using 3:4 title "43034_0.985" with linespoints linewidth 0.5, \
"coef_43034_0.9825.dat" using 3:4 title "43034_0.9825" with linespoints linewidth 0.5, \
"coef_43034_0.98.dat" using 3:4 title "43034_0.98" with linespoints linewidth 0.5, \
"coef_43034_0.9775.dat" using 3:4 title "43034_0.9775" with linespoints linewidth 0.5, \
"coef_43034_0.975.dat" using 3:4 title "43034_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_42049.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_42049_1.025.dat" using 3:4 title "42049_1.025" with linespoints linewidth 0.5, \
"coef_42049_1.0225.dat" using 3:4 title "42049_1.0225" with linespoints linewidth 0.5, \
"coef_42049_1.02.dat" using 3:4 title "42049_1.02" with linespoints linewidth 0.5, \
"coef_42049_1.0175.dat" using 3:4 title "42049_1.0175" with linespoints linewidth 0.5, \
"coef_42049_1.015.dat" using 3:4 title "42049_1.015" with linespoints linewidth 0.5, \
"coef_42049_1.0125.dat" using 3:4 title "42049_1.0125" with linespoints linewidth 0.5, \
"coef_42049_1.01.dat" using 3:4 title "42049_1.01" with linespoints linewidth 0.5, \
"coef_42049_1.0075.dat" using 3:4 title "42049_1.0075" with linespoints linewidth 0.5, \
"coef_42049_1.005.dat" using 3:4 title "42049_1.005" with linespoints linewidth 0.5, \
"coef_42049_1.0025.dat" using 3:4 title "42049_1.0025" with linespoints linewidth 0.5, \
"coef_42049_1.dat" using 3:4 title "42049_1" with linespoints linewidth 2, \
"coef_42049_0.9975.dat" using 3:4 title "42049_0.9975" with linespoints linewidth 0.5, \
"coef_42049_0.995.dat" using 3:4 title "42049_0.995" with linespoints linewidth 0.5, \
"coef_42049_0.9925.dat" using 3:4 title "42049_0.9925" with linespoints linewidth 0.5, \
"coef_42049_0.99.dat" using 3:4 title "42049_0.99" with linespoints linewidth 0.5, \
"coef_42049_0.9875.dat" using 3:4 title "42049_0.9875" with linespoints linewidth 0.5, \
"coef_42049_0.985.dat" using 3:4 title "42049_0.985" with linespoints linewidth 0.5, \
"coef_42049_0.9825.dat" using 3:4 title "42049_0.9825" with linespoints linewidth 0.5, \
"coef_42049_0.98.dat" using 3:4 title "42049_0.98" with linespoints linewidth 0.5, \
"coef_42049_0.9775.dat" using 3:4 title "42049_0.9775" with linespoints linewidth 0.5, \
"coef_42049_0.975.dat" using 3:4 title "42049_0.975" with linespoints linewidth 0.5
EOF


gnuplot <<EOF
set terminal svg
set output "urandom_2TRL_40571.svg"
set grid
set title "urandom_2TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_1_RD.dat" using 2:3 title "CONSTANTES" with lines linewidth 2, \
"coef_L1.dat" using 3:4 title "L1" with lines linewidth 2, \
"coef_40571_1.025.dat" using 3:4 title "40571_1.025" with linespoints linewidth 0.5, \
"coef_40571_1.0225.dat" using 3:4 title "40571_1.0225" with linespoints linewidth 0.5, \
"coef_40571_1.02.dat" using 3:4 title "40571_1.02" with linespoints linewidth 0.5, \
"coef_40571_1.0175.dat" using 3:4 title "40571_1.0175" with linespoints linewidth 0.5, \
"coef_40571_1.015.dat" using 3:4 title "40571_1.015" with linespoints linewidth 0.5, \
"coef_40571_1.0125.dat" using 3:4 title "40571_1.0125" with linespoints linewidth 0.5, \
"coef_40571_1.01.dat" using 3:4 title "40571_1.01" with linespoints linewidth 0.5, \
"coef_40571_1.0075.dat" using 3:4 title "40571_1.0075" with linespoints linewidth 0.5, \
"coef_40571_1.005.dat" using 3:4 title "40571_1.005" with linespoints linewidth 0.5, \
"coef_40571_1.0025.dat" using 3:4 title "40571_1.0025" with linespoints linewidth 0.5, \
"coef_40571_1.dat" using 3:4 title "40571_1" with linespoints linewidth 2, \
"coef_40571_0.9975.dat" using 3:4 title "40571_0.9975" with linespoints linewidth 0.5, \
"coef_40571_0.995.dat" using 3:4 title "40571_0.995" with linespoints linewidth 0.5, \
"coef_40571_0.9925.dat" using 3:4 title "40571_0.9925" with linespoints linewidth 0.5, \
"coef_40571_0.99.dat" using 3:4 title "40571_0.99" with linespoints linewidth 0.5, \
"coef_40571_0.9875.dat" using 3:4 title "40571_0.9875" with linespoints linewidth 0.5, \
"coef_40571_0.985.dat" using 3:4 title "40571_0.985" with linespoints linewidth 0.5, \
"coef_40571_0.9825.dat" using 3:4 title "40571_0.9825" with linespoints linewidth 0.5, \
"coef_40571_0.98.dat" using 3:4 title "40571_0.98" with linespoints linewidth 0.5, \
"coef_40571_0.9775.dat" using 3:4 title "40571_0.9775" with linespoints linewidth 0.5, \
"coef_40571_0.975.dat" using 3:4 title "40571_0.975" with linespoints linewidth 0.5
EOF
