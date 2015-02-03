#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;                 /* Vector de precintos */
    precint *precinctsFiltrados;        /* Vector de precintos filtrados */
    long np;                            /* Numero de elementos del vector */
    long npFiltrados;                   /* Numero de elementos del vector (filtrados) */
    long WprecinctSize, HprecinctSize;  /* Tamaño del precinto */
    long i;
    double mediana, suma, media, min, max;

    /* Comprobamos el número de parametros */
    if (argc!=4)
    {
        printf("\nUso: %s <filename_precincts_list_in DAT> <W_precinct_size> <H_precinct_size>.\n\n",argv[0]);
        exit(1);
    }

    /* Validamos el valor del tamaño de precinto */
    WprecinctSize = atoi(argv[2]);
    HprecinctSize = atoi(argv[3]);

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/HprecinctSize)*(MAXCOLS/WprecinctSize);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));
    precinctsFiltrados = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[1]);

    /* Recorremos el vector de precintos */
    npFiltrados = 0;
    for(i=0;i<np;i++)
    {
        if (precincts[i].countDifferences > 0)
        {
            precinctsFiltrados[npFiltrados] = precincts[i];
            npFiltrados++;
        }
    }

    if (npFiltrados==0)
    {
        mediana = -1;
        media = -1;
        min = -1;
        max = -1;
    }
    else
    {
        /* Calculamos la media, min y max */
        suma = precinctsFiltrados[0].countDifferences;
        min = precinctsFiltrados[0].countDifferences;
        max = precinctsFiltrados[0].countDifferences;
        for(i=1;i<npFiltrados;i++)
        {
            if (precinctsFiltrados[i].countDifferences > max)
            {
                max = precinctsFiltrados[i].countDifferences;
            }

            if (precinctsFiltrados[i].countDifferences < min)
            {
                min = precinctsFiltrados[i].countDifferences;
            }

            suma = suma + precinctsFiltrados[i].countDifferences;
        }
        media = suma/npFiltrados;

        /* Calculamos la mediana */
        if (npFiltrados%2!=0)
        {
            mediana = precinctsFiltrados[npFiltrados/2].countDifferences;
        }
        else
        {
            mediana = (precinctsFiltrados[npFiltrados/2].countDifferences + precinctsFiltrados[(npFiltrados/2)-1].countDifferences)/2;
        }
    }

    printf("\nNum. Precincts: %ld\n",npFiltrados);
    printf("[Threshold] Mediana: %lf\n",mediana);
    printf("[Threshold] Media: %lf\n",media);
    printf("[Threshold] Min: %lf\n",min);
    printf("[Threshold] Max: %lf\n",max);

    return 0;
}