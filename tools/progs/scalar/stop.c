#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 4096

int main(int argc, char *argv[]) {
  if(argc<=1) {
    fprintf(stderr,"%s {char|short|int|float|double} number < input > output\n",argv[0]);
    fprintf(stderr,"Stop copying when copy the number-th item\n");
    return 1;
  }
 
  int limit = atoi(argv[2]);
  int counter = 0;
 
  if(argv[1][0]=='c') {
    char num;
    char buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: char\n",argv[0]);
    for(;;) {
      int r = fread(buf,sizeof(char),BUF_SIZE,stdin);
      if(r==0) break;
      if(counter>limit) break;
      fwrite(buf,sizeof(char),r,stdout);
      counter += r;
    }
  }

  if(argv[1][0]=='s') {
    short num;
    short buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: short\n",argv[0]);
    num=atoi(argv[2]); 
    fprintf(stderr,"%s: adding by %d\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(short),BUF_SIZE,stdin);
      if(r==0) break;
      if(counter>limit) break;
      fwrite(buf,sizeof(short),r,stdout);
      counter +=r;
    }
  }

  if(argv[1][0]=='i') {
    int num;
    int buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: int\n",argv[0]);
    num=atoi(argv[2]); 
    fprintf(stderr,"%s: adding by %d\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(int),BUF_SIZE,stdin);
      if(r==0) break;
      if(counter>limit) break;
      fwrite(buf,sizeof(int),r,stdout);
      counter += r;
    }
  }

  if(argv[1][0]=='f') {
    float num;
    float buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: float\n",argv[0]);
    num=atof(argv[2]); 
    fprintf(stderr,"%s: adding by %f\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(float),BUF_SIZE,stdin);
      if(r==0) break;
      if(counter>limit) break;
      fwrite(buf,sizeof(float),r,stdout);
      counter += r;
    }
  }

  if(argv[1][0]=='d') {
    double num;
    double buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: double\n",argv[0]);
    num=atof(argv[2]); 
    fprintf(stderr,"%s: adding by %f\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(double),BUF_SIZE,stdin);
      if(r==0) break;
      if(counter>limit) break;
      fwrite(buf,sizeof(double),r,stdout);
      counter += r;
    }
  }

  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
