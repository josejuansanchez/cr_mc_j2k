#include <stdio.h>
#include <stdlib.h>
#include "distinct.h"

int main(int argc, char *argv[])
{
	offset *listaA;
	offset *listaB;
	offset *distintos;
	FILE *f;
	long neA, neB, nedis, i, j;
	int readOK, writeOK;

	if (argc != 4)
	{
		printf("\nUso: %s <lista_offsetsA> <lista_offsetsB> <lista_offsets_distintos>\n",argv[0]);
		printf("\nDescripción: ");
		printf("\n   Devuelve una lista con los elementos de <lista_offsetsB> que no aparecen en <lista_offsetsA>.\n\n");
		exit(1);
	}

	/* Contamos el numero de elementos de la lista A para reservar memoria */
	neA = NumeroDeOffsetList(argv[1]);
	if (!neA)
	{
		printf("\nError al abrir el archivo: %s.",argv[1]);
		exit(1);
	}

	/* Reservamos memoria dinámica para el vector A de offsets */
   	listaA = (offset *) malloc (neA*sizeof(offset));

	/* Leemos la lista A */
	readOK = LeerOffsetList(argv[1],listaA,&neA);
	if (!readOK)
	{
		printf("\nError al abrir el archivo: %s.",argv[1]);
		exit(1);
	}

	/* Contamos el numero de elementos de la lista B para reservar memoria */
	neB = NumeroDeOffsetList(argv[2]);
	if (!neB)
	{
		printf("\nError al abrir el archivo: %s.",argv[2]);
		exit(1);
	}

	/* Reservamos memoria dinámica para el vector B de offsets */
   	listaB = (offset *) malloc (neB*sizeof(offset));

	/* Leemos la lista B */
	readOK = LeerOffsetList(argv[2],listaB,&neB);
	if (!readOK)
	{
		printf("\nError al abrir el archivo: %s.",argv[2]);
		exit(1);
	}

	/* Reservamos memoria dinámica para el vector de offsets distintos */
   	distintos = (offset *) malloc ((neA+neB)*sizeof(offset));

	/* Eliminamos los elementos repetidos */
	EliminarRepetidosTwo(listaA,neA,listaB,neB,distintos,&nedis);

	/* Guardamos en disco la lista definitiva */
	writeOK = EscribirOffsetList(argv[3],distintos,nedis);

	printf("\n# A: %ld",neA);
	printf("\n# B: %ld",neB);
	printf("\n# Distintos: %ld\n",nedis);

	return 0;
}
