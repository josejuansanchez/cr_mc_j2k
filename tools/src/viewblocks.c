#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;      /* Dimensiones de la imagen A */
    unsigned char **imageA; /* Array 2D para la imagen A */
    precint *precincts;     /* Vector de precintos */
    long np;                /* Numero de elementos del vector */
    long precinctSize;      /* Tamaño del precinto */
    int readOK, writeOK;    /* Controlan la E/S de disco */
    long i,j;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
        printf("\nUso: %s <in_filenameA> <precinct_size> <out_filename>.",argv[0]);
        printf("\n\nin_filenameA = Image PGM.");
        printf("\nprecinct_size = [16,4096].");
        printf("\nout_filename = Image PGM.\n\n");
        exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[2]);

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


    /* Dibujamos los bloques */
    for(i=0; i<rowsA; i=i+precinctSize)
    {
        for(j=0; j<colsA; j=j+precinctSize)
        {
            drawCodeblock(imageA, i, j, 128, precinctSize);
        }
    }

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[3],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
        printf("\nEl archivo: %s se ha creado con éxito.\n",argv[3]);
    }
    else
    {
        printf("\nError al crear la imagen de precintos: %s.",argv[3]);
    }

    /* Liberamos la memoria usada por las imágenes */
    deallocate2D(imageA,MAXROWS);

    return 0;
}