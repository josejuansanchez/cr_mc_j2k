#!/bin/bash

set -x

rm RD_j2k.dat
rm *motion*
mcj2k compress --slopes="44500" --pictures=257
rm -rf tmp
mkdir tmp
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

mcj2k compress --slopes="44000" --pictures=257
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

mcj2k compress --slopes="43400" --pictures=257
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

mcj2k compress --slopes="43000" --pictures=257
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

mcj2k compress --slopes="42000" --pictures=257
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

mcj2k compress --slopes="40000" --pictures=257
cp *.mjc *type* tmp
cd tmp
mcj2k expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcj2k info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_j2k.dat

#echo 'set terminal svg; set output "RD_j2k.svg"; set yrange [0:]; set xrange[0:]; plot "RD_j2k.dat" smooth bezier' | gnuplot
echo 'set terminal svg; set output "RD_j2k.svg"; set yrange [0:]; set xrange[0:]; plot "RD_j2k.dat" with linespoints' | gnuplot
