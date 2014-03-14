#include <stdio.h>

#define BUF_SIZE 4096

int main(int arg, char *argv[]) {

  int ch;

  /* Leemos el magic number "vix" */
  {
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
  }
  
  /* Leemos la sección de vídeo */
  {
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
  }
  
  /* Leemos la sección de color */
  {
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
  }
  
  /* Leemos la sección de imagen */
  {
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif
    while((ch = getchar())!='\n') {
#if defined DEBUG
      putc(ch,stderr);
#endif
    }
#if defined DEBUG
    putc('\n',stderr);
#endif

    int x, y, c;
    scanf("%d %d %d",&x,&y,&c);
#if defined DEBUG
    fprintf(stderr,"%d %d %d\n",x,y,c);
#endif
    int i;
    for(i=0; i<c; i++) {
      int a,b;
      scanf("%d %d",&a,&b);
#if defined DEBUG
      fprintf(stderr,"%d %d\n",a,b);
#endif
    }
  }
  
  ch = getchar();
#if defined DEBUG
  putc(ch,stderr);
#endif
  
  char x[BUF_SIZE];
  for(;;) {
    int r = fread(x,sizeof(char),BUF_SIZE,stdin);
    if(r==0) break;
    fwrite(x,sizeof(char),r,stdout);
  }
}

