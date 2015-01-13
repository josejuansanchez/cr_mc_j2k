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
    int readOK;   		 /* Controlan la E/S de disco */
    long nwritten;
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=3)
    {
	printf("\nUso: %s <in_filenameA> <out_filenameB>.",argv[0]);
	printf("\n\nin_filenameA = Image PGM.");
	printf("\nout_filenameB = Image PGM sin cabecera.\n\n");
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

    /* Creamos el archivo de salida */
    if ((file = fopen(argv[2], "w")) == NULL)	
    {
           printf("Error al crear el archivo: %s.\n",argv[2]);
	   return(0);
    }
    
    /* Write data */
    nwritten = 0;
    for (i=0; i < rowsA; i++) 
    {
        nwritten += fwrite((void*)&(imageA[i][0]),sizeof(unsigned char),colsA, file);
    }	
    printf("\nBytes: %ld\n",nwritten);
    fclose(file);    	

    return 0;
}
