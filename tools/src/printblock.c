#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;       /* Dimensiones de la imagen A */
    unsigned char **imageA;  /* Array 2D para la imagen A */
    FILE* file;
    int readOK, writeOK;     /* Controlan la E/S de disco */
    long i, j;
    long x, y, w, h;
    double suma, cont;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
        printf("\nUso: %s <in_filenameA> <x> <y> <w> <h>.",argv[0]);
        printf("\n\nin_filenameA = Image PGM.");
        printf("\nx, y, w, h = Dimensiones del precinto.\n\n");
        exit(0);
    }

    x = atoi(argv[2]);
    y = atoi(argv[3]);
    w = atoi(argv[4]);
    h = atoi(argv[5]);

    /* Reservamos memoria dinámica para la imagen */
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

    /* Imprimimos el precinto */
    suma = 0;
    cont = 0;
    for(i=x; i < x+h; i++)
    {
        for(j=y; j < y+w; j++)
        {
            printf(" %3d ",imageA[i][j]);
            suma = suma + imageA[i][j];
            cont = cont + 1;
        }
        printf("\n");
    }
    printf("\nSum: %lf. Cont: %.0lf. Avg: %lf\n",suma, cont, suma/cont);

    return 0;
}