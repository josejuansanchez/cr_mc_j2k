set grid
set title "container CIF - m=motion h=texture"
set xlabel "bit-rate"
set ylabel "RMSE"
plot "coef_constantes.dat" using 6:7 title "constantes"  with linespoints linewidth 2, \
"coef_L.dat" using 6:7 title "L"  with linespoints linewidth 2, \
"coef__.dat" using 6:7 title "sin nada" with linespoints linewidth 1, \
"coef_m4.dat" using 6:7 title "m4" with linespoints linewidth 1, \
"coef_m4_m3.dat" using 6:7 title "m4_m3" with linespoints linewidth 1, \
"coef_m4_m3_m2.dat" using 6:7 title "m4_m3_m2" with linespoints linewidth 1, \
"coef_m4_m3_m2_m1.dat" using 6:7 title "m4_m3_m2_m1" with linespoints linewidth 1, \
"coef_h4.dat" using 6:7 title "h4" with linespoints linewidth 1, \
"coef_h4_h3.dat" using 6:7 title "h4_h3" with linespoints linewidth 1, \
"coef_h4_h3_h2.dat" using 6:7 title "h4_h3_h2" with linespoints linewidth 1, \
"coef_h4_h3_h2_h1.dat" using 6:7 title "h4_h3_h2_h1" with linespoints linewidth 1, \
"coef_m4h4.dat" using 6:7 title "m4h4" with linespoints linewidth 1, \
"coef_m4h4_m3.dat" using 6:7 title "m4h4_m3" with linespoints linewidth 1, \
"coef_m4h4_h3.dat" using 6:7 title "m4h4_h3" with linespoints linewidth 1, \
"coef_m4h4_m3h3.dat" using 6:7 title "m4h4_m3h3" with linespoints linewidth 1, \
"coef_m4h4_m3h3_m2.dat" using 6:7 title "m4h4_m3h3_m2" with linespoints linewidth 1, \
"coef_m4h4_m3h3_h2.dat" using 6:7 title "m4h4_m3h3_h2" with linespoints linewidth 1, \
"coef_m4h4_m3h3_m2h2.dat" using 6:7 title "m4h4_m3h3_m2h2" with linespoints linewidth 1, \
"coef_m4h4_m3h3_m2h2_m1.dat" using 6:7 title "m4h4_m3h3_m2h2_m1" with linespoints linewidth 1, \
"coef_m4h4_m3h3_m2h2_h1.dat" using 6:7 title "m4h4_m3h3_m2h2_h1" with linespoints linewidth 1, \
"coef_m4h4_m3h3_m2h2_m1h1.dat" using 6:7 title "m4h4_m3h3_m2h2_m1h1" with linespoints linewidth 1
