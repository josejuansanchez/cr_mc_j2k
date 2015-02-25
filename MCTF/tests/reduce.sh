#!/bin/bash


if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_dir=$PWD/data-${0##*/}

##############################	##############################
#      		       PARÁMETROS ENTRADA  		     #
##############################	##############################
dd if=motion_4 of=dosPrimerosBloques bs=8 count=2
dd if=motion_4 of=dosSegundosBloques bs=8 count=2 skip=22
cat dosPrimerosBloques dosSegundosBloques > mini_motion_4.rawl
short2ascii < mini_motion_4.rawl > mini_motion_4.ascii
cat mini_motion_4.ascii


entorno


########################################################### short 16bits : sipiiii

echo -e "-13\n28\n37\n-41\n-76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n-67\n2" | ascii2int | int2short > mini_motion_4.rawl
short2ascii < mini_motion_4.rawl

kdu_compress -i mini_motion_4.rawl -o mini_motion_4.j2c -no_weights Sprecision=16 Ssigned=yes Sdims='{'4,4'}' Clevels=1 Catk=2 Kextension:I2=CON Kreversible:I2=yes Ksteps:I2=\{1,0,0,0\},\{1,0,1,1\} Kcoeffs:I2=-1.0,0.5

### transcode
kdu_transcode -i mini_motion_4.j2c -o transcoded.j2c -reduce 1
kdu_expand -i transcoded.j2c -o expand.rawl
short2ascii < expand.rawl

########################################################### char 8bits * 
echo -e "-13\n28\n37\n-41\n-76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n-67\n2" | ascii2int | int2char > mini_motion_4.rawl
char2ascii < mini_motion_4.rawl

kdu_compress -i mini_motion_4.rawl -o mini_motion_4.j2c -no_weights Sprecision=8 Ssigned=yes Sdims='{'4,4'}' Clevels=1 Catk=2 Kextension:I2=CON Kreversible:I2=yes Ksteps:I2=\{1,0,0,0\},\{1,0,1,1\} Kcoeffs:I2=-1.0,0.5

### transcode
kdu_transcode -i mini_motion_4.j2c -o transcoded.j2c -reduce 1
kdu_expand -i transcoded.j2c -o expand.rawl
char2ascii < expand.rawl
-2 2 42 13
########################################################### uchar 8bits
echo -e "13\n28\n37\n41\n76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n67\n2\n13\n28\n37\n41\n76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n67\n2\n13\n28\n37\n41\n76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n67\n2\n13\n28\n37\n41\n76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n67\n2" | ascii2int | int2uchar > mini_motion_4.raw
uchar2ascii < mini_motion_4.raw

kdu_compress -i mini_motion_4.raw -o mini_motion_4.j2c Creversible=yes -no_weights Sprecision=8 Ssigned=no Sdims='{'8,8'}' Clevels=1 

### transcode
kdu_transcode -i mini_motion_4.j2c -o transcoded.j2c -reduce 1
kdu_expand -i transcoded.j2c -o expand.raw
uchar2ascii < expand.raw

### expand
kdu_expand -i mini_motion_4.j2c -o expand.raw
diff mini_motion_4.raw expand.raw

########################################################### dwt nucleo
echo -e "13\n28\n37\n41\n76\n50\n1\n9\n0\n94\n38\n75\n32\n40\n67\n2" | ascii2int | int2uchar > mini_motion_4.raw
uchar2ascii < mini_motion_4.raw

kdu_compress -i mini_motion_4.raw -o mini_motion_4.j2c -no_weights Sprecision=8 Ssigned=no Sdims='{'4,4'}' Clevels=1 Catk=2 Kextension:I2=CON Kreversible:I2=yes Ksteps:I2=\{1,0,0,0\},\{1,0,1,1\} Kcoeffs:I2=-1.0,0.5

### transcode
kdu_transcode -i mini_motion_4.j2c -o transcoded.j2c -reduce 1
kdu_expand -i transcoded.j2c -o expand.raw
uchar2ascii < expand.raw

### expand
kdu_expand -i mini_motion_4.j2c -o expand.raw
diff mini_motion_4.raw expand.raw






########################################################### COMPRUEBA
### expand
kdu_expand -i mini_motion_4.j2c -o expand.rawl
diff mini_motion_4.rawl expand.rawl



set +x
