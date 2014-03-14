#define BUF_SIZE 4096

#include <stdio.h>
#include <netinet/in.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    fprintf(stderr,"Representación de los enteros en bytes de la red\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    int x[BUF_SIZE],y[BUF_SIZE];
    int r = fread(x,sizeof(int),BUF_SIZE,stdin);
    if(r==0) break;
    {
      int i;
      for(i=0; i<r; i++) {
	y[i] = htonl(x[i]);
      }
    }
    fwrite(y,sizeof(int),r,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  
  return 0;
}
