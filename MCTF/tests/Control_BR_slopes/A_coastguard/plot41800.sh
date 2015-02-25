set output "PLOT_container_5TRL_41800.svg"
set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 5:6 title "constantes"  with linespoints linewidth 2, \
"coef_L.dat"  using 5:6 title "L"  with linespoints linewidth 2, \
"coef_41800_1.02.dat" using 5:6 title "1.02" with linespoints linewidth 1, \
"coef_41800_1.01.dat" using 5:6 title "1.01" with linespoints linewidth 1, \
"coef_41800_1.0075.dat" using 5:6 title "1.0075" with linespoints linewidth 1, \
"coef_41800_1.005.dat" using 5:6 title "1.005" with linespoints linewidth 1, \
"coef_41800_1.0025.dat" using 5:6 title "1.0025" with linespoints linewidth 1, \
"coef_41800_0.999.dat" using 5:6 title "0.999" with linespoints linewidth 1, \
"coef_41800_0.998.dat" using 5:6 title "0.998" with linespoints linewidth 1, \
"coef_41800_0.997.dat" using 5:6 title "0.997" with linespoints linewidth 1, \
"coef_41800_0.996.dat" using 5:6 title "0.996" with linespoints linewidth 1, \
"coef_41800_0.995.dat" using 5:6 title "0.995" with linespoints linewidth 1, \
"coef_41800_0.994.dat" using 5:6 title "0.994" with linespoints linewidth 1, \
"coef_41800_0.993.dat" using 5:6 title "0.993" with linespoints linewidth 1, \
"coef_41800_0.992.dat" using 5:6 title "0.992" with linespoints linewidth 1, \
"coef_41800_0.991.dat" using 5:6 title "0.991" with linespoints linewidth 1, \
"coef_41800_0.99.dat" using 5:6 title "0.99" with linespoints linewidth 1, \
"coef_41800_0.9875.dat" using 5:6 title "0.9875" with linespoints linewidth 1, \
"coef_41800_0.985.dat" using 5:6 title "0.985" with linespoints linewidth 1, \
"coef_41800_0.9825.dat" using 5:6 title "0.9825" with linespoints linewidth 1, \
"coef_41800_0.98.dat" using 5:6 title "0.98" with linespoints linewidth 1, \
"coef_41800_1.02_0.0005.dat" using 5:6 title "1.02_0.0005" with linespoints linewidth 1, \
"coef_41800_1.01_0.0005.dat" using 5:6 title "1.01_0.0005" with linespoints linewidth 1, \
"coef_41800_1.0075_0.0005.dat" using 5:6 title "1.0075_0.0005" with linespoints linewidth 1, \
"coef_41800_1.005_0.0005.dat" using 5:6 title "1.005_0.0005" with linespoints linewidth 1, \
"coef_41800_1.0025_0.0005.dat" using 5:6 title "1.0025_0.0005" with linespoints linewidth 1, \
"coef_41800_0.999_0.0005.dat" using 5:6 title "0.999_0.0005" with linespoints linewidth 1, \
"coef_41800_0.998_0.0005.dat" using 5:6 title "0.998_0.0005" with linespoints linewidth 1, \
"coef_41800_0.997_0.0005.dat" using 5:6 title "0.997_0.0005" with linespoints linewidth 1, \
"coef_41800_0.996_0.0005.dat" using 5:6 title "0.996_0.0005" with linespoints linewidth 1, \
"coef_41800_0.995_0.0005.dat" using 5:6 title "0.995_0.0005" with linespoints linewidth 1, \
"coef_41800_0.994_0.0005.dat" using 5:6 title "0.994_0.0005" with linespoints linewidth 1, \
"coef_41800_0.993_0.0005.dat" using 5:6 title "0.993_0.0005" with linespoints linewidth 1, \
"coef_41800_0.992_0.0005.dat" using 5:6 title "0.992_0.0005" with linespoints linewidth 1, \
"coef_41800_0.991_0.0005.dat" using 5:6 title "0.991_0.0005" with linespoints linewidth 1, \
"coef_41800_0.99_0.0005.dat" using 5:6 title "0.99_0.0005" with linespoints linewidth 1, \
"coef_41800_0.9875_0.0005.dat" using 5:6 title "0.9875_0.0005" with linespoints linewidth 1, \
"coef_41800_0.985_0.0005.dat" using 5:6 title "0.985_0.0005" with linespoints linewidth 1, \
"coef_41800_0.9825_0.0005.dat" using 5:6 title "0.9825_0.0005" with linespoints linewidth 1, \
"coef_41800_0.98_0.0005.dat" using 5:6 title "0.98_0.0005" with linespoints linewidth 1, \
"coef_41800_1.02_0.001.dat" using 5:6 title "1.02_0.001" with linespoints linewidth 1, \
"coef_41800_1.01_0.001.dat" using 5:6 title "1.01_0.001" with linespoints linewidth 1, \
"coef_41800_1.0075_0.001.dat" using 5:6 title "1.0075_0.001" with linespoints linewidth 1, \
"coef_41800_1.005_0.001.dat" using 5:6 title "1.005_0.001" with linespoints linewidth 1, \
"coef_41800_1.0025_0.001.dat" using 5:6 title "1.0025_0.001" with linespoints linewidth 1, \
"coef_41800_0.999_0.001.dat" using 5:6 title "0.999_0.001" with linespoints linewidth 1, \
"coef_41800_0.998_0.001.dat" using 5:6 title "0.998_0.001" with linespoints linewidth 1, \
"coef_41800_0.997_0.001.dat" using 5:6 title "0.997_0.001" with linespoints linewidth 1, \
"coef_41800_0.996_0.001.dat" using 5:6 title "0.996_0.001" with linespoints linewidth 1, \
"coef_41800_0.995_0.001.dat" using 5:6 title "0.995_0.001" with linespoints linewidth 1, \
"coef_41800_0.994_0.001.dat" using 5:6 title "0.994_0.001" with linespoints linewidth 1, \
"coef_41800_0.993_0.001.dat" using 5:6 title "0.993_0.001" with linespoints linewidth 1, \
"coef_41800_0.992_0.001.dat" using 5:6 title "0.992_0.001" with linespoints linewidth 1, \
"coef_41800_0.991_0.001.dat" using 5:6 title "0.991_0.001" with linespoints linewidth 1, \
"coef_41800_0.99_0.001.dat" using 5:6 title "0.99_0.001" with linespoints linewidth 1, \
"coef_41800_0.9875_0.001.dat" using 5:6 title "0.9875_0.001" with linespoints linewidth 1, \
"coef_41800_0.985_0.001.dat" using 5:6 title "0.985_0.001" with linespoints linewidth 1, \
"coef_41800_0.9825_0.001.dat" using 5:6 title "0.9825_0.001" with linespoints linewidth 1, \
"coef_41800_0.98_0.001.dat" using 5:6 title "0.98_0.001" with linespoints linewidth 1, \
"coef_41800_1.02_0.002.dat" using 5:6 title "1.02_0.002" with linespoints linewidth 1, \
"coef_41800_1.01_0.002.dat" using 5:6 title "1.01_0.002" with linespoints linewidth 1, \
"coef_41800_1.0075_0.002.dat" using 5:6 title "1.0075_0.002" with linespoints linewidth 1, \
"coef_41800_1.005_0.002.dat" using 5:6 title "1.005_0.002" with linespoints linewidth 1, \
"coef_41800_1.0025_0.002.dat" using 5:6 title "1.0025_0.002" with linespoints linewidth 1, \
"coef_41800_0.999_0.002.dat" using 5:6 title "0.999_0.002" with linespoints linewidth 1, \
"coef_41800_0.998_0.002.dat" using 5:6 title "0.998_0.002" with linespoints linewidth 1, \
"coef_41800_0.997_0.002.dat" using 5:6 title "0.997_0.002" with linespoints linewidth 1, \
"coef_41800_0.996_0.002.dat" using 5:6 title "0.996_0.002" with linespoints linewidth 1, \
"coef_41800_0.995_0.002.dat" using 5:6 title "0.995_0.002" with linespoints linewidth 1, \
"coef_41800_0.994_0.002.dat" using 5:6 title "0.994_0.002" with linespoints linewidth 1, \
"coef_41800_0.993_0.002.dat" using 5:6 title "0.993_0.002" with linespoints linewidth 1, \
"coef_41800_0.992_0.002.dat" using 5:6 title "0.992_0.002" with linespoints linewidth 1, \
"coef_41800_0.991_0.002.dat" using 5:6 title "0.991_0.002" with linespoints linewidth 1, \
"coef_41800_0.99_0.002.dat" using 5:6 title "0.99_0.002" with linespoints linewidth 1, \
"coef_41800_0.9875_0.002.dat" using 5:6 title "0.9875_0.002" with linespoints linewidth 1, \
"coef_41800_0.985_0.002.dat" using 5:6 title "0.985_0.002" with linespoints linewidth 1, \
"coef_41800_0.9825_0.002.dat" using 5:6 title "0.9825_0.002" with linespoints linewidth 1, \
"coef_41800_0.98_0.002.dat" using 5:6 title "0.98_0.002" with linespoints linewidth 1

