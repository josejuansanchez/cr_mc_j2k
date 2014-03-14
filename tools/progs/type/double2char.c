#define BUF_SIZE 4096

#include <stdio.h>

main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    double x[BUF_SIZE];
    char y[BUF_SIZE];
    int r = fread(x,sizeof(double),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	if(x[i]<-128.0) y[i] = -128;
	else if(x[i]>127.0) y[i] = 127;
	else y[i]=(char)x[i];
      }
    }
    fwrite(y,sizeof(char),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
}
