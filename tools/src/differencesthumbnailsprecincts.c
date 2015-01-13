/* differencesthumbnailsprecincts.c */
/* Sólo calculamos las diferencias sobre el vector de precintos que recibimos de entrada */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                /* Dimensiones de la imagen A */
    long rowsB, colsB;                /* Dimensiones de la imagen B */
    unsigned char **imageA;  		  /* Array 2D para la imagen A */
    unsigned char **imageB;  		  /* Array 2D para la imagen B */
    unsigned char **imageC;  		  /* Array 2D para la imagen C */
    int readOK, writeOK;   		      /* Controlan la E/S de disco */
    precint *precincts;			      /* Vector de precintos */
    long np;				          /* Numero de elementos del vector */
    double avg;				          /* Media */	
    long contUp, contDown, contEqual; /* Contadores de precintos que estan por encima, debajo e igual que la media */
    long i, j, k;
    long precinctSize;
    long offsetx, offsety;
    double suma;
    long offset;

    /* Comprobamos el número de parametros */
    if (argc!=8)
    {
	   printf("\nUso: %s <in_filenameA> <in_filenameB> <out_filename_precincts_list.dat> <out_filename_precincts_list.txt> <precint_size> <offset> <in_filename_precincts_list.txt>.\n",argv[0]);
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
        /* Calculamos el numero de precintos que contiene la imagen */
        np = rowsA*colsA;

        /* Reservamos memoria dinámica para el vector de precintos */
    	precincts = (precint *) malloc (np*sizeof(precint));

        /* Generamos la imagen C con las diferencias de A - B */
        differencesABS(imageA,imageB,imageC,rowsA,colsA);

        /* Leemos el vector de precintos sobre el que vamos a calcular las diferencias */
        readOK = readPrecinctsFromFileTXT(precincts, &np, argv[7]);
    	if (!readOK)
    	{
	       printf("\nError al abrir el archivo de precintos: %s.\n",argv[7]);
	       exit(1);
    	}

        precinctSize = atoi(argv[5]);
        offset = atoi(argv[6]);
        for(i=0;i<np;i++)
        {
	       //printf("\n[%ld] %ld : %ld",i,precincts[i].offsetx/16,precincts[i].offsety/16);

            offsetx = precincts[i].offsetx/offset;	// Si precintSize=2. / 64 para imágenes de 4096. 16 para imágenes de de 1024
            offsety = precincts[i].offsety/offset;

            suma = 0;
            for(j=offsetx;j<(offsetx + precinctSize);j++)
            {
                for(k=offsety;k<(offsety + precinctSize);k++)
                {
                    suma = suma + imageC[i][j];		
                }
            }
            avg = suma/(precinctSize*precinctSize);
            precincts[i].countDifferences = avg;
        }
	
        /* Ordenamos el vector de precintos */
        OrdenarSeleccionDirecta(precincts,np);

        /* Imprimimos la lista de precintos */
        printPrecinctsList(precincts,np);

        /* Guardamos la lista de precintos .dat en disco */
        writeOK = writePrecinctsToFile(precincts,np,argv[3]);
        if (writeOK)
        {
            printf("\nEl archivo: %s, con la lista de precintos .dat se ha creado con éxito.",argv[3]);
        }
        else	
        {
            printf("\nError al crear el archivo de precintos: %s.",argv[3]);
        }

        /* Guardamos la lista de precintos .txt en disco */
        writeOK = writePrecinctsToFileTXT(precincts,0,np,argv[4]);
        if (writeOK)
        {
            printf("\nEl archivo: %s, con la lista de precintos .txt se ha creado con éxito.",argv[4]);
        }
        else	
        {
            printf("\nError al crear el archivo de precintos: %s.",argv[4]);
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
    free(precincts);      

    return 0;
}