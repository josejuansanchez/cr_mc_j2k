#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 4096

int main(int argc, char *argv[]) {

  FILE *f1 = fopen(argv[2],"r");
  FILE *f2 = fopen(argv[3],"r");

  if(argv[1][0]=='i') {
    int num;
    int buf1[BUF_SIZE];
    int buf2[BUF_SIZE];
    int buf3[BUF_SIZE];
    fprintf(stderr,"%s: data type: int\n",argv[0]);
    for(;;) {
      int r1 = fread(buf1,sizeof(int),BUF_SIZE,f1);
      int r2 = fread(buf2,sizeof(int),BUF_SIZE,f2);
      if(r1==0) break;
      {
	int i;
	for(i=0; i<r1; i++) {
	  buf3[i] = buf1[i] + buf2[i];
	}
      }
      fwrite(buf3,sizeof(int),r1,stdout);
    }
  }


  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
