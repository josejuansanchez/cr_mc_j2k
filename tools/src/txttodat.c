#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main(int argc, char *argv[])
{
	FILE *f;

	/* Comprobamos el número de parametros */
	if (argc!=3)
	{
		printf("\nUso: %s <in_filename_precincts_list_txt> <out_filename_precincts_list_dat>.",argv[0]);
		printf("\nin_filename_precincts_list_txt = Precincts list.");
		printf("\nout_filename_precincts_list_dat = Precincts list.\n\n");
		printf("\n*** NOTA: El campo countDiff no toma ningún valor. *** \n\n");
		exit(0);
	}
	
	printf("\nFile: %s",argv[1]);

	if (TXTtoDAT(argv[1], argv[2]))
	{
		printf("\nEl archivo: %s se creó con éxito!\n", argv[2]);
	}
	else
	{
		printf("\nError al crear el archivo: %s.\n", argv[2]);
	}
	return 1;
}