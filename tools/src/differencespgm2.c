/* differencespgm2.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

#define FILENAME_AVG_UP	   "precinctsavgup.pgm"
#define FILENAME_AVG_DOWN  "precinctsavgdown.pgm"
#define FILENAME_RESIDUO   "residuo.pgm"

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
    long i;

    /* Comprobamos el número de parametros */
    if (argc!=7)
    {
        printf("\nUso: %s <in_filenameA> <in_filenameB> <precision> <precinct_size> <out_filename_precinctswithql_txt> <metric_distance>.",argv[0]);
        printf("\n\nin_filenameA = Image PGM.");
        printf("\nin_filenameB = Image PGM.");
        printf("\nprecision = [0,255].");
        printf("\nprecinct_size = [16,4096].");
        printf("\nfilename_precincts_list = Precincts list with quality layer.");
        printf("\nmetric_distance = Metric distances.\n\n");
        exit(0);
    }

    /* Validamos el valor de la precisión */
    precision = atoi(argv[3]);
    if (precision<0 || precision>255)
    {
        printf("\nEl valor de precision debe ser un número entero entre [0,255].\n");
        exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[4]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
        printf("\nEl valor de precint_size debe un múltiplo de 2 entre [16,4096].\n");
        exit(0);
    }*/

    /* Validamos el valor de la métrica de distancia entre WOIS */
    metricDistance = atoi(argv[6]);
    if (metricDistance<0 || metricDistance>5)
    {
        printf("\nEl valor de metricDistance (%d) debe estar entre [0,5].\n",metricDistance);
        exit(0);
    }

    /* Reservamos memoria para todas las imágenes */
    //allocate2D(imageA,MAXROWS,MAXCOLS);
    //allocate2D(imageB,MAXROWS,MAXCOLS);
    //allocate2D(imageC,MAXROWS,MAXCOLS);

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

    /* Reservamos memoria dinámica para la imagen */
    imageD = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++) 
    {
        imageD[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
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

       /* Generamos la imagen C con las diferencias de A - B */
       differences(imageA,imageB,imageC,rowsA,colsA);

       /* Generamos el vector de precintos con las diferencias */
       countDifferences(imageC,rowsA,colsA,precision,precincts,precinctSize,metricDistance);

       /* Ordenamos el vector de precintos */
       OrdenarSeleccionDirecta(precincts,np);

       /* Calculamos la capa de calidad que le corresponde a cada precinto */
       CalculateQualityLayer(precincts,np,7);

       /* Imprimimos la lista de precintos */
       printPrecinctsListQualityLayer(precincts,np);

       /* Guardamos la lista de precintos en disco */
       writeOK = writePrecinctsWithQualityLayerToFile(precincts,np,argv[5]);
       if (writeOK)
       {
           printf("\nEl archivo: %s, con la lista de precintos se ha creado con éxito.",argv[5]);
       }
       else
       {
           printf("\nError al crear el archivo de precintos: %s.",argv[5]);
       }
    }
    else
    {
       printf("\nLas imágenes no tienen las mismas dimensiones.\n");
    }

    /* Liberamos la memoria usada por las imágenes */
    deallocate2D(imageA,MAXROWS);
    deallocate2D(imageB,MAXROWS);
    deallocate2D(imageC,MAXROWS);
    deallocate2D(imageD,MAXROWS);
    free(precincts);

    return 0;
}