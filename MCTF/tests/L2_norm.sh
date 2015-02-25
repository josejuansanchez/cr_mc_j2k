#!/bin/bash

# Este script calcula la Norma L2 de la transformada temporal
# implementada por MCTF. 

# La Norma L2 de un vector X se define como:
#
# sqrt( sum_n X_n^2 )
#
# que básicamente es la Distancia Euclídea cuando X tiene dos o tres
# componentes, y cuando X tiene más dimensiones, se habla de la Norma
# Eucĺidea.
#
# Para el caso de calcular la ganancia de una determinada subbanda (se
# supone que todos los coeficientes de dicha subbanda poseen la misma
# ganancia, aunque esto no tiene por qué ser así en los límites de la
# subbanda), lo que hacemos es calcular la energía de la función base:
#
# sqrt( sum_n ( |basis(n)|^ 2) )
#
# donde basis(n) es la función base generada al calcular la
# transformada inversa de una descomposición temporal donde sólo uno
# de los coeficientes (imágenes residuo (H) o imágenes de baja
# frecuencia (L)) es diferente de 0.
#
# En dicha transformada inversa se considera que los vectores de
# movimiento son 0 y por tanto, la fase de actualización no tiene
# efecto.

# 6 TRLs
# 32x32     64x64
# 281149440 1124597760 L5[0] 
# 281149440 1124597760 L5[1]
# 18382848  73531392   H5[0]          .0653
# 17645568  70582272   H4[0]          .0627
# 17645568  70582272   H4[1]
# 9338880   37355520   H3[0]          .0332
# 12779520  51118080   H3[1]          .0454
# 12779520  51118080   H3[2]
# 9338880   37355520   H3[3]          
# 5308416   21233664   H2[0]          .0188
# 6684672   26738688   H2[1]          .0237
# 6684672   26738688   H2[2]
# 6684672   26738688   H2[3]
# 6684672   26738688   H2[4]
# 6684672   26738688   H2[5]
# 6684672   26738688   H2[6]
# 5308416   21233664   H2[7]
# 3538944   14155776   H1[0]          .0125
# 3932160   15728640   H1[1]          .0139
# 3932160   15728640   H2[2]
# 3932160   15728640   H2[3]
# 3932160   15728640   H2[4]
# 3932160   15728640   H2[5]
# 3932160   15728640   H2[6]
# 3932160   15728640   H2[7]
# 3932160   15728640   H2[8]
# 3932160   15728640   H2[9]
# 3932160   15728640   H2[10]
# 3932160   15728640   H2[11]
# 3932160   15728640   H2[12]
# 3932160   15728640   H2[13]
# 3932160   15728640   H2[14]
# 3538944   14155776   H2[15]

# 5 TRLs
# ADD_VALUE=127
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# Sin Actu  Con Actu
# 143745024 L4[0]
# 143745024 L4[1]
# 421160448 L4[0] + L4[1]
# 132143616  H4[0]
# 67643904   H3[0]
# 67643904   H3[1]
# 36966912   H2[0]
# 36966912   H2[1]
# 36966912   H2[2]
# 36966912   H2[3]
# 24774144   H1[0]
# 24774144   H1[1]
# 24774144   H1[2]
# 24774144   H1[3]
# 24774144   H1[4]
# 24774144   H1[5]
# 24774144   H1[6]
# 24774144   H1[7]

# 5 TRLs
# ADD_VALUE=64
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# Sin Actu  Con Actu
# 36765696  36765696  L4[0]
# 36765696  36765696  L4[1]
# 106954752 106954752 L4[0] + L3[1]
# 33816576  33816576  H4[0]           .9197
# 17301504  17301504  H3[0]           .4705
# 17301504  17301504  H3[1]
# 9437184   9437184   H2[0]           .2566
# 9437184   9437184   H2[1]
# 9437184   9437184   H2[2]
# 9437184   9437184   H2[3]
# 9437184   6291456   H1[0]
# 6291456   6291456   H1[1]           .1711
# 6291456   6291456   H1[2]
# 6291456   6291456   H1[3]
# 6291456   6291456   H1[4]
# 6291456   6291456   H1[5]
# 6291456   6291456   H1[6]
# 6291456   6291456   H1[7]

# 4 TRLs
# ADD_VALUE=127
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# Sin Actu  Con Actu
# 78458880  78458880  L3[0]
# 78458880  78458880  L3[1]
# 222967296 222967296 L3[0] + L3[1]
# 67643904  67643904  H3[0]          .8621
# 36966912  36966912  H2[0]          .4711
# 36966912  36966912  H2[1]
# 24774144  24774144  H1[0]          .3157
# 24774144  24774144  H1[1]
# 24774144  24774144  H1[2]
# 24774144  24774144  H1[3]

# 4 TRLs
# ADD_VALUE=64
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# Sin Actu  Con Actu
# 20054016  20054016  L3[0]
# 20054016  20054016  L3[1]
# 56623104  56623104  L3[0] + L3[1]
# 17301504  17301504  H3[0]         .8627
# 9437184   9437184   H2[0]
# 9437184   9437184   H2[1]         .4705
# 6291456   6291456   H1[0]         .3137
# 6291456   6291456   H1[1]
# 6291456   6291456   H1[2]
# 6291456   6291456   H1[3]

# 4 TRLs
# ADD_VALUE=32
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# 5013504  L3[0]
# 5013504  L3[1]
# 14155776 L3[0] + L3[1]
# 4325376  H3[0]          .8627
# 2359296  H2[0]          .4705
# 2359296  H2[1]
# 1572864  H1[0]          .3137
# 1572864  H1[1]
# 1572864  H1[2]
# 1572864  H1[3]

# 4 TRLs
# ADD_VALUE=2
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# 12288  L3[0]
# 12288  L3[1]
# 55296  L3[0] + L3[1]
# 12288  H3[0]         1.0
# 9216   H2[0]          .75
# 9216   H2[1]
# 6144   H1[0]          .5
# 6144   H1[1]
# 6144   H1[2]
# 6144   H1[3]

# 3 TRLs
# ADD_VALUE=32
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# 2949120 L2[0]
# 2949120 L2[1]
# 7864320 L2[0] + L2[1]
# 2359296 H2[0]
# 1572864 H1[0]
# 1572864 H1[1]

# 2 TRLs
# ADD_VALUE=32
# PIXELS_IN_Y=32 PIXELS_IN_X=32
# 1966080 L1[0]
# 1966080 L1[1]
# 4718592 L3[0] + L3[1]
# 1572864 H1[0]

set -x

data_dir=data-${0##*/}

VIDEO=zero
PICTURES=5 # <- OJO
#PICTURES=17 # <- OJO
TEMPORAL_LEVELS=3 # <- OJO
#TEMPORAL_LEVELS=5 # <- OJO
PIXELS_IN_Y=32
PIXELS_IN_X=32
ADD_VALUE=32

frame_size=`echo "(3*($PIXELS_IN_Y*$PIXELS_IN_X))/2" | bc`

rm -rf $data_dir
mkdir $data_dir
cd $data_dir
ln -s /dev/zero low_0

# Analizamos
mcj2k analyze --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X --always_B=1

# "Enviamos"
rm -rf tmp
mkdir tmp
x=$[ $TEMPORAL_LEVELS - 1 ]
cp low_$x high* frame_types* motion_* tmp

# Sintetizamos 0000...0
cd tmp
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

# Sintetizamos 10...0
read
cd ..
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d low_$x
add char $ADD_VALUE < x00 > 1
cat 1 x01 > low_$x
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

# Sintetizamos 010...0
read
cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d low_$x
add char $ADD_VALUE < x01 > 1
cat x00 1 > low_$x
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

# Sintetizamos 110...0
read
cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
add char $ADD_VALUE < low_$x > 1
cp 1 low_$x
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
add char $ADD_VALUE < high_$x > 1
cp 1 high_$x
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 1 ]
add char $ADD_VALUE < x00 > 1
cat 1 x01 > high_$[ $x - 1 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 1 ]
add char $ADD_VALUE < x01 > 1
cat x00 1 > high_$[ $x - 1 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 2 ]
add char $ADD_VALUE < x00 > 1
cat 1 x01 x02 x03 > high_$[ $x - 2 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 2 ]
add char $ADD_VALUE < x01 > 1
cat x00 1 x02 x03 > high_$[ $x - 2 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 2 ]
add char $ADD_VALUE < x02 > 1
cat x00 x01 1 x03 > high_$[ $x - 2 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 2 ]
add char $ADD_VALUE < x03 > 1
cat x00 x01 x02 1 > high_$[ $x - 2 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x00 > 1
cat 1 x01 x02 x03 x04 x05 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x01 > 1
cat x00 1 x02 x03 x04 x05 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x02 > 1
cat x00 x01 1 x03 x04 x05 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x03 > 1
cat x00 x01 x02 1 x04 x05 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x04 > 1
cat x00 x01 x02 x03 1 x05 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x05 > 1
cat x00 x01 x02 x03 x04 1 x06 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x06 > 1
cat x00 x01 x02 x03 x04 x05 1 x07 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 3 ]
add char $ADD_VALUE < x07 > 1
cat x00 x01 x02 x03 x04 x05 x06 1 > high_$[ $x - 3 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x00 > 1
cat 1 x01 x02 x03 x04 x05 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x01 > 1
cat x00 1 x02 x03 x04 x05 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x02 > 1
cat x00 x01 1 x03 x04 x05 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x03 > 1
cat x00 x01 x02 1 x04 x05 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x04 > 1
cat x00 x01 x02 x03 1 x05 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x05 > 1
cat x00 x01 x02 x03 x04 1 x06 x07 x08 x08 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x06 > 1
cat x00 x01 x02 x03 x04 x05 1 x07 x08 x09 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x07 > 1
cat x00 x01 x02 x03 x04 x05 x06 1 x08 x09 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x08 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 1 x09 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x09 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 1 x10 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x10 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 1 x11 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x11 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 1 x12 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x12 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 x11 1 x13 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x13 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 x11 x12 1 x14 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x14 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 x11 x12 x13 1 x15 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

cd ..
rm -rf tmp
mkdir tmp
cp low_$x high* frame_types* motion_* tmp
cd tmp
split -b $frame_size -d high_$[ $x - 4 ]
add char $ADD_VALUE < x15 > 1
cat x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 x11 x12 x13 x14 1 > high_$[ $x - 4 ]
mcj2k synthesize --pictures=$PICTURES --temporal_levels=$TEMPORAL_LEVELS --pixels_in_y=$PIXELS_IN_Y --pixels_in_x=$PIXELS_IN_X
#mplayer low_0 -demuxer rawvideo -rawvideo w=$PIXELS_IN_X:h=$PIXELS_IN_Y > /dev/null 2> /dev/null
snr --file_A=low_0 --file_B=/dev/zero --block_size=$frame_size

read

set +x

