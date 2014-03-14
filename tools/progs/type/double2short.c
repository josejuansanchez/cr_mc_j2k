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
    short y[BUF_SIZE];
    int r = fread(x,sizeof(double),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	if(x[i]<-32768.0) y[i] = -32768;
	else if(x[i]>32767.0) y[i] = 32767;
	else y[i] = (short)x[i];
      }
    }
    fwrite(y,sizeof(short),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
}
