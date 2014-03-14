#include <stdio.h>

main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"< entrada > salida\n");
    return 1;
  }

  fprintf(stderr,"%s: running\n",argv[0]);
  for(;;) {
    float x;
    char y;
    fread(&x,sizeof(float),1,stdin);
    if(feof(stdin)) break;
    if(x<-128.0) y = -128;
    else if(x>127.0) y = 127;
    else y = (char)x;
    fwrite(&y,sizeof(char),1,stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
}
