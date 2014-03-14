#!/bin/bash

set -x

rm RD_jpg.dat
rm *motion*
mcjpg compress --slopes="31" --pictures=257
rm -rf tmp
mkdir tmp
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

mcjpg compress --slopes="25" --pictures=257
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

mcjpg compress --slopes="20" --pictures=257
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

mcjpg compress --slopes="15" --pictures=257
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

mcjpg compress --slopes="5" --pictures=257
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

mcjpg compress --slopes="1" --pictures=257
cp *.mjc *.mjpeg *type* tmp
cd tmp
mcjpg expand --pictures=257
cd ..
RMSE=`snr --file_A=low_0 --file_B=tmp/low_0 2> /dev/null | grep RMSE | cut -f 3`
rate=`mcjpg info --pictures=257 | grep "Total average:" | cut -d " " -f 3`
echo $rate $RMSE >> RD_jpg.dat

#echo 'set terminal svg; set output "RD_jpg.svg"; set yrange [0:]; set xrange[0:]; plot "RD_jpg.dat" smooth bezier' | gnuplot
echo 'set terminal svg; set output "RD_jpg.svg"; set yrange [0:]; set xrange[0:]; plot "RD_jpg.dat" with linespoints' | gnuplot
