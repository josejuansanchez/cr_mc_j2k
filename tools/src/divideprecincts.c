#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;      /* Vector de precintos */
    long np;                 /* Numero de elementos del vector */
    int readOK, writeOK;     /* Controlan la E/S de disco */
    double avg;              /* Media */
    long precinctSize;       /* Tamaño del precinto */

    /* Comprobamos el número de parametros */
    if (argc!=5)
    {
        printf("\nUso: %s <in_precincts_list> <out_precincts_down_list> <out_precincts_up_list> <precinct_size>.\n",argv[0]);
        printf("\nDescripción: "); 
        printf("\n Divide una lista de precintos de entrada en dos listas.");
        printf("\n   - Precintos que estan por debajo de la media.");
        printf("\n   - Precintos que son superiores o igual a la media.");
        printf("\nParámetros: ");
        printf("\n  - <in_precincts_list> = Lista de precintos de entrada.");
        printf("\n  - <out_precincts_down_list> = Lista de precintos que están por debajo de la media.");
        printf("\n  - <out_precincts_up_list> = Lista de precintos que están por encima o igual que la media.");
        printf("\n  - <precinct_size> = Un valor entre [16,4096].\n\n");
        exit(0);
    }

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[4]);
    /*if (precinctSize<16 || precinctSize>4096 || precinctSize%2!=0)
    {
        printf("\nEl valor de precint_size debe ser un múltiplo de 2 entre [16,4096].\n");
        exit(0);
    }*/

    /* Calculamos el numero de precintos que contiene la imagen */
    np = (MAXROWS/precinctSize)*(MAXCOLS/precinctSize);

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));

    /* Leemos el archivo de precintos */
    readOK = readPrecinctsToFile(precincts,&np,argv[1]);
    if (!readOK)
    {
        printf("\nError al leer el archivo de precintos: %s.\n",argv[1]);
        exit(1);
    }

    /* Calculamos la media de las diferencias entre los precintos */
    avg = averageDifference(precincts,np);

    /* Guardamos en disco la lista de precintos que están por debajo de la media */
    writeOK = writePrecinctsAvgDownToFile(precincts,np,argv[2],avg);
    if (!writeOK)
    {
        printf("\nError al crear el archivo de precintos: %s.\n",argv[2]);
        exit(1);
    }
    else
    {
        printf("\nEl archivo: %s se ha creado con éxito.",argv[2]);
    }

    /* Guardamos en disco la lista de precintos que están por encima o igual que la media */
    writeOK = writePrecinctsAvgUpToFile(precincts,np,argv[3],avg);
    if (!writeOK)
    {
        printf("\nError al crear el archivo de precintos: %s.\n",argv[3]);
        exit(1);
    }
    else
    {
        printf("\nEl archivo: %s se ha creado con éxito.\n",argv[3]);
    }
    
    return 0;
}