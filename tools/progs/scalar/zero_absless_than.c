#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 4096

int main(int argc, char *argv[]) {
  if(argc<=1) {
    fprintf(stderr,"%s {char|short|int|float|double} number < input > output\n",argv[0]);
    fprintf(stderr,"Makes zero every abs(item) less than \"number\"\n");
    return 1;
  }
 
  if(argv[1][0]=='c') {
    char num;
    char buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: char\n",argv[0]);
    num=atoi(argv[2]); 
    fprintf(stderr,"%s: zeroing less than %d\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(char),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(abs(buf[i])<num) buf[i] = 0;
	}
      }
      fwrite(buf,sizeof(char),r,stdout);
    }
  }

  if(argv[1][0]=='s') {
    short num;
    short buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: short\n",argv[0]);
    num=atoi(argv[2]); 
    fprintf(stderr,"%s: zeroing less than %d\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(short),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(abs(buf[i])<num) buf[i] = 0;
	}
      }
      fwrite(buf,sizeof(short),r,stdout);
    }
  }

  if(argv[1][0]=='i') {
    int num;
    int buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: int\n",argv[0]);
    num=atoi(argv[2]); 
    fprintf(stderr,"%s: zeroing less than %d\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(int),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(abs(buf[i])<num) buf[i] = 0;
	}
      }
      fwrite(buf,sizeof(int),r,stdout);
    }
  }

  if(argv[1][0]=='f') {
    float num;
    float buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: float\n",argv[0]);
    num=atof(argv[2]); 
    fprintf(stderr,"%s: zeroing less than %f\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(float),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(fabs(buf[i])<num) buf[i] = 0;
	}
      }
      fwrite(buf,sizeof(float),r,stdout);
    }
  }

  if(argv[1][0]=='d') {
    double num;
    double buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: double\n",argv[0]);
    num=atof(argv[2]); 
    fprintf(stderr,"%s: zeroing less than %f\n",argv[0],num);
    for(;;) {
      int r = fread(buf,sizeof(double),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(fabs(buf[i])<num) buf[i] = 0;
	}
      }      
      fwrite(buf,sizeof(double),r,stdout);
    }
  }

  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
