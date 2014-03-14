#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;			 /* Vector de precintos */
    precint *precinctsFiltrados;	 /* Vector de precintos filtrados */
    long np;				 /* Numero de elementos del vector */
    long npFiltrados;			 /* Numero de elementos del vector (filtrados) */
    long WprecinctSize, HprecinctSize;	 /* Tamaño del precinto */
    long i;
    double threshold;
    double max;

    /* Comprobamos el número de parametros */
    if (argc!=6)
    {
	printf("\nUso: %s <filename_precincts_list_in DAT> <W_precinct_size> <H_precinct_size> <threshold> <filename_precincts_filtrados TXT>.\n\n",argv[0]);
	exit(1);
    }

    /* Validamos el valor del tamaño de precinto */
    WprecinctSize = atoi(argv[2]);
    HprecinctSize = atoi(argv[3]);

    threshold = atof(argv[4]);

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/HprecinctSize)*(MAXCOLS/WprecinctSize);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));
    precinctsFiltrados = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[1]);

    /* Recorremos el vector de precintos */
    max = -1;
    npFiltrados = 0;
    for(i=0;i<np;i++)
    {	
	if (precincts[i].countDifferences >= threshold)
	{
	    precinctsFiltrados[npFiltrados] = precincts[i];
	    npFiltrados++;
	}
	/* Calculamos el MSE máximo */
	if (precincts[i].countDifferences > max)
	{
		max = precincts[i].countDifferences;
	}
    }
    printf("\nNum. Precincts: %ld\n",npFiltrados);
    printf("MSE Máximo: %lf\n",max);

    if (npFiltrados==0)
    {
    	printf("\nNo se puede crear el archivo de salida porque no hay precintos filtrados.\n");
	printf("MSE Máximo: %lf \t Threshold: %lf.\n\n",max, threshold);
	exit(1);
    }

    /* Guardamos la nueva lista de precintos en disco */
    writePrecinctsToFileTXT(precinctsFiltrados,0,npFiltrados,argv[5]);

    return 0;
}

