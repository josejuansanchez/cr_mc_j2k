#define BUF_SIZE 4096

#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"int2short < entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"int2short: running\n");
  for(;;) {
    int x[BUF_SIZE];
    short y[BUF_SIZE];
    int r = fread(x,sizeof(int),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	if(x[i]<-32768) y[i] = -32768;
	else if(x[i]>32767) y[i] = 32767;
	else y[i] = (short)x[i];
      }
    }
    fwrite(y,sizeof(short),r,stdout);
  }
  fprintf(stderr,"int2short: done\n");
  
  return 0;
}
