#define BUF_SIZE 4096

#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< input > output\n");
    return 1;
  }
  
  fprintf(stderr,"%s: running ...\n",argv[0]);
  for(;;) {
    short x[BUF_SIZE];
    double y[BUF_SIZE];
    int r = fread(x,sizeof(short),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	y[i] = (double)x[i];
      }
    }
    fwrite(y,sizeof(double),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
