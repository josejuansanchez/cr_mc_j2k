/*
 * decorrelate.cpp
 *
 * Fase de predicción de la transformada temporal.
 *
 * Cuando se utiliza para analizar, utiliza la información sobre el
 * movimiento para generar una predicción de las imágenes impares
 * (imágenes predichas) a partir de las pares (imágenes de
 * referencia). Luego las predicciones son restadas a las imágenes
 * impares para generar la banda de alta frecuencia temporal (imágenes
 * error). Si la imagen predicha posee una entropía menor o igual que
 * la imagen residuo, es la imagen predicha la que pasa a formar parte
 * de la subbanda de alta frecuencia.
 *
 * Cuando se utiliza para sintetizar, utiliza la información de
 * movimiento para generar una predicción de las imágenes impares a
 * partir de las pares. Luego las predicciones son sumadas a la banda
 * de alta frecuencia temporal (imágenes error) para generar las
 * imágenes impares.
 *
 * La resta o la suma de imágenes se realiza en el dominio de la
 * imagen.
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
#include "entropy.h"

#include "PGM.cpp"

// TC = Texture Component
// IO = Input Output
// CPU = Central Processing Unit
#define TC_IO_TYPE unsigned char
#define TC_CPU_TYPE short
#define MIN_TC_VAL 0
#define MAX_TC_VAL 255
#define TEXTURE_INTERPOLATION_FILTER _5_3
/****/
//#define COMPONENTS 3
#define COMPONENTS 1
/****/
#define PIXELS_IN_X 352
#define PIXELS_IN_Y 288

#define GET_PREDICTION
#define DEBUG

void predict
(
 int block_overlaping,
 int block_size,
 int blocks_in_y,
 int blocks_in_x,
 int components,
 int pixels_in_y,
 int pixels_in_x,
 MVC_TYPE ****mv,
 class dwt2d < TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TC_CPU_TYPE > > *overlap_dwt,
 TC_CPU_TYPE **prediction_block,
 TC_CPU_TYPE ***prediction_picture,
 TC_CPU_TYPE ****reference_picture
) {
  int dwt_border = block_overlaping;
  int levels = 0;
  if(block_overlaping>0) {
    levels = (int)rint(log((double)block_overlaping)/log(2.0));
  }
  for(int c=0; c<components; c++) {
    for(int by=0; by<blocks_in_y; by++) {
      for(int bx=0; bx<blocks_in_x; bx++) {
	
	int mvy0 = mv[PREV][Y_FIELD][by][bx] + by * block_size;
	int mvy1 = mv[NEXT][Y_FIELD][by][bx] + by * block_size;
	int mvx0 = mv[PREV][X_FIELD][by][bx] + bx * block_size;
	int mvx1 = mv[NEXT][X_FIELD][by][bx] + bx * block_size;

	/* Copiamos el bloque. */
	for(int y=-dwt_border; y<(block_size+dwt_border); y++) {
	  for(int x=-dwt_border; x<(block_size+dwt_border); x++) {
	    prediction_block[y+dwt_border][x+dwt_border]
	      =
	      (reference_picture[PREV][c][mvy0+y][mvx0+x]
	       +
	       reference_picture[NEXT][c][mvy1+y][mvx1+x])
	      /2;
	  }
	}
	
	/* DWT del bloque. */
	overlap_dwt->analyze(prediction_block,
			     block_size + dwt_border * 2,
			     block_size + dwt_border * 2,
			     levels);
	
	/* Copiamos en "prediction_picture" las bandas de alta frecuencia. */ {
	  for(int l=1; l<=levels; l++) {
	    int bs = block_size>>l;
	    for(int y=0; y<bs; y++) {
	      for(int x=0; x<bs; x++) {
		/* Banda LH */
		prediction_picture
		  [c]
		  [by*bs+y]
		  [(pixels_in_x>>l)+bx*bs+x]
		  =
		  prediction_block
		  [(dwt_border>>l)+y]
		  [((block_size+dwt_border*3)>>l)+x];
		/* Banda HL */
		prediction_picture
		  [c]
		  [(pixels_in_y>>l)+by*bs+y]
		  [bx*bs+x]
		  =
		  prediction_block
		  [((block_size+dwt_border*3)>>l)+y]
		  [(dwt_border>>l)+x];
		/* Banda HH */
		prediction_picture
		  [c]
		  [(pixels_in_y>>l)+by*bs+y]
		  [(pixels_in_x>>l)+bx*bs+x]
		  =
		  prediction_block
		  [((block_size+dwt_border*3)>>l)+y]
		  [((block_size+dwt_border*3)>>l)+x];
	      } /* for(x) */
	    } /* for(y) */
	  } /* for(l) */
	} /* Bandas de alta frecuencia. */
	
	/* Copiamos en prediction_picture la banda LL. */ { 
	  int bs = block_size>>levels;
	  for(int y=0; y<bs; y++) {
	    for(int x=0; x<bs; x++) {
	      prediction_picture
		[c]
		[by*bs+y]
		[bx*bs+x]
		=
		prediction_block
		[(dwt_border>>levels)+y]
		[(dwt_border>>levels)+x];
	    } /* for(x) */
	  } /* for(y) */
	} /* Banda LL. */
      } /* for(blocks_in_y) */
    } /* for(blocks_in_x) */
    
    overlap_dwt->synthesize(prediction_picture[c], pixels_in_y, pixels_in_x, levels);
   
#ifdef _1_ 
    if(levels) {
      /* Clipping de la predicción. */
      for(int y=0; y<pixels_in_y; y++) {
	for(int x=0; x<pixels_in_x; x++) {
	  TC_CPU_TYPE aux = prediction_picture[c][y][x];
	  if(aux<MIN_TC_VAL) aux=MIN_TC_VAL;
	  else if(aux>MAX_TC_VAL) aux=MAX_TC_VAL;
	  prediction_picture[c][y][x] = aux;
	}
      }
    }
#endif
  } /* for(components) */

} /* predict() */

#include <getopt.h>

int main(int argc, char *argv[]) {

#if defined DEBUG
  info("%s ", argv[0]);
  for(int i=1; i<argc; i++) {
    info("%s ", argv[i]);
  }
  info("\n");
#endif

  int block_overlaping = 0;
  int block_size = 16;
  int components = COMPONENTS;
  char *even_fn = (char *)"even";
  char *frame_types_fn = (char *)"frame_types";
  char *high_fn = (char *)"high";
  char *motion_in_fn = (char *)"motion_in";
#if defined ANALYZE
  char *motion_out_fn = (char *)"motion_out";
#endif
  char *odd_fn = (char *)"odd";
  int pictures = 33;
  /****/
  //int pixels_in_x[COMPONENTS] = {PIXELS_IN_X, PIXELS_IN_X/2, PIXELS_IN_X/2};
  //int pixels_in_y[COMPONENTS] = {PIXELS_IN_Y, PIXELS_IN_Y/2, PIXELS_IN_Y/2};
  int pixels_in_x[COMPONENTS] = {PIXELS_IN_X};
  int pixels_in_y[COMPONENTS] = {PIXELS_IN_Y};
  /****/
  int search_range = 4;
  int subpixel_accuracy = 0;

  /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
  int c;
  while(1) {
    
    static struct option long_options[] = {
      {"block_overlaping", required_argument, 0, 'v'},
      {"block_size", required_argument, 0, 'b'},
      {"even_fn", required_argument, 0, 'e'},
      {"frame_types_fn", required_argument, 0, 'f'},
      {"high_fn", required_argument, 0, 'h'},
      {"motion_in_fn", required_argument, 0, 'i'},
#if defined ANALYZE
      {"motion_out_fn", required_argument, 0, 't'},
#endif
      {"odd_fn", required_argument, 0, 'o'},
      {"pictures", required_argument, 0, 'p'},
      {"pixels_in_x", required_argument, 0, 'x'},
      {"pixels_in_y", required_argument, 0, 'y'},
      {"search_range", required_argument, 0, 's'},
      {"subpixel_accuracy", required_argument, 0, 'a'},
      {"help", no_argument, 0, '?'},
      {0, 0, 0, 0}
    };
    
    int option_index = 0;

    c = getopt_long(argc, argv,
#if defined ANALYZE
		    "v:b:e:f:h:i:t:o:p:x:y:s:a:?",
#else
		    "v:b:e:f:h:i:o:p:x:y:s:a:?",
#endif
		    long_options, &option_index);
    
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
      
    case 'v':
      block_overlaping = atoi(optarg);
#if defined DEBUG
      info("%s: block_overlaping=%d\n", argv[0], block_overlaping);
#endif
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

    case 'i':
      motion_in_fn = optarg;
#if defined DEBUG
      info("%s: motion_in_fn=\"%s\"\n", argv[0], motion_in_fn);
#endif
      break;

#if defined ANALYZE
    case 't':
      motion_out_fn = optarg;
#if defined DEBUG
      info("%s: motion_out_fn=\"%s\"\n", argv[0], motion_out_fn);
#endif
      break;
#endif

    case 'o':
      odd_fn = optarg;
#if defined DEBUG
      info("%s: odd_fn=\"%s\"\n", argv[0], odd_fn);
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

    case 's':
      search_range = atoi(optarg);
#if defined DEBUG
      info("%s: search_range=%d\n", argv[0], search_range);
#endif
      break;
      
    case 'a':
      subpixel_accuracy = atoi(optarg);
#if defined DEBUG
      info("%s: subpixel_accuracy=%d\n", argv[0], subpixel_accuracy);
#endif
      break;
      
    case '?':
      //      print::info("[0;32m\n");
#if defined ANALYZE
      printf("+------------------+\n");
      printf("| MCTF decorrelate |\n");
      printf("+------------------+\n");
#else
      printf("+----------------+\n");
      printf("| MCTF correlate |\n");
      printf("+----------------+\n");
#endif
      printf("\n");
#if defined ANALYZE
      printf("  Block-based time-domain motion decorrelation.\n");
#else
      printf("  Block-based time-domain motion correlation.\n");
#endif
      printf("\n");
      printf("  Parameters:\n");
      printf("\n");
      printf("   -[-]block_o[v]erlaping = number of overlaped pixels between the blocks in the motion estimation (%d)\n", block_overlaping);
      printf("   -[-b]lock_size = size of the blocks in the motion estimation process (%d)\n", block_size);
      printf("   -[-e]ven_fn = input file with the even pictures (\"%s\")\n", even_fn);
      printf("   -[-f]rame_types_fn = output file with the frame types (\"%s\")\n", frame_types_fn);
      printf("   -[-h]igh_fn = input file with high-subband pictures (\"%s\")\n", high_fn);
      printf("   -[-]motion_[i]n_fn = input file with the motion fields (\"%s\")\n", motion_in_fn);
#if defined ANALYZE
      printf("   -[-]mo[t]ion_out_fn = output file with the motion fields (\"%s\")\n", motion_out_fn);
#endif
      printf("   -[-o]dd_fn = input file with odd pictures (\"%s\")\n", odd_fn);
      printf("   -[-p]ictures = number of images to process (%d)\n", pictures);
      printf("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n", pixels_in_x[0]);
      printf("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n", pixels_in_y[0]);
      printf("   -[-s]earch_range = size of the searching area of the motion estimation (%d)\n", search_range);
      printf("   -[-]subpixel_[a]ccuracy = sub-pixel accuracy of the motion estimation (%d)\n", subpixel_accuracy);
      printf("\n");
      exit(1);
      break;
      
    default:
      error("%s: Unrecognized argument. Aborting ...\n", argv[0]);
      abort();
    }
  }
  
  FILE *even_fd; {
    even_fd = fopen(even_fn, "r");
    if(!even_fd) {
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], even_fn);
      abort();
    }
  }

  FILE *motion_in_fd;{
    motion_in_fd = fopen(motion_in_fn, "r");
    if(!motion_in_fd) {
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], motion_in_fn);
      abort();
    }
  }

#if defined ANALYZE
  FILE *motion_out_fd;{
    motion_out_fd = fopen(motion_out_fn, "w");
    if(!motion_out_fd) {
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], motion_out_fn);
      abort();
    }
  }
#endif

  FILE *odd_fd; {
    odd_fd = fopen(odd_fn,
#if defined ANALYZE
		    "r"
#else
		    "w"
#endif
		   );
    if(!odd_fd) {
#if defined ANALYZE
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], odd_fn);
#else
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], odd_fn);
#endif
      abort();
    }
  }
  

  FILE *high_fd; {
    high_fd = fopen(high_fn,
#if defined ANALYZE
		    "w"
#else
		    "r"
#endif
		    );
    if(!high_fd) {
#if defined ANALYZE
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], high_fn);
#else
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], high_fn);    
#endif
      abort();
    }
  }

#if defined GET_PREDICTION
  FILE *prediction_fd; char prediction_fn[80]; {
#if defined ANALYZE
    sprintf(prediction_fn, "prediction_%s", even_fn);
#else
    sprintf(prediction_fn, "prediction_%s", even_fn);
#endif /* ANALYZE */
    prediction_fd = fopen(prediction_fn, "w");
    if(!prediction_fd) {
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], prediction_fn);
      abort();
    }
#if defined DEBUG
    info("%s: writing predictions in \"%s\"\n",
	 argv[0], prediction_fn);
#endif
  }
#endif /* GET_PREDICTION */

  FILE *frame_types_fd; {
    frame_types_fd = fopen(frame_types_fn,
#if defined ANALYZE
			   "w"
#else
			   "r"
#endif
			   );
    if(!frame_types_fd) {
#if defined ANALYZE
      error("%s: unable to write \"%s\" ... aborting!\n",
	    argv[0], frame_types_fn);
#else
      error("%s: unable to read \"%s\" ... aborting!\n",
	    argv[0], frame_types_fn);    
#endif
      abort();
    }
  }

  class dwt2d <
  TC_CPU_TYPE,
    TEXTURE_INTERPOLATION_FILTER <
  TC_CPU_TYPE
    >
    >
  *image_dwt = new class dwt2d <
    TC_CPU_TYPE,
    TEXTURE_INTERPOLATION_FILTER <
      TC_CPU_TYPE
      >
    >;
  image_dwt->set_max_line_size(PIXELS_IN_X_MAX);

  int blocks_in_y = pixels_in_y[0]/block_size;
  int blocks_in_x = pixels_in_x[0]/block_size;
#if defined DEBUG
  info("%s: blocks_in_y = %d\n", argv[0], blocks_in_y);
  info("%s: blocks_in_x = %d\n", argv[0], blocks_in_x);
#endif

  motion < MVC_TYPE > motion;
  texture < TC_IO_TYPE, TC_CPU_TYPE > image;

  MVC_TYPE ****mv = motion.alloc(blocks_in_y, blocks_in_x);

  MVC_TYPE ****zeroes = motion.alloc(blocks_in_y, blocks_in_x);
  for(int by=0; by<blocks_in_y; by++) {
    for(int bx=0; bx<blocks_in_x; bx++) {
      zeroes[0][0][by][bx] = 0;
      zeroes[0][1][by][bx] = 0;
      zeroes[1][0][by][bx] = 0;
      zeroes[1][1][by][bx] = 0;
    }
  }

  TC_CPU_TYPE **prediction_block =
    image.alloc((pixels_in_y[0]/blocks_in_y + block_overlaping*2)
		<< subpixel_accuracy,
		(pixels_in_x[0]/blocks_in_x + block_overlaping*2)
		<< subpixel_accuracy,
		0);

  /****/
  // Modificación: 16 / Julio / 2013
  // Hemos multiplicado por 4 la variable search_rage
  /****/
  int picture_border_size = 4*search_range + block_overlaping;
#if defined DEBUG
  info("%s: picture_border = %d\n", argv[0], picture_border_size);
#endif

  TC_CPU_TYPE ***reference[2];
  for(int i=0; i<2; i++) {
    reference[i] = new TC_CPU_TYPE ** [COMPONENTS];
    for(int c=0; c<COMPONENTS; c++) {
      reference[i][c] =
	      image.alloc(pixels_in_y[0] << subpixel_accuracy,
		    pixels_in_x[0] << subpixel_accuracy,
		    picture_border_size << subpixel_accuracy);
    }
  }

  TC_CPU_TYPE ***predicted = new TC_CPU_TYPE ** [COMPONENTS];
  for(int c=0; c<COMPONENTS; c++) {
    predicted[c] = image.alloc(pixels_in_y[c], /* c */
			       pixels_in_x[c], /* c */
			       picture_border_size);
  }

  TC_CPU_TYPE ***prediction = new TC_CPU_TYPE ** [COMPONENTS];
  for(int c=0; c<COMPONENTS; c++) {
    prediction[c] = image.alloc(pixels_in_y[0] << subpixel_accuracy,
				pixels_in_x[0] << subpixel_accuracy,
				0);
  }
  
  TC_CPU_TYPE ***residue = new TC_CPU_TYPE ** [COMPONENTS];
  for(int c=0; c<COMPONENTS; c++) {
    residue[c] = image.alloc(pixels_in_y[c], /* c */
			     pixels_in_x[c], /* c */
			     0/*picture_border_size*/);
  }
  
#if defined GET_PREDICTION
  TC_CPU_TYPE *line = (TC_CPU_TYPE *)malloc(pixels_in_x[0]*sizeof(TC_CPU_TYPE));
#endif
  
  /* Comienza la descorrelación. */

  /* Leemos la primera imagen (reference[0]). */
  for(int c=0; c<COMPONENTS; c++) {

    /* PRUEBA */
    //image.read(even_fd, reference[0][c], pixels_in_y[c], pixels_in_x[c]);

    /**********/   
    // Reservamos memoria para la imagen que vamos a leer de disco
    unsigned char **imageTemp;
    imageTemp = ( unsigned char** )malloc( pixels_in_y[c]*sizeof( unsigned char* ) );
    for(int i = 0; i < pixels_in_y[c]; i++) 
    {
    	imageTemp[i] = ( unsigned char* )malloc( pixels_in_x[c]*sizeof( unsigned char ) );
    }

    // Leemos la imagen de disco
    long rows_even, cols_even;
    pgmRead (even_fn, &rows_even, &cols_even, imageTemp);

    // Copiamos la imagen que hemos leído de disco a la estructura reference[0]
    for(int y=0; y < pixels_in_y[c]; y++) {
      for(int x=0; x < pixels_in_x[c]; x++) {
	       reference[0][c][y][x] = (TC_CPU_TYPE) imageTemp[y][x];
      }
    }
    /**********/
  }

  /****/
  /* Interpolamos las cromas de reference[0], para que tengan el mismo
     tama~no que la luma. Esto es necesario porque los campos de
     movimiento se aplican a las cromas con la misma precisión que a
     la luma. */

  /* Croma Cb. */

  /*
    +--------------+--------------+
    |              |00000000000000|
    |              |00000000000000|
    |              |00000000000000|
    |              |00000000000000|
    |              |00000000000000|
    |              |00000000000000|
    +--------------+--------------+
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    +--------------+--------------+
   */
  
  /*
  for(int y=0; y<pixels_in_y[0]/2; y++) {
    memset(reference[0][1][y]+pixels_in_x[0]/2, 0,
	   (pixels_in_x[0]*sizeof(TC_CPU_TYPE))/2);
  }
  */

  /*
    +--------------+--------------+
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    |              |              |
    +--------------+--------------+
    |00000000000000|00000000000000|
    |00000000000000|00000000000000|
    |00000000000000|00000000000000|
    |00000000000000|00000000000000|
    |00000000000000|00000000000000|
    |00000000000000|00000000000000|
    +--------------+--------------+
   */

  /*    
  for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
    memset(reference[0][1][y], 0, pixels_in_x[0]*sizeof(TC_CPU_TYPE));
  }
  */

  /* Interpolamos. */
  /*
  image_dwt->synthesize(reference[0][1], pixels_in_y[0], pixels_in_x[0], 1);
  */

  /* Croma Cr. */
  /*
  for(int y=0; y<pixels_in_y[0]/2; y++) {
    memset(reference[0][2][y]+pixels_in_x[0]/2, 0,
	   (pixels_in_x[0]*sizeof(TC_CPU_TYPE))/2);
  }
  for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
    memset(reference[0][2][y], 0, pixels_in_x[0]*sizeof(TC_CPU_TYPE));
  }
  image_dwt->synthesize(reference[0][2], pixels_in_y[0], pixels_in_x[0], 1); 
  */

  /* En este punto referece[0] tiene sus tres componentes con el mismo
     tamaño. Es el momento de interpolar (y rellenar bordes) si se
     está usando estimación de movimiento sub-pixel. */

  /*
  // Interpolamos y rellenamos bordes
  for(int c = 0; c < COMPONENTS; c++) {
    
    for(int s = 1; s <= subpixel_accuracy; s++) {
      
      // Interpolamos. (El error está aquí!)
      for(int y = 0; y < ( pixels_in_y[0] << s ) / 2; y++) {
	memset ( reference[0][c][y] + ( pixels_in_x[0] << s ) / 2,
		 0,
		 ( ( ( pixels_in_x[0] << s ) / 2 ) * sizeof(TC_CPU_TYPE) )
		 );
      }
      
      for(int y = ( pixels_in_y[0] << s) / 2; y < ( pixels_in_y[0] << s); y++) {
	memset(reference[0][c][y],
	       0,
	       ( pixels_in_x[0] << s ) *sizeof(TC_CPU_TYPE) );
      }
      image_dwt->synthesize(reference[0][c],
			    pixels_in_y[0] << s,
			    pixels_in_x[0] << s,
			    1);
      
    }
    
    // Rellenamos.
    image.fill_border(reference[0][c],
		      pixels_in_y[0] << subpixel_accuracy,
		      pixels_in_x[0] << subpixel_accuracy,
		      picture_border_size << subpixel_accuracy);
    
  }
  */
  /****/

  /* Procesamos el resto de imágenes. */
  
  for(int i=0; i<pictures/2; i++) {
    
#if defined ANALYZE /* Descorrelacionamos. */     

#if defined DEBUG
    info("%s: reading picture %d of \"%s\".\n",
	 argv[0], i, odd_fn);
#endif

    /* Leemos siguiente la imagen (que es la que vamos a predecir). */
    for(int c=0; c<COMPONENTS; c++) {

      /* PRUEBA */
      //image.read(odd_fd, predicted[c], pixels_in_y[c], pixels_in_x[c]);

      /**********/
      // Reservamos memoria para la imagen que vamos a leer de disco
      unsigned char **imageTemp;
      imageTemp = ( unsigned char** )malloc( pixels_in_y[c]*sizeof( unsigned char* ) );
      for(int i = 0; i < pixels_in_y[c]; i++) 
      {
    	imageTemp[i] = ( unsigned char* )malloc( pixels_in_x[c]*sizeof( unsigned char ) );
      }

      // Leemos la imagen de disco
      long rows_odd, cols_odd;
      pgmRead (odd_fn, &rows_odd, &cols_odd, imageTemp);

      // Copiamos la imagen que hemos leído de disco a la estructura predicted
      for(int y=0; y<pixels_in_y[c]; y++) {
        for(int x=0; x<pixels_in_x[c]; x++) {
	       predicted[c][y][x] = (TC_CPU_TYPE) imageTemp[y][x];
        }
      }
      /**********/
    }

#else /* SYNTHESIZE.  Correlacionamos. */

#if defined DEBUG
    info("%s: reding picture %d of \"%s\". (high_fn)\n", argv[0], i, high_fn);
#endif

    /* Leemos la imagen residuo. */

    for(int c=0; c<COMPONENTS; c++) {
      image.read(high_fd, residue[c], pixels_in_y[c], pixels_in_x[c]);
      for(int y=0; y<pixels_in_y[c]; y++) {
	     for(int x=0; x<pixels_in_x[c]; x++) {
	       residue[c][y][x] -= 128;
	     }
      }
    }

#endif /* SYNTHESIZE */

#if defined DEBUG
    info("%s: reading picture %d of \"%s\".\n",
	 argv[0], i, even_fn);
#endif

    /* Leemos reference[1], interpolando las cromas. */

    for(int c=0; c<COMPONENTS; c++) {

      /* PRUEBA */
      //image.read(even_fd, reference[1][c], pixels_in_y[c], pixels_in_x[c]);

      /**********/
      // Reservamos memoria para la imagen que vamos a leer de disco
      unsigned char **imageTemp;
      imageTemp = ( unsigned char** )malloc( pixels_in_y[c]*sizeof( unsigned char* ) );
      for(int i = 0; i < pixels_in_y[c]; i++) 
      {
    	 imageTemp[i] = ( unsigned char* )malloc( pixels_in_x[c]*sizeof( unsigned char ) );
      }

      // Leemos la imagen de disco
      long rows_even, cols_even;
      pgmRead (even_fn, &rows_even, &cols_even, imageTemp);

      // Copiamos la imagen que hemos leído de disco a la estructura reference[1]
      for(int y=0; y<pixels_in_y[c]; y++) {
        for(int x=0; x<pixels_in_x[c]; x++) {
	       reference[1][c][y][x] = (TC_CPU_TYPE) imageTemp[y][x];
        }
      }
      /**********/
    }

    /****/
    /*
    // Croma Cb
    for(int y=0; y<pixels_in_y[0]/2; y++) {
      memset(reference[1][1][y]+pixels_in_x[0]/2, 0,
	     (pixels_in_x[0]*sizeof(TC_CPU_TYPE))/2);
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      memset(reference[1][1][y], 0, pixels_in_x[0]*sizeof(TC_CPU_TYPE));
    }
    image_dwt->synthesize(reference[1][1], pixels_in_y[0], pixels_in_x[0], 1);

    // Croma Cr
    for(int y=0; y<pixels_in_y[0]/2; y++) {
      memset(reference[1][2][y]+pixels_in_x[0]/2, 0,
	     (pixels_in_x[0]*sizeof(TC_CPU_TYPE))/2);
    }
    for(int y=pixels_in_y[0]/2; y<pixels_in_y[0]; y++) {
      memset(reference[1][2][y], 0, pixels_in_x[0]*sizeof(TC_CPU_TYPE));
    }
    image_dwt->synthesize(reference[1][2], pixels_in_y[0], pixels_in_x[0], 1);

    // Interpolamos y rellenamos bordes. 
    for(int c = 0; c < COMPONENTS; c++) {
      
      for(int s = 1; s <= subpixel_accuracy; s++) {
	
	    // Interpolamos. (El error está aquí!)
	    for(int y = 0; y < ( pixels_in_y[0] << s ) / 2; y++) {
	      memset ( reference[1][c][y] + ( pixels_in_x[0] << s ) / 2,
		    0,
		    ( ( ( pixels_in_x[0] << s ) / 2 ) * sizeof(TC_CPU_TYPE) )
		    );
	    }
	
	    for(int y = ( pixels_in_y[0] << s) / 2; y < ( pixels_in_y[0] << s); y++) {
	     memset(reference[1][c][y],
		    0,
		    ( pixels_in_x[0] << s ) *sizeof(TC_CPU_TYPE) );
	     }
	
      image_dwt->synthesize(reference[1][c],
			      pixels_in_y[0] << s,
			      pixels_in_x[0] << s,
			      1);

      }
      
      // Rellenamos
      image.fill_border(reference[1][c],
			pixels_in_y[0] << subpixel_accuracy,
			pixels_in_x[0] << subpixel_accuracy,
			picture_border_size << subpixel_accuracy);

    }
    */
    /****/

    /* Leemos los campos de movimiento. */
#if defined DEBUG
    info("%s: reading motion vector field %d in \"%s\".\n",
	 argv[0], i, motion_in_fn);
#endif
    motion.read(motion_in_fd, mv, blocks_in_y, blocks_in_x);

#if defined ANALYZE
    float motion_entropy; {
      static int count[256];
      
      for(int i=0; i<256; i++) {
	     count[i] = 0;
      }
      
      for(int y=0; y<blocks_in_y; y++) {
	     for(int x=0; x<blocks_in_x; x++) {
	       count[ mv[PREV][Y_FIELD][y][x] + 128 ]++;
	       count[ mv[PREV][X_FIELD][y][x] + 128 ]++;
	       count[ mv[NEXT][Y_FIELD][y][x] + 128 ]++;
	       count[ mv[NEXT][X_FIELD][y][x] + 128 ]++;
	     }
      }

      motion_entropy = entropy(count, 256);
    }
#endif /* ANALYZE */

    /* Si la entropía de la imagen predicha es inferior o igual a la
       entropía de la imagen error entonces la imagen predicha
       reemplaza a la imagen error. */

      /* Escribimos la imagen residuo, submuestreando las cromas. */

    predict(block_overlaping << subpixel_accuracy,
	    block_size << subpixel_accuracy,
	    blocks_in_y,
	    blocks_in_x,
	    COMPONENTS,
	    pixels_in_y[0]<<subpixel_accuracy,
	    pixels_in_x[0]<<subpixel_accuracy,
	    mv,
	    image_dwt,
	    prediction_block,
	    prediction,
	    reference);

    for(int c=0; c<COMPONENTS; c++) {
      for(int y=0; y<pixels_in_y[0] << subpixel_accuracy; y++) {
       for(int x=0; x<pixels_in_x[0] << subpixel_accuracy; x++) {
         if (prediction[c][y][x] < 0) prediction[c][y][x] = 0;
         else if (
          prediction[c][y][x] > 255) prediction[c][y][x] = 255;
       }
      }
    }

    /* Submuestreamos las tres componentes porque la compensación de
       movimiento se hace a la resolución original del vídeo. */
    for(int c=0; c<COMPONENTS; c++) {
      image_dwt->analyze(prediction[c],
			 pixels_in_y[0] << subpixel_accuracy,
			 pixels_in_x[0] << subpixel_accuracy,
			 subpixel_accuracy);
    }

    /****/
    /*
    // La predicción está todavía en YUV444 y hay que pasarla a YUV422.
    image_dwt->analyze(prediction[1], pixels_in_y[0], pixels_in_x[0], 1);
    image_dwt->analyze(prediction[2], pixels_in_y[0], pixels_in_x[0], 1);
    */
    /****/

#if defined GET_PREDICTION
#if defined DEBUG
    info("%s: writing picture %d of \"%s\".\n",
	 argv[0], i, prediction_fn);
#endif /* DEBUG */
    for(int c=0; c<COMPONENTS; c++) {
      image.write(prediction_fd, prediction[c], pixels_in_y[c], pixels_in_x[c]);

      // PRUEBA
      /****/
      unsigned char **imageTemp;
      imageTemp = ( unsigned char** )malloc( pixels_in_y[c]*sizeof( unsigned char* ) );
      for(int i = 0; i < pixels_in_y[c]; i++) 
      {
        imageTemp[i] = ( unsigned char* )malloc( pixels_in_x[c]*sizeof( unsigned char ) );
      }

      for(int y=0; y < pixels_in_y[c]; y++) {
        for(int x=0; x < pixels_in_x[c]; x++) {
         imageTemp[y][x] = (unsigned char) prediction[c][y][x];
        }
      }

      pgmWrite("prediction_temp.pgm", pixels_in_y[c], pixels_in_x[c], imageTemp, "");
      /****/
    }
#endif /* GET_PREDICTION */

#if defined ANALYZE

    /* Generamos la imagen "residue". */

#if defined DEBUG
      info("%s: writing picture %d of \"%s\".\n",
	   argv[0], i, high_fn);
#endif

      /*

	Una resta a alta resolución y una reducción, vs, dos
	reducciones y una resta a baja resolución.

	Sin truncar:

	1 2 3 4   1 1 2 2   0  1  1  2     0.5  1.5
	5 6 7 8 - 5 5 6 6 = 0  1  1  2 -> -0.5 -1.5
	8 7 6 5   8 8 7 7   0 -1 -1 -2
	4 3 2 1   4 4 3 3   0 -1 -1 -2

           |         |
           v         v

	3.5 5.5 - 3.0 4.0 =  0.5  1.5
        5.5 3.5   6.0 5.0   -0.5 -1.5

	Truncando:

	1 2 3 4   1 1 2 2   0  1  1  2     0  1
	5 6 7 8 - 5 5 6 6 = 0  1  1  2 -> -1 -2
	8 7 6 5   8 8 7 7   0 -1 -1 -2
	4 3 2 1   4 4 3 3   0 -1 -1 -2

           |         |
           v         v

	3 5     -   3 4 =  0  1
        5 3         6 5   -1 -2
	
	O sea, que es lo mismo compensar el movimiento a alta
	resolución que a baja resolución (siempre y cuando las
	predicciones sean iguales).

       */


    /* Compensamos (con clipping). La compensación se hace a
       resolución over-pixel.*/
    for(int c=0; c<COMPONENTS; c++) {
      for(int y=0; y<pixels_in_y[c]; y++) {
       for(int x=0; x<pixels_in_x[c]; x++) {
         int val = predicted[c][y][x] - prediction[c][y][x];
         if(val < -128) val = -128;
         else if(val > 127) val = 127;
         residue[c][y][x] = val;
       }
     }
    }

    /* Calculamos la entropía de la imagen residuo y de la imagen
       predicha. Sólo usamos la luma. */

    float residue_entropy, predicted_entropy; {
      static int predicted_count[256];
      static int residue_count[256];

      for(int i=0; i<256; i++) {
       predicted_count[i] = 0;
       residue_count[i] = 0;
     }

     for(int y=0; y<pixels_in_y[0]; y++) {
       for(int x=0; x<pixels_in_x[0]; x++) {
        predicted_count[ predicted[0][y][x] ]++;
	      residue_count[ residue[0][y][x] + 128 ]++; // Usar puntero
	     }
      }

      predicted_entropy = entropy(predicted_count, 256);
      residue_entropy = entropy(residue_count, 256);
    }

    /* Si la entropía de la imagen predicha es inferior o igual a la
       entropía de la imagen error entonces la imagen predicha
       reemplaza a la imagen error. */

      /* Escribimos la imagen residuo, submuestreando las cromas. */

    int predicted_size
      = (int)(predicted_entropy * (float)pixels_in_y[0] * (float)pixels_in_x[0]);
    int residue_size
      = (int)(residue_entropy * (float)pixels_in_y[0] * (float)pixels_in_x[0]);
    int motion_size
      = (int)(motion_entropy * (float)blocks_in_y * (float)blocks_in_x);

#if defined DEBUG
    info("predicted_entropy=%f residue_entropy=%f motion_entropy=%f\n",
	 predicted_entropy, residue_entropy, motion_entropy);
    info("predicted_size=%d residue_size=%d motion_size=%d\n",
	 predicted_size, residue_size, motion_size);
#endif

    //if(predicted_entropy <= (residue_entropy + motion_entropy)) /* Imagen de tipo I. */ {
    if(predicted_size <= (residue_size + motion_size)) {

      /* Indicamos en el code-stream que se trata de una imagen I. */
      putc('I', frame_types_fd);

      /* Copiamos predicted a residue. */
      
      for(int c=0; c<COMPONENTS; c++) {
        for(int y=0; y<pixels_in_y[c] /* c */; y++) {
          for(int x=0; x<pixels_in_x[c] /* c */; x++) {
            residue[c][y][x] = predicted[c][y][x];
            //printf("%d ",residue[c][y][x]);
          }
        }
      }

      for(int c=0; c<COMPONENTS; c++) {
	     image.write(high_fd, residue[c], pixels_in_y[c], pixels_in_x[c]);
      }

      /* No hay campo de movimiento (distinto de 0) asociado a una imagen I. */
      motion.write(motion_out_fd, zeroes, blocks_in_y, blocks_in_x);

    } else {

      /* Indicamos en el code-stream que se trata de una imagen B. */
      putc('B', frame_types_fd);

      /* Convertimos al rango [0,255] posiblemente con clipping y escribimos a disco. */

      for(int c=0; c<COMPONENTS; c++) {
	/* El siguiente lazo sólo es necesario si el rango dinámico de
	   la imagen residuo tiene que almacenarse en el rango
	   [0,255]. */
        for(int y=0; y<pixels_in_y[c]; y++) {
          for(int x=0; x<pixels_in_x[c]; x++) {
            int val = residue[c][y][x] + 128;
            if(val < 0) val = 0;
            else if(val > 255) val = 255;
            residue[c][y][x] = val;
          }
        }	
        image.write(high_fd, residue[c], pixels_in_y[c], pixels_in_x[c]);
      }

      /* Las imágenes I sí que tienes campo de movimiento asociado. */
      motion.write(motion_out_fd, mv, blocks_in_y, blocks_in_x);
    }

#else /* SYNTHESIZE */

#if defined DEBUG
    info("%s: writing picture %d of \"%s\".\n",
	 argv[0], i, odd_fn);
#endif

    /* Descompensamos. */

    if(fgetc(frame_types_fd) == 'I') {

      /* Si la imagen es de tipo I, copiamos residue a predicted. */
      for(int c=0; c<COMPONENTS; c++) {
       for(int y=0; y<pixels_in_y[c]; y++) {
         for(int x=0; x<pixels_in_x[c]; x++) {
           predicted[c][y][x] = residue[c][y][x] + 128;
	         /*	if (predicted[c][y][x] < 0 ) predicted[c][y][x] = 0;
		        else if(predicted[c][y][x] > 255 ) predicted[c][y][x] = 255;*/
          }
        }
      }
    } else {
      for(int c=0; c<COMPONENTS; c++) {
       for(int y=0; y<pixels_in_y[c]; y++) {
         for(int x=0; x<pixels_in_x[c]; x++) {
           int val = residue[c][y][x] + prediction[c][y][x];
           if(val<0) val=0;
           else if(val>255) val=255;
           predicted[c][y][x] = val;
         }
       }
     }
    }

    /* Escribimos la imagen predicha, submuestreando las cromas. */
    for(int c=0; c<COMPONENTS; c++) {
      image.write(odd_fd, predicted[c], pixels_in_y[c], pixels_in_x[c]);
    }

#endif /* SYNTHESIZE */
    
    /* SWAP(&reference_picture[0], &reference_picture[1]). */ {
      TC_CPU_TYPE ***tmp = reference[0];
      reference[0] = reference[1];
      reference[1] = tmp;
    }
  }

  delete image_dwt;
}