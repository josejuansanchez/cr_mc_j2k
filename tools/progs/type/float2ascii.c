#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    float x;
    fread(&x,sizeof(float),1,stdin);
    if(feof(stdin)) break;
    printf("%f\n",x);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  
  return 0;
}
