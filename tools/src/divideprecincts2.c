#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    precint *precincts;			 /* Vector de precintos */
    long np;				 /* Numero de elementos del vector */
    int readOK, writeOK;   		 /* Controlan la E/S de disco */
    long precinctSize;			 /* Tamaño del precinto */	
    long i;
    long startql7, startql6, startql5, startql4, startql3, startql2, startql1;

    /* Comprobamos el número de parametros */
    if (argc!=3)
    {
	printf("\nUso: %s <in_precincts_list> <precinct_size>.\n",argv[0]);
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
    readOK = readPrecinctsWithQualityLayerFromFile(precincts,&np,argv[1]);
    if (!readOK)
    {
	printf("\nError al leer el archivo de precintos: %s.\n",argv[1]);
	exit(1);    
    }

    /*
    for(i=0;i<np;i++)
    {
	printf("X=%ld \t Y=%ld \t QL= %ld\n",precincts[i].offsetx,precincts[i].offsety,precincts[i].qualitylayer);
    }
    */

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==7)
	{
		startql7 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==6)
	{
		startql6 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==5)
	{
		startql5 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==4)
	{
		startql4 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==3)
	{
		startql3 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==2)
	{
		startql2 = i;
		break;			
	}
    }

    for(i=0;i<np;i++)
    {
	if (precincts[i].qualitylayer==1)
	{
		startql1 = i;
		break;			
	}
    }

    //printf("\n%ld %ld %ld %ld %ld %ld %ld\n",startql7,startql6,startql5,startql4,startql3,startql2,startql1);

    writePrecinctsToFileTXT(precincts,0,startql7,"8ql.txt");
    writePrecinctsToFileTXT(precincts,startql7,startql6,"7ql.txt");
    writePrecinctsToFileTXT(precincts,startql6,startql5,"6ql.txt"); 
    writePrecinctsToFileTXT(precincts,startql5,startql4,"5ql.txt");
    writePrecinctsToFileTXT(precincts,startql4,startql3,"4ql.txt");
    writePrecinctsToFileTXT(precincts,startql3,startql2,"3ql.txt");
    writePrecinctsToFileTXT(precincts,startql2,startql1,"2ql.txt");
    writePrecinctsToFileTXT(precincts,startql1,np,"1ql.txt");

    return 0;
}

