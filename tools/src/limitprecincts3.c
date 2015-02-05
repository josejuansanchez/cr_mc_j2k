#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;             /* Vector de precintos */
    precint *precinctsFiltrados;    /* Vector de precintos filtrados */
    precint *precinctsDescartados;  /* Vector de precintos descartados */
    long np;                        /* Numero de elementos del vector */
    long npFiltrados;               /* Numero de elementos del vector (filtrados) */
    long npDescartados;             /* Numero de elementos del vector (descartados) */
    long precinctSize;              /* Tamaño del precinto */
    long i;
    long contup;

    /* Comprobamos el número de parametros */
    if (argc!=7)
    {
        printf("\nUso: %s <filename_precincts_list_in> <filename_precincts_list_out> <precinct_size> <contup> <filename_precincts_descartados_txt> <filename_precincts_filtrados_txt>.",argv[0]);
        printf("\nfilename_precincts_list = Precincts list IN.");
        printf("\nfilename_precincts_list = Precincts list OUT.");
        printf("\nprecinct_size = Precinct Size.");
        printf("\nfilename_precincts_descartados_txt = Archivo de texto con precintos descartados.");
        printf("\nfilename_precincts_filtrados_txt = Archivo de texto con precintos filtrados.\n\n");
        exit(0);
    }

    contup = atoi(argv[4]);

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[3]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
        printf("\nEl valor de precint_size debe un múltiplo de 2 entre [16,4096].\n");
        exit(0);
    }*/

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/precinctSize)*(MAXCOLS/precinctSize);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));
    precinctsFiltrados = (precint *) malloc (np*sizeof(precint));
    precinctsDescartados = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[1]);

    /* Recorremos el vector de precintos */
    npFiltrados = 0;
    npDescartados = 0;
    for(i=0;i<np;i++)
    {
        if (i < contup)
        {
            precinctsFiltrados[npFiltrados] = precincts[i];
            npFiltrados++;
        }
        else
        {
            precinctsDescartados[npDescartados] = precincts[i];
            npDescartados++;
        }
    }
    printf("\nNum. Precincts: %ld\n",npFiltrados);

    /* Guardamos la nueva lista de precintos en disco */
    writePrecinctsToFile(precinctsFiltrados,npFiltrados,argv[2]);

    writePrecinctsToFileTXT(precinctsDescartados,0,npDescartados,argv[5]);

    writePrecinctsToFileTXT(precinctsFiltrados,0,npFiltrados,argv[6]);

    return 0;
}