#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"

int main (int argc, char *argv[])
{
	long rows, cols;
	unsigned char **image;
	int color;
	int writeOK;
	long i, j;

	/* Comprobamos el número de parametros */
	if (argc!=5)
	{
		printf("\nUso: %s <rows> <cols> <color> <image_filename>.\n\n",argv[0]);
		exit(0);
	}

	rows = atoi(argv[1]);
	cols = atoi(argv[2]);
	color = atoi(argv[3]);

	/* Validamos los parametros de entrada */
	if (rows<0)
	{
		printf("\nError: rows no puede ser negativo.\n\n");
		exit(0);
	}

	if (cols<0)
	{
		printf("\nError: cols no puede ser negativo.\n\n");
		exit(0);
	}

	if ((color<0) || (color>255))
	{
		printf("\nError: color tiene que estar en el rango [0,255].\n\n");
		exit(0);
	}

	/* Reservamos memoria dinámica para la imagen */
	image = ( unsigned char** )malloc( rows*sizeof( unsigned char* ) );
     
    	/* Reservamos memoria para cada fila */
   	for(i = 0; i < rows; i++) 
    	{
    		image[i] = ( unsigned char* )malloc( cols*sizeof( unsigned char ) );
    	}

	/* Inicializamos la matriz de la imagen con el color de entrada */
	for(i=0;i<rows;i++)
	{
		for(j=0;j<cols;j++)
		{
			image[i][j] = color;
		}
	}

	/* Guardamos la imagen en disco */
	writeOK = pgmWrite (argv[4],rows,cols,image,NULL);
	if (writeOK) 
	{
		printf("\nLa imagen: %s se ha creado con éxito.\n\n",argv[4]);
	}
	else	
    	{
		printf("\nError al crear la imagen: %s\n\n.",argv[4]);
    	}

	return 0;
}

