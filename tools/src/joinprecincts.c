#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

#define MAX 4096

int main (int argc, char *argv[])
{
    precint *precinctsUp;
    precint *precinctsDown;
    precint *precinctsOut;
    long npUp;
    long npDown;
    long i, j;
    int readOK, writeOK;

    if (argc!=4)
    {
        printf("\nUso: %s <in_filename_precincts_list_A_dat> <in_filename_precincts_list_B_dat> <out_filename_precincts_dat>.\n\n",argv[0]);
        exit(0);
    }

    /* Reservamos memoria dinámica para los vectores de precintos */
    precinctsUp = (precint *) malloc (MAX*sizeof(precint));
    precinctsDown = (precint *) malloc (MAX*sizeof(precint));
    precinctsOut = (precint *) malloc (2*MAX*sizeof(precint));

    readOK = readPrecinctsToFile(precinctsUp, &npUp, argv[1]);
    if (!readOK)
    {
        printf("\nError al abrir el archivo: %s.\n",argv[1]);
        exit(1);
    }

    readOK = readPrecinctsToFile(precinctsDown, &npDown, argv[2]);
    if (!readOK)
    {
        printf("\nError al abrir el archivo: %s.\n",argv[2]);
        exit(1);
    }


    for(i=0;i<npUp;i++)
    {
        precinctsOut[i] = precinctsUp[i];
    }

    for(j=0;j<npDown;j++)
    {
        precinctsOut[i] = precinctsDown[j];
        i++;
    }

    OrdenarSeleccionDirecta(precinctsOut, i);

    writeOK = writePrecinctsToFile(precinctsOut, i, argv[3]);
    if (!writeOK)
    {
        printf("\nError al abrir el archivo: %s.\n",argv[3]);
        exit(1);
    }
    else
    {
        printf("\nEl archivo: %s se creó con éxito.\n",argv[3]);
    }

    return 0;
}