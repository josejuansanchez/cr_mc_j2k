/* differencesppm.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                /* Dimensiones de la imagen A */
    long rowsB, colsB;                /* Dimensiones de la imagen B */
    unsigned char **imageA;           /* Array 2D para la imagen A */
    unsigned char **imageB;           /* Array 2D para la imagen B */
    unsigned char **imageC;           /* Array 2D para la imagen C */
    unsigned char **imageD;           /* Array 2D para la imagen D */
    int readOK, writeOK;              /* Controlan la E/S de disco */
    precint *precincts;               /* Vector de precintos */
    long np;                          /* Numero de elementos del vector */
    unsigned char precision;          /* Precision para evaluar cuando consideramos que existe una diferencia */
    double avg;                       /* Media */
    long contUp, contDown, contEqual; /* Contadores de precintos que estan por encima, debajo e igual que la media */
    long precinctSize;                /* Tamaño del precinto */
    int metricDistance;               /* Métrica de distancia entre WOIS */
    long i, j;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
        printf("\nUso: %s <in_filenameA> <in_filenameB> <out>.",argv[0]);
        exit(0);
    }

    /* Reservamos memoria dinámica para la imagen */
    imageA = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* )*3 );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
        imageA[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char )*3 );
    }

    /* Reservamos memoria dinámica para la imagen */
    imageB = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* )*3 );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
        imageB[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char )*3 );
    }

    /* Reservamos memoria dinámica para la imagen */
    imageC = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* )*3 );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
        imageC[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char )*3 );
    }
   
    /* Leemos la imagen A de disco */
    readOK = ppmRead (argv[1],&rowsA,&colsA,imageA);
    if (!readOK)
    {
        printf("\nError al abrir la imagen: %s.\n",argv[1]);
        exit(1);
    }

    /* Leemos la imagen B de disco */
    readOK = ppmRead (argv[2],&rowsB,&colsB,imageB);
    if (!readOK)
    {
        printf("\nError al abrir la imagen: %s.\n",argv[2]);
        exit(1);
    }

    /* Comprobamos que las dos imágenes tienen las mismas dimensiones */
    if (rowsA==rowsB && colsA==colsB)
    {
        /* Generamos la imagen C con las diferencias de A - B */
        //differences(imageA,imageB,imageC,rowsA,colsA);

        for (i=0; i < rowsA; i++) 
        {
            for (j=0; j < colsA*3; j=j+3) 
            {
                imageC[i][j] = (unsigned char)(((int)imageA[i][j] - (int)imageB[i][j]) + 128);
                imageC[i][j+1] = (unsigned char)(((int)imageA[i][j+1] - (int)imageB[i][j+1]) + 128);
                imageC[i][j+2] = (unsigned char)(((int)imageA[i][j+2] - (int)imageB[i][j+2]) + 128);
            }
        }

        /* Guardamos la imagen residuo en disco */
        writeOK = ppmWrite (argv[3],rowsA,colsA,imageC,NULL);
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