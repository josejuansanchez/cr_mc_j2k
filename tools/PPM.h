#define MAXROWS 4096
#define MAXCOLS 4096
#define MAXLENGTH 256
#define MAXVALUE 255

int ppmRead (char *fileName,long *rows,long *cols,unsigned char **image);
int ppmWrite(char* filename, long rows,long cols,unsigned char **image,char* comment_string);
