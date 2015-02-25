set grid
set title "crew CIF - m=motion h=texture"
set xlabel "bit-rate"
set ylabel "RMSE"
set logscale x
plot "coef_constantes.dat"  using 5:6 title "constantes"  with linespoints linewidth 2, \
"coef_L.dat"  using 5:6 title "L"  with linespoints linewidth 2, \
"coef__.dat" using 5:6 title "sin nada" with linespoints linewidth 1, \
"coef_h3.dat" using 5:6 title "h3" with linespoints linewidth 1, \
"coef_h3_h2.dat" using 5:6 title "h3_h2" with linespoints linewidth 1, \
"coef_h3_h2_h1.dat" using 5:6 title "h3_h2_h1" with linespoints linewidth 1, \
"coef_m3.dat" using 5:6 title "m3" with linespoints linewidth 1, \
"coef_m3h3.dat" using 5:6 title "m3h3" with linespoints linewidth 1, \
"coef_m3h3_m2.dat" using 5:6 title "m3h3_m2" with linespoints linewidth 1, \
"coef_m3h3_h2.dat" using 5:6 title "m3h3_h2" with linespoints linewidth 1, \
"coef_m3h3_m2h2.dat" using 5:6 title "m3h3_m2h2" with linespoints linewidth 1, \
"coef_m3h3_m2h2_m1.dat" using 5:6 title "m3h3_m2h2_m1" with linespoints linewidth 1, \
"coef_m3h3_m2h2_h1.dat" using 5:6 title "m3h3_m2h2_h1" with linespoints linewidth 1, \
"coef_m3h3_m2h2_m1h1.dat" using 5:6 title "m3h3_m2h2_m1h1" with linespoints linewidth 1
