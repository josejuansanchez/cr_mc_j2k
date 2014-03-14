#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 4096

int main(int argc, char *argv[]) {
  if(argc<=1) {
    fprintf(stderr,"%s {char|short|int} number < input > output\n",argv[0]);
    fprintf(stderr,"Compute the AND operation with the \"number\"\n");
    return 1;
  }
 
  if(argv[1][0]=='c') {
    char num;
    char buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: char\n",argv[0]);
    sscanf(argv[2],"%X",&num);    
    fprintf(stderr,"%s: AND width %X\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(char),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  buf[i] &= num;
	}
      }
      fwrite(buf,sizeof(char),r,stdout);
    }
  }

  if(argv[1][0]=='s') {
    short num;
    short buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: short\n",argv[0]);
    sscanf(argv[2],"%X",&num);
    fprintf(stderr,"%s: AND width %X\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(short),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  buf[i] &= num;
	}
      }
      fwrite(buf,sizeof(short),r,stdout);
    }
  }

  if(argv[1][0]=='i') {
    int num;
    int buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: int\n",argv[0]);
    sscanf(argv[2],"%X",&num);
    fprintf(stderr,"%s: AND width %X\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(int),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  buf[i] &= num;
	}
      }
      fwrite(buf,sizeof(int),r,stdout);
    }
  }

  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
