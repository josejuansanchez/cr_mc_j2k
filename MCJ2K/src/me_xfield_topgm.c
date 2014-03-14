#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if (argc < 5) 
    {
      printf("Uso: %s <me_filename_in> <block_size> <pixels_in_y> <pixels_in_x>\n",argv[0]);
      exit(1);
    }

    FILE *fin, *fout;
    int y, x, blocks_in_y, blocks_in_x, block_size;
    int pixels_in_y, pixels_in_x;
    double y_field, x_field;
    int i;

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

    /* Array 2D para la imagen */
    unsigned char **imageOut;

    /* Reservamos memoria dinámica para la imagen de salida */
    imageOut = ( unsigned char** )malloc( pixels_in_y*sizeof( unsigned char* ) );
     
    /* Reservamos memoria para cada fila */
    for(i = 0; i < pixels_in_y; i++)
    {
    	imageOut[i] = ( unsigned char* )malloc( pixels_in_x*sizeof( unsigned char ) );
    }

    /* Leemos el archivo de entrada */
    for(y=0; y<pixels_in_y; y=y+block_size) 
    {
      for(x=0; x<pixels_in_x; x=x+block_size) 
      {
	   fscanf(fin, " %lf %lf", &y_field, &x_field);

	   x_field = x_field * 128;

	   // Clipping [-128, 127]
	   if (x_field < -128) {
		x_field = -128;
	   } else {
		if (x_field > 127)
			x_field = 127;
	   }

	   x_field = x_field + 128;

	   /* Escribimos el bloque en el archivo de salida */
	   int sub_y, sub_x;
	   for(sub_y=y; (sub_y < y+block_size) && (sub_y < pixels_in_y); sub_y++)
	   {
	       for(sub_x=x; (sub_x < x+block_size) && (sub_x < pixels_in_x); sub_x++)
	       {
  		    imageOut[sub_y][sub_x] = (unsigned char)x_field;
	       }
	   }
      }
      char newline;
      fscanf(fin,"%c",&newline);
    }
    fclose(fin);

    /* Cabecera */
    fprintf(fout,"P5\n");
    /* Dimensiones de la imagen */	
    fprintf(fout,"%d %d\n", pixels_in_x, pixels_in_y);
    /* Máximo valor del archivo */
    fprintf(fout, "%d\n", (int)255);

    for(y=0; y<pixels_in_y; y++) 
    {
      for(x=0; x<pixels_in_x; x++) 
      {    
	   fwrite(&imageOut[y][x], sizeof(imageOut[y][x]), 1, fout);
      }
    }
    fclose(fout);

    return 0;
}