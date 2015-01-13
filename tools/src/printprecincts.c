#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;			 /* Vector de precintos */
    long np;				     /* Numero de elementos del vector */
    int readOK, writeOK;   		 /* Controlan la E/S de disco */
    double avg;				     /* Media */
    long precinctSize;			 /* Tamaño del precinto */	

    /* Comprobamos el número de parametros */
    if (argc!=3)
    {
	printf("\nUso: %s <in_precincts_list> .\n",argv[0]);
	printf("\nDescripción: "); 
	printf("\n Muestra por pantalla una lista de precintos.");
	printf("\nParámetros: ");
	printf("\n  - <in_precincts_list> = Lista de precintos de entrada.");
	printf("\n  - <precinct_size> = Un valor entre [16,4096].\n\n");
	exit(0);
    }	

    /* Validamos el valor del tamaño de precinto */
    precinctSize = atoi(argv[2]);
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

    /* Imprimimos la lista de precintos */
    printPrecinctsList(precincts,np);

    /* Calculamos la media de las diferencias entre los precintos */
    //avg = averageDifference(precincts,np);
    
    return 0;
}