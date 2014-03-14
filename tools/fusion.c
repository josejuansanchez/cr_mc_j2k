#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                   /* Dimensiones de la imagen A */
    long rowsB, colsB;                   /* Dimensiones de la imagen B */
    unsigned char **imageA;  		 /* Array 2D para la imagen A */
    unsigned char **imageB;  		 /* Array 2D para la imagen B */
    int readOK, writeOK;	 	 /* Controlan la E/S de disco */
    FILE* f;
    long i, j, x, y, w, h;

    /* Comprobamos el número de parametros */
    if (argc!=7)
    {
	printf("\nUso: %s <img A> <img B> <list> <w> <h> <out img C>.\n\n",argv[0]);
	exit(0);
    }

    w = atoi(argv[4]);
    h = atoi(argv[5]);

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

    f = fopen(argv[3],"r");
    if (f==NULL)
    {
	printf("\nError al abrir el archivo: %s.\n",argv[3]);
    }

/*
    int m,n;
    for(m=0;m<512;m=m+w)
    {
	for(n=0;n<512;n=n+h)
	{
    		for(i=m;i<(m + w);i++)
    		{
			for(j=n;j<(n + h);j++)
			{
	    		 if (i==m) imageA[i][j] = 255;
	    		 if (i==(m+w)-1) imageA[i][j] = 255;
	    		 if (j==n) imageA[i][j] = 255;
	   		 if (j==(n+h)-1) imageA[i][j] = 255;
			}
   		}
	}
    }
*/

    fscanf(f,"%ld %ld",&x, &y);
    while(!feof(f))
    {

    	/* Copiamos el trozo de B en A */
    	for(i=y;i<y+h;i++)
    	{
		for(j=x;j<x+w;j++)
		{
			imageA[i][j] = imageB[i][j];
			//imageA[i][j] = 128;
		}
    	}

	fscanf(f,"%ld %ld",&x, &y);
    }


    /* Guardamos la imagen en disco */
    writeOK = pgmWrite(argv[6],rowsA,colsA,imageA,NULL);
    if (writeOK) 
    {
	printf("\nEl archivo: %s, se ha creado con éxito.\n",argv[6]);
    }
    else	
    {
	printf("\nError al crear la imagen: %s.\n",argv[6]);
    }  	

    return 0;
}
