#define BUF_SIZE 4096

#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    double x[BUF_SIZE];
    int r = fread(x,sizeof(double),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	printf("%f\n",x[i]);
      }
    }
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  
  return 0;
}
