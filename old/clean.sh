#!/bin/bash

echo "Borrando bytes.readed..."
rm bytes.readed

echo "Borrando contenido de thumbnails..."
#rm -rf ../data/thumbnails/*.j2c ../data/thumbnails/*.pgm

echo "Borrando background: data/thumbnails/background.j2c..."
rm -rf ../data/thumbnails/background.j2c

echo "Borrando caché en: data/thumbnails..."
rm -rf ../data/thumbnails/*.cache ../data/thumbnails/*.ord ../data/thumbnails/*.lrcp ../data/thumbnails/*.woi

echo "Borrando imágenes truncadas en: data/thumbnails..."
rm -rf ../data/thumbnails/*trunc.*

echo "Borrando imágenes truncadas en: data/imagestrunc..."
rm -rf ../data/imagestrunc/*trunc.*

echo "Borrando imágenes reconstruidas..."
rm -rf ../data/imagesprecincts/*.pgm

echo "Borrando imágenes drawblocks..."
rm -rf ../data/imagesdrawblocks/*.pgm

echo "Borrando archivos de precintos..."
rm -rf ../data/precincts/*.dat
rm -rf ../data/precincts/*.txt

echo "Borrando datos de las gráficas..."
#rm -rf ../data/graficas/*.dat

