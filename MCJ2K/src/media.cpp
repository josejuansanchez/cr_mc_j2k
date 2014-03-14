#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdarg.h>
#include <string.h>

#include "display.cpp"
#include "texture.cpp"
#include "motion.cpp"

#include "io_operations.cpp"

#define DEBUG

int main(int argc, char *argv[])
{
   int block_size;
   int pixels_in_x;
   int pixels_in_y;
   char filename_f[80];
   char filename_g[80];
   TYPE factor_F;
   TYPE factor_G;

   /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
   int c;
   while(1) {
    
	static struct option long_options[] = {
      	{"block_size", required_argument, 0, 'b'},
      	{"pixels_in_x", required_argument, 0, 'x'},
      	{"pixels_in_y", required_argument, 0, 'y'},
        {"filename_f", required_argument, 0, 'f'},
        {"filename_g", required_argument, 0, 'g'},
        {"factor_F", required_argument, 0, 'F'},
        {"factor_G", required_argument, 0, 'G'},
      	{"help", no_argument, 0, '?'},
      	{0, 0, 0, 0}
    	};

    	int option_index = 0;
    
    	c = getopt_long(argc, argv, "b:x:y:f:g:F:G:?", long_options, &option_index);

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
      
           case 'x':
      		pixels_in_x = atoi(optarg);
 		#if defined DEBUG
     		info("%s: pixels_in_x=%d\n", argv[0], pixels_in_x);
		#endif
      		break;
      
           case 'y':
      		pixels_in_y = atoi(optarg);
		#if defined DEBUG
      		info("%s: pixels_in_y=%d\n", argv[0], pixels_in_y);
		#endif
      		break;
      
           case 'f':
		strcpy(filename_f, optarg);
		#if defined DEBUG
      		info("%s: filename_f=%s\n", argv[0], filename_f);
		#endif
      		break;

           case 'g':
		strcpy(filename_g, optarg);
		#if defined DEBUG
      		info("%s: filename_g=%s\n", argv[0], filename_g);
		#endif
      		break;

           case 'F':
      		factor_F = atof(optarg);
 		#if defined DEBUG
     		info("%s: factor_F=%f\n", argv[0], factor_F);
		#endif
      		break;

           case 'G':
      		factor_G = atof(optarg);
 		#if defined DEBUG
     		info("%s: factor_G=%f\n", argv[0], factor_G);
		#endif
      		break;

           case '?':
      		printf("+----------------------+\n");
      		printf("| MCTF motion_estimate |\n");
       		printf("+----------------------+\n");
      		printf("\n");
      		printf("   Block-based time-domain motion estimation.\n");
      		printf("\n");
      		printf("  Parameters:\n");
      		printf("\n");
      		printf("   -[-][b]lock_size = size of the blocks in the motion estimation\n");
      		printf("   -[-]pixels_in_[x] = size of the X dimension of the pictures\n");
      		printf("   -[-]pixels_in_[y] = size of the Y dimension of the pictures\n");
      		printf("   -[-]filename_[f] = motion vector field\n");
      		printf("   -[-]filename_[g] = motion vector field\n");
      		printf("\n");
      		exit(1);
      		break;
      
          default:
      		error("%s: Unrecognized argument. Aborting ...\n", argv[0]);
      		abort();
      }
   }

  int blocks_in_y = pixels_in_y/block_size;
  int blocks_in_x = pixels_in_x/block_size;
  #if defined DEBUG
  info("%s: blocks_in_y=%d\n", argv[0], blocks_in_y);
  info("%s: blocks_in_x=%d\n", argv[0], blocks_in_x);
  #endif

  // Reservamos memoria para mv_A
  TYPE ****mv_A = new TYPE *** [ 2 ]; /* PREV | NEXT */
    for(int i=0; i<2; i++) {
      mv_A[i] = new TYPE ** [2]; /* Y_FIELD | X_FIELD */
      for(int f=0; f<2; f++) {
	mv_A[i][f] = new TYPE * [blocks_in_y];
	for(int y=0; y<blocks_in_y; y++) {
	  mv_A[i][f][y] = new TYPE [blocks_in_x];
	}
      }
  }

  // Reservamos memoria para mv_B
  TYPE ****mv_B = new TYPE *** [ 2 ]; /* PREV | NEXT */
    for(int i=0; i<2; i++) {
      mv_B[i] = new TYPE ** [2]; /* Y_FIELD | X_FIELD */
      for(int f=0; f<2; f++) {
	mv_B[i][f] = new TYPE * [blocks_in_y];
	for(int y=0; y<blocks_in_y; y++) {
	  mv_B[i][f][y] = new TYPE [blocks_in_x];
	}
      }
  }

  // Reservamos memoria para mv_C
  TYPE ****mv_C = new TYPE *** [ 2 ]; /* PREV | NEXT */
    for(int i=0; i<2; i++) {
      mv_C[i] = new TYPE ** [2]; /* Y_FIELD | X_FIELD */
      for(int f=0; f<2; f++) {
	mv_C[i][f] = new TYPE * [blocks_in_y];
	for(int y=0; y<blocks_in_y; y++) {
	  mv_C[i][f][y] = new TYPE [blocks_in_x];
	}
      }
  }

  // PREV = 0; NEXT = 1
  int prev_or_next = 0;		

  // Leemos el primer archivo en mv_A
  readMEFromFile(filename_f, blocks_in_y, blocks_in_x, mv_A, prev_or_next);

  // Leemos el segundo archivo en mv_B
  readMEFromFile(filename_g, blocks_in_y, blocks_in_x, mv_B, prev_or_next);

  // Hacemos la media
  for(int y=0; y<blocks_in_y; y++) {
     for(int x=0; x<blocks_in_x; x++) {
	mv_C[prev_or_next][Y_FIELD][y][x] = ((mv_A[prev_or_next][Y_FIELD][y][x]*factor_F) + (mv_B[prev_or_next][Y_FIELD][y][x]*factor_G))/(factor_F+factor_G);
	mv_C[prev_or_next][X_FIELD][y][x] = ((mv_A[prev_or_next][X_FIELD][y][x]*factor_F) + (mv_B[prev_or_next][X_FIELD][y][x]*factor_G))/(factor_F+factor_G);
      }
  }

  // Guardamos en disco la media de los vectores de movimiento
  char filename_out[80];
  char filename_gnuplot[80];

  sprintf(filename_out, "vectors/avg.dat");
  sprintf(filename_gnuplot, "gnuplot/avg.dat");

  writeAVGToFile(filename_out, blocks_in_y, blocks_in_x, mv_C, prev_or_next);
  writeAVGToFileForGnuPlot(filename_gnuplot, blocks_in_y, blocks_in_x, block_size, mv_C, prev_or_next);

  return 0;
}

