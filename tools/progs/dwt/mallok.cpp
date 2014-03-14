#include <stdio.h>  /* fprintf() */
#include <stdlib.h> /* malloc(), free() */
#include "mallok.h"

void *mallok::alloc_1d(int x, int size) throw(bad_alloc) {
  void *h = malloc(x*size);
  if(!h) {
    fprintf(stderr,"mallok::alloc_1d: out of memory (x=%d,size=%d)\n",x,size);
    throw bad_alloc();
  }
  return h;
}

void mallok::free_1d(void *h) throw() {
  free(h);
}

void **mallok::alloc_2d(int y, int x, int size) throw(bad_alloc) {
  void **h;
  try {
    h = (void **)mallok::alloc_1d(y,sizeof(void *));
  } catch (bad_alloc) {
    fprintf(stderr,"mallok::alloc_2d: out of memory (y=%d)\n",y);
    throw;
  }
  try {
    h[0] = (void *)mallok::alloc_1d(y*x,size);
  } catch (bad_alloc) {
    fprintf(stderr,"mallok::alloc_2d: out of memory (y*x=%d,size=%d)\n",y*x,size);
    throw;
  }
  int i;
  for(i=1; i<y; i++) {
    h[i] = (unsigned char *)h[i-1] + x*size;
  }
  return h;
}

void mallok::free_2d(void **h) throw() {
  free(h[0]);
  free(h);
}

void ***mallok::alloc_3d(int z, int y, int x, int size) throw(bad_alloc) {
  void ***h;
  try {
    h = (void ***)mallok::alloc_2d(z,y,sizeof(void *));
  } catch (bad_alloc) {
    fprintf(stderr,"mallok::alloc_3d: out of memory (z=%d,y=%d)\n",z,y);
    throw;
  }
  try {
    h[0][0] = (void *)mallok::alloc_1d(z*y*x,size);
  } catch (bad_alloc) {
    fprintf(stderr,"mallok::alloc_3d: out of memory (z*y*x=%d,size=%d)",z*y*x,size);
    throw;
  }
  int i;
  for(i=1; i<z*y; i++) {
    h[i/y][i%y] = (unsigned char *)h[0][i-1] + x*size;
  }
  return h;
}

void mallok::free_3d(void ***h) throw() {
  free(h[0][0]);
  free(h);
}
