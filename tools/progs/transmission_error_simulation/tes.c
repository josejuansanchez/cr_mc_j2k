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
  fprintf(stderr,"tes block_size list_lost_blocks < original_file > received_file\n");
}

work(int argc, char *argv[]) {
  int block_size = atoi(argv[1]);
  FILE *lost_fd = fopen(argv[2],"r");
  FILE *in_fd = stdin;
  FILE *out_fs = stdout;
  char *block_buf, *zero_buf;
  
  if(!lost_fd) {
    perror("fopen");
    fprintf(stderr,"tes: unable to open \"%s\"\n",argv[1]);
    exit(EXIT_FAILURE);
  }

  fprintf(stderr,"tes: block_size=%d\n",block_size);

  block_buf = (char *)malloc(block_size);
  if(!block_buf) {
    perror("malloc");
    fprintf(stderr,"tes: unable to allocate %d bytes of memory\n",block_size);
    exit(EXIT_FAILURE);
  }

  zero_buf = (char *)calloc(block_size,sizeof(char));
  if(!zero_buf) {
    perror("malloc");
    fprintf(stderr,"tes: unable to allocate %d bytes of memory\n",block_size);
    exit(EXIT_FAILURE);
  }

  int block_counter = 0;
  
  int lost;
  fscanf(lost_fd, "%d", &lost);

  for(;;) {

    fread(block_buf, sizeof(char), block_size, in_fd);
    fprintf(stderr,"processing block %d",block_counter);
    if(lost == block_counter) {
      fwrite(zero_buf, sizeof(char), block_size, out_fs);
      fprintf(stderr," ... erased\n");
      fscanf(lost_fd, "%d", &lost);
    } else {
      fwrite(block_buf, sizeof(char), block_size, out_fs);
      fprintf(stderr,"\n");
    }
    if(feof(in_fd)) break;
    block_counter++;
  }
  
  free(zero_buf);
  free(block_buf);
  return 0;
}
