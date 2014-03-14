#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  if(argc<=1) {
    print_parameters();
  } else {
    work(argc,argv);
  }
  return EXIT_SUCCESS;
}

print_parameters() {
  fprintf(stderr,"tex (int)block_size (float)error_probabilty (int)head_size < original_file > received_file\n");
}

work(int argc, char *argv[]) {
  int block_size = atoi(argv[3]);
  float prob = atof(argv[2]);
  int head_size = atoi(argv[1]);
  FILE *in_fd = stdin;
  FILE *out_fd = stdout;
  char *block_buf, *zero_buf;

  fprintf(stderr,"%s: block_size=%d\n", argv[0], block_size);
  fprintf(stderr,"%s: error_probability=%f\n", argv[0], prob);

  block_buf = (char *)malloc(block_size);
  if(!block_buf) {
    perror("malloc");
    fprintf(stderr,"%s: unable to allocate %d bytes of memory\n", argv[0], block_size);
    exit(EXIT_FAILURE);
  }

  zero_buf = (char *)calloc(block_size,sizeof(char));
  if(!zero_buf) {
    perror("malloc");
    fprintf(stderr,"%s: unable to allocate %d bytes of memory\n", argv[0], block_size);
    exit(EXIT_FAILURE);
  }

  fprintf(stderr,"%s: skipping %d bytes of header\n", argv[0], head_size);
  while(head_size>0) {
    putc(getc(in_fd),out_fd);
    head_size--;
  }

  int block_counter = 0;
  
  long int rand;

  for(;;) {
    fread(block_buf, sizeof(char), block_size, in_fd);
    fprintf(stderr,"processing block %d",block_counter);
    rand = random() - RAND_MAX/2;
    if(rand<0) {
      fwrite(zero_buf, sizeof(char), block_size, out_fd);
      fprintf(stderr," ... lost\n");
    } else {
      fwrite(block_buf, sizeof(char), block_size, out_fd);
      fprintf(stderr,"\n");
    }
    if(feof(in_fd)) break;
    block_counter++;
  }
  
  free(zero_buf);
  free(block_buf);
  return 0;
}
