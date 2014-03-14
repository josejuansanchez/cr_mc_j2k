/*
 * The 2D Discrete Wavelet Transform.
 * gse. 2006.
 */

#include <stdio.h>
#include <stdlib.h>
#include "mallok.h"
#include "dprfb.h"
#include "Haar.h"
#include "5_3.h"
#include "13_7.h"
#include "SP.h"
#include "dwt2d.h"

void print_parameters(int argc, char *argv[]) {
  fprintf(stderr,"%s {Haar|5/3|S+P|13/7} {0|1} Y X levels < stdin > stdout\n",argv[0]);
  fprintf(stderr," Filter Name\n");
  fprintf(stderr," 0 -> direct DWT\n");
  fprintf(stderr," 1 -> inverse DWT\n");
  fprintf(stderr," Y*X = number of int items\n");
  fprintf(stderr," levels = number of levels of the 2D-DWT\n");
}

void work(int argc, char *argv[]) {
  int Y = atoi(argv[3]);
  int X = atoi(argv[4]);
  int max_Y_X;
  if(Y>X) max_Y_X = Y; else max_Y_X = X;
  dwt2d dwt;
  dwt.set_max_line_size(max_Y_X);
  int levels = atoi(argv[5]);
  
  fprintf(stderr,"%s: Y = %d\n",argv[0],Y);
  fprintf(stderr,"%s: X = %d\n",argv[0],X);
  fprintf(stderr,"%s: Number of levels = %d\n",argv[0],levels);
  
  class mallok malloc;
  int **data = (int **)malloc.alloc_2d(Y,X,sizeof(int));

  {
    fprintf(stderr,"%s: reading data\n",argv[0]);
    int y;
    for(y=0; y<Y; y++) {
      fread(data[y],sizeof(int),X,stdin);
    }
  }
  
  class dprfb *filter;

  switch(argv[1][0]) {
  case 'H'/*aar*/:
    //dwt.set_filter(new class Haar());
    filter = new class Haar();
    break;

  case 'S'/*P*/:
    filter = new class SP();
    //dwt.set_filter(new class SP());
    break;

  case '5':
    filter = new class _5_3();
    //dwt.set_filter(new class _5_3());
    break;

  case '1':
    filter = new class _13_7();
    //dwt.set_filter(new class _13_7());
    break;

  default:
    fprintf(stderr,"%s: undefined filter\n",argv[0]);
  }

  dwt.set_filter(filter);

  fprintf(stderr,"%s: using %s\n",argv[0], filter->get_filter_name());

  if(!atoi(argv[2])) {
    fprintf(stderr,"%s: direct transform\n",argv[0]);
    dwt.analyze(data,Y,X,levels/*,filter*/);
  } else {
    fprintf(stderr,"%s: inverse transform\n",argv[0]);
    dwt.synthesize(data,Y,X,levels/*,filter*/);
  }

  {
    fprintf(stderr,"%s: writing data\n",argv[0]);
    int y;
    for(y=0; y<Y; y++) {
      fwrite(data[y],sizeof(int),X,stdout);
    }
  }  

}

int main(int argc, char *argv[]) {
  if(argc<=5) {
    print_parameters(argc,argv);
  } else {
    work(argc,argv);
  }
  return EXIT_SUCCESS;
}

