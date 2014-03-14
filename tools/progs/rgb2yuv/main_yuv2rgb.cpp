#include <stdio.h>
#include <stdlib.h>
#include "rgb2yuv.h"

#define BUF_SIZE 4096

class main_yuv2rgb: public rgb2yuv {
  
public:
  
  main_yuv2rgb(int argc, char *argv[]) {
    
    int rgb[3*BUF_SIZE];
    int yuv[3*BUF_SIZE];
    for(;;) {
      int r = fread(rgb, 3*sizeof(int), BUF_SIZE, stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<BUF_SIZE*3; i+=3) {
	  yuv_to_rgb(yuv+i, rgb+i);
	}
      }
      fwrite(rgb, 3*sizeof(int), r, stdout);
    }
  }

  
};


void print_parameters(int argc, char *argv[]) {
  fprintf(stderr,"rgb2yuv < (int)yuv_sequence > (int)rgb_sequence\n");
}

int main(int argc, char *argv[]) {
  if(argc>1) {
    print_parameters(argc, argv);
  } else {
    new main_yuv2rgb(argc, argv);
  }
  return EXIT_SUCCESS;
}
