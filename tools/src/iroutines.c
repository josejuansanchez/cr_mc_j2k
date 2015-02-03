#include "PGM.h"
#include "iroutines.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void allocate2D(unsigned char** image, int rows, int cols)
{
    long i;

    /* Reservamos memoria dinámica para la imagen */
    image = ( unsigned char** )malloc( rows*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < rows; i++) 
    {
        image[i] = ( unsigned char* )malloc( cols*sizeof( unsigned char ) );
    }
}

void deallocate2D(unsigned char** image, int rows)
{
    long i;

    /* Liberamos la memoria utilizada por cada fila */
    for(i = 0; i < rows; i++) 
    {
        free(image[i]);
    }
     
    /* Liberamos el array de punteros */
    free(image);
}

void differences(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols)
{
    long i,j;

    /* Restamos píxel a píxel de la imagen A con la imagen B */
    for (i=0; i < rows; i++) 
    {
        for (j=0; j < cols; j++) 
          {
       imageC[i][j] = (unsigned char)(((int)imageA[i][j] - (int)imageB[i][j]) + 128);
       //imageC[i][j] = imageA[i][j] - imageB[i][j];
       }
    }
}

void differencesABS(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols)
{
    long i,j;

    /* Restamos píxel a píxel de la imagen A con la imagen B */
    for (i=0; i < rows; i++) 
    {
       for (j=0; j < cols; j++) 
       {
           imageC[i][j] = abs(imageA[i][j] - imageB[i][j]);
       }
    }
}

void sum(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols)
{
    long i,j;

    for (i=0; i < rows; i++) 
    {
       for (j=0; j < cols; j++) 
       {
           imageC[i][j] = (imageA[i][j] + imageB[i][j])/2;
       }
    }
}

/* Dibuja los bordes de un code block */
void drawCodeblock(unsigned char **image, long horizontalCoordinate, long verticalCoordinate, long color, long precinctSize)
{
    long i, j;
    
    for(i=verticalCoordinate;i<(verticalCoordinate + precinctSize);i++)
    {
       for(j=horizontalCoordinate;j<(horizontalCoordinate + precinctSize);j++)
       {
           if (i==verticalCoordinate) image[i][j] = color;
           if (i==(verticalCoordinate+precinctSize)-1) image[i][j] = color;
           if (j==horizontalCoordinate) image[i][j] = color;
           if (j==(horizontalCoordinate+precinctSize)-1) image[i][j] = color;
       }
    }
}

void drawCodeblock_WH(unsigned char **image, long horizontalCoordinate, long verticalCoordinate, long color, long WprecinctSize, long HprecinctSize)
{
    long i, j;
    
    for(i=verticalCoordinate;i<(verticalCoordinate + HprecinctSize);i++)
    {
       for(j=horizontalCoordinate;j<(horizontalCoordinate + WprecinctSize);j++)
       {
           if (i==verticalCoordinate) image[i][j] = color;
           if (i==(verticalCoordinate+HprecinctSize)-1) image[i][j] = color;
           if (j==horizontalCoordinate) image[i][j] = color;
           if (j==(horizontalCoordinate+WprecinctSize)-1) image[i][j] = color;
       }
    }
}

/* Dibuja los bordes de todos los code blocks */
void drawAllCodeblocks(unsigned char **image, long rows, long cols, long precinctSize)
{
    long offsetx, offsety;
    long i, j;

    for(offsetx=0; offsetx<rows; offsetx=offsetx + precinctSize)
    {
       for(offsety=0; offsety<cols; offsety=offsety + precinctSize)
       {
           drawCodeblock(image,offsetx,offsety,0,precinctSize);
       }
    }
}

void countDifferences(unsigned char **image, long rows, long cols, unsigned char precision, precint *precincts, long precinctSize, int metricDistance)
{
    long offsetx, offsety;
    long i, j, ne;
    double cont, suma, suma_m1, suma_m2, suma_m3, suma_m4, suma_m5, avg;
    long max, maxx, maxy;
    precint p;

    /* Inicializamos el numero de elementos del vector de precintos */
    ne = 0;

    /* Recorremos las dos imágenes */
    for(offsetx=0; offsetx<rows; offsetx=offsetx + precinctSize)
    {
       for(offsety=0; offsety<cols; offsety=offsety + precinctSize)
       {
        /* Añadimos los valores del offset del precinto actual al vector */
        precincts[ne].offsetx = offsetx;
        precincts[ne].offsety = offsety;

          /* Calculamos las "métricas de distancia" entre WOIS con 5 métodos distintos */

        /* Método 4 */
        suma = 0;
        for(i=offsetx;i<(offsetx + precinctSize);i++)
        {
          for(j=offsety;j<(offsety + precinctSize);j++)
          {
            suma = suma + image[i][j];
          }
        }
        avg = suma/(precinctSize*precinctSize);

        cont = 0;
        suma_m1 = 0;
        suma_m2 = 0;
        suma_m3 = 0;
        suma_m4 = 0;
        suma_m5 = 0;
        for(i=offsetx;i<(offsetx + precinctSize);i++)
        {
          for(j=offsety;j<(offsety + precinctSize);j++)
          {
            /* Método 0 */
            if (abs(image[i][j])>=precision) cont++;

            /* Método 1 */
            suma_m1 =  suma_m1 + image[i][j];

            /* Método 2 */
            suma_m2 =  suma_m2 + abs(image[i][j]);

            /* Método 3 */
            suma_m3 = suma_m3 + (image[i][j]*image[i][j]);

            /* Método 4 */
            suma_m4 = suma_m4 + (image[i][j] - avg)*(image[i][j] - avg);

            /* Método 5 (MSE) */
            suma_m5 = suma_m5 + ((image[i][j]-128)*(image[i][j]-128));
            //printf("%d %d %d\n", (image[i][j]-128), (image[i][j]-128)*(image[i][j]-128), suma_m5);

          }
        }

        /* Añadimos al vector de precintos los valores calculados */
        switch(metricDistance)
        {
          case 0: precincts[ne].countDifferences = cont; break;
          case 1: precincts[ne].countDifferences = abs(suma_m1); break;
          case 2: precincts[ne].countDifferences = suma_m2; break;
          case 3: precincts[ne].countDifferences = sqrt(suma_m3); break;
          case 4: precincts[ne].countDifferences = suma_m4/(precinctSize*precinctSize); break;
          case 5: precincts[ne].countDifferences = suma_m5/(precinctSize*precinctSize); break;
        }

        /* Incrementamos el número de elementos del vector de precintos */
        ne = ne + 1;
       }
    }
}

/* Imprime el contenido de un code block por pantalla */
void printCodeblock(unsigned char **image, long offsetx, long offsety, long precinctSize)
{
    long i, j;
    
    for(i=offsetx;i<(offsetx + precinctSize);i++)
    {
       for(j=offsety;j<(offsety + precinctSize);j++)
       {
           printf(" %3d ",image[i][j]);
       }
       printf("\n");
    }
}

/* Calculamos la media de las diferencias encontradas en los precintos */
double averageDifference(precint *precincts, long np)
{
    long i;
    double sum,avg;
    
    sum = 0;
    for(i=0;i<np;i++)
    {
       sum = sum + precincts[i].countDifferences;
    }
    avg = sum / np;
    return avg;
}

/* Devuelve el número de precintos que están por encima, por debajo y que son iguales a la media */
void averageStats(precint *precincts, long np, double avg, long *contUp, long *contDown, long *contEqual)
{
    long i;

    *contUp = 0;
    *contDown = 0;
    *contEqual = 0;
    for(i=0;i<np;i++)
    {
       if (precincts[i].countDifferences > avg)
       {
            *contUp = *contUp + 1;
       }
       else
       {
           if (precincts[i].countDifferences < avg)
            *contDown = *contDown + 1;
           else
            *contEqual = *contEqual + 1;
       }
    }
}

/* Imprimimos por pantalla la lista de precintos */
void printPrecinctsList(precint *precincts, long np)
{
    long i;
    for(i=0;i<np;i++)
    {
       printf("\nPrecint: %5ld. CountDiff: %3lf OffsetX: %4ld. OffsetY: %4ld",
       i,precincts[i].countDifferences,precincts[i].offsetx,precincts[i].offsety);
    }
    printf("\n");
}

void printPrecinctsListQualityLayer(precint *precincts, long np)
{
    long i;
    for(i=0;i<np;i++)
    {
       printf("\nPrecint: %5ld. CountDiff: %3lf. OffsetX: %4ld. OffsetY: %4ld QualityLayer: %4ld",
       i,precincts[i].countDifferences,precincts[i].offsetx,precincts[i].offsety,precincts[i].qualitylayer);
    }
    printf("\n");
}

/* Creamos una imagen a partir del vector de precintos */
void precinctsAvgUpToImage(precint *precincts, long np, double avg, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize)
{
    long i, j, k;

    /* Inicializamos la matriz de la imagen con el valor 255 */
    //initializeImage(imageOut,rows,cols,255);

    /* Recorremos el vector de precintos */
    for(i=0;i<np;i++)
    {
       /* Si el numero de diferencias del precinto es mayor o igual a la media */
       if (precincts[i].countDifferences >= avg)
       {
        /* Copiamos los valores de los precintos de la imageIn a la imageOut */
        for(j=precincts[i].offsetx;j<(precincts[i].offsetx + precinctSize);j++)
        {
            for(k=precincts[i].offsety;k<(precincts[i].offsety + precinctSize);k++)
            {
                imageOut[j][k] = imageIn[j][k];
            }
        }
       }
    }
}

/* Creamos una imagen a partir del vector de precintos */
void precinctsAvgDownToImage(precint *precincts, long np, double avg, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize)
{
    long i, j, k;

    /* Inicializamos la matriz de la imagen con el valor 255 */
    //initializeImage(imageOut,rows,cols,255);

    /* Recorremos el vector de precintos */
    for(i=0;i<np;i++)
    {
       /* Si el numero de diferencias del precinto es menor a la media */
       if (precincts[i].countDifferences < avg)
       {
        /* Copiamos los valores de los precintos de la imageIn a la imageOut */
        for(j=precincts[i].offsetx;j<(precincts[i].offsetx + precinctSize);j++)
        {
          for(k=precincts[i].offsety;k<(precincts[i].offsety + precinctSize);k++)
          {
            imageOut[j][k] = imageIn[j][k];
          }
        }
       }
    }
}

/* Creamos una imagen a partir del vector de precintos */
void MaxPrecinctsToImage(precint *precincts, long np, long max, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize)
{
    long i, j, k;

    /* Recorremos el vector de precintos */
    for(i=0;i<max;i++)
    {
        /* Copiamos los valores de los precintos de la imageIn a la imageOut */
        for(j=precincts[i].offsetx;j<(precincts[i].offsetx + precinctSize);j++)
        {
            for(k=precincts[i].offsety;k<(precincts[i].offsety + precinctSize);k++)
            {
                imageOut[j][k] = imageIn[j][k];
            }
        }
    }
}

/* Inicializamos la matriz de una imagen a un valor dado como parámetro */
void initializeImage(unsigned char **image, long rows, long cols, unsigned char value)
{
    long i, j;

    for(i=0;i<rows;i++)
    {
        for(j=0;j<cols;j++)
        {
            image[i][j] = value;
        }
    }
}

/* Ordena el vector de precintos de mayor a menor */
void OrdenarSeleccionDirecta(precint *precincts, long np)
{
    long i,j,k;
    precint aux;

    for(i=0;i<=np-2;i++)
    {
        k = i;
        for(j=i+1;j<=np-1;j++)
        {
            if (precincts[j].countDifferences > precincts[k].countDifferences)
            {
                k = j;
            }
        }
        aux = precincts[k];
        precincts[k] = precincts[i];
        precincts[i] = aux;
    }
}

/* Guarda el vector de precintos en un archivo binario */
int writePrecinctsToFile(precint *precincts, long np, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"wb");
    if (f==NULL)
    {
        printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos el número de elementos del vector y el vector */
    fwrite(&np,sizeof(np),1,f);
    for(i=0;i<np;i++)
    {
        fwrite(&precincts[i],sizeof(precint),1,f);
    }

    fclose(f);
    return 1;
}

/* Guarda el vector de precintos en un archivo de texto */
/* <horizontal_coordinate> <vertical_coordinate> */
int writePrecinctsToFileTXT(precint *precincts, long start, long end, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"wt");
    if (f==NULL)
    {
       printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos el vector */
    for(i=start;i<end;i++)
    {
        fprintf(f, "%4ld %4ld\n",precincts[i].offsetx,precincts[i].offsety);
    }

    fclose(f);
    return 1;
}

/* Lee el vector de precintos de un archivo de texto */
int readPrecinctsFromFileTXT(precint *precincts, long *np, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"rt");
    if (f==NULL)
    {
        printf("\nError al leer el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos el número de elementos del vector y el vector */
    i = 0;
    fscanf(f, "%4ld %4ld\n",&precincts[i].offsetx,&precincts[i].offsety);	
    while(!feof(f))
    {
        i = i + 1;
        fscanf(f, "%4ld %4ld\n",&precincts[i].offsetx,&precincts[i].offsety);
    }
    *np = i+1;

    fclose(f);
    return 1;
}


/* Guarda el vector de precintos en un archivo de texto */
int writePrecinctsWithQualityLayerToFile(precint *precincts, long np, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"wt");
    if (f==NULL)
    {
        printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos el número de elementos del vector y el vector */
    for(i=0;i<np;i++)
    {
        fprintf(f, "%4ld %4ld %4ld\n",precincts[i].offsetx,precincts[i].offsety,precincts[i].qualitylayer);
    }

    fclose(f);
    return 1;
}

/* Lee el vector de precintos desde un archivo de texto */
int readPrecinctsWithQualityLayerFromFile(precint *precincts, long *np, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"rt");
    if (f==NULL)
    {
        printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos el número de elementos del vector y el vector */
    i = 0;
    fscanf(f, "%4ld %4ld %4ld\n",&precincts[i].offsetx,&precincts[i].offsety,&precincts[i].qualitylayer);
    while(!feof(f))
    {
        i = i + 1;
        fscanf(f, "%4ld %4ld %4ld\n",&precincts[i].offsetx,&precincts[i].offsety,&precincts[i].qualitylayer);
    }
    *np = i+1;

    fclose(f);
    return 1;
}

/* Lee el vector de precintos en un archivo binario */
int readPrecinctsToFile(precint *precincts, long *np, char *filename)
{
    FILE *f;
    long i;

    f = fopen(filename,"rb");
    if (f==NULL)
    {
        printf("\nError al abrir el archivo de precintos.\n");
        return 0;
    }

    /* Leemos el número de elementos del vector y el vector */
    fread(np,sizeof(*np),1,f);
    for(i=0;i<*np;i++)
    {
        fread(&precincts[i],sizeof(precint),1,f);
    }

    fclose(f);
    return 1;
}

/* Guarda los precintos que están por debajo de la media en un archivo de texto */
int writePrecinctsAvgDownToFile(precint *precincts, long np, char *filename, double avg)
{
    FILE *f;
    long i;

    f = fopen(filename,"wt");
    if (f==NULL)
    {
        printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos los elementos del vector */
    for(i=0;i<np;i++)
    {
        if (precincts[i].countDifferences < avg)
        fprintf(f, "%4ld %4ld\n",precincts[i].offsetx,precincts[i].offsety);
    }

    fclose(f);
    return 1;
}


/* Guarda los precintos que están por encima o igual que la media en un archivo de texto */
int writePrecinctsAvgUpToFile(precint *precincts, long np, char *filename, double avg)
{
    FILE *f;
    long i;

    f = fopen(filename,"wt");
    if (f==NULL)
    {
        printf("\nError al crear el archivo de precintos.\n");
        return 0;
    }

    /* Guardamos los elementos del vector */
    for(i=0;i<np;i++)
    {
        if (precincts[i].countDifferences >= avg)
        fprintf(f, "%4ld %4ld\n",precincts[i].offsetx,precincts[i].offsety);
    }

    fclose(f);
    return 1;
}

/* Calculamos la capa de calidad que le corresponde a cada precinto */
void CalculateQualityLayer(precint *precincts, long np, long maxqualitylayer)
{
    long i;
    double maxDifference;

    maxDifference = precincts[0].countDifferences;
    for(i=1;i<np;i++)
    {
        if (precincts[i].countDifferences > maxDifference)
        {
        maxDifference = precincts[i].countDifferences;
        }
    }

    for(i=0;i<np;i++)
    {
        precincts[i].qualitylayer =  round(precincts[i].countDifferences / (maxDifference/(double)maxqualitylayer)) + 1;
    }

}

/* Lee el vector de precintos de un archivo de texto */
long countPrecinctsFromFileTXT(char *filename)
{
    FILE *f;
    long i;
    precint p;

    f = fopen(filename,"rt");
    if (f==NULL)
    {
        printf("\nError al leer el archivo de precintos.\n");
        return 0;
    }

    /* Inicializamos el valor del registro para poder comprobar el número de elementos del archivo */
    p.offsetx = -1;
    p.offsety = -1;

    i = 0;
    fscanf(f, "%4ld %4ld\n",&p.offsetx,&p.offsety);
    //printf("\n[%ld] Precint: %ld \t %ld", i, p.offsetx, p.offsety);	
    while(!feof(f))
    {
        i = i + 1;
        fscanf(f, "%4ld %4ld\n",&p.offsetx,&p.offsety);
        //printf("\n[%ld] Precint: %ld \t %ld", i, p.offsetx, p.offsety);
    }
    
    if (p.offsetx!=-1 && p.offsety!=-1)
    {
        i = i + 1;
    }

    fclose(f);
    return i;
}

/* Lee el vector de precintos de un archivo de texto */
int TXTtoDAT(char *filenameIn, char *filenameOut)
{
    FILE *fIn, *fOut;
    long i, np;
    precint p;

    fIn = fopen(filenameIn,"rt");
    if (fIn==NULL)
    {
        printf("\nError al leer el archivo de precintos TXT.\n");
        return 0;
    }

    fOut = fopen(filenameOut,"wb");
    if (fOut==NULL)
    {
        printf("\nError al crear el archivo de precintos DAT.\n");
        return 0;
    }

    /* Contamos el número de precintos del archivo de texto */
    np = countPrecinctsFromFileTXT(filenameIn);

    fwrite(&np,sizeof(np),1,fOut);

    fscanf(fIn, "%4ld %4ld\n",&p.offsetx,&p.offsety);
    while(!feof(fIn))
    {
        fwrite(&p,sizeof(precint),1,fOut);
        fscanf(fIn, "%4ld %4ld\n",&p.offsetx,&p.offsety);
    }

    fclose(fIn);
    fclose(fOut);
    return 1;
}