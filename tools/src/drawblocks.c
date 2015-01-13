/* drawblocks.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;          /* Dimensiones de la imagen A */
    unsigned char **imageA;  	/* Array 2D para la imagen A */
    precint *precincts;			/* Vector de precintos */
    long np;				    /* Numero de elementos del vector */
    long precinctSize;			/* Tamaño del precinto */
    int readOK, writeOK;   		/* Controlan la E/S de disco */
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=5)
    {
	   printf("\nUso: %s <in_filenameA> <filename_precincts_list (.dat)> <precinct_size> <out_filename>.",argv[0]);
	   printf("\n\nin_filenameA = Image PGM.");
	   printf("\nfilename_precincts_list = Precincts list (.dat).");
	   printf("\nprecinct_size = [16,4096].");
	   printf("\nout_filename = Image PGM.\n\n");
	   exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[3]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
	printf("\nEl valor de precint_size debe un múltiplo de 2 entre [16,4096].\n");
	exit(0);
    }*/

    /* Reservamos memoria dinámica para la imagen A */
    imageA = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
    	imageA[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Leemos la imagen A de disco */
    readOK = pgmRead (argv[1],&rowsA,&colsA,imageA);
    if (!readOK)
    {
	   printf("\nError al abrir la imagen: %s.\n",argv[1]);
	   exit(1);
    }

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (rowsA/precinctSize)*(colsA/precinctSize);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[2]);

    /* Dibujamos los bloques */
    for(i=0; i < np; i++)
    {
    	drawCodeblock(imageA,precincts[i].offsetx,precincts[i].offsety,255,precinctSize);
    }

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[4],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
	   printf("\nEl archivo: %s, con la imagen de precintos UP se ha creado con éxito.",argv[4]);
    }
    else	
    {
	   printf("\nError al crear la imagen de precintos: %s.",argv[4]);
    }    

    /* Liberamos la memoria usada por las imágenes */
    deallocate2D(imageA,MAXROWS);

    return 0;
}