/*
 * interlevel_motion_decorrelation.cpp
 *
 * Descorrelaciona los campos de movimiento de la iteración actual (i)
 * a partir de los campos de movimiento de la interación posterior
 * (i+1). Si, para un bloque de la iteración i+1 tenemos que una de
 * sus componentes vale X, entonces, es previsible que en la iteración
 * i, valga X/2. Esto es consecuencia del esquema de descorrelación
 * temporal utilizado para las imágenes.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdarg.h>
//#include "Haar.cpp"
#include "5_3.cpp"
//#include "13_7.cpp"
//#include "SP.cpp"
#include "dwt2d.cpp"
#include "texture.cpp"
#include "motion.cpp"
#include "display.cpp"

void decorrelate_field
(
 int blocks_in_x,
 int blocks_in_y,
 MVC_TYPE ****predicted,
 MVC_TYPE ****reference,
 MVC_TYPE ****residue
 ) {
  for (int y=0; y<blocks_in_y; y++) {
    for (int x=0; x<blocks_in_x; x++) {
#if defined ANALYZE
      /* Descorrelacionamos. */
      residue[PREV][X_FIELD][y][x] = predicted[PREV][X_FIELD][y][x] - reference[PREV][X_FIELD][y][x]/2;
      residue[PREV][Y_FIELD][y][x] = predicted[PREV][Y_FIELD][y][x] - reference[PREV][Y_FIELD][y][x]/2;
      residue[NEXT][X_FIELD][y][x] = predicted[NEXT][X_FIELD][y][x] - reference[NEXT][X_FIELD][y][x]/2;
      residue[NEXT][Y_FIELD][y][x] = predicted[NEXT][Y_FIELD][y][x] - reference[NEXT][Y_FIELD][y][x]/2;
#else
      /* Correlacionamos. */
      predicted[PREV][X_FIELD][y][x] = residue[PREV][X_FIELD][y][x] + reference[PREV][X_FIELD][y][x]/2;
      predicted[PREV][Y_FIELD][y][x] = residue[PREV][Y_FIELD][y][x] + reference[PREV][Y_FIELD][y][x]/2;
      predicted[NEXT][X_FIELD][y][x] = residue[NEXT][X_FIELD][y][x] + reference[NEXT][X_FIELD][y][x]/2;
      predicted[NEXT][Y_FIELD][y][x] = residue[NEXT][Y_FIELD][y][x] + reference[NEXT][Y_FIELD][y][x]/2;
#endif
    }
  }
}

#include <getopt.h>

int main(int argc, char *argv[]) {

#if defined DEBUG
  info("%s: ", argv[0]);
  for(int i=1; i<argc; i++) {
    info("%s ", argv[i]);
  }
  info("\n");
#endif

  int blocks_in_x = 22;
  int blocks_in_y = 18;
  int fields_in_predicted = 1;
  char *predicted_fn = (char *)"/dev/zero";
  char *reference_fn = (char *)"/dev/zero";
  char *residue_fn = (char *)"/dev/zero";

  /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
  int c;
  while(1) {
    
    static struct option long_options[] = {
      {"blocks_in_x", required_argument, 0, 'x'},
      {"blocks_in_y", required_argument, 0, 'y'},
      {"fields_in_predicted", required_argument, 0, 'f'},
      {"predicted_fn", required_argument, 0, 'p'},
      {"reference_fn", required_argument, 0, 'r'},
      {"residue_fn", required_argument, 0, 'e'},
      {"help", no_argument, 0, '?'},
      {0, 0, 0, 0}
    };
    
    int option_index = 0;
    
    c = getopt_long(argc, argv, "x:y:f:p:r:e:?", long_options, &option_index);
    
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
      
    case 'x':
      blocks_in_x = atoi(optarg);
#if defined DEBUG
      info("%s: blocks_in_x=%d\n", argv[0], blocks_in_x);
#endif
      break;
      
    case 'y':
      blocks_in_y = atoi(optarg);
#if defined DEBUG
      info("%s: blocks_in_y=%d\n", argv[0], blocks_in_y);
#endif
      break;

    case 'f':
      fields_in_predicted = atoi(optarg);
#if defined DEBUG
      info("%s: fields_in_predicted=%d\n", argv[0], fields_in_predicted);
#endif
      break;

    case 'p':
      predicted_fn = optarg;
#if defined DEBUG
      info("%s: predicted_fn = \"%s\"\n", argv[0], predicted_fn);
#endif
      break;

    case 'r':
      reference_fn = optarg;
#if defined DEBUG
      info("%s: reference_fn = \"%s\"\n", argv[0], reference_fn);
#endif
      break;

    case 'e':
      residue_fn = optarg;
#if defined DEBUG
      info("%s: residue_fn = \"%s\"\n", argv[0], residue_fn);
#endif
      break;
      
    case '?':
#if defined ANALYZE
      printf("+-----------------------------------+\n");
      printf("| SVC interlevel_motion_decorrelate |\n");
      printf("+-----------------------------------+\n");
#else
      printf("+---------------------------------+\n");
      printf("| SVC interlevel_motion_correlate |\n");
      printf("+---------------------------------+\n");
#endif
      printf("\n");
#if defined ANALYZE
      printf("  Interlevel decorrelation of the motion information\n");
#else
      printf("  Interlevel correlation of the motion information\n");
#endif
      printf("\n");
      printf("  Parameters:\n");
      printf("\n");
      printf("   -[-]blocks_in_[x]=number of blocks in the X direction (%d)\n", blocks_in_x);
      printf("   -[-]blocks_in_[y]=number of blocks in the Y direction (%d)\n", blocks_in_y);
      printf("   -[-f]ields_in_predicted=number of motion fields in the	predicted sequence of motion fields(%d)\n", fields_in_predicted);
      printf("   -[-p]redicted=name of the file with the predicted fields(\"%s\")\n", predicted_fn);
      printf("   -[-r]eference=name of the file with the reference fields\"%s\"\n", reference_fn);
      printf("   -[-]r[e]sidue=name of the file with the residues(\"%s\")\n", residue_fn);
      printf("\n");
      exit(1);
      break;
      
    default:
      error("%s: aborting ...\n", argv[0]);
      abort();
    }
  }
  
  FILE *predicted_fd = fopen(predicted_fn,
#if defined ANALYZE
			     "r"
#else
			     "w"
#endif
			     );
  if(!predicted_fd) {
#if defined ANALYZE
    error("%s: unable to read \"%s\" ... aborting!\n", argv[0], predicted_fn);
#else
    error("%s: unable to write \"%s\" ... aborting!\n", argv[0], predicted_fn);    
#endif
    abort();
  }
  
  FILE *reference_fd = fopen(reference_fn, "r");
  if(reference_fd) {
#if defined DEBUG
    info("%s: reference file name = \"%s\"\n",argv[0], reference_fn);
#endif
  } else {
    reference_fd = fopen("/dev/zero", "r");
 #if defined DEBUG
   info("%s: \"%s\" does not exist: reference file name=\"%s\"\n",argv[0],
		 reference_fn, "/dev/zero");
#endif
  }

  FILE *residue_fd = fopen(residue_fn,
#if defined ANALYZE
			   "w"
#else
			   "r"
#endif
			   );
  if(!residue_fd) {
#if defined ANALYZE
    error("%s: unable to write \"%s\" ... aborting!\n", argv[0], residue_fn);
#else
    error("%s: unable to read \"%s\" ... aborting!\n", argv[0], residue_fn);    
#endif
    abort();
  }

  motion < MVC_TYPE > motion;
  MVC_TYPE ****predicted = motion.alloc(blocks_in_y, blocks_in_x);
  MVC_TYPE ****reference = motion.alloc(blocks_in_y, blocks_in_x);
  MVC_TYPE ****residue = motion.alloc(blocks_in_y, blocks_in_x);
  
  for(int i=0; i<fields_in_predicted; i++) {
    
#if defined DEBUG
    info("%s: %d\n",argv[0], i);
#endif
    
    /* Leemos el campo de movimiento que sirve de referencia (el
       campo de movimiento de la iteración temporal superior). */
    motion.read(reference_fd, reference, blocks_in_y, blocks_in_x);
    
    /* Des/correlacionamos dos campos de movimiento
       consecutivos, usando la misma referencia. */
    for(int p=0; p<2; p++) {
#if defined ANALYZE
      /* Leemos el campo de movimiento que va a ser predicho. */
      motion.read(predicted_fd, predicted, blocks_in_y, blocks_in_x);
      if(feof(predicted_fd)) break;
#else
      /* Leemos el campo de movimiento residuo. */
      motion.read(residue_fd, residue, blocks_in_y, blocks_in_x);
      if(feof(residue_fd)) break;
#endif
      
      decorrelate_field
	(blocks_in_x,
	 blocks_in_y,
	 predicted,
	 reference,
	 residue);
      
#if defined ANALYZE
      /* Escribimos el residuo. */
      motion.write(residue_fd, residue, blocks_in_y, blocks_in_x);
#else
      /* Escribimos el la reconstruccón. */
      motion.write(predicted_fd, predicted, blocks_in_y, blocks_in_x);
#endif
    }
    
  }
}
