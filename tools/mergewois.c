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
    precint *precincts;			 /* Vector de precintos */
    long np;				 /* Numero de elementos del vector */
    long precinctSize;			 /* Tamaño del precinto */
    int readOK, writeOK;   		 /* Controlan la E/S de disco */
    double avg;				 /* Media */	
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
	printf("\nUso: %s <in_filenameA> <in_pmg_filenameB> <filename_precincts_list> <precinct_size> <out_filename>.",argv[0]);
	printf("\n\nin_filenameA = Image PGM. (Quality Layer 0).");
	printf("\nin_filenameB = Image PGM. (All Quality Layers).");
	printf("\nfilename_precincts_list = Precincts list.");
	printf("\nprecinct_size = [16,4096].");
	printf("\nout_filename = Image PGM.\n\n");
	exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[4]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
	printf("\nEl valor de precint_size debe un múltiplo de 2 entre [16,4096].\n");
	exit(0);
    }*/

    /* Reservamos memoria para todas las imágenes */
    //allocate2D(imageA,MAXROWS,MAXCOLS);
    //allocate2D(imageB,MAXROWS,MAXCOLS);

    /* Reservamos memoria dinámica para la imagen A */
    imageA = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
    	imageA[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Reservamos memoria dinámica para la imagen B */
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

    /* Comprobamos que las dos imágenes tienen las mismas dimensiones */
    if (rowsA==rowsB && colsA==colsB)
    {
	/* Calculamos el numero de precintos que contiene la imagen */
    	np = (rowsA/precinctSize)*(colsA/precinctSize);

    	/* Reservamos memoria dinámica para el vector de precintos */
    	precincts = (precint *) malloc (np*sizeof(precint));

	/* Leemos la lista de precintos */
    	readPrecinctsToFile(precincts,&np,argv[3]);

	/* Calculamos la media de las diferencias entre los precintos */
	avg = averageDifference(precincts,np);

	/* Generamos una imagen con los precintos que están por encima de la media */
	precinctsAvgUpToImage(precincts,np,avg,imageB,imageA,rowsA,colsA,precinctSize);
	
	/* Guardamos la imagen en disco */
        writeOK = pgmWrite (argv[5],rowsA,colsA,imageA,NULL);
        if (writeOK) 
	{
	    printf("\nEl archivo: %s, con la imagen de precintos UP se ha creado con éxito.",argv[5]);
	}
	else	
	{
	    printf("\nError al crear la imagen de precintos: %s.",argv[5]);
	}    
    }
    else
    {
	printf("\nLas imágenes no tienen las mismas dimensiones.\n");    
    }

    /* Liberamos la memoria usada por las imágenes */
    deallocate2D(imageA,MAXROWS);
    deallocate2D(imageB,MAXROWS);

    return 0;
}
