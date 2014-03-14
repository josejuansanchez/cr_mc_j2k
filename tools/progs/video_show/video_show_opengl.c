/*
 * video_show_opengl.c 
 * Visualizador de secuencias de vídeo en formato RAW basado en video_show.cc
 * Jose Miguel Dana Pérez.
 * gse. 2010.
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/timeb.h>

/* Includes OpenGL */
#include <GL/gl.h>
#include <GL/glut.h>

#include "args.h"
#include "malloc.h"

#define DEFAULT_ROWS 288
#define DEFAULT_COLS 352
#define DEFAULT_FPS  30

FILE *input_file;
int width, height; 
int rows, cols;  /* Dimensiones de la imagen */
float fps;
int frame = 0;   /* Número de frame mostrado */
unsigned int *openglImage;
unsigned char *buffer;
unsigned char **buffer_Y, **buffer_U, **buffer_V;
unsigned char *ptr_buffer;
unsigned char **ptr_buffer_Y, **ptr_buffer_U, **ptr_buffer_V;
char **argv_ptr;
struct timeb tp;
int elapsed_time, tiempo;
int read_more_data=1;
double zoom=1.0;

#define CHOP(x)	    ((x < 0) ? 0 : ((x > 255) ? 255 : x))
#define RGB(r,g,b) ((unsigned long)(((unsigned char)(r)|((unsigned short)(g)<<8))|(((unsigned long)(unsigned char)(b))<<16)))
#define RGBA(r,g,b,a) ((unsigned long)(((unsigned char)(r)|((unsigned short)(g)<<8))|(((unsigned long)(unsigned char)(b))<<16)|(((unsigned long)(unsigned char)(a))<<24)))

void changeSize(int w, int h) {
  if(h==0)
    h=1;
  
  glViewport(0,0,w,h);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  
  gluOrtho2D(0.0,(GLfloat) w, 0.0, (GLfloat) h);
  
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  
  zoom=(double) w/cols;
  width=w;
  height=w/((double)cols/rows);
  glutReshapeWindow(width,height);
  glRasterPos2i(0,0);
  glPixelZoom(zoom,zoom);
}

void keysMapper(unsigned char key, int x, int y) {
  if(key=='q')
    exit(EXIT_SUCCESS);
  // FullScreen doesn't work correctly	
  if(key=='f')
  	glutFullScreen();
  if(key=='p')
    read_more_data=!read_more_data;
  if(key=='+') {
    zoom+=0.1;
    glClear(GL_COLOR_BUFFER_BIT);
    width=cols*zoom;
    height=rows*zoom;
    glutReshapeWindow(width,height);
    glRasterPos2i(0,0);
    glPixelZoom(zoom,zoom);
  }
  if(key=='-') {
    zoom-=0.1;
    glClear(GL_COLOR_BUFFER_BIT);
    width=cols*zoom;
    height=rows*zoom;
    glutReshapeWindow(width,height);
    glRasterPos2i(0,0);
    glPixelZoom(zoom,zoom);
  }
}

void SetupRC() {
  glClearColor(0.0,0.0,0.0,0.0);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
}

void RenderScene() {
  glViewport(0,0,width,height);			
  glClear(GL_COLOR_BUFFER_BIT);
  //glWindowPos2iMESA(0,0);
  glRasterPos2i(0,0);
  //glRasterPos2f(-cols/2.0,-rows/2.0);
  //glPixelZoom(1.0,-1.0);	
  //glRasterPos2i(0,0);
  glDrawPixels(cols,rows,GL_RGBA,GL_UNSIGNED_BYTE,openglImage);
  
  glutSwapBuffers();
}


void display_eyuv_image/*_on_color_display*/(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  
  if(read_more_data) {
    for(i=0; i<rows; i++) {
      fread(buffer_Y[i],cols,sizeof(unsigned char),input_file);
    }
    for(i=0; i<rows/2; i++) {
      fread(buffer_U[i],cols/2,sizeof(unsigned char),input_file);
    }
    for(i=0; i<rows/2; i++) {
      fread(buffer_V[i],cols/2,sizeof(unsigned char),input_file);
    }
  }

  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      /*int y = buffer_Y[i][j];
	int u = buffer_U[i/2][j/2];
	int v = buffer_V[i/2][j/2];*/
      
      int tempR = 104635*(buffer_V[i/2][j/2] - 128);
      int tempG = -25690*(buffer_U[i/2][j/2] - 128) + -53294 * (buffer_V[i/2][j/2] - 128);
      int tempB = 132278*(buffer_U[i/2][j/2] - 128);
      
      tempR += ((buffer_Y[i][j] - 16)*76310);
      tempG += ((buffer_Y[i][j] - 16)*76310);
      tempB += ((buffer_Y[i][j] - 16)*76310);
      
      unsigned char r=CHOP((int)(tempR >> 16));
      unsigned char g=CHOP((int)(tempG >> 16));
      unsigned char b=CHOP((int)(tempB >> 16));
      
      openglImage[(rows-1-i)*cols+j]=RGBA(r,g,b,255);
      
    }
  }

#ifdef _DEBUG_  
  ftime(&tp);
  //float delay=tp.time*1000 + tp.millitm - tiempo;
  tiempo = tp.time*1000 + tp.millitm;
  
  int tmp = tiempo - elapsed_time;
  fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	  frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
#endif

  if(!feof(input_file))
    frame++;
  else
    rewind(input_file);
  
  glutPostRedisplay();
  //glutTimerFunc((unsigned int)((1.0/fps*1000)-delay+25),display_eyuv_image_on_color_display,0);
  glutTimerFunc((unsigned int)(1.0/fps*1000),display_eyuv_image/*_on_color_display*/,0);
  //glutTimerFunc((unsigned int)(1.0),display_eyuv_image_on_color_display,0);
}

void display_rgb_image/*_on_color_display*/(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  
  if(read_more_data) 
    fread(buffer,rows*cols*3,sizeof(unsigned char),input_file);
  
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      int r = *buffer++;
      int g = *buffer++;
      int b = *buffer++;
      openglImage[(rows-1-i)*cols+j]=RGBA(r,g,b,255);
    }
  }

#ifdef _DEBUG_
  ftime(&tp);
  float delay=tp.time*1000 + tp.millitm - tiempo;
  tiempo = tp.time*1000 + tp.millitm;
  
  int tmp = tiempo - elapsed_time;
  fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	  frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
#endif

  if(!feof(input_file))
    frame++;
  else
    rewind(input_file);
  
  glutPostRedisplay();
  //glutTimerFunc((unsigned int)((1.0/fps*1000)-delay+25),display_eyuv_image_on_color_display,0);
  glutTimerFunc((unsigned int)(1.0/fps*1000),display_rgb_image/*_on_color_display*/,0);
}

void display_gray8_image/*_on_color_display*/(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  unsigned char *ptr = buffer;
  if(read_more_data) 
    fread(buffer,rows*cols,sizeof(unsigned char),input_file);
  
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      openglImage[(rows-1-i)*cols+j]=RGBA(*ptr,*ptr,*ptr,255);
      *ptr++;
    }
  }

#ifdef _DEBUG_  
  ftime(&tp);
  float delay=tp.time*1000 + tp.millitm - tiempo;
  tiempo = tp.time*1000 + tp.millitm;
  
  int tmp = tiempo - elapsed_time;
  fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	  frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
#endif

  if(!feof(input_file))
    frame++;
  else
    rewind(input_file);
  
  glutPostRedisplay();
  //glutTimerFunc((unsigned int)((1.0/fps*1000)-delay+25),display_eyuv_image_on_color_display,0);
  glutTimerFunc((unsigned int)(1.0/fps*1000),display_gray8_image/*_on_color_display*/,0);
}

void display_gray16_image/*_on_color_display*/(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  unsigned short *ptr = buffer;
  if(read_more_data) 
    fread(buffer,rows*cols,sizeof(unsigned short),input_file);
  
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      openglImage[(rows-1-i)*cols+j]=RGBA((*ptr)/256,(*ptr)/256,(*ptr)/256,255);
      *ptr++;
    }
  }

#ifdef _DEBUG_  
  ftime(&tp);
  float delay=tp.time*1000 + tp.millitm - tiempo;
  tiempo = tp.time*1000 + tp.millitm;
  
  int tmp = tiempo - elapsed_time;
  fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	  frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
#endif

  if(!feof(input_file))
    frame++;
  else
    rewind(input_file);
  
  glutPostRedisplay();
  //glutTimerFunc((unsigned int)((1.0/fps*1000)-delay+25),display_eyuv_image_on_color_display,0);
  glutTimerFunc((unsigned int)(1.0/fps*1000),display_gray16_image/*_on_color_display*/,0);
}

#ifdef _1_
void display_gray8_image_on_gray_display(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  
  fread(buffer,rows*cols,sizeof(unsigned char),input_file);
  
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      openglImage[(rows-1-i)*cols+j]=RGBA(*buffer,*buffer,*buffer,255);
      *buffer++;
    }
  }
  
#ifdef DEBUG
  ftime(&tp);
  float delay=tp.time*1000 + tp.millitm - tiempo;
  tiempo = tp.time*1000 + tp.millitm;

  int tmp = tiempo - elapsed_time;
  fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	  frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
#endif

  if(!feof(input_file))
    frame++;
  else
    rewind(input_file);
  
  glutPostRedisplay();
  //glutTimerFunc((unsigned int)((1.0/fps*1000)-delay+25),display_eyuv_image_on_color_display,0);
  glutTimerFunc((unsigned int)(1.0/fps*1000),display_gray8_image_on_color_display,0);
}
#endif

int main(int argc, char *argv[]) {
  if(ARGS__EXIST("-help")) {
    fprintf(stderr,"Presenta una secuencia de v'ideo\n");
    fprintf(stderr," [-input <input sequence file name>] (default stdin)\n");
    fprintf(stderr," [-y_dim <number of rows>] (default %d)\n",DEFAULT_ROWS);
    fprintf(stderr," [-x_dim <number of columns>] (default %d)\n",DEFAULT_COLS);
    fprintf(stderr," [-fps <frames per second>] (default %d)\n",DEFAULT_FPS);
    fprintf(stderr," [-rgb|yuv|gray8|gray16] (default yuv)\n");
    fprintf(stderr," [-step] frame by frame\n");
    fprintf(stderr,"/* Compilation date: %s %s */\n",__DATE__,__TIME__);
    fprintf(stderr,"/* Running under: %s */\n",getenv("HOSTTYPE"));
  } 
  else {
    
    argv_ptr = argv;
    
    /* Abrimos el fichero de entrada */
    input_file = stdin;
    if(ARGS__EXIST("-input")) {
      fprintf(stderr,"%s: Input File = %s\n",argv[0],ARGS__GET("-input"));
      input_file = fopen(ARGS__GET("-input"),"rb");
      if(!input_file) {
	fprintf(stderr,"%s: Unable to open input file: %s\n",argv[0],ARGS__GET("-input"));
	return 1;
      }
    } 
    else 
      fprintf(stderr,"%s: Input File = stdin\n",argv[0]);
    
    /* Leemos los argumentos de entrada */
    rows = DEFAULT_ROWS;
    if(ARGS__EXIST("-y_dim")) rows = atoi(ARGS__GET("-y_dim"));
    fprintf(stderr,"%s: rows = %d\n",argv[0],rows);
    cols = DEFAULT_COLS;
    if(ARGS__EXIST("-x_dim")) cols = atoi(ARGS__GET("-x_dim"));
    fprintf(stderr,"%s: cols = %d\n",argv[0],cols);
    fps = DEFAULT_FPS;
    if(ARGS__EXIST("-fps")) fps = atof(ARGS__GET("-fps"));
    fprintf(stderr,"%s: fps = %f\n",argv[0],fps);
    
    
    width=cols;
    height=rows;
    
    openglImage=(unsigned int*)malloc(sizeof(unsigned int)*rows*cols);
    
    ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo;
    
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowSize(cols,rows);
    glutCreateWindow("Image");
    glutDisplayFunc(RenderScene);
    glutReshapeFunc(changeSize);
    glutKeyboardFunc(keysMapper);
    
    if(ARGS__EXIST("-gray8")) {
      buffer = (unsigned char *)malloc(rows*cols*sizeof(unsigned char));
      ptr_buffer = buffer;
      glutTimerFunc((int)(1.0/fps)*1000,display_gray8_image/*_on_color_display*/,0);
      fprintf(stderr,"%s: displaying a gray8 image ...\n",argv[0]);
    } else if(ARGS__EXIST("-gray16")) {
      buffer = (unsigned short *)malloc(rows*cols*sizeof(unsigned short));
      ptr_buffer = buffer;
      glutTimerFunc((int)(1.0/fps)*1000,display_gray16_image/*_on_color_display*/,0);
      fprintf(stderr,"%s: displaying a gray16 image ...\n",argv[0]);
    }else if(ARGS__EXIST("-rgb")) {
      buffer = (unsigned char *)malloc(rows*cols*3*sizeof(unsigned char));
      ptr_buffer = buffer;
      glutTimerFunc((int)(1.0/fps)*1000,display_rgb_image/*_on_color_display*/,0);
      fprintf(stderr,"%s: displaying a RGB image ...\n",argv[0]);
    } else /* default */ {
      buffer_Y = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
      buffer_U = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
      buffer_V = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
      ptr_buffer_Y = buffer_Y;
      ptr_buffer_U = buffer_U;
      ptr_buffer_V = buffer_V;
      glutTimerFunc((int)(1.0/fps)*1000,display_eyuv_image/*_on_color_display*/,0);
      fprintf(stderr,"%s: displaying a YUV image ...\n",argv[0]);
    } 
    
    SetupRC();
    
    glutMainLoop();		
    
  }
  return 0;
}


