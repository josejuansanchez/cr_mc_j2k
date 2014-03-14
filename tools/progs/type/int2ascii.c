#define BUF_SIZE 4096

#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    int x[BUF_SIZE];
    int r = fread(&x,sizeof(int),BUF_SIZE,stdin);
    {
      int i;
      for(i=0; i<r; i++) {
	printf("%d\n",x[i]);
      }
    }
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  
  return 0;
}
