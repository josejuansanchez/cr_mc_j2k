#include <stdio.h>
#include <stdlib.h>

//#include "args.h"

/*
#define N_BYTES_1 1
#define N_BYTES_2 1
*/

int main(int argc, char *argv[]) {
  if(argc<=1) {
    print_parameters();
  } else {
    work(argc,argv);
  }
  return EXIT_SUCCESS;
}

print_parameters() {
  fprintf(stderr,"mux chunk_size_of_the_first_source chunk_size_of_the_second_source first_source < second_source | output\n");
  /*
  fprintf(stderr,"Mux 2 data sequences\n");
  fprintf(stderr," first input data seq. < second input data seq. > output data seq.\n");
  fprintf(stderr," [-n_bytes_1 <chunk size of the first source> (default %d)\n",N_BYTES_1);
  fprintf(stderr," [-n_bytes_2 <chunk size of the first source> (default %d)\n",N_BYTES_2);
  */
}

work(int argc, char *argv[]) {
  int n_bytes_1 = atoi(argv[1]);
  int n_bytes_2 = atoi(argv[2]);
  FILE *fd_1 = fopen(argv[3],"rb");
  FILE *fd_2 = stdin;
  FILE *fd_o = stdout;
  char *buffer_1, *buffer_2;
  
  if(!fd_1) {
    perror("fopen");
    fprintf(stderr,"mux: unable to open \"%s\"\n",argv[1]);
    exit(EXIT_FAILURE);
  }
#if defined DEBUG
  fprintf(stderr,"mux: number of bytes of the first source = %d\n",n_bytes_1);
  fprintf(stderr,"mux: number of bytes of the second source = %d\n",n_bytes_2);
#endif

  buffer_1 = (char *)malloc(n_bytes_1);
  if(!buffer_1) {
    perror("malloc");
    fprintf(stderr,"mux: unable to allocate %d bytes of memory\n",n_bytes_1);
    exit(EXIT_FAILURE);
  }

  buffer_2 = (char *)malloc(n_bytes_2);
  if(!buffer_2) {
    perror("malloc");
    fprintf(stderr,"mux: unable to allocate %d bytes of memory\n",n_bytes_2);
    exit(EXIT_FAILURE);
  }

  for(;;) {
    fread(buffer_1, sizeof(char), n_bytes_1, fd_1);
    if(feof(fd_1)) break;
    fread(buffer_2, sizeof(char), n_bytes_2, fd_2);
    if(feof(fd_2)) break;
    fwrite(buffer_1, sizeof(char), n_bytes_1, fd_o);
    fwrite(buffer_2, sizeof(char), n_bytes_2, fd_o);
  }
  
  free(buffer_1);
  free(buffer_2);
  return 0;
}
