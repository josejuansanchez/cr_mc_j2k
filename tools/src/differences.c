/* differences.c */
/* Recibe dos imágenes PGM de entrada y como salida devuelve la diferencia de las dos imágenes en PGM */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;          /* Dimensiones de la imagen A */
    long rowsB, colsB;          /* Dimensiones de la imagen B */
    unsigned char **imageA;     /* Array 2D para la imagen A */
    unsigned char **imageB;     /* Array 2D para la imagen B */
    unsigned char **imageC;     /* Array 2D para la imagen C */
    int readOK, writeOK;        /* Controlan la E/S de disco */
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
        printf("\nUso: %s <in_filenameA> <in_filenameB> <out_filenameC>.",argv[0]);
        printf("\n\nin_filenameA = Image PGM.");
        printf("\nin_filenameB = Image PGM.");
        printf("\nout_filenameC = Image PGM.\n\n.");
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

    /* Reservamos memoria dinámica para la imagen */
    imageC = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
        imageC[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
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
        /* Generamos la imagen C con las diferencias de A - B */
        differences(imageA,imageB,imageC,rowsA,colsA);

        /* Guardamos la imagen residuo en disco */
        writeOK = pgmWrite(argv[3],rowsA,colsA,imageC,NULL);
        if (writeOK) 
        {
            printf("\nEl archivo: %s, con la imagen residuo se ha creado con éxito.\n\n",argv[3]);
        }
        else
        {
            printf("\nError al crear la imagen residuo: %s.\n\n",argv[3]);
        }
    }
    else
    {
        printf("\nLas imágenes no tienen las mismas dimensiones.\n");
    }

    return 0;
}