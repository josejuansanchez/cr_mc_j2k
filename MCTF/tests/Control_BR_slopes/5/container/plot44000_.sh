set grid
set title "container_5TRL - CURVA RD"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat"  using 6:7 title "constantes"  with linespoints linewidth 2, \
"coef_L.dat"  using 6:7 title "L"  with linespoints linewidth 2, \
"coef_44000_1.02_0.001.dat" using 6:7 title "1.02_0.001" with linespoints linewidth 1, \
"coef_44000_1.01_0.001.dat" using 6:7 title "1.01_0.001" with linespoints linewidth 1, \
"coef_44000_1.0075_0.001.dat" using 6:7 title "1.0075_0.001" with linespoints linewidth 1, \
"coef_44000_1.005_0.001.dat" using 6:7 title "1.005_0.001" with linespoints linewidth 1, \
"coef_44000_1.0025_0.001.dat" using 6:7 title "1.0025_0.001" with linespoints linewidth 1, \
"coef_44000_0.999_0.001.dat" using 6:7 title "0.999_0.001" with linespoints linewidth 1, \
"coef_44000_0.998_0.001.dat" using 6:7 title "0.998_0.001" with linespoints linewidth 1, \
"coef_44000_0.997_0.001.dat" using 6:7 title "0.997_0.001" with linespoints linewidth 1, \
"coef_44000_0.996_0.001.dat" using 6:7 title "0.996_0.001" with linespoints linewidth 1, \
"coef_44000_0.995_0.001.dat" using 6:7 title "0.995_0.001" with linespoints linewidth 1, \
"coef_44000_0.994_0.001.dat" using 6:7 title "0.994_0.001" with linespoints linewidth 1, \
"coef_44000_0.993_0.001.dat" using 6:7 title "0.993_0.001" with linespoints linewidth 1, \
"coef_44000_0.992_0.001.dat" using 6:7 title "0.992_0.001" with linespoints linewidth 1, \
"coef_44000_0.991_0.001.dat" using 6:7 title "0.991_0.001" with linespoints linewidth 1, \
"coef_44000_0.99_0.001.dat" using 6:7 title "0.99_0.001" with linespoints linewidth 1, \
"coef_44000_0.9875_0.001.dat" using 6:7 title "0.9875_0.001" with linespoints linewidth 1, \
"coef_44000_0.985_0.001.dat" using 6:7 title "0.985_0.001" with linespoints linewidth 1, \
"coef_44000_0.9825_0.001.dat" using 6:7 title "0.9825_0.001" with linespoints linewidth 1, \
"coef_44000_0.98_0.001.dat" using 6:7 title "0.98_0.001" with linespoints linewidth 1
#"coef_44000_1.02_0.002.dat" using 6:7 title "1.02_0.002" with linespoints linewidth 1, \
#"coef_44000_1.01_0.002.dat" using 6:7 title "1.01_0.002" with linespoints linewidth 1, \
#"coef_44000_1.0075_0.002.dat" using 6:7 title "1.0075_0.002" with linespoints linewidth 1, \
#"coef_44000_1.005_0.002.dat" using 6:7 title "1.005_0.002" with linespoints linewidth 1, \
#"coef_44000_1.0025_0.002.dat" using 6:7 title "1.0025_0.002" with linespoints linewidth 1, \
#"coef_44000_0.999_0.002.dat" using 6:7 title "0.999_0.002" with linespoints linewidth 1, \
#"coef_44000_0.998_0.002.dat" using 6:7 title "0.998_0.002" with linespoints linewidth 1, \
#"coef_44000_0.997_0.002.dat" using 6:7 title "0.997_0.002" with linespoints linewidth 1, \
#"coef_44000_0.996_0.002.dat" using 6:7 title "0.996_0.002" with linespoints linewidth 1, \
#"coef_44000_0.995_0.002.dat" using 6:7 title "0.995_0.002" with linespoints linewidth 1, \
#"coef_44000_0.994_0.002.dat" using 6:7 title "0.994_0.002" with linespoints linewidth 1, \
#"coef_44000_0.993_0.002.dat" using 6:7 title "0.993_0.002" with linespoints linewidth 1, \
#"coef_44000_0.992_0.002.dat" using 6:7 title "0.992_0.002" with linespoints linewidth 1, \
#"coef_44000_0.991_0.002.dat" using 6:7 title "0.991_0.002" with linespoints linewidth 1, \
#"coef_44000_0.99_0.002.dat" using 6:7 title "0.99_0.002" with linespoints linewidth 1, \
#"coef_44000_0.9875_0.002.dat" using 6:7 title "0.9875_0.002" with linespoints linewidth 1, \
#"coef_44000_0.985_0.002.dat" using 6:7 title "0.985_0.002" with linespoints linewidth 1, \
#"coef_44000_0.9825_0.002.dat" using 6:7 title "0.9825_0.002" with linespoints linewidth 1, \
#"coef_44000_0.98_0.002.dat" using 6:7 title "0.98_0.002" with linespoints linewidth 1, \
#"coef_44000_1.02_0.003.dat" using 6:7 title "1.02_0.003" with linespoints linewidth 1, \
#"coef_44000_1.01_0.003.dat" using 6:7 title "1.01_0.003" with linespoints linewidth 1, \
#"coef_44000_1.0075_0.003.dat" using 6:7 title "1.0075_0.003" with linespoints linewidth 1, \
#"coef_44000_1.005_0.003.dat" using 6:7 title "1.005_0.003" with linespoints linewidth 1, \
#"coef_44000_1.0025_0.003.dat" using 6:7 title "1.0025_0.003" with linespoints linewidth 1, \
#"coef_44000_0.999_0.003.dat" using 6:7 title "0.999_0.003" with linespoints linewidth 1, \
#"coef_44000_0.998_0.003.dat" using 6:7 title "0.998_0.003" with linespoints linewidth 1, \
#"coef_44000_0.997_0.003.dat" using 6:7 title "0.997_0.003" with linespoints linewidth 1, \
#"coef_44000_0.996_0.003.dat" using 6:7 title "0.996_0.003" with linespoints linewidth 1, \
#"coef_44000_0.995_0.003.dat" using 6:7 title "0.995_0.003" with linespoints linewidth 1, \
#"coef_44000_0.994_0.003.dat" using 6:7 title "0.994_0.003" with linespoints linewidth 1, \
#"coef_44000_0.993_0.003.dat" using 6:7 title "0.993_0.003" with linespoints linewidth 1, \
#"coef_44000_0.992_0.003.dat" using 6:7 title "0.992_0.003" with linespoints linewidth 1, \
#"coef_44000_0.991_0.003.dat" using 6:7 title "0.991_0.003" with linespoints linewidth 1, \
#"coef_44000_0.99_0.003.dat" using 6:7 title "0.99_0.003" with linespoints linewidth 1, \
#"coef_44000_0.9875_0.003.dat" using 6:7 title "0.9875_0.003" with linespoints linewidth 1, \
#"coef_44000_0.985_0.003.dat" using 6:7 title "0.985_0.003" with linespoints linewidth 1, \
#"coef_44000_0.9825_0.003.dat" using 6:7 title "0.9825_0.003" with linespoints linewidth 1, \
#"coef_44000_0.98_0.003.dat" using 6:7 title "0.98_0.003" with linespoints linewidth 1

