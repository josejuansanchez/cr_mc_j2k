/* differencesthumbnails.c */

/* Changed: 26 Julio 2013 */
/* x: horizontal coordinate */
/* y: vertical coordinate */

#include <stdio.h>
#include <stdlib.h>
#include "PGM.h"
#include "iroutines.h"

int main (int argc, char *argv[])
{
    long rowsA, colsA;                   /* Dimensiones de la imagen A */
    long rowsB, colsB;                   /* Dimensiones de la imagen B */
    unsigned char **imageA;              /* Array 2D para la imagen A */
    unsigned char **imageB;              /* Array 2D para la imagen B */
    unsigned char **imageC;              /* Array 2D para la imagen C */
    int readOK, writeOK;                 /* Controlan la E/S de disco */
    precint *precincts;                  /* Vector de precintos */
    long np;                             /* Numero de elementos del vector */
    double avg;                          /* Media */
    long contUp, contDown, contEqual;    /* Contadores de precintos que estan por encima, debajo e igual que la media */
    long i, j, ne;
    long WprecinctSize, HprecinctSize;
    long offsetx, offsety;
    double suma;
    long Woffset, Hoffset;

    /* Comprobamos el número de parametros */
    if (argc!=9)
    {
        printf("\nUso: %s <in_filenameA> <in_filenameB> \
          <out_filename_precincts_list.dat> <out_filename_precincts_list.txt> \
          <w_precint_size> <h_precint_size> <w_offset> <h_offset>.\n",argv[0]);
        exit(1);
    }

    /* Reservamos memoria dinámica para la imagen A */
    imageA = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );

    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++)
    {
        imageA[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Reservamos memoria dinámica para la imagen B */
    imageB = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );

    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++)
    {
        imageB[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Reservamos memoria dinámica para la imagen */
    imageC = ( unsigned char** )malloc( MAXROWS*sizeof( unsigned char* ) );

    /* Reservamos memoria para cada fila */
    for(i = 0; i < MAXROWS; i++)
    {
        imageC[i] = ( unsigned char* )malloc( MAXCOLS*sizeof( unsigned char ) );
    }

    /* Leemos la imagen A de disco */
    readOK = pgmRead (argv[1],&rowsA,&colsA,imageA);
    if (!readOK)
    {
        printf("\nError al abrir la imagen: %s.\n",argv[1]);
        exit(1);
    }

    /* Leemos la imagen B de disco */
    readOK = pgmRead (argv[2],&rowsB,&colsB,imageB);
    if (!readOK)
    {
        printf("\nError al abrir la imagen: %s.\n",argv[2]);
        exit(1);
    }

    /* Comprobamos que las dos imágenes tienen las mismas dimensiones */
    if (rowsA!=rowsB || colsA!=colsB)
    {
        printf("\nLas imágenes no tienen las mismas dimensiones.\n");
        exit(1);
    }

    /* Calculamos el numero de precintos que contiene la imagen */
    np = rowsA*colsA;

    /* Reservamos memoria dinámica para el vector de precintos */
    precincts = (precint *) malloc (np*sizeof(precint));

    /* Generamos la imagen C con las diferencias de A - B */
    differencesABS(imageA,imageB,imageC,rowsA,colsA);

    /* Generamos el vector de precintos con las diferencias */
    ne = 0;
    WprecinctSize = atoi(argv[5]);
    HprecinctSize = atoi(argv[6]);
    Woffset = atoi(argv[7]);
    Hoffset = atoi(argv[8]);

    printf("\nnp: %ld \t WprecinctSize: %ld \t HprecinctSize: %ld \t Woffset: %ld \t Hoffset: %ld\n", np, WprecinctSize, HprecinctSize, Woffset, Hoffset);

    for(offsety=0; offsety<rowsA; offsety=offsety + HprecinctSize)
    {
        for(offsetx=0; offsetx<colsA; offsetx=offsetx + WprecinctSize)
        {
            //printf("\n\t**OffsetX: %ld OffsetY: %ld",offsetx,offsety);

            precincts[ne].offsety = offsety*Hoffset;    // Si precintSize==2. / offset=64 para imágenes de 4096. 16 para imágenes de de 1024
            precincts[ne].offsetx = offsetx*Woffset;

            //printf("\n\t\t**OffsetX: %ld OffsetY: %ld",precincts[ne].offsetx,precincts[ne].offsety);

            suma = 0;
            for(i=offsety;i<(offsety + HprecinctSize);i++)
            {
                for(j=offsetx;j<(offsetx + WprecinctSize);j++)
                {
                    suma = suma + imageC[i][j];
                }
            }
            avg = suma/(WprecinctSize*HprecinctSize);

            // Solamente cuando el MSE sea mayor que 1 es cuando guardamos el precinto en la lista
            // e incrementamos el numero de elementos
            if (avg > 1)
            {
                precincts[ne].countDifferences = avg;
                ne = ne + 1;
            }
        }
    }

    /* Actualizamos el número de precintos */
    np = ne;

    /* Ordenamos el vector de precintos */
    OrdenarSeleccionDirecta(precincts,np);

    /* Imprimimos la lista de precintos */
    printPrecinctsList(precincts,np);

    /* Guardamos la lista de precintos .dat en disco */
    writeOK = writePrecinctsToFile(precincts,np,argv[3]);
    if (writeOK)
    {
        printf("\nEl archivo: %s, con la lista de precintos .dat se ha creado con éxito.",argv[3]);
    }
    else
    {
        printf("\nError al crear el archivo de precintos: %s.",argv[3]);
        exit(1);
    }

    /* Guardamos la lista de precintos .txt en disco */
    writeOK = writePrecinctsAndDifferencesToFileTXT(precincts,0,np,argv[4]);
    //writeOK = writePrecinctsToFileTXT(precincts,0,np,argv[4]);
    if (writeOK)
    {
        printf("\nEl archivo: %s, con la lista de precintos .txt se ha creado con éxito.\n",argv[4]);
    }
    else
    {
        printf("\nError al crear el archivo de precintos: %s.\n",argv[4]);
        exit(1);
    }

    return 0;
}
