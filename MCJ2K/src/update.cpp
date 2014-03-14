/* Activa la fases de actualización durante el análisis y la síntesis
   temporal. */
//#define UPDATE_STEP

/*
 * update.cpp
 *
 * Suma a las imágenes pares (S_{2t}) el error de predicción cometido
 * para las mismas. De esta forma, la banda de baja frecuencia creada
 * "se mejora" creándose un promediado.  Ver ../doc/analyze_step.txt y
 * ../doc/synthesize_step.txt.
 *
 * Si la estimación de movimiento es muy buena, esta etapa funciona
 * razonablemente bien, suavizando las reconstrucciones. Sin embargo,
 * cuando la estimación no es muy buena, produce ciertas
 * perturbaciones.
 *
 * Además, el uso de la fase de actualización acarrea otro ligero
 * inconveniente. Cuando la banda de baja frecuencia temporal es
 * actualizada, se generan unas imágenes que ya no son las
 * reales. Cuando se desea descomprimir hasta una determinada banda de
 * frecuencia temporal, el uso de la fase de actualización implica
 * usar la fase de des-actualización en el descompresor. Esto
 * significa que necesitamos los residuos y los campos de
 * movimiento. Con esta información podríamos descomprimir el
 * siguiente nivel de resolución temporal (aunque todavía
 * actualizado). Nótese que sólo el nivel de resolución temporal más
 * alto sería el que no se actualiza.
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdarg.h>
#include <string.h>
//#include "Haar.cpp"
#include "5_3.cpp"
//#include "13_7.cpp"
//#include "SP.cpp"
#include "dwt2d.cpp"
#include "texture.cpp"
#include "motion.cpp"
#include "display.cpp"

#define TC_IO_TYPE unsigned char
#define TC_CPU_TYPE short
#define TEC_IO_TYPE unsigned char
#define TEC_CPU_TYPE short
#define MAX_TC_VAL 255
#define MIN_TC_VAL 0
#define TEXTURE_INTERPOLATION_FILTER _5_3
#define COMPONENTS 3
#define PIXELS_IN_X 352
#define PIXELS_IN_Y 288

//#define DEBUG

int clip(int x, int dim) {
  if(x<0) return 0;
  if(x>=dim) return dim-1;
  return x;   
}

void update
(
 int block_size,
 int blocks_in_y,
 int blocks_in_x,
 int components,
 MVC_TYPE ****mv,
 int *pixels_in_y,
 int *pixels_in_x,
 TC_CPU_TYPE ****reference_picture,
 TEC_CPU_TYPE ***residue_picture
) {
  for(int c=0; c<components; c++) {
    for(int by=0; by<blocks_in_y; by++) {
      for(int bx=0; bx<blocks_in_x; bx++) {
	for(int y=0; y<block_size; y++) {
	  for(int x=0; x<block_size; x++) {
	      int aux;
#define _0_
#ifdef _0_
	      /* Actualizamos la imagen previa. */
	      aux = reference_picture[PREV][c]
		[clip(by*block_size+y+mv[PREV][Y_FIELD][by][bx],pixels_in_y[c])]
		[clip(bx*block_size+x+mv[PREV][X_FIELD][by][bx],pixels_in_x[c])];
	      
	      aux
#ifdef ANALYZE
		+= 
#else
		-=
#endif
		(residue_picture[c]
		 [by*block_size+y]
		 [bx*block_size+x] /*>> iteration*/ /4);
	      
	      if(aux>255) aux = 255; else if(aux<0) aux = 0;
	      
	      reference_picture[PREV][c]
		[clip(by*block_size+y+mv[PREV][Y_FIELD][by][bx],pixels_in_y[c])]
		[clip(bx*block_size+x+mv[PREV][X_FIELD][by][bx],pixels_in_x[c])]
		= aux;
	      
	      /* Actualizamos la imagen posterior. */
	      aux = reference_picture[NEXT][c]
		[clip(by*block_size+y+mv[NEXT][Y_FIELD][by][bx],pixels_in_y[c])]
		[clip(bx*block_size+x+mv[NEXT][X_FIELD][by][bx],pixels_in_x[c])];
	      
	      aux
#ifdef ANALYZE
		+= 
#else
		-=
#endif
		(residue_picture[c]
		 [by*block_size+y]
		 [bx*block_size+x] /*>> iteration*/ /4);
	      
	      if(aux>255) aux = 255; else if(aux<0) aux = 0;
	      
	      reference_picture[NEXT][c]
		[clip(by*block_size+y+mv[NEXT][Y_FIELD][by][bx],pixels_in_y[c])]
		[clip(bx*block_size+x+mv[NEXT][X_FIELD][by][bx],pixels_in_x[c])]
		= aux;
#endif
#ifdef _1_
	      /* Actualizamos la imagen previa. */
	      aux = reference_picture[PREV][c]
		[by*block_size[c]+y]
		[bx*block_size[c]+x];
	      
	      aux
#ifdef ANALYZE
		+= 
#else
		-=
#endif
		(error_picture[c]
		 [clip(by*block_size[c]+y-mv[PREV][Y_FIELD][by][bx],Y[c])]
		 [clip(bx*block_size[c]+x-mv[PREV][X_FIELD][by][bx],X[c])] /*>> iteration*/ /4);
	      
	      if(aux>255) aux = 255; else if(aux<0) aux = 0;
	      
	      reference_picture[PREV][c]
		[by*block_size[c]+y]
		[bx*block_size[c]+x]
		= aux;
	      
	      /* Actualizamos la imagen posterior. */
	      aux = reference_picture[NEXT][c]
		[by*block_size[c]+y]
		[bx*block_size[c]+x];
	      aux
#ifdef ANALYZE
		+= 
#else
		-=
#endif
		(error_picture[c]
		 [clip(by*block_size[c]+y-mv[NEXT][Y_FIELD][by][bx],Y[c])]
		 [clip(bx*block_size[c]+x-mv[NEXT][X_FIELD][by][bx],X[c])] /*>> iteration*/ /4);
	      
	      if(aux>255) aux = 255; else if(aux<0) aux = 0;
	      
	      reference_picture[NEXT][c]
		[by*block_size[c]+y]
		[bx*block_size[c]+x]
		= aux;
#endif
	  }	    
	}
      }
    }
  }
}

#include <getopt.h>

int main(int argc, char *argv[]) {

#if defined DEBUG
  info("%s ", argv[0]);
  for(int i=1; i<argc; i++) {
    info("%s ", argv[i]);
  }
  info("\n");
#endif
  int block_size = 16;
  int components = COMPONENTS;
  char *even_fn = (char *)"even";
  char *frame_types_fn = (char *)"frame_types";
  char *high_fn = (char *)"high";
  char *low_fn = (char *)"low";
  char *motion_fn = (char *)"motion";
  int pictures = 33;
  int pixels_in_x[COMPONENTS] = {PIXELS_IN_X, PIXELS_IN_X/2, PIXELS_IN_X/2};
  int pixels_in_y[COMPONENTS] = {PIXELS_IN_Y, PIXELS_IN_Y/2, PIXELS_IN_Y/2};
  int pix[COMPONENTS], piy[COMPONENTS];
  int subpixel_accuracy = 0;

  /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
  int c;
  while(1) {

    static struct option long_options[] = {
      {"block_size", required_argument, 0, 'b'},
      {"even_fn", required_argument, 0, 'e'},
      {"frame_types_fn", required_argument, 0, 'f'},
      {"high_fn", required_argument, 0, 'h'},
      {"low_fn", required_argument, 0, 'l'},
      {"motion_fn", required_argument, 0, 'm'},
      {"pictures", required_argument, 0, 'p'},
      {"pixels_in_x", required_argument, 0, 'x'},
      {"pixels_in_y", required_argument, 0, 'y'},
      {"subpixel_accuracy", required_argument, 0, 'a'},
      {"help", no_argument, 0, '?'},
      {0, 0, 0, 0}
    };

    int option_index = 0;

    c = getopt_long(argc, argv, "b:e:f:h:l:m:x:y:a:?", long_options, &option_index);

    if(c==-1) {
      /* Ya no hay más opciones. */
      break;
    }
    
    switch (c) {
    case 0:
      /* If this option set a flag, do nothing else now. */
      if (long_options[option_index].flag != 0)
	break;
      info("option %s", long_options[option_index].name);
      if (optarg)
	info(" with arg %s", optarg);
      info("\n");
      break;

    case 'b':
      block_size = atoi(optarg);
#if defined DEBUG
      info("%s: block_size=%d\n", argv[0], block_size);
#endif
      break;
      
    case 'e':
      even_fn = optarg;
#if defined DEBUG
      info("%s: even_fn=\"%s\"\n", argv[0], even_fn);
#endif
      break;

    case 'f':
      frame_types_fn = optarg;
#if defined DEBUG
      info("%s: frame_types_fn=\"%s\"\n", argv[0], frame_types_fn);
#endif
      break;

    case 'h':
      high_fn = optarg;
#if defined DEBUG
      info("%s: high_fn=\"%s\"\n", argv[0], high_fn);
#endif
      break;

    case 'l':
      low_fn = optarg;
#if defined DEBUG
      info("%s: low_fn=\"%s\"\n", argv[0], low_fn);
#endif
      break;

    case 'm':
      motion_fn = optarg;
#if defined DEBUG
      info("%s: motion_fn=\"%s\"\n", argv[0], motion_fn);
#endif
      break;

    case 'p':
      pictures = atoi(optarg);
#if defined DEBUG
      info("%s: pictures=%d\n", argv[0], pictures);
#endif
      break;
      
    case 'x':
      pixels_in_x[0] = atoi(optarg);
      pixels_in_x[1] = pixels_in_x[2] = pixels_in_x[0]/2;      
#if defined DEBUG
      info("%s: pixels_in_x=%d\n", argv[0], pixels_in_x[0]);
#endif
      break;
      
    case 'y':
      pixels_in_y[0] = atoi(optarg);
      pixels_in_y[1] = pixels_in_y[2] = pixels_in_y[0]/2;
#if defined DEBUG
      info("%s: pixels_in_y=%d\n", argv[0], pixels_in_y[0]);
#endif
      break;

    case 'a':
      subpixel_accuracy = atoi(optarg);
#if defined DEBUG
      info("%s: subpixel_accuracy=%d\n", argv[0], subpixel_accuracy);
#endif
      break;
      
    case '?':
#if defined ANALYZE
      printf("+-------------+\n");
      printf("| MCTF update |\n");
      printf("+-------------+\n");
#else
      printf("+----------------+\n");
      printf("| MCTF un_update |\n");
      printf("+----------------+\n");
#endif
      printf("\n");
#if defined ANALYZE
      printf("  Block-based time-domain motion updating\n");
#else
      printf("  Block-based time-domain motion updating\n");
#endif
      printf("\n");
      printf("  Parameters:\n");
      printf("\n");
      printf("   -[-b]lock_size = size of the blocks in the motion estimation process (%d)\n", block_size);
      printf("   -[-e]ven_fn = input file with the even pictures (\"%s\")\n", even_fn);
      printf("   -[-f]rame_types_fn = output file with the frame types (\"%s\")\n", frame_types_fn);
      printf("   -[-h]igh_fn = input file with high-subband pictures (\"%s\")\n", high_fn);
      printf("   -[-l]ow_fn = output file with low-subband pictures (\"%s\")\n", low_fn);
      printf("   -[-m]otion_fn = input file with the motion fields (\"%s\")\n", motion_fn);
      printf("   -[-p]ictures = number of images to process (%d)\n", pictures);
      printf("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n", pixels_in_x[0]);
      printf("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n", pixels_in_y[0]);
      printf("   -[-]subpixel_[a]ccuracy = sub-pixel accuracy of the motion estimation (%d)\n", subpixel_accuracy);
      printf("\n");
      exit(1);
      break;

    default:
      error("%s: Unrecognized argument. Aborting ...\n", argv[0]);
      abort();
    }
  }
  
  /* Comienza el juego. */

  FILE *even_fd; {
    even_fd = fopen(even_fn,
#if defined ANALYZE
		    "r"
#else
		    "w"
#endif
		    );
    if(!even_fd) {
      
#if defined ANALYZE
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], even_fn);
#else
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], even_fn);    
#endif
      abort();
    }
  }

  FILE *high_fd; {
    high_fd = fopen(high_fn, "r");
    if(!high_fd) {
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], high_fn);
      abort();
    }
  }

  FILE *low_fd; {
    low_fd = fopen(low_fn,
#if defined ANALYZE
		   "w"
#else
		   "r"
#endif
		   );
    if(!low_fd) {
#if defined ANALYZE
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], low_fn);
#else
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], low_fn);    
#endif
      abort();
    }
  }

  FILE *motion_fd; {
    motion_fd = fopen(motion_fn, "r");
    if(!motion_fd) {
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], motion_fn);
      abort();
    }
  }

  FILE *frame_types_fd; {
    frame_types_fd = fopen(frame_types_fn, "r");
    if(!frame_types_fd) {
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], frame_types_fn);    
      abort();
    }
  }

  class dwt2d < TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TC_CPU_TYPE > > *image_dwt
    = new class dwt2d < TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TC_CPU_TYPE > >;
  image_dwt->set_max_line_size(PIXELS_IN_X_MAX);
  
  class dwt2d < TEC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TEC_CPU_TYPE > > *error_dwt
    = new class dwt2d < TEC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TEC_CPU_TYPE > >;
  error_dwt->set_max_line_size(PIXELS_IN_X_MAX);

  int blocks_in_y = pixels_in_y[0]/block_size;
  int blocks_in_x = pixels_in_x[0]/block_size;
#if defined DEBUG
  info("%s: blocks in Y=%d\n", argv[0], blocks_in_y);
  info("%s: blocks in X=%d\n", argv[0], blocks_in_x);
#endif

  motion < MVC_TYPE > motion;
  MVC_TYPE ****mv = motion.alloc(blocks_in_y, blocks_in_x);

  texture < TC_IO_TYPE, TC_CPU_TYPE > image;
  texture < TEC_IO_TYPE, TEC_CPU_TYPE > error;

  TC_CPU_TYPE ***reference[2];
  for(int i=0; i<2; i++) {
    reference[i] = new TC_CPU_TYPE ** [COMPONENTS];
    for(int c=0; c<COMPONENTS; c++) {
      reference[i][c] = image.alloc(pixels_in_y[0], pixels_in_x[0], 0);
    }
  }

  TEC_CPU_TYPE ***residue = new TEC_CPU_TYPE ** [COMPONENTS];
  for(int c=0; c<COMPONENTS; c++) {
    residue[c] = error.alloc(pixels_in_y[0], pixels_in_x[0], 0);
  }

  piy[0] = piy[1] = piy[2] = pixels_in_y[0];
  pix[0] = pix[1] = pix[2] = pixels_in_x[0];

  /* Leémos reference[0]. */
#if defined DEBUG
#ifdef ANALYZE
  info("%s: reading picture 0 from \"%s\".\n", argv[0], even_fn);
#else
  info("%s: reading picture 0 from \"%s\".\n", argv[0], low_fn);
#endif
#endif
  for(int c=0; c<COMPONENTS; c++) {
    image.read(
#ifdef ANALYZE
	       even_fd,
#else
	       low_fd,
#endif
	       reference[0][c], pixels_in_y[c], pixels_in_x[c]);
  }
#if defined UPDATE_STEP
  for(int y=0; y<pixels_in_y[0]/2; y++) {
    for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
      reference[0][1][y][x] = 0;
      reference[0][2][y][x] = 0;
    }
  }
  for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
    for(int x=0; x<pixels_in_x[0]/2; x++) {
      reference[0][1][y][x] = 0;
      reference[0][2][y][x] = 0;
    }
  }
  for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
    for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
      reference[0][1][y][x] = 0;
      reference[0][2][y][x] = 0;
    }
  }
  image_dwt->synthesize(reference[0][1], pixels_in_y[0], pixels_in_x[0], 1);
  image_dwt->synthesize(reference[0][2], pixels_in_y[0], pixels_in_x[0], 1);
#endif

  /* Procesamos el resto de imágenes de la secuencia. */
  int i=0;
  for(i; i<pictures/2; i++) {
#if defined DEBUG
    info("%s: reading picture %d from \"%s\".\n", argv[0], i, high_fn);
    //info("%s: Picture %d. ",argv[0], i);
#endif
    for(int c=0; c<COMPONENTS; c++) {
      error.read(high_fd, residue[c], pixels_in_y[c], pixels_in_x[c]);
      /* Recuperamos el rango dinámico orignal del residuo. */
      for(int y=0; y<pixels_in_y[c]; y++) {
	for(int x=0; x<pixels_in_x[c]; x++) {
	  residue[c][y][x] -= 128;
	}
      }
    }
#if defined UPDATE_STEP
    for(int y=0; y<pixels_in_y[0]/2; y++) {
      for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
	residue[1][y][x] = 0;
	residue[2][y][x] = 0;
      }
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      for(int x=0; x<pixels_in_x[0]/2; x++) {
	residue[1][y][x] = 0;
	residue[2][y][x] = 0;
      }
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
	residue[1][y][x] = 0;
	residue[2][y][x] = 0;
      }
    }
    error_dwt->synthesize(residue[1], pixels_in_y[0], pixels_in_x[0], 1);
    error_dwt->synthesize(residue[2], pixels_in_y[0], pixels_in_x[0], 1);
#endif

    /* Leemos reference[1]. */
#if defined DEBUG
#ifdef ANALYZE 
    info("%s: reading picture %d from \"%s\".\n", argv[0], i, even_fn);
#else
    info("%s: reading picture %d from \"%s\".\n", argv[0], i, low_fn);
#endif
#endif
    for(int c=0; c<COMPONENTS; c++) {
      image.read(
#ifdef ANALYZE 
		 even_fd,
#else
		 low_fd,
#endif
		 reference[1][c], pixels_in_y[c], pixels_in_x[c]);
    }
#if defined UPDATE_STEP
    for(int y=0; y<pixels_in_y[0]/2; y++) {
      for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
	reference[1][1][y][x] = 0;
	reference[1][2][y][x] = 0;
      }
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      for(int x=0; x<pixels_in_x[0]/2; x++) {
	reference[1][1][y][x] = 0;
	reference[1][2][y][x] = 0;
      }
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      for(int x=pixels_in_x[0]/2; x<pixels_in_x[0]; x++) {
	reference[1][1][y][x] = 0;
	reference[1][2][y][x] = 0;
      }
    }
    image_dwt->synthesize(reference[1][1], pixels_in_y[0], pixels_in_x[0], 1);
    image_dwt->synthesize(reference[1][2], pixels_in_y[0], pixels_in_x[0], 1);
#endif

#if defined UPDATE_STEP
    motion.read(motion_fd, mv, blocks_in_y, blocks_in_x);
#endif

#if defined UPDATE_STEP
    if(fgetc(frame_types_fd) == 'B') {
      update(block_size,
	     blocks_in_y,
	     blocks_in_x,
	     COMPONENTS,
	     mv,
	     piy,
	     pix,
	     reference,
	     residue);
    
      for(int c=0; c<COMPONENTS; c++) {
	for(int y=0; y<pixels_in_y[c]; y++) {
	  for(int x=0; x<pixels_in_y[c]; x++) {
	    int aux = reference[0][c][y][x];
	    if(aux>MAX_TC_VAL) aux = MAX_TC_VAL;
	    else if(aux<MIN_TC_VAL) aux = MIN_TC_VAL;
	    reference[0][c][y][x] = aux;
	  }
	}
      }
    }
#endif

#if defined DEBUG
#ifdef ANALYZE 
    info("%s: writing picture %d from \"%s\".\n", argv[0], i, low_fn);
#else
    info("%s: writing picture %d from \"%s\".\n", argv[0], i, even_fn);
#endif
#endif
#if defined UPDATE_STEP
    image_dwt->analyze(reference[0][1], pixels_in_y[0], pixels_in_x[0], 1);
    image_dwt->analyze(reference[0][2], pixels_in_y[0], pixels_in_x[0], 1);
#endif 
    for(int c=0; c<COMPONENTS; c++) {
      image.write(
#ifdef ANALYZE
		  low_fd,
#else
		  even_fd,
#endif
		  reference[0][c], pixels_in_y[c], pixels_in_x[c]);
    }

    /* SWAP(&reference_picture[0], &reference_picture[1]). */ {
      TC_CPU_TYPE ***tmp = reference[0];
      reference[0] = reference[1];
      reference[1] = tmp;
    }    
  }

#if defined UPDATE_STEP
  for(int c=0; c<components; c++) {
    for(int y=0; y<pixels_in_y[c]; y++) {
      for(int x=0; x<pixels_in_x[c]; x++) {
	int aux = reference[0][c][y][x];
	if(aux>MAX_TC_VAL) aux = MAX_TC_VAL;
	else if(aux<MIN_TC_VAL) aux = MIN_TC_VAL;
	reference[0][c][y][x] = aux;
      }
    }
  }
#endif

#if defined DEBUG
#ifdef ANALYZE 
  info("%s: writing picture %d from \"%s\".\n", argv[0], i, low_fn);
#else
  info("%s: writing picture %d from \"%s\".\n", argv[0], i, even_fn);
#endif
#endif
#if defined UPDATE_STEP
  image_dwt->analyze(reference[0][1], pixels_in_y[0], pixels_in_x[0], 1);
  image_dwt->analyze(reference[0][2], pixels_in_y[0], pixels_in_x[0], 1);
#endif
  for(int c=0; c<COMPONENTS; c++) {
    image.write(
#ifdef ANALYZE
		low_fd,
#else
		even_fd,
#endif
		reference[0][c], pixels_in_y[c], pixels_in_x[c]);
  }
}
