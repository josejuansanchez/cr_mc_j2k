#!/bin/sh

convert /home/data/imagenes/lena_512x512.grn gray:1.y;
uchar2int < 1.y > 1

echo "Calculando la transformada directa (Haar), 3 niveles"
rdwt2d Haar 0 512 512 3 < 1 > 2
echo "Calculando la transformada inversa (Haar), 3 niveles"
rdwt2d Haar 1 512 512 3 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

echo "Calculando la transformada directa (5/3), 3 niveles"
rdwt2d 5/3 0 512 512 3 < 1 > 2
echo "Calculando la transformada inversa (5/3), 3 niveles"
rdwt2d 5/3 1 512 512 3 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

echo "Calculando la transformada directa (13/7), 3 niveles"
rdwt2d 13/7 0 512 512 3 < 1 > 2
echo "Calculando la transformada inversa (13/7), 3 niveles"
rdwt2d 13/7 1 512 512 3 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

echo "Calculando la transformada directa (Haar), 5 niveles"
rdwt2d Haar 0 512 512 5 < 1 > 2
echo "Calculando la transformada inversa (Haar), 5 niveles"
rdwt2d Haar 1 512 512 5 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

echo "Calculando la transformada directa (5/3), 5 niveles"
rdwt2d 5/3 0 512 512 5 < 1 > 2
echo "Calculando la transformada inversa (5/3), 5 niveles"
rdwt2d 5/3 1 512 512 5 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

echo "Calculando la transformada directa (13/7), 5 niveles"
rdwt2d 13/7 0 512 512 5 < 1 > 2
echo "Calculando la transformada inversa (13/7), 5 niveles"
rdwt2d 13/7 1 512 512 5 < 2 > 3
echo "Verificando la reversibilidad de la transformación"
cmp 1 3
echo "Visualizando la reconstrucción"
int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step
echo "Visualizando las bandas de frecuencia"
int2float < 2 | normalize float | mult float 255 | float2uchar | video_show -x_dim 512 -y_dim 512 -gray8 -step
#int2uchar < 3 | video_show -x_dim 512 -y_dim 512 -gray8 -step

rm -f 1 2 3 4
