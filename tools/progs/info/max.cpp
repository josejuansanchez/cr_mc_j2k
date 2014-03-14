#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#define BUF_SIZE 4096

int main (int argc, char *argv[]) { 

  if(argc<=1) {
    fprintf(stderr,"%s {char|short|int|float|double} < input\n",argv[0]);
    fprintf(stderr,"Compute which and where the maximum and minimum values are\n");
    return 1;
  }

  int index = 0;
  int max_position;
  int min_position;
  
  fprintf(stderr,"%s: data type: \"%s\"\n",argv[0],argv[1]);

  if(!strcmp(argv[1],"unsigned char")) {
    unsigned char max = 0;
    unsigned char min = 255;
    unsigned char buf[BUF_SIZE];
    for(;;) {
      int r = fread(buf,sizeof(unsigned char),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  unsigned char x = buf[i];
	  if(x>max) {
	    max = x;
	    max_position = index;
	  }
	  if(x<min) {
	    min = x;
	    min_position = index;
	  }
	  index++;
	}
      }      
    }
    fprintf(stderr,"%s: max value = %d\n",argv[0],max);
    fprintf(stderr,"%s: min value = %d\n",argv[0],min);
  }

  if(!strcmp(argv[1],"short")) {
    short max = SHRT_MIN;
    short min = SHRT_MAX;
    short buf[BUF_SIZE];
    for(;;) {
      int r = fread(buf,sizeof(short),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  short x = buf[i];
	  if(x>max) {
	    max = x;
	    max_position = index;
	  }
	  if(x<min) {
	    min = x;
	    min_position = index;
	  }
	  index++;
	}
      }      
    }
    fprintf(stderr,"%s: max value = %d\n",argv[0],max);
    fprintf(stderr,"%s: min value = %d\n",argv[0],min);
  }
  
  if(!strcmp(argv[1],"int")) {
    int max = INT_MIN;
    int min = INT_MAX;
    int buf[BUF_SIZE];
    for(;;) {
      int r = fread(buf,sizeof(int),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  int x = buf[i];
	  if(x>max) {
	    max = x;
	    max_position = index;
	  }
	  if(x<min) {
	    min = x;
	    min_position = index;
	  }
	  index++;
	}
      }      
    }
    fprintf(stderr,"%s: max value = %d\n",argv[0],max);
    fprintf(stderr,"%s: min value = %d\n",argv[0],min);
  }
  
  if(!strcmp(argv[1],"float")) {
    float max = -1E100;
    float min = 1E100;
    float buf[BUF_SIZE];
    for(;;) {
      int r = fread(buf,sizeof(float),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  float x = buf[i];
	  if(x>max) {
	    max = x;
	    max_position = index;
	  }
	  if(x<min) {
	    min = x;
	    min_position = index;
	  }
	  index++;
	}
      }      
    }
    fprintf(stderr,"%s: max value = %f\n",argv[0],max);
    fprintf(stderr,"%s: min value = %f\n",argv[0],min);
  }
  
  if(!strcmp(argv[1],"double")) {
    double max = -1E100;
    double min = 1E100;
    double buf[BUF_SIZE];
    for(;;) {
      int r = fread(buf,sizeof(double),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  double x = buf[i];
	  if(x>max) {
	    max = x;
	    max_position = index;
	  }
	  if(x<min) {
	    min = x;
	    min_position = index;
	  }
	  index++;
	}
      }      
    }
    fprintf(stderr,"%s: max value = %f\n",argv[0],max);
    fprintf(stderr,"%s: min value = %f\n",argv[0],min);
  }
  fprintf(stderr,"%s: max position = %d\n",argv[0],max_position);
  fprintf(stderr,"%s: min position = %d\n",argv[0],min_position);

  fprintf(stderr,"%s: done\n",argv[0]);
  return 0;
}
