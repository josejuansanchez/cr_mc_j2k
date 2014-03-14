#include <stdio.h>
#include <stdlib.h>
#include "rgb2yuv.h"

#define BUF_SIZE 4096

class main_rgb2yuv: public rgb2yuv {

public:
  
  main_rgb2yuv(int argc, char *argv[]) {
    
    int rgb[3*BUF_SIZE];
    int yuv[3*BUF_SIZE];
    for(;;) {
      int r = fread(rgb, 3*sizeof(int), BUF_SIZE, stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<BUF_SIZE*3; i+=3) {
	  rgb_to_yuv(rgb+i, yuv+i);
	}
      }
      fwrite(yuv, 3*sizeof(int), r, stdout);
    }
  }

  
};

void print_parameters(int argc, char *argv[]) {
  fprintf(stderr,"rgb2yuv < (int)rgb_sequence > (int)yuv_sequence\n");
}
  
int main(int argc, char *argv[]) {
  if(argc>1) {
    print_parameters(argc, argv);
  } else {
    new main_rgb2yuv(argc, argv);
  }
  return EXIT_SUCCESS;
}
