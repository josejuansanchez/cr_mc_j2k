#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                   /* Dimensiones de la imagen A */
    unsigned char **imageA;  		 /* Array 2D para la imagen A */
    unsigned char **imageB;  		 /* Array 2D para la imagen B */
    FILE* file;
    int readOK, writeOK;	 	 /* Controlan la E/S de disco */
    long nwritten;
    long i, j, ib, jb;
    long x, y, w, h;

    /* Comprobamos el número de parametros */
    if (argc!=7)
    {
	printf("\nUso: %s <in_filenameA> <out_filenameB> <x> <y> <w> <h>.",argv[0]);
	printf("\n\nin_filenameA = Image PGM.");
	printf("\nout_filenameB = Image PGM.\n\n");
	exit(0);
    }

    x = atoi(argv[3]);
    y = atoi(argv[4]);
    w = atoi(argv[5]);
    h = atoi(argv[6]);

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

    /* Extraemos un trozo de imagen de A */
    ib = 0;
    for(i=x;i<x+h;i++)
    {
	jb = 0;
	for(j=y;j<y+w;j++)
	{
		imageB[ib][jb] = imageA[i][j];
		jb++;
	}
	ib++;
    }

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[2],ib,jb,imageB,NULL);
    if (writeOK) 
    {
	printf("\nEl archivo: %s, se ha creado con éxito.",argv[2]);
    }
    else	
    {
	printf("\nError al crear la imagen: %s.",argv[2]);
    }  	

    return 0;
}
