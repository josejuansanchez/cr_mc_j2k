#include <stdio.h>
#include <stdlib.h>

int pos;

int offset;

int main(int argc, char *argv[]) {
  work(argc,argv);
  return EXIT_SUCCESS;
}

print_parameters() {
  fprintf(stderr,"tes block_size list_lost_blocks < original_file > received_file\n");
}

work(int argc, char *argv[]) {
  pos = 0;
  offset = 0;
  for(;;) {
    int c=get();
    if(c=='K') {
      c=get();
      if(c=='a') {
	c=get();
	if(c=='k') {
	  c=get();
	  if(c=='a') {
	    c=get();
	    if(c=='d') {
	      c=get();
	      if(c=='u') {
		printf("%d %d\n",pos, pos-offset);
		offset = pos;
	      }
	    }
	  }
	}
      }
    }
    if(c==EOF) break;
  }
  return 0;
}

get() {
  pos++;
  int c= getchar();
  //fprintf(stderr,"%d\n",c);
  return c;
}

