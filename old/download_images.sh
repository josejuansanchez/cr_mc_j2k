#!/bin/bash

function CheckExitStatusCode()
{
	if [ $? -ne 0 ]; then
		echo "Error"
		exit
	fi
}

#set -x

IMAGES_DIRECTORY=/home/josejuan/Utilidades/data/thumbnails/delphi_512x512

# PASO 1. Creamos un array con las URLs de todas las imágenes con las que vamos a trabajar
##################################################################################################

# Declaramos un array sin un tamaño fijo
typeset -a URLImagesList

for (( d=1; d<=1; d++ ))
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

echo "Número de Imágenes. URL: ${#URLImagesList[@]}"


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

for (( i=0; i<${#URLImagesList[@]}; i++ ))
do
	echo "Item $i: ${URLImagesList[i]}"
done

# PASO 2. Descargamos las imágenes
##########################################################################################
for (( i=0; i<${#URLImagesList[@]}; i++ ))
do
  echo "Downloading $i/2..."
  wget ${URLImagesList[((i))]}
  CheckExitStatusCode
  num=`printf "%04d" $i`
  # Obtenemos el nombre de la imagen a partir de la URL
  image=`echo ${URLImagesList[((i))]} | cut -d/ -f10`
  mv $image ${IMAGES_DIRECTORY}/sun${num}.jp2

  # Descomprimimos la imagen en PGM y borramos el JP2
  kdu_expand -i ${IMAGES_DIRECTORY}/sun${num}.jp2 -o ${IMAGES_DIRECTORY}/sun${num}.pgm
  rm ${IMAGES_DIRECTORY}/sun${num}.jp2
done

