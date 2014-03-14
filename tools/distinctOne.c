#include <stdio.h>
#include <stdlib.h>
#include "distinct.h"

/*
int compare(const void *_a, const void *_b) 
{
 
        offset *a, *b;
        
        a = (offset *) _a;
        b = (offset *) _b;
        
        return (a->offset - b->offset);
}
*/

int main(int argc, char *argv[])
{
	offset *lista;
	offset *distintos;
	long ne, nedis;
	double sum;
	int readOK, writeOK;

	if (argc != 3)
	{
		printf("\nUso: %s <in_offset_list> <out_distinct_offset_list>\n",argv[0]);
		printf("\nDescripción: ");
		printf("\n    Acepta una lista de offsets y devuelve la misma lista sin elementos repetidos.\n");
		printf("\nParámetros: ");
		printf("\n    - <in_offset_list> = Archivo de entrada con la lista de offsets.");
		printf("\n    - <out_offset_list> = Archivo de salida con la lista de offsets.\n\n");
		exit(1);
	}

	/* Contamos el numero de elementos de la lista para reservar memoria */
	ne = NumeroDeOffsetList(argv[1]);
	if (!ne)
	{
		printf("\nError al abrir el archivo: %s.",argv[1]);
		exit(1);
	}

	/* Reservamos memoria dinámica para los vectores de offsets */
   	lista = (offset *) malloc (ne*sizeof(offset));
   	distintos = (offset *) malloc (ne*sizeof(offset));

	/* Leemos el archivo de offsets */
	readOK = LeerOffsetList(argv[1],lista,&ne);
	if (!readOK)
	{
		printf("\nError al abrir el archivo: %s.",argv[1]);
		exit(1);
	}

	//qsort(lista, ne, sizeof(offset), &compare);

	/* Creamos una lista con los paquetes que no se repiten */
	EliminarRepetidosOne(lista,ne,distintos,&nedis);
	printf("\n# Paquetes total: %ld",ne);
	printf("\n# Paquetes distintos: %ld",nedis);
	printf("\n# Paquetes repetidos: %ld",ne-nedis);

	/* Sumamos los bytes de los paquetes distintos */	
	sum = SumBytes(distintos,nedis);
	printf("\nSum (Bytes): %lf",sum);
        printf("\nSum (KBytes): %lf",sum/1024);
        printf("\nSum (MBytes): %lf\n",sum/(1024*1024));
	printf("\nBYTES: %.0lf",sum);

	/* Ordenamos la lista ascendentemente según el offset */
	OrdenarSeleccionDirecta(distintos,nedis);

	/* Guardamos la nueva lista de offset sin elementos repetidos */
	writeOK = EscribirOffsetList(argv[2],distintos,nedis);
	if (!writeOK)
	{
		printf("\nError al crear el archivo: %s.",argv[2]);
		exit(1);
	}

	return 0;
}


