/*
 * bidirectional_motion_decorrelation.cpp
 *
 * La mayoría del movimiento en las escenas es lineal. Por este
 * motivo, codificamos el campo hacia adelante como el error de
 * predicción del campo hacia atrás cambiado de signo.
 *
 */

#include <stdio.h>  /* NULL, FILE, (f)printf(), stdout, fopen() */
#include <stdlib.h> /* abs(), exit(), EXIT_FAILURE */
#include <stdarg.h>
#include "motion.cpp"
#include "display.cpp"

void decorrelate_field
(
 int blocks_in_x,
 int blocks_in_y,
 MVC_TYPE ****field
 ) {
  for (int y=0; y<blocks_in_y; y++) {
    for (int x=0; x<blocks_in_x; x++) {
#if defined ANALYZE
      /* Descorrelacionamos. */
      field[NEXT][X_FIELD][y][x] -= field[PREV][X_FIELD][y][x];
      field[NEXT][Y_FIELD][y][x] -= field[PREV][Y_FIELD][y][x];
#else
      /* Correlacionamos. */
      field[NEXT][X_FIELD][y][x] += field[PREV][X_FIELD][y][x];
      field[NEXT][Y_FIELD][y][x] += field[PREV][Y_FIELD][y][x];
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
  int fields = 1;
  char *input_fn = (char *)"/dev/zero";
  char *output_fn = (char *)"/dev/zero";

  /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
  int c;
  while(1) {
    
    static struct option long_options[] = {
      {"blocks_in_x", required_argument, 0, 'x'},
      {"blocks_in_y", required_argument, 0, 'y'},
      {"fields", required_argument, 0, 'f'},
      {"input_fn", required_argument, 0, 'i'},
      {"output_fn", required_argument, 0, 'o'},
      {"help", no_argument, 0, '?'},
      {0, 0, 0, 0}
    };
    
    int option_index = 0;
    
    c = getopt_long(argc, argv, "x:y:f:i:o:?", long_options, &option_index);
    
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
#if defined INFO
      info("%s: blocks_in_x=%d\n", argv[0], blocks_in_x);
#endif
      break;
      
    case 'y':
      blocks_in_y = atoi(optarg);
#if defined INFO
      info("%s: blocks_in_y=%d\n", argv[0], blocks_in_y);
 #endif
     break;

    case 'f':
      fields = atoi(optarg);
#if defined INFO
      info("%s: fields=%d\n", argv[0], fields);
#endif
      break;
      
    case 'i':
      input_fn = optarg;
#if defined INFO
      info("%s: input = \"%s\"\n", argv[0], input_fn);
#endif
      break;

    case 'o':
      output_fn = optarg;
#if defined INFO
      info("%s: output = \"%s\"\n", argv[0], output_fn);
 #endif
     break;

    case '?':
#if defined ANALYZE
      printf("+---------------------------------------+\n");
      printf("| MCTF bidirectional_motion_decorrelate |\n");
      printf("+---------------------------------------+\n");
#else
      printf("+-------------------------------------+\n");
      printf("| MCTF bidirectional_motion_correlate |\n");
      printf("+-------------------------------------+\n");
#endif
      printf("\n");
#if defined ANALYZE
      printf("  Bidirectional decorrelation of the motion information.\n");
#else
      printf("  Bidirectional correlation of the motion information.\n");
#endif
      printf("\n");
      printf("  Parameters:\n");
      printf("\n");
      printf("   -[-]blocks_in_[x]=number of blocks in the X direction (%d)\n", blocks_in_x);
      printf("   -[-]blocks_in_[y]=number of blocks in the Y direction (%d)\n", blocks_in_y);
      printf("   -[-f]ields=number of fields in input (%d)\n", fields);
      printf("   -[-i]nput=name of the file with the input fields (\"%s\")\n", input_fn);
      printf("   -[-o]utput=name of the file with the output fields (\"%s\")\n", output_fn);
      printf("\n");
      exit(1);
      break;

    default:
      error("%s: Unrecognized argument. Aborting ...\n", argv[0]);
      abort();
    }
  }
  
  /* Comienza el juego. */
  
  FILE *input_fd = fopen( input_fn, "r" );
  if(!input_fd) {
    error("%s: unable to read \"%s\" ... aborting!\n",
	  argv[0], input_fn);
    abort();
  }

  FILE *output_fd = fopen( output_fn, "w" );
  if(!output_fd) {
    error("%s: unable to write \"%s\" ... aborting!\n",
	  argv[0], output_fn);
    abort();
  }

  motion < MVC_TYPE > motion;
  MVC_TYPE ****field = motion.alloc(blocks_in_y, blocks_in_x);
  
  for(int i=0; i<fields; i++) {
    
#if defined INFO
    info("%s: %d\n",argv[0], i);
#endif
    motion.read(input_fd, field, blocks_in_y, blocks_in_x);

    decorrelate_field
      (blocks_in_x,
       blocks_in_y,
       field);

    motion.write(output_fd, field, blocks_in_y, blocks_in_x);
    
  }
}
