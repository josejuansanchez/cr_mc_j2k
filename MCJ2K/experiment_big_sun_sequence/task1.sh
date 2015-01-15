#!/bin/bash

##################################################################################
#
# NOTA: Este script ha sido la base de "task2.sh" y "task3.sh"
#
##################################################################################


set -x

IMAGES_DIRECTORY=images_test

# Parámetros para la estimación de movimiento
X=4096
Y=4096
B=4 #16
A=1
D=0 #2  

rm tiempo
echo "Inicio del experimento: `date`" > tiempo

#for (( d=1; d<=31; d++ ))
for (( d=1; d<=10; d++ ))
do
	day=`printf "%02d" $d`
	echo "Day: $day"

	# Si no existe el directorio de las imágenes lo creamos
	if [ ! -d "${IMAGES_DIRECTORY}/${day}" ]; then
	  echo "Creando nuevo directorio: ${IMAGES_DIRECTORY}/${day}"
	  mkdir -p ${IMAGES_DIRECTORY}/${day}
	fi

	# Construimos la URL donde están las imágenes y obtenemos la lista de nombres de imágenes
	URL=http://delphi.nascom.nasa.gov/jp2/AIA/171/2012/01/$day/
	#URL=http://helioviewer.nascom.nasa.gov/jp2/v0.8/AIA/304/2011/10/$day/
	lns=$(curl -s ${URL} | sed 's/.*href="\([^"]*\)".*/\1/' | grep ".jp2" | tail -n +4)
	total=$(echo ${lns} | wc -w)
	n=1

	# Convertimos la lista de nombres de imágenes en un array
	arr=($lns)

	# Descargamos las dos primeras imágenes
	##########################################################################################
	for (( i=1; i<=2; i++ ))
	do
	  echo "Downloading $i/2..."
	  wget ${URL}${arr[((i-1))]}
	  num=`printf "%04d" $i`
	  mv ${arr[((i-1))]} ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2

	  # Descomprimimos la imagen en PGM y borramos el JP2
	  kdu_expand -i ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2 -o ${IMAGES_DIRECTORY}/${day}/sun${num}.pgm
	  rm ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2
	done

	# Calculamos los vectores de movimiento
	echo "Calculando vectores de movimiento..."
	rm motion
    	even=`printf %04d $(($i-2))`
	odd=`printf %04d $(($i-1))`
	./bin/me -p 2 -x $X -y $Y -b $B -e ${IMAGES_DIRECTORY}/${day}/sun${even}.pgm -o ${IMAGES_DIRECTORY}/${day}/sun${odd}.pgm -a $A -d $D

	# Renombramos los archivos de salida
	mv gnuplot/prev.dat gnuplot/avg.dat
	mv vectors/prev.dat vectors/avg.dat

	# Borramos la imagen que no necesitamos en la siguiente iteración
	rm ${IMAGES_DIRECTORY}/${day}/sun${even}.pgm


	# Descargamos el resto de imágenes
	##########################################################################################
	for (( i=3; i<=total; i++ ))
	do
	  echo Downloading ${i}/${total}...
	  wget ${URL}${arr[((i-1))]}
	  num=`printf "%04d" $i`
	  mv ${arr[((i-1))]} ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2

	  # Descomprimimos la imagen en PGM y borramos el JP2
	  kdu_expand -i ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2 -o ${IMAGES_DIRECTORY}/${day}/sun${num}.pgm
	  rm ${IMAGES_DIRECTORY}/${day}/sun${num}.jp2

	  # Calculamos los vectores de movimiento
	  echo "Calculando vectores de movimiento..."
	  rm motion
	  even=`printf %04d $(($i-1))`
	  odd=`printf %04d $i`
	  ./bin/me -p 2 -x $X -y $Y -b $B -e ${IMAGES_DIRECTORY}/${day}/sun${even}.pgm -o ${IMAGES_DIRECTORY}/${day}/sun${odd}.pgm -a $A -d $D

	  # Hacemos la media
	  #F=`echo $(($i-2))/$(($i-1)) | bc -l`
	  #G=`echo 1/$(($i-1)) | bc -l`

	  F=$(($i-2))
	  G=1

	  ./bin/media -b $B -x $X -y $Y -f vectors/avg.dat -F $F -g vectors/prev.dat -G $G

	  # Renombramos los archivos de salida
	  cp gnuplot/avg.dat gnuplot/avg${num}.dat
	  cp vectors/avg.dat vectors/avg${num}.dat

	  # Borramos la imagen que no necesitamos en la siguiente iteración
	  rm ${IMAGES_DIRECTORY}/${day}/sun${even}.pgm

	  # Puede ser interesante conservar un histórico de los vectores en lugar de eliminarlos todos
	  # ESTA SECCIÓN DE CÓDIGO ES TEMPORAL ######
  	  anterior=`printf "%04d" $((i-1))`
	  rm gnuplot/avg${anterior}.dat
	  rm vectors/avg${anterior}.dat
	  #################################

	done
done

echo "Fin del experimento: `date`" >> tiempo