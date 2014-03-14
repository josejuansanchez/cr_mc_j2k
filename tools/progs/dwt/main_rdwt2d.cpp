#include "mallok.h"
#include "dprfb.h"
#include "Haar.h"
#include "5_3.h"
#include "13_7.h"
#include "SP.h"
#include "dwt2d.h"
#include "rdwt2d.h"
#include <stdio.h>
#include <stdlib.h>

void work(int argc, char *argv[]) {
  
  int Y = atoi(argv[3]);
  int X = atoi(argv[4]);
  int max_Y_X;
  if(Y>X) max_Y_X = Y; else max_Y_X = X;
  int levels = atoi(argv[5]);
  class rdwt2d dwt/*(max_Y_X,levelsi)*/;
  dwt.set_max_number_of_levels(levels);
  dwt.set_max_line_size(max_Y_X);

  fprintf(stderr,"%s: Y = %d\n",argv[0],Y);
  fprintf(stderr,"%s: X = %d\n",argv[0],X);
  fprintf(stderr,"%s: Number of levels = %d\n",argv[0],levels);
  
  class mallok malloc;
  
  int ****data; /* Nivel de resolución, fase, Y, X */
  data = (int ****)malloc.alloc_1d(levels,sizeof(int ***));
  data[0] = (int ***)malloc.alloc_1d(1,sizeof(int **));
  data[0][0] = (int **)malloc.alloc_2d(Y,X,sizeof(int));
  {
    int l;
    for(l=1; l<levels; l++) {
      data[l] = (int ***)malloc.alloc_1d(1<<(2*l),sizeof(int **));
      int p;
      for(p=0; p<(1<<(2*l)); p++) {
	data[l][p] = (int **)malloc.alloc_2d(Y>>(l-1),X>>(l-1),sizeof(int));
      }
    }
  }

  class dprfb *filter;

  switch(argv[1][0]) {
  case 'H'/*aar*/:
    filter = new class Haar();
    break;

  case 'S'/*P*/:
    filter = new class SP();
    break;

  case '5':
    filter = new class _5_3();
    break;

  case '1':
    filter = new class _13_7();
    break;

  default:
    fprintf(stderr,"%s: undefined filter\n",argv[0]);
  }

  fprintf(stderr,"%s: using %s\n",argv[0], filter->get_filter_name());
  int *line = (int *)malloc.alloc_1d(X, sizeof(int));

  if(!atoi(argv[2])) {
    fprintf(stderr,"%s: direct transform\n",argv[0]);
    {
      fprintf(stderr,"%s: reading data\n",argv[0]);
      int y;
      for(y=0; y<Y; y++) {
	fread(data[0][0][y],sizeof(int),X,stdin);
      }
    }
    dwt./*unsort_*/analyze(data,Y,X,levels,filter);
#define _1_
#ifdef _1_
    int l = levels-1, y, x;
    { /* Banda LL */
      fprintf(stderr,"LL");
      for(y=0; y<Y; y++) {
	for(x=0; x<X; x++) {
	  int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
#define _WEIGHT_
	  line[x] = data[l][p][y>>l][x>>l];
#ifdef _WEIGHT_
	  line[x] <<= (l+1);
#endif
	} /* X */
	fwrite(line, sizeof(line[0]), X, stdout);
      } /* Y */
    } /* Banda LL */
    for(l=levels-1; l>0; l--) {
      fprintf(stderr,"l");
      { /* Banda LH */
	fprintf(stderr,"LH");
	for(y=0; y<Y; y++) {
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
	    line[x] = data[l][p][y>>l][(x>>l)+X/(1<<l)];
#ifdef _WEIGHT_
	    line[x] <<= l;
#endif
	  } /* X */
	  fwrite(line, sizeof(line[0]), X, stdout);
	} /* Y */
      } /* Banda LH */
      { /* Banda HL */
	fprintf(stderr,"HL");
	for(y=0; y<Y; y++) {
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
	    line[x] = data[l][p][(y>>l)+Y/(1<<l)][x>>l];
#ifdef _WEIGHT_
	    line[x] <<= l;
#endif
	  } /* X */
	  fwrite(line, sizeof(line[0]), X, stdout);
	} /* Y */
      } /* Banda HL */
      { /* Banda HH */
	fprintf(stderr,"HH");
	for(y=0; y<Y; y++) {
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
	    line[x] = data[l][p][(y>>l)+Y/(1<<l)][(x>>l)+X/(1<<l)];
#ifdef _WEIGHT_
	    line[x] <<= (l-1);
#endif
	  } /* X */
	  fwrite(line, sizeof(line[0]), X, stdout);
	} /* Y*/
      } /* Banda HH */
    } /* spatial_levels-1 */
#else
    {
      int l;
      for(l=1; l<levels; l++) {
	int p;
	for(p=0; p<(1<<(2*l)); p++) {
	  int y;
	  for(y=0; y<Y>>(l-1); y++) {
	    fwrite(data[l][p][y], sizeof(int), X>>(l-1), stdout);
	  }
	}
      }
    }
#endif
  } else {
    fprintf(stderr,"%s: inverse transform\n",argv[0]);
#ifdef _1_
    int l = levels-1, y, x;
    { /* Banda LL */
      fprintf(stderr,"LL");
      for(y=0; y<Y; y++) {
	fread(line, sizeof(line[0]), X, stdin);
	for(x=0; x<X; x++) {
	  int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
#ifdef _WEIGHT_
	  line[x] >>= (l+1);
#endif
	  data[l][p][y>>l][x>>l] = line[x];
	} /* X */
      } /* Y */
    } /* Banda LL */
    for(l=levels-1; l>0; l--) {
      fprintf(stderr,"l");
      { /* Banda LH */
	fprintf(stderr,"LH");
	for(y=0; y<Y; y++) {
	  fread(line, sizeof(line[0]), X, stdin);
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
#ifdef _WEIGHT_
	    line[x] >>= l;
#endif
	    data[l][p][y>>l][(x>>l)+X/(1<<l)] = line[x];
	  } /* X */
	} /* Y */
      } /* Banda LH */
      { /* Banda HL */
	fprintf(stderr,"HL");
	for(y=0; y<Y; y++) {
	  fread(line, sizeof(line[0]), X, stdin);
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
#ifdef _WEIGHT_
	    line[x] >>= l;
#endif
	    data[l][p][(y>>l)+Y/(1<<l)][x>>l] = line[x];
	  } /* X */
	} /* Y */
      } /* Banda HL */
      { /* Banda HH */
	fprintf(stderr,"HH");
	for(y=0; y<Y; y++) {
	  fread(line, sizeof(line[0]), X, stdin);
	  for(x=0; x<X; x++) {
	    int p = (y%(1<<l))*(1<<l)+(x%(1<<l));
#ifdef _WEIGHT_
	    line[x] >>= (l-1);
#endif
	    data[l][p][(y>>l)+Y/(1<<l)][(x>>l)+X/(1<<l)] = line[x];
	  } /* X */
	} /* Y*/
      } /* Banda HH */
    } /* spatial_levels-1 */
#else
    {
      int l;
      for(l=1; l<levels; l++) {
	int p;
	for(p=0; p<(1<<(2*l)); p++) {
	  int y;
	  for(y=0; y<Y>>(l-1); y++) {
	    fread(data[l][p][y], sizeof(int), X>>(l-1), stdin);
	  }
	}
      }
    }
#endif
    dwt./*unsort_*/synthesize(data,Y,X,levels,filter);
    {
      fprintf(stderr,"%s: writing data\n",argv[0]);
      int y;
      for(y=0; y<Y; y++) {
	fwrite(data[0][0][y],sizeof(int),X,stdout);
      }
    }  
  }
}

void print_parameters(int argc, char *argv[]) {
  fprintf(stderr,"%s {Haar|5/3|S+P|13/7} {0|1} Y X levels < stdin > stdout\n",argv[0]);
  fprintf(stderr," Filter Name\n");
  fprintf(stderr," 0 -> direct DWT\n");
  fprintf(stderr," 1 -> inverse DWT\n");
  fprintf(stderr," Y*X = number of int items\n");
  fprintf(stderr," levels = number of levels of the 2D-DWT\n");
}

int main(int argc, char *argv[]) {
  if(argc<=1) {
    print_parameters(argc,argv);
  } else {
    work(argc,argv);
  }
  return EXIT_SUCCESS;
}
