#define BUF_SIZE 4096

#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< input > output\n");
    return 1;
  }

#if defined DEBUG
  fprintf(stderr,"%s: running ...\n",argv[0]);
#endif
  for(;;) {
    unsigned char x[BUF_SIZE];
    int y[BUF_SIZE];
    int r = fread(x,sizeof(unsigned char),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	y[i] = (int)x[i];
      }
    }
    fwrite(y,sizeof(int),r,stdout);
  }
#if defined DEBUG
  fprintf(stderr,"%s: done\n",argv[0]);
#endif
  return 0;
}
