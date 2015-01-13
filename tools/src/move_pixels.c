#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PGM.h"

int main(int argc, char *argv[])
{
    if (argc < 6) 
    {
      printf("Uso: %s <me_filename_in> <block_size> <pixels_in_y> <pixels_in_x> <source_image>\n",argv[0]);
      exit(1);
    }

    FILE *fin;
    int y, x, blocks_in_y, blocks_in_x, block_size;
    int pixels_in_y, pixels_in_x, i;
    double y_field, x_field;
    char source_image[80];

    /* Actualizamos el tamaño de bloque */
    block_size = atoi(argv[2]);

    printf("block_size: %d\n", block_size);

    /* Actualizamos las dimensiones de la imagen de salida */
    pixels_in_y = atoi(argv[3]);
    pixels_in_x = atoi(argv[4]);

    printf("pixels_in_y: %d\n", pixels_in_y);
    printf("pixels_in_x: %d\n", pixels_in_x);

    /* Actualizamos el número total de bloques en cada eje */
    blocks_in_y = pixels_in_y/block_size;
    blocks_in_x = pixels_in_x/block_size;

    printf("blocks_in_y: %d\n", blocks_in_y);
    printf("blocks_in_x: %d\n", blocks_in_x);

    /* Abrimos el archivo de entrada */
    if ((fin = fopen(argv[1],"r"))== NULL) 
    {
	printf("ERROR: Al leer del archivo de entrada: %s.\n", argv[1]);
	exit(1);
    }

    /* Cargamos la imagen PGM de entrada en un array */
    unsigned char **imageIn;

    /* Reservamos memoria dinámica para la imagen de entrada */
    imageIn = ( unsigned char** )malloc( pixels_in_y*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < pixels_in_y; i++)
    {
    	imageIn[i] = ( unsigned char* )malloc( pixels_in_x*sizeof( unsigned char ) );
    }

    /* Leemos la imagen de entrada de disco */
    long rows, cols;   
    if (!pgmRead (argv[5], &rows, &cols, imageIn))
    {
	printf("\nError al abrir la imagen: %s.\n",argv[5]);
	exit(1);
    }

    /* Array 2D para la imagen */
    unsigned char **imageOut;

    /* Reservamos memoria dinámica para la imagen de salida */
    imageOut = ( unsigned char** )malloc( pixels_in_y*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < pixels_in_y; i++)
    {
    	imageOut[i] = ( unsigned char* )malloc( pixels_in_x*sizeof( unsigned char ) );
    }

    /* Leemos el archivo de entrada */
    for(y=0; y<pixels_in_y; y=y+block_size)
    {
      for(x=0; x<pixels_in_x; x=x+block_size)
      {

	/* Copiamos el bloque de píxeles que empieza en la esquina (y,x) de la imagenIn a la imagenOut */
	int sub_y, sub_x;
	for(sub_y=y; sub_y < y+block_size; sub_y++)
	{
	  for(sub_x=x; sub_x < x+block_size; sub_x++)
	  {
		imageOut[sub_y][sub_x] = imageIn[sub_y][sub_x];	
	  }
	}

	/* Leemos los valores del vector de movimiento para el bloque que empieza en la esquina (y,x)*/
	fscanf(fin, " %lf %lf", &y_field, &x_field);

	/* Comprobamos si existe movimiento en alguna de las coordenadas */
	if ((x_field!=0) || (y_field!=0))
	{
		int newX = x+((int)round(x_field)*-1);
		int newY = y+((int)round(y_field)*-1);

		// Sólo actualizamos los píxeles si las nuevas coordenadas estan dentro del rango de la imagen [0, Width] y [0, Height]
		if ((newX >= 0) && (newX < pixels_in_x) && (newY >= 0) && (newY < pixels_in_y))
		{
			int x_movement, y_movement;

			x_movement = x - newX;
			y_movement = y - newY;
			
			/* Copiamos los píxeles teniendo el cuenta el movimiento del bloque */
			for(sub_y=y; sub_y < y+block_size; sub_y++)
			{
	  	  	  for(sub_x=x; sub_x < x+block_size; sub_x++)
	  	  	  {
				if ((sub_x >= 0) && (sub_x < pixels_in_x) && (sub_y >= 0) && (sub_y <= pixels_in_y) && (sub_x - x_movement >= 0) && (sub_x - x_movement < pixels_in_x) && (sub_y - y_movement >= 0) && (sub_y - y_movement < pixels_in_y))
				{
					imageOut[sub_y - y_movement][sub_x - x_movement] = imageIn[sub_y][sub_x];
					
					// Imprime un bloque gris					
					//imageOut[sub_y - y_movement][sub_x - x_movement] = 128;

					//printf("y: %3d   x: %3d | newY: %3d   newX: %3d | sub_y: %3d   sub_x: %3d | y_mov: %3d   x_mov: %3d | %3d   %3d \n",y,x,newY,newX,sub_y,sub_x,y_movement,x_movement,sub_y - y_movement,sub_x - x_movement);
				}					
	  	  	  }
			  printf("\n");
			}			
			//int test;
			//scanf(" %d", &test);
		}
	}
	else
	{
		//imageOut[y+(int)round(y_field)][x+(int)round(x_field)] = 128;
	}
      }
      char newline;
      fscanf(fin,"%c",&newline);
    }
    fclose(fin);

    char filename[80] = "prueba.pgm";

    if (pgmWrite(filename, pixels_in_y, pixels_in_x, imageOut, NULL))
    {
	printf("\nEl archivo: %s se ha creado con éxito.\n", filename);
    }
    else
    {
	printf("\nError al crear la imagen: %s.\n",filename);
    }

    return 0;
}