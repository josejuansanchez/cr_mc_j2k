#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;         /* Vector de precintos */
    long np;                    /* Numero de elementos del vector */
    long i, contup, contdown;
    double sum, avg;

    /* Comprobamos el número de parametros */
    if (argc!=2)
    {
        printf("\nUso: %s <filename_precincts_list_in>.",argv[0]);
        printf("\nfilename_precincts_list = Precincts list IN.\n\n");
        exit(0);
    }

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/32)*(MAXCOLS/32);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));

    /* Leemos la lista de precintos */
    readPrecinctsToFile(precincts,&np,argv[1]);

    sum = 0;
    for(i=0;i<np;i++)
    {
        sum = sum + precincts[i].countDifferences;
        //printf("\nMSE: %lf",precincts[i].countDifferences);
    }
    avg = sum / np;

    contup = 0;
    contdown = 0;
    for(i=0;i<np;i++)
    {
        if (precincts[i].countDifferences > (precincts[0].countDifferences/2))
        {
            contup = contup + 1;
        }
        else
        {
            contdown = contdown + 1;
        }
    }

    printf("\nSum: %lf",sum);
    printf("\nCont: %ld",np);
    printf("\nAvg: %lf",avg);
    printf("\nContUp: %ld",contup);
    printf("\nContDown: %ld\n",contdown);

    return 0;
}