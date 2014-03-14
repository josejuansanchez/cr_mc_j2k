#define MVC_IO_TYPE short
#define MVC_CPU_TYPE short

#define TYPE double

void writeMEToFile(char *filename, int blocks_in_y, int blocks_in_x, MVC_CPU_TYPE ****mv, int prev_or_next)
{
  FILE *f;

  f = fopen(filename,"w");
  if (f==NULL) {
    info("Error al crear el archivo: %s.\n", filename);
    exit(-1);
  }

  for(int y=0; y<blocks_in_y; y++) {
    for(int x=0; x<blocks_in_x; x++) {
      static char aux[80];
      fprintf(f, " %lf %lf", (TYPE)mv[prev_or_next][Y_FIELD][y][x], (TYPE)mv[prev_or_next][X_FIELD][y][x]);
    }
    fprintf(f,"\n");
  }

  fclose(f);
  printf("File: %s created!\n", filename);
}

void writeMEToFileForGnuPlot(char *filename, int blocks_in_y, int blocks_in_x, int block_size, MVC_CPU_TYPE ****mv, int prev_or_next)
{
    FILE *f;

    f = fopen(filename,"w");
    if (f==NULL) {
	info("Error al crear el archivo: %s.\n", filename);
	exit(-1);
    }

    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {								      
	fprintf(f,"%d %d %lf %lf\n",x*block_size, y*block_size, (TYPE)mv[prev_or_next][X_FIELD][y][x], (TYPE)mv[prev_or_next][Y_FIELD][y][x]); // OJO <--- (X_FIELD, Y_FIELD)
      }      
    }

   fclose(f);
   printf("File: %s created!\n", filename);
}

/********************************************************************************************************/

void readMEFromFile(char *filename, int blocks_in_y, int blocks_in_x, TYPE ****mv, int prev_or_next)
{
    FILE *f;

    f = fopen(filename,"r");
    if (f==NULL) {
	info("Error al leer del archivo: %s.\n", filename);
	exit(-1);
    }

    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {
	fscanf(f, " %lf %lf", &mv[prev_or_next][Y_FIELD][y][x], &mv[prev_or_next][X_FIELD][y][x]);
      }
      char newline;
      fscanf(f,"%c",&newline);
    }

   fclose(f);
}

void writeAVGToFile(char *filename, int blocks_in_y, int blocks_in_x, TYPE ****mv, int prev_or_next)
{
    FILE *f;

    f = fopen(filename,"w");
    if (f==NULL) {
	info("Error al crear el archivo: %s.\n", filename);
	exit(-1);
    }

    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {
	fprintf(f," %lf %lf", mv[prev_or_next][Y_FIELD][y][x], mv[prev_or_next][X_FIELD][y][x]);
      }
      fprintf(f,"\n");
    }

   fclose(f);
   printf("File: %s created!\n", filename);
}

void writeAVGToFileForGnuPlot(char *filename, int blocks_in_y, int blocks_in_x, int block_size, TYPE ****mv, int prev_or_next)
{
    FILE *f;

    f = fopen(filename,"w");
    if (f==NULL) {
	info("Error al crear el archivo: %s.\n", filename);
	exit(-1);
    }

    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {
	fprintf(f,"%d %d %lf %lf\n",x*block_size, y*block_size, mv[prev_or_next][X_FIELD][y][x], mv[prev_or_next][Y_FIELD][y][x]);  // OJO <--- (X_FIELD, Y_FIELD)
      }      
    }

   fclose(f);
   printf("File: %s created!\n", filename);
}

