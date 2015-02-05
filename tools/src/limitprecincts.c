#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;      /* Vector de precintos */
    long np;                 /* Numero de elementos del vector */
    long maxPrecincts;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
        printf("\nUso: %s <filename_precincts_list_in> <filename_precincts_list_in> <max_precincts>.",argv[0]);
        printf("\nfilename_precincts_list = Precincts list IN.");
        printf("\nfilename_precincts_list = Precincts list OUT.");
        printf("\nmax_precincts = Número de precintos con los que vamos a generar la imagen.\n\n");
        exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    maxPrecincts = atoi(argv[3]);

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/32)*(MAXCOLS/32);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[1]);

    /* Guardamos la nueva lista de precintos en disco */
    writePrecinctsToFile(precincts,maxPrecincts,argv[2]);

    return 0;
}