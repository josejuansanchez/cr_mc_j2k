#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"ascii2int < entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"ascii2int: running\n");
  for(;;) {
    int x;
    scanf("%d",&x);
    if(feof(stdin)) break;
    fwrite(&x,sizeof(int),1,stdout);
  }
  fprintf(stderr,"ascii2int: done\n");
  return 0;
}
