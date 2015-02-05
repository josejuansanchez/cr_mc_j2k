/* drawoneblock.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;          /* Dimensiones de la imagen A */
    unsigned char **imageA;     /* Array 2D para la imagen A */
    long precinctSize;          /* Tamaño del precinto */
    int readOK, writeOK;        /* Controlan la E/S de disco */
    long x, y;
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
        printf("\nUso: %s <in_filenameA> <horizontal_coordinate> <vertical_coordinate> <precintSize> <out_filename>.\n\n",argv[0]);
       exit(0);
    }

    x = atoi(argv[2]);
    y = atoi(argv[3]);
    precinctSize = atoi(argv[4]);

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

    /* Dibujamos el bloque */
    drawCodeblock(imageA,x,y,255,precinctSize);

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[5],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
        printf("\nEl archivo: %s, con la imagen se ha creado con éxito.",argv[5]);
    }
    else
    {
        printf("\nError al crear la imagen: %s.",argv[5]);
    }    
    return 0;
}