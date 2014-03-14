#define BUF_SIZE 4096

#include <stdio.h>
#include <limits.h>

main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    fprintf(stderr,"Transforma float's en int's\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    float x[BUF_SIZE];
    int y[BUF_SIZE];
    int r = fread(x,sizeof(float),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	if(x[i]<INT_MIN) y[i] = INT_MIN;
	else if(x[i]>INT_MAX) y[i] = INT_MAX;
	else y[i] = (int)x[i];
      }
    }
    fwrite(y,sizeof(int),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
}
