#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>

#define BUF_SIZE 4096

main (int argc, char *argv[]) { 
  FILE *tmp_file;
  char *tmp_filename, *number;

  int i;
  if(argc<=1) {
    fprintf(stderr,"%s {float|double} < input > output\n",argv[0]);
    fprintf(stderr,"normalize to the [0,1] interval\n");
    return 1;
  }

  tmp_filename = (char *)malloc(80*sizeof(char));
  number = (char *)malloc(3*sizeof(char));
  fprintf(stderr,"%s: running ...\n",argv[0]);
  sprintf(number,"%d",getpid()%1000);
  strcpy(tmp_filename,"/tmp/");
  strcat(tmp_filename,number);
  tmp_file=fopen(tmp_filename,"w");
  if(!tmp_file) {
    fprintf(stderr,"%s: unable to open (%s)\n",argv[0],tmp_filename);
    exit(1);
  }
  fprintf(stderr,"%s: searching maximum and minimum (%s)\n",argv[0],tmp_filename);

  if(argv[1][0]=='f') {
    float max=-10E10,min=10E10,diff;
    float buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: float\n",argv[0]);
    for(;;) {
      int r = fread(buf,sizeof(float),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(max<buf[i]) {
	    max = buf[i];
	  }
	  else if(min>buf[i]) {
	    min=buf[i];
	  }
	  //fprintf(stderr,"%f\n",buf[i]);
	}
      }
      fwrite(buf,sizeof(float),r,tmp_file);
    }
    fprintf(stderr,"%s: max=%f min=%f\n",argv[0],max,min);
    fprintf(stderr,"%s: normalizing the input data\n",argv[0]);
    fclose(tmp_file);
    tmp_file=fopen(tmp_filename,"rb");
    if(!tmp_file) {
      fprintf(stderr,"%s: unable to read \"%s\"\n",argv[0],tmp_filename);
      exit(2);
    }
    diff=max-min;
    for(;;) {
      float normal[BUF_SIZE];
      int r = fread(buf,sizeof(float),BUF_SIZE,tmp_file);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  normal[i]=(buf[i]-min)/diff;
	}
      }
      fwrite(normal,sizeof(float),r,stdout);
    }
  }

  if(argv[1][0]=='d') {
    double max=-10E10,min=10E10,diff;
    double buf[BUF_SIZE];
    fprintf(stderr,"%s: data type: double\n",argv[0]);
    for(;;) {
      int r = fread(buf,sizeof(double),BUF_SIZE,stdin);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  if(max<buf[i]) max = buf[i];
	  else if(min>buf[i]) min=buf[i];
	}
      }
      fwrite(buf,sizeof(double),r,tmp_file);
    }
    fprintf(stderr,"%s: max=%f min=%f\n",argv[0],max,min);
    fprintf(stderr,"%s: normalizing the input data\n",argv[0]);
    fclose(tmp_file);
    tmp_file=fopen(tmp_filename,"rb");
    if(!tmp_file) {
      fprintf(stderr,"%s: unable to read \"%s\"\n",argv[0],tmp_filename);
      exit(2);
    }
    diff=max-min;
    for(;;) {
      double normal[BUF_SIZE];
      int r = fread(buf,sizeof(double),BUF_SIZE,tmp_file);
      if(r==0) break;
      {
	int i;
	for(i=0; i<r; i++) {
	  normal[i]=(buf[i]-min)/diff;
	}
      }
      fwrite(normal,sizeof(double),r,stdout);
    }
  }
  remove(tmp_filename);
  fprintf(stderr,"%s: removing %s\n",argv[0],tmp_filename);
  fprintf(stderr,"%s: done\n",argv[0]);
}
