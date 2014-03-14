#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[]) {
  if(argc>1) {
    fprintf(stderr,"Compute the log() operation to the input\n");
    fprintf(stderr," < double input sequence > double output sequence\n");
    return 1;
  }
 
  for(;;) {
    double x, y;
    fread(&x, sizeof(double), 1, stdin);
    if(feof(stdin)) break;
    y = log(x);
    fwrite(&y, sizeof(double), 1, stdout);
  }
  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
