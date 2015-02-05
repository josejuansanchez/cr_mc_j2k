#include <stdio.h>
#include <stdlib.h>
#include "distinct.h"

void OrdenarSeleccionDirecta(offset precints[], long np)
{
    long i,j,k;
    offset aux;

    for(i=0;i<=np-2;i++)
    {
		k = i;
		for(j=i+1;j<=np-1;j++)
		{
			if (precints[j].offset < precints[k].offset)
			{
				k = j;
			}
		}
		aux = precints[k];
		precints[k] = precints[i];
		precints[i] = aux;
	}
}


int LeerOffsetList(char *filename, offset *lista, long *ne)
{
	FILE *f;

	/* Abrimos el archivo */
	f = fopen(filename,"r");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s.",filename);
		return 0;
	}

	/* Leemos el archivo de paquetes y lo guardamos en un vector */
	*ne = 0;
	fscanf(f,"%ld:%ld",&lista[*ne].offset,&lista[*ne].length);
	while(!feof(f))
	{
		//printf("[%ld] %ld:%ld\n",*ne,lista[*ne].offset,lista[*ne].length);
		*ne = *ne + 1;
		fscanf(f,"%ld:%ld",&lista[*ne].offset,&lista[*ne].length);
	}
	//fclose(f);
	return 1;
}

int EscribirOffsetList(char *filename, offset *lista, long ne)
{
	FILE *f;
	long i;

	/* Creamos el archivo */
	f = fopen(filename,"w");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s.",filename);
		return 0;
	}

	for(i=0;i<ne;i++)
	{
		fprintf(f,"%ld:%ld\n",lista[i].offset,lista[i].length);
	}
	fclose(f);
	return 1;
}

int NumeroDeOffsetList(char *filename)
{
	FILE *f;
	offset o;
	long ne;

	/* Abrimos el archivo */
	f = fopen(filename,"r");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s.",filename);
		return 0;
	}

	/* Leemos el archivo de paquetes y lo guardamos en un vector */
	ne = 0;
	fscanf(f,"%ld:%ld\n",&o.offset,&o.length);
	while(!feof(f))
	{
		ne = ne + 1;
		fscanf(f,"%ld:%ld\n",&o.offset,&o.length);
	}	
	fclose(f);
	return ne;
}

/* Devuelve en listaOut los elementos de listaIn sin repeticiones */
void EliminarRepetidosOne(offset *listaIn, long neIn, offset *listaOut, long *neOut)
{
	long i, j;
	int encontrado;

	*neOut = 0;
	for(i=0;i<neIn;i++)
	{
		encontrado = 0;
		for(j=0;j<*neOut;j++)
		{
			if (listaIn[i].offset==listaOut[j].offset)
			{
				encontrado = 1;
				break;
			}
		}
		if (!encontrado)
		{
			listaOut[*neOut] = listaIn[i];
			*neOut = *neOut + 1;
		}
	}
}

/* Devuevle en listaOut los elementos de listaB que no están en listaA */
void EliminarRepetidosTwo(offset *listaA, long neA, offset *listaB, long neB, offset *listaOut, long *neOut)
{
	long i, j;
	int encontrado;

	*neOut = 0;
	for(i=0;i<neB;i++)
	{
		encontrado = 0;
		for(j=0;j<neA;j++)
		{
			if (listaB[i].offset==listaA[j].offset)
			{
				encontrado = 1;
				break;
			}
		}
		if (!encontrado)
		{
			listaOut[*neOut] = listaB[i];
			*neOut = *neOut + 1;
		}		
	}
}

double SumBytes(offset *lista, long ne)
{
	long i;
	double sum = 0;
	for(i=0;i<ne;i++)
	{
		sum = sum + lista[i].length;
	}
	return sum;
}