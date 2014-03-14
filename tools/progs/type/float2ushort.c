#define BUF_SIZE 4096

#include <stdio.h>

main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    float x[BUF_SIZE];
    unsigned short y[BUF_SIZE];
    int r = fread(x,sizeof(float),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	if(x[i]<0) y[i] = 0;
	else if(x[i]>65535) y[i] = 65535;
	else y[i] = (unsigned short)x[i];
      }
    }
    fwrite(y,sizeof(unsigned short),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
}
