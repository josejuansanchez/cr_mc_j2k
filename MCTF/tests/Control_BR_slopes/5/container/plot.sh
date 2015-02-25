#set terminal svg
#set output "1.svg"
#---------------------------
#set terminal fig color solid
#set output "1.fig"


# PLOT


#
gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_45000.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_45000_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_45000_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_45000_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_45000_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_45000_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_45000_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_45000_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_45000_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_45000_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_45000_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_45000_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_45000_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_45000_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_45000_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_45000_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_45000_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_45000_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_45000_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_45000_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_45000_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_45000_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_45000_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_45000_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_45000_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_45000_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_45000_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_45000_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_45000_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_45000_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_45000_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_45000_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_45000_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_45000_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_45000_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_45000_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_45000_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_45000_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_45000_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_45000_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_45000_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_45000_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_45000_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_45000_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_44800.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_44800_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_44800_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_44800_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_44800_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_44800_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_44800_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_44800_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_44800_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_44800_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_44800_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_44800_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_44800_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_44800_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_44800_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_44800_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_44800_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_44800_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_44800_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_44800_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_44800_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_44800_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_44800_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_44800_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_44800_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_44800_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_44800_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_44800_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_44800_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_44800_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_44800_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_44800_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_44800_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_44800_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_44800_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_44800_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_44800_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_44800_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_44800_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_44800_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_44800_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_44800_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_44800_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_44800_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_44600.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_44600_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_44600_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_44600_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_44600_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_44600_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_44600_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_44600_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_44600_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_44600_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_44600_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_44600_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_44600_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_44600_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_44600_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_44600_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_44600_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_44600_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_44600_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_44600_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_44600_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_44600_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_44600_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_44600_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_44600_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_44600_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_44600_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_44600_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_44600_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_44600_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_44600_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_44600_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_44600_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_44600_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_44600_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_44600_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_44600_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_44600_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_44600_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_44600_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_44600_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_44600_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_44600_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_44600_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_44300.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_44300_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_44300_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_44300_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_44300_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_44300_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_44300_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_44300_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_44300_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_44300_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_44300_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_44300_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_44300_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_44300_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_44300_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_44300_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_44300_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_44300_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_44300_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_44300_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_44300_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_44300_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_44300_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_44300_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_44300_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_44300_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_44300_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_44300_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_44300_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_44300_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_44300_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_44300_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_44300_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_44300_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_44300_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_44300_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_44300_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_44300_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_44300_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_44300_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_44300_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_44300_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_44300_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_44300_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_44000.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_44000_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_44000_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_44000_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_44000_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_44000_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_44000_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_44000_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_44000_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_44000_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_44000_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_44000_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_44000_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_44000_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_44000_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_44000_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_44000_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_44000_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_44000_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_44000_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_44000_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_44000_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_44000_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_44000_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_44000_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_44000_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_44000_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_44000_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_44000_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_44000_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_44000_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_44000_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_44000_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_44000_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_44000_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_44000_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_44000_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_44000_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_44000_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_44000_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_44000_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_44000_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_44000_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_44000_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_43700.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_43700_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_43700_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_43700_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_43700_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_43700_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_43700_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_43700_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_43700_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_43700_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_43700_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_43700_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_43700_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_43700_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_43700_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_43700_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_43700_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_43700_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_43700_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_43700_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_43700_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_43700_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_43700_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_43700_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_43700_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_43700_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_43700_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_43700_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_43700_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_43700_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_43700_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_43700_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_43700_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_43700_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_43700_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_43700_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_43700_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_43700_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_43700_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_43700_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_43700_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_43700_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_43700_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_43700_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_43400.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_43400_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_43400_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_43400_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_43400_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_43400_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_43400_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_43400_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_43400_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_43400_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_43400_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_43400_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_43400_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_43400_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_43400_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_43400_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_43400_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_43400_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_43400_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_43400_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_43400_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_43400_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_43400_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_43400_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_43400_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_43400_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_43400_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_43400_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_43400_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_43400_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_43400_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_43400_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_43400_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_43400_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_43400_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_43400_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_43400_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_43400_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_43400_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_43400_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_43400_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_43400_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_43400_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_43400_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_43100.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_43100_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_43100_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_43100_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_43100_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_43100_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_43100_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_43100_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_43100_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_43100_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_43100_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_43100_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_43100_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_43100_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_43100_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_43100_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_43100_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_43100_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_43100_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_43100_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_43100_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_43100_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_43100_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_43100_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_43100_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_43100_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_43100_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_43100_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_43100_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_43100_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_43100_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_43100_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_43100_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_43100_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_43100_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_43100_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_43100_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_43100_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_43100_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_43100_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_43100_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_43100_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_43100_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_43100_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF




gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_42800.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_42800_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_42800_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_42800_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_42800_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_42800_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_42800_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_42800_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_42800_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_42800_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_42800_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_42800_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_42800_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_42800_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_42800_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_42800_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_42800_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_42800_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_42800_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_42800_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_42800_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_42800_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_42800_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_42800_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_42800_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_42800_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_42800_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_42800_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_42800_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_42800_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_42800_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_42800_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_42800_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_42800_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_42800_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_42800_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_42800_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_42800_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_42800_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_42800_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_42800_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_42800_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_42800_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_42800_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF




gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_42500.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_42500_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_42500_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_42500_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_42500_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_42500_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_42500_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_42500_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_42500_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_42500_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_42500_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_42500_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_42500_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_42500_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_42500_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_42500_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_42500_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_42500_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_42500_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_42500_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_42500_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_42500_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_42500_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_42500_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_42500_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_42500_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_42500_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_42500_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_42500_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_42500_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_42500_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_42500_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_42500_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_42500_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_42500_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_42500_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_42500_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_42500_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_42500_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_42500_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_42500_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_42500_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_42500_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_42500_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_42200.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_42200_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_42200_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_42200_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_42200_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_42200_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_42200_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_42200_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_42200_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_42200_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_42200_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_42200_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_42200_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_42200_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_42200_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_42200_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_42200_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_42200_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_42200_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_42200_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_42200_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_42200_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_42200_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_42200_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_42200_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_42200_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_42200_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_42200_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_42200_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_42200_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_42200_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_42200_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_42200_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_42200_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_42200_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_42200_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_42200_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_42200_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_42200_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_42200_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_42200_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_42200_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_42200_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_42200_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_41800.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_41800_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_41800_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_41800_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_41800_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_41800_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_41800_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_41800_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_41800_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_41800_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_41800_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_41800_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_41800_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_41800_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_41800_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_41800_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_41800_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_41800_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_41800_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_41800_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_41800_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_41800_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_41800_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_41800_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_41800_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_41800_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_41800_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_41800_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_41800_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_41800_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_41800_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_41800_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_41800_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_41800_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_41800_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_41800_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_41800_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_41800_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_41800_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_41800_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_41800_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_41800_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_41800_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_41800_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_41400.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_41400_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_41400_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_41400_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_41400_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_41400_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_41400_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_41400_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_41400_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_41400_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_41400_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_41400_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_41400_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_41400_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_41400_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_41400_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_41400_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_41400_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_41400_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_41400_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_41400_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_41400_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_41400_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_41400_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_41400_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_41400_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_41400_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_41400_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_41400_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_41400_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_41400_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_41400_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_41400_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_41400_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_41400_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_41400_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_41400_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_41400_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_41400_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_41400_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_41400_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_41400_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_41400_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_41400_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_41000.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_41000_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_41000_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_41000_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_41000_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_41000_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_41000_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_41000_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_41000_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_41000_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_41000_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_41000_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_41000_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_41000_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_41000_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_41000_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_41000_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_41000_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_41000_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_41000_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_41000_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_41000_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_41000_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_41000_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_41000_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_41000_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_41000_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_41000_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_41000_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_41000_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_41000_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_41000_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_41000_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_41000_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_41000_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_41000_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_41000_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_41000_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_41000_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_41000_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_41000_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_41000_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_41000_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_41000_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_40500.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_40500_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_40500_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_40500_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_40500_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_40500_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_40500_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_40500_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_40500_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_40500_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_40500_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_40500_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_40500_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_40500_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_40500_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_40500_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_40500_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_40500_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_40500_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_40500_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_40500_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_40500_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_40500_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_40500_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_40500_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_40500_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_40500_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_40500_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_40500_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_40500_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_40500_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_40500_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_40500_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_40500_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_40500_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_40500_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_40500_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_40500_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_40500_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_40500_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_40500_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_40500_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_40500_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_40500_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF



gnuplot <<EOF
set terminal svg
set output "PLOT_container_5TRL_40000.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with lines linewidth 1, \
"coef_L.dat"  using 6:7 title "L"  with lines linewidth 1, \
"coef_40000_1.02.dat" using 6:7 title "1.02" with linespoints linewidth 0.5, \
"coef_40000_1.01.dat" using 6:7 title "1.01" with linespoints linewidth 0.5, \
"coef_40000_1.0075.dat" using 6:7 title "1.0075" with linespoints linewidth 0.5, \
"coef_40000_1.005.dat" using 6:7 title "1.005" with linespoints linewidth 0.5, \
"coef_40000_1.0025.dat" using 6:7 title "1.0025" with linespoints linewidth 0.5, \
"coef_40000_0.999.dat" using 6:7 title "0.999" with linespoints linewidth 0.5, \
"coef_40000_0.998.dat" using 6:7 title "0.998" with linespoints linewidth 0.5, \
"coef_40000_0.997.dat" using 6:7 title "0.997" with linespoints linewidth 0.5, \
"coef_40000_0.996.dat" using 6:7 title "0.996" with linespoints linewidth 0.5, \
"coef_40000_0.995.dat" using 6:7 title "0.995" with linespoints linewidth 0.5, \
"coef_40000_0.994.dat" using 6:7 title "0.994" with linespoints linewidth 0.5, \
"coef_40000_0.993.dat" using 6:7 title "0.993" with linespoints linewidth 0.5, \
"coef_40000_0.992.dat" using 6:7 title "0.992" with linespoints linewidth 0.5, \
"coef_40000_0.991.dat" using 6:7 title "0.991" with linespoints linewidth 0.5, \
"coef_40000_0.99.dat" using 6:7 title "0.99" with linespoints linewidth 0.5, \
"coef_40000_0.9875.dat" using 6:7 title "0.9875" with linespoints linewidth 0.5, \
"coef_40000_0.985.dat" using 6:7 title "0.985" with linespoints linewidth 0.5, \
"coef_40000_0.9825.dat" using 6:7 title "0.9825" with linespoints linewidth 0.5, \
"coef_40000_0.98.dat" using 6:7 title "0.98" with linespoints linewidth 0.5, \
"coef_40000_1.02_0.0005.dat" using 6:7 title "1.02_0.0005" with linespoints linewidth 0.5, \
"coef_40000_1.01_0.0005.dat" using 6:7 title "1.01_0.0005" with linespoints linewidth 0.5, \
"coef_40000_1.0075_0.0005.dat" using 6:7 title "1.0075_0.0005" with linespoints linewidth 0.5, \
"coef_40000_1.005_0.0005.dat" using 6:7 title "1.005_0.0005" with linespoints linewidth 0.5, \
"coef_40000_1.0025_0.0005.dat" using 6:7 title "1.0025_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.999_0.0005.dat" using 6:7 title "0.999_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.998_0.0005.dat" using 6:7 title "0.998_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.997_0.0005.dat" using 6:7 title "0.997_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.996_0.0005.dat" using 6:7 title "0.996_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.995_0.0005.dat" using 6:7 title "0.995_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.994_0.0005.dat" using 6:7 title "0.994_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.993_0.0005.dat" using 6:7 title "0.993_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.992_0.0005.dat" using 6:7 title "0.992_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.991_0.0005.dat" using 6:7 title "0.991_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.99_0.0005.dat" using 6:7 title "0.99_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.9875_0.0005.dat" using 6:7 title "0.9875_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.985_0.0005.dat" using 6:7 title "0.985_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.9825_0.0005.dat" using 6:7 title "0.9825_0.0005" with linespoints linewidth 0.5, \
"coef_40000_0.98_0.0005.dat" using 6:7 title "0.98_0.0005" with linespoints linewidth 0.5, \
"coef_40000_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 0.5, \
"coef_40000_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 0.5, \
"coef_40000_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 0.5, \
"coef_40000_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 0.5, \
"coef_40000_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 0.5, \
"coef_40000_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 0.5, \
"coef_40000_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 0.5, \
"coef_40000_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 0.5, \
"coef_40000_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 0.5, \
"coef_40000_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 0.5, \
"coef_40000_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 0.5, \
"coef_40000_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 0.5, \
"coef_40000_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 0.5, \
"coef_40000_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 0.5, \
"coef_40000_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 0.5, \
"coef_40000_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 0.5, \
"coef_40000_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 0.5, \
"coef_40000_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 0.2
EOF






