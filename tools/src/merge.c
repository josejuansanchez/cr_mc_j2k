#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;        /* Dimensiones de la imagen A */
    long rowsB, colsB;        /* Dimensiones de la imagen B */
    unsigned char **imageA;   /* Array 2D para la imagen A */
    unsigned char **imageB;   /* Array 2D para la imagen B */
    FILE* file;
    int readOK, writeOK;      /* Controlan la E/S de disco */
    long nwritten;
    long i, j, ib, jb;
    long x, y, w, h;

    /* Comprobamos el número de parametros */
    if (argc!=8)
    {
        printf("\nUso: %s <in_filenameA_background> <in_filenameB> <out_filenameC> <x> <y> <w> <h>.",argv[0]);
        printf("\n\nin_filenameA = Image PGM Background.");
        printf("\nin_filenameB = Image PGM WOI.");
        printf("\nout_filenameB = Image PGM.\n\n");
        exit(0);
    }

    x = atoi(argv[4]);
    y = atoi(argv[5]);
    w = atoi(argv[6]);
    h = atoi(argv[7]);

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

    /* Copiamos el trozo de B en A */
    ib = 0;
    for(i=x;i<x+h;i++)
    {
        jb = 0;
        for(j=y;j<y+w;j++)
        {
            imageA[i][j] = imageB[ib][jb];
            jb++;
        }
        ib++;
    }

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[3],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
        printf("\nEl archivo: %s, se ha creado con éxito.",argv[3]);
    }
    else
    {
        printf("\nError al crear la imagen: %s.",argv[3]);
    }

    return 0;
}