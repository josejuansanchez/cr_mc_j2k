#include <stdlib.h>
#include "malloc.h"

void **malloc__alloc_2d(int y, int x, int size) {
  int i;
  void **h = (void **)malloc(y*sizeof(void *));
  for(i=0; i<y; i++) {
    h[i] = (void *)malloc(x*size);
  }
  return h;
}

void malloc__free_2d(void **h, int y) {
  int i;
  for(i=0; i<y; i++) {
    free(h[i]);
  }
  free(h);
}

void ***malloc__alloc_3d(int z, int y, int x, int size) {
  int i;
  void ***h = (void ***)malloc(z*sizeof(void **));
  for(i=0; i<z; i++) {
    h[i] = (void **)malloc__alloc_2d(y,x,size);
  }
  return h;
}

void malloc__free_3d(void ***h, int z, int y) {
  int i;
  for(i=0; i<z; i++) {
    malloc__free_2d((void **)h[i],y);
  }
  free(h);
}
