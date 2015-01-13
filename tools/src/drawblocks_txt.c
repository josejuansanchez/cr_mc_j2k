/* drawblocks_txt.c */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                  /* Dimensiones de la imagen A */
    unsigned char **imageA;  		    /* Array 2D para la imagen A */
    precint *precincts;			        /* Vector de precintos */
    long np;				            /* Numero de elementos del vector */
    long WprecinctSize, HprecinctSize;  /* Tamaño del precinto */
    int readOK, writeOK;   		        /* Controlan la E/S de disco */
    long i;
    int x,y;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
	printf("\nUso: %s <in_filenameA> <filename_precincts_list (.txt)> <W_precinct_size> <H_precinct_size> <out_filename>.",argv[0]);
	printf("\n\nin_filenameA = Image PGM.");
	printf("\nfilename_precincts_list = Precincts list (.txt).");
	printf("\nprecinct_size = [16,4096].");
	printf("\nout_filename = Image PGM.\n\n");
	exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    WprecinctSize = atoi(argv[3]);
    HprecinctSize = atoi(argv[4]);

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

    /* Leemos el archivo con las WOIs y las dibujamos en la imagen */
    FILE *f = fopen(argv[2],"r");
    if (!f) return -1;
  
    while(!feof(f))
    {
        fscanf(f,"%d %d\n",&x,&y);
        drawCodeblock_WH(imageA,x,y,255,WprecinctSize,HprecinctSize);
    }
    fclose(f);

    /* Guardamos la imagen en disco */
    writeOK = pgmWrite (argv[5],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
	   printf("\nEl archivo: %s, con la imagen de precintos UP se ha creado con éxito.\n",argv[5]);
    }
    else	
    {
	   printf("\nError al crear la imagen de precintos: %s.\n",argv[5]);
    }    

    return 0;
}