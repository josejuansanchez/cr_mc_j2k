#define MAXROWS 4096
#define MAXCOLS 4096
#define MAXLENGTH 256
#define MAXVALUE 255

int pgmRead (char *fileName,long *rows,long *cols,unsigned char **image);
int pgmWrite(char* filename, long rows,long cols,unsigned char **image,char* comment_string);
