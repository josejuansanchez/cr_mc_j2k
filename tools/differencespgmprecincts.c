/* differencespgmprecincts.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;          /* Dimensiones de la imagen A */
    long rowsB, colsB;          /* Dimensiones de la imagen B */
    unsigned char **imageA;  	/* Array 2D para la imagen A */
    unsigned char **imageB;  	/* Array 2D para la imagen B */
    int readOK, writeOK;   		/* Controlan la E/S de disco */
    precint *precinctsIn;		/* Vector de precintos de entrada*/
    long npIn;				    /* Numero de elementos del vector de entrada */
    precint *precinctsOut;		/* Vector de precintos de salida*/
    long precinctSize;			/* Tamaño del precinto */
    long i, j, k;
    unsigned char diff;
    double sumaMSE;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
	   printf("\nUso: %s <in_filename_precincts_list_txt> <in_filenameA> <in_filenameB> <precinct_size> <out_filename_precincts_list>.",argv[0]);
	   printf("\n\nin_filename_precincts_list = Lista de precintos de entrada.");
	   printf("\nin_filenameA = Image PGM.");
	   printf("\nin_filenameB = Image PGM.");
	   printf("\nprecinct_size = [16,4096].");
	   printf("\nout_filename_precincts_list = Precincts list.\n\n");
	   exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[4]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
	printf("\nEl valor de precint_size debe un múltiplo de 2 entre [16,4096].\n");
	exit(0);
    }*/

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
    readOK = pgmRead (argv[2],&rowsA,&colsA,imageA);
    if (!readOK)
    {
	   printf("\nError al abrir la imagen: %s.\n",argv[2]);
	   exit(1);
    }

    /* Leemos la imagen B de disco */
    readOK = pgmRead (argv[3],&rowsB,&colsB,imageB);
    if (!readOK)
    {
	   printf("\nError al abrir la imagen: %s.\n",argv[3]);
	   exit(1);
    }

    /* Comprobamos que las dos imágenes tienen las mismas dimensiones */
    if (rowsA==rowsB && colsA==colsB)
    {
        /* Calculamos el numero de precintos que contiene la imagen */
        npIn = (rowsA/precinctSize)*(colsA/precinctSize);

        /* Reservamos memoria dinámica para el vector de precintos */
        precinctsIn = (precint *) malloc (npIn*sizeof(precint));
        precinctsOut = (precint *) malloc (npIn*sizeof(precint));

        /* Leemos el vector de precintos sobre el que vamos a calcular las diferencias */
        readOK = readPrecinctsFromFileTXT(precinctsIn, &npIn, argv[1]);
        if (!readOK)
        {
	       printf("\nError al abrir el archivo de precintos: %s.\n",argv[1]);
	       exit(1);
        }	

        for(i=0;i<npIn;i++) 
        {
	       /* Calculamos el MSE para cada precinto */
	       /* Restamos píxel a píxel los precintos de la imagen A con la imagen B */
	       sumaMSE = 0;
	       for(j=precinctsIn[i].offsetx;j<(precinctsIn[i].offsetx + precinctSize);j++)
	       {
		      for(k=precinctsIn[i].offsety;k<(precinctsIn[i].offsety + precinctSize);k++)
		      {
		          diff = (unsigned char)(((int)imageA[j][k] - (int)imageB[j][k]))+128;
		          sumaMSE = sumaMSE + ((diff-128)*(diff-128));
		      }
	       }
	       //printf("[%d] %lf. PrecintSize: %ld, MSE: %lf\n", i, sumaMSE, precinctSize, sumaMSE/(precinctSize*precinctSize));

	       /* Generamos el vector de precintos con las diferencias */
	       precinctsOut[i].offsetx = precinctsIn[i].offsetx;
	       precinctsOut[i].offsety = precinctsIn[i].offsety;
	       precinctsOut[i].countDifferences = sumaMSE/(precinctSize*precinctSize);
        }

        /* Ordenamos el vector de precintos */
        OrdenarSeleccionDirecta(precinctsOut,npIn);

        /* Imprimimos la lista de precintos */
        printPrecinctsList(precinctsOut,npIn);

        /* Guardamos la lista de precintos en disco */
        writeOK = writePrecinctsToFile(precinctsOut,npIn,argv[5]);
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

    return 0;
}