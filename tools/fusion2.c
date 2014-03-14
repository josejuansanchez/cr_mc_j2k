#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                   /* Dimensiones de la imagen A */
    long rowsB, colsB;                   /* Dimensiones de la imagen B */
    unsigned char **imageA;  		 /* Array 2D para la imagen A */
    unsigned char **imageB;  		 /* Array 2D para la imagen B */
    int readOK, writeOK;	 	 /* Controlan la E/S de disco */
    FILE* f;
    long i, j;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
	printf("\nUso: %s <img A> <img B> <out img C>.\n\n",argv[0]);
	exit(0);
    }

    /* Reservamos memoria dinámica para la imagen */
    imageA = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
    	imageA[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Reservamos memoria dinámica para la imagen */
    imageB = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
    	imageB[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Leemos la imagen A de disco */
    readOK = pgmRead (argv[1],&rowsA,&colsA,imageA);
    if (!readOK)
    {
	printf("\nError al abrir la imagen: %s.\n",argv[1]);
	exit(1);
    }

    /* Leemos la imagen B de disco */
    readOK = pgmRead (argv[2],&rowsB,&colsB,imageB);
    if (!readOK)
    {
	printf("\nError al abrir la imagen: %s.\n",argv[2]);
	exit(1);
    }

    for(i=0;i<rowsA;i++)
    {
	for(j=0;j<colsA;j++)
	{
		//imageA[i][j] = (imageA[i][j] + imageB[i][j])/2;
		imageA[i][j] = (unsigned char)((imageA[i][j]*0.5) + (imageB[i][j]*0.5));
		/*int aux = imageA[i][j] + imageB[i][j] - 128;
		if (aux > 255)
		{
			imageA[i][j] = 255;
		}
		else
		{
			if (aux < 0)
			{
				imageA[i][j] = 0;
			}
			else
			{
				imageA[i][j] = aux;
			}			
		}*/		
	}
    }

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite(argv[3],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
	printf("\nEl archivo: %s, se ha creado con éxito.\n",argv[3]);
    }
    else	
    {
	printf("\nError al crear la imagen: %s.\n",argv[3]);
    }  	

    return 0;
}
