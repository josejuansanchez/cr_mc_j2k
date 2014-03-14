#!/bin/bash

##################################################################################
#
# NOTA: Este script calcula la MEDIA PONDERADA de todos los vectores de movimiento
#
##################################################################################

function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

#set -x

IMAGES_DIRECTORY=images_test

# Parámetros para la estimación de movimiento
X=4096
Y=4096
B=4 #16
A=0 #1
D=0 #2  

rm tiempo
echo "Inicio del experimento: `date`" > tiempo
echo "Inicio del experimento: `date`" > log.txt

# PASO 1. Creamos un array con las URLs de todas las imágenes con las que vamos a trabajar
##################################################################################################

# Declaramos un array sin un tamaño fijo
typeset -a URLImagesList

for (( d=1; d<=31; d++ ))
do
	day=`printf "%02d" $d`
	echo "Day: $day"

	# Construimos la URL donde están las imágenes y obtenemos la lista de nombres de imágenes
	#URL=http://delphi.nascom.nasa.gov/jp2/AIA/171/2012/01/$day/
	URL=http://198.118.248.104/jp2/AIA/171/2012/01/$day/
	lns=$(curl -s ${URL} | sed 's/.*href="\([^"]*\)".*/\1/' | grep ".jp2" | tail -n +4)
	total=$(echo ${lns} | wc -w)
	n=1

	# Convertimos la lista de nombres de imágenes en un array
	array=($lns)

	# Creamos un array temporal con la URL completa de la imagen
	unset URLtempList
	i=0
	for item in ${array[*]}
	do
	    #printf "Item $i:   %s\n" ${URL}${item}
	    URLtempList[$i]=${URL}${item}
	    i=$((i+1))
	done

	# Guardamos los resultados del array temporal en un array global
	URLImagesList=("${URLImagesList[@]}" "${URLtempList[@]}")
done

echo "Número de Imágenes. URL: ${#URLImagesList[@]}" >> log.txt


# De todas las imágenes solamente seleccionamos aquellas que están separadas de 10 en 10 (10*36=360 segundos)
typeset -a tempList
j=0
for (( i=0; i<${#URLImagesList[@]}; i=i+10 ))
do
	#echo "${URLImagesList[i]}"
	tempList[$j]=${URLImagesList[i]}
	j=$((j+1))
done

unset URLImagesList
URLImagesList=("${URLImagesList[@]}" "${tempList[@]}")

echo "Número de Imágenes (Filtradas). URL: ${#URLImagesList[@]}"
echo "Número de Imágenes (Filtradas). URL: ${#URLImagesList[@]}" >> log.txt

for (( i=0; i<${#URLImagesList[@]}; i++ ))
do
	echo "Item $i: ${URLImagesList[i]}"
done

# PASO 2. Descargamos las dos primeras imágenes
##########################################################################################
for (( i=1; i<=2; i++ ))
do
  echo "Downloading $i/2..."
  wget ${URLImagesList[((i-1))]}
  CheckExitStatusCode
  num=`printf "%04d" $i`
  # Obtenemos el nombre de la imagen a partir de la URL
  image=`echo ${URLImagesList[((i-1))]} | cut -d/ -f10`
  mv $image ${IMAGES_DIRECTORY}/sun${num}.jp2

  # Descomprimimos la imagen en PGM y borramos el JP2
  kdu_expand -i ${IMAGES_DIRECTORY}/sun${num}.jp2 -o ${IMAGES_DIRECTORY}/sun${num}.pgm
  rm ${IMAGES_DIRECTORY}/sun${num}.jp2
done

# Calculamos los vectores de movimiento
echo "Calculando vectores de movimiento..."
rm motion
even=`printf %04d $(($i-2))`
odd=`printf %04d $(($i-1))`
./bin/me -p 2 -x $X -y $Y -b $B -e ${IMAGES_DIRECTORY}/sun${even}.pgm -o ${IMAGES_DIRECTORY}/sun${odd}.pgm -a $A -d $D

# Renombramos los archivos de salida
mv gnuplot/prev.dat gnuplot/avg.dat
mv vectors/prev.dat vectors/avg.dat

# Borramos la imagen que no necesitamos en la siguiente iteración
rm ${IMAGES_DIRECTORY}/sun${even}.pgm


# PASO 3. Descargamos el resto de imágenes
##########################################################################################
for (( i=3; i<=${#URLImagesList[@]}; i++ ))
do
  echo "Downloading ${i}/${#URLImagesList[@]}..."
  echo "Downloading ${i}/${#URLImagesList[@]}..." >> log.txt
  wget ${URLImagesList[((i-1))]}
  CheckExitStatusCode
  num=`printf "%04d" $i`
  # Obtenemos el nombre de la imagen a partir de la URL
  image=`echo ${URLImagesList[((i-1))]} | cut -d/ -f10`
  mv $image ${IMAGES_DIRECTORY}/sun${num}.jp2

  # Descomprimimos la imagen en PGM y borramos el JP2
  kdu_expand -i ${IMAGES_DIRECTORY}/sun${num}.jp2 -o ${IMAGES_DIRECTORY}/sun${num}.pgm
  rm ${IMAGES_DIRECTORY}/sun${num}.jp2

  # Calculamos los vectores de movimiento
  echo "Calculando vectores de movimiento. Imagen: $(($i-1))..."
  echo "Calculando vectores de movimiento. Imagen: $(($i-1))..." >> log.txt
  rm motion
  even=`printf %04d $(($i-1))`
  odd=`printf %04d $i`
  ./bin/me -p 2 -x $X -y $Y -b $B -e ${IMAGES_DIRECTORY}/sun${even}.pgm -o ${IMAGES_DIRECTORY}/sun${odd}.pgm -a $A -d $D

  # Hacemos la media ponderada
  F=$(($i-2))
  G=1

  # Hacemos la media aritmética
  #F=1
  #G=1

  ./bin/media -b $B -x $X -y $Y -f vectors/avg.dat -F $F -g vectors/prev.dat -G $G

  # Renombramos los archivos de salida
  cp gnuplot/avg.dat gnuplot/avg${num}.dat
  cp vectors/avg.dat vectors/avg${num}.dat

  # Borramos la imagen que no necesitamos en la siguiente iteración
  rm ${IMAGES_DIRECTORY}/sun${even}.pgm

  # Puede ser interesante conservar un histórico de los vectores en lugar de eliminarlos todos
  # ESTA SECCIÓN DE CÓDIGO ES TEMPORAL ######
  anterior=`printf "%04d" $((i-1))`
  let MODULUS=$anterior%500
  if [ ! "$MODULUS" -eq "0" ]; then  	# Sólo conservamos los datos de las imágenes de 500 en 500
      rm gnuplot/avg${anterior}.dat
      rm vectors/avg${anterior}.dat
  fi
  #################################

done

echo "Fin del experimento: `date`" >> tiempo
echo "Fin del experimento: `date`" >> log.txt

