#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if (argc < 5) 
    {
      printf("Uso: %s <gnuplot_filename_in> <block_size> <pixels_in_y> <pixels_in_x>\n",argv[0]);
      exit(1);
    }

    FILE *fin, *fout;
    int y, x, blocks_in_y, blocks_in_x, block_size;
    int pixels_in_y, pixels_in_x;
    //double y_field, x_field;

    /* Actualizamos el tamaño de bloque */
    block_size = atoi(argv[2]);

    printf("block_size: %d\n", block_size);

    /* Actualizamos las dimensiones de la imagen de salida */
    pixels_in_y = atoi(argv[3]);
    pixels_in_x = atoi(argv[4]);

    printf("pixels_in_y: %d\n", pixels_in_y);
    printf("pixels_in_x: %d\n", pixels_in_x);

    /* Actualizamos el número total de bloques en cada eje */
    blocks_in_y = pixels_in_y/block_size;
    blocks_in_x = pixels_in_x/block_size;

    printf("blocks_in_y: %d\n", blocks_in_y);
    printf("blocks_in_x: %d\n", blocks_in_x);

    /* Abrimos el archivo de entrada */
    if ((fin = fopen(argv[1],"r"))== NULL) 
    {
	printf("ERROR: Al leer del archivo de entrada: %s.\n", argv[1]);
	exit(1);
    }

    char filename[80] = "prueba.pgm";
    //strcpy(filename, argv[1]);
    //strcat(filename,".pgm");

    /* Creamos el archivo de salida */
    if ((fout = fopen(filename, "w")) == NULL)	
    {
           printf("ERROR: El crear el archivo de salida.\n");
	   exit(1);
    }
    
    /* Cabecera */
    fprintf(fout,"P5\n");
    /* Dimensiones de la imagen */	
    fprintf(fout,"%d %d\n", blocks_in_x, blocks_in_y);
    /* Máximo valor del archivo */
    fprintf(fout, "%d\n", (int)255);


    /* Leemos el archivo de entrada */
    int x_temp, y_temp;
    float y_field, x_field;

    for(y=0; y<blocks_in_y; y++) 
    {
      for(x=0; x<blocks_in_x; x++) 
      {
	fscanf(fin,"%d %d %f %f\n",&x_temp, &y_temp, &x_field, &y_field);
	x_field = x_field + 128;
  	unsigned char c = (unsigned char)x_field;
	//printf("%d\n",c);
        fwrite(&c,sizeof(unsigned char), 1, fout);
      }
    }

    fclose(fin);	
    fclose(fout);

    return 0;
}

