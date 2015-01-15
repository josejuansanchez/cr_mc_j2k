#!/bin/bash

X=4096
Y=4096
B=4 #16


./bin/suma -b $B -x $X -y $Y -f vectors/avg0002.dat -g vectors/avg0003.dat

mv vectors/sum.dat vectors/sum_total.dat

#for (( i=4; i<=7629; i++ ))
for (( i=4; i<=7964; i++ ))
do

  num=`printf "%04d" $i`

  echo "Calculando la suma de la imagen: $num"
  ./bin/suma -b $B -x $X -y $Y -f vectors/sum_total.dat -g vectors/avg${num}.dat

  mv vectors/sum.dat vectors/sum_total.dat

done

./bin/divide -b 4 -x 4096 -y 4096 -f vectors/sum_total.dat -N 7963
