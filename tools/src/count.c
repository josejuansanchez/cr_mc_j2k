#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main(int argc, char *argv[])
{
    FILE *f;

    /* Comprobamos el número de parametros */
    if (argc!=2)
    {
        printf("\nUso: %s <in_filename_precincts_list_txt>.",argv[0]);
        printf("\nin_filename_precincts_list_txt = Precincts list.\n\n");
        exit(0);
    }

    printf("\nFile: %s",argv[1]);
    printf("\nCount: %ld\n",countPrecinctsFromFileTXT(argv[1]));

    return 1;
}