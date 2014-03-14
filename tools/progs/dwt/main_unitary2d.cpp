/*
 * Convierte en unitaria una transformada.
 * gse. 2006.
 */

#include "mallok.h"
#include "dprfb.h"
#include "unitary.h"
#include "dwt2d.h"
#include <stdio.h>
#include <stdlib.h>

void print_parameters(int argc, char *argv[]) {
  fprintf(stderr,"%s {0|1} Y X levels < stdin > stdout\n",argv[0]);
  fprintf(stderr,"0 -> direct energy scaling\n");
  fprintf(stderr,"1 -> inverse energy scaling\n");
  fprintf(stderr,"Y*X = number of int items\n");
  fprintf(stderr,"levels = number of levels of the DWT\n");
}

void work(int argc, char *argv[]) {
  int Y = atoi(argv[2]);
  int X = atoi(argv[3]);
  int levels = atoi(argv[4]);
  fprintf(stderr,"%s: Y = %d\n",argv[0],Y);
  fprintf(stderr,"%s: X = %d\n",argv[0],X);
  fprintf(stderr,"%s: number of levels = %d\n",argv[0],levels);
  int *data = (int *)malloc(X*sizeof(int));

  class mallok malloc;
  int **weight = (int **)malloc.alloc_2d(Y,X,sizeof(int));
  int max;
  if(Y>X) max = Y; else max = X;
  class dwt2d dwt;
  dwt.set_max_line_size(max);

  {
    int y;
    for(y=0; y<Y; y++) {
      int x;
      for(x=0; x<X; x++) {
	weight[y][x] = 0;
      }
    }
  }

  class dprfb *filter = new class unitary();

  dwt.analyze(weight, Y, X, levels, filter);

  if(!atoi(argv[1])) {
    int y;
    for(y=0; y<Y; y++) {
      fread(data,sizeof(int),X,stdin);
      int x;
      for(x=0; x<X; x++) {
	data[x] <<= weight[y][x];
      }
      fwrite(data,sizeof(int),X,stdout);
    }
  } else {
    int y;
    for(y=0; y<Y; y++) {
      fread(data,sizeof(int),X,stdin);
      int x;
      for(x=0; x<X; x++) {
	data[x] >>= weight[y][x];
      }
      fwrite(data,sizeof(int),X,stdout);
    }
  }
} 

int main(int argc, char *argv[]) {
  if(argc<=4) {
    print_parameters(argc,argv);
  } else {
    work(argc,argv);
  }
  return EXIT_SUCCESS;
}

