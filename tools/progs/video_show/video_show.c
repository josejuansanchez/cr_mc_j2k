/*
 * video_show.cc -- Visualizador de secuencias de vídeo en formato RAW.
 * gse. 2005.
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/timeb.h>

/* Includes X11 */
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>
#include <X11/Xatom.h>
#include "X_image_icon"

#include "args.h"
#include "malloc.h"

#define DEFAULT_ROWS 288
#define DEFAULT_COLS 352
#define DEFAULT_FPS  30

#define ITIMER_MODE /*ITIMER_PROF*/ ITIMER_REAL /*ITIMER_VIRTUAL*/

/* X declarations */ 
Display *display;
int screen_num;
Screen *screen_ptr;
unsigned int mask;
XImage *ximage;
Drawable win;
GC my_gc;
int maxdepth;
Visual *visual;
XEvent report;
char *image;
int RGB[256];

/* Timer declarations */
struct itimerval itimer;
int i_sec;

FILE *input_file;
int rows, cols;  /* Dimensiones de la imagen */
int frame = 0;   /* Número de frame mostrado */
unsigned char *buffer;
unsigned char **buffer_Y, **buffer_U, **buffer_V;
unsigned char *ptr_buffer;
unsigned char **ptr_buffer_Y, **ptr_buffer_U, **ptr_buffer_V;
char **argv_ptr;
struct timeb tp;
int elapsed_time, tiempo;
int read_more_data=1;

#define CHOP(x)	    ((x < 0) ? 0 : ((x > 255) ? 255 : x))

void display_eyuv_image_on_color_display(int signum /*Parámetro inútil, pero obligatorio */) {
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
      
      {
	int r = CHOP((int)(tempR >> 16));
	int g = CHOP((int)(tempG >> 16));
	int b = CHOP((int)(tempB >> 16));
	int x = (r << 16) | (g << 8) | b;
	XPutPixel(ximage,j,i,x);
      }
    }
  }
  XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
  buffer_Y = ptr_buffer_Y;
  buffer_U = ptr_buffer_U;
  buffer_V = ptr_buffer_V;
  ftime(&tp);
  tiempo = tp.time*1000 + tp.millitm;
  {
    int tmp = tiempo - elapsed_time;
    fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	    frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
  }
  if(!feof(input_file)) {
    frame++;
  } else {
    /*ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo - elapsed_time;
    fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",
    argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));*/
    rewind(input_file);
  }
}

void display_yuv_image_on_color_display(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  if(read_more_data) {
    for(i=0; i<rows; i++) {
      fread(buffer_Y[i],cols,sizeof(unsigned char),input_file);
    }
    for(i=0; i<rows; i++) {
      fread(buffer_U[i],cols,sizeof(unsigned char),input_file);
    }
    for(i=0; i<rows; i++) {
      fread(buffer_V[i],cols,sizeof(unsigned char),input_file);
    }
  }

  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      /*int y = buffer_Y[i][j];
      int u = buffer_U[i/2][j/2];
      int v = buffer_V[i/2][j/2];*/

      int tempR = 104635*(buffer_V[i][j] - 128);
      int tempG = -25690*(buffer_U[i][j] - 128) + -53294 * (buffer_V[i][j] - 128);
      int tempB = 132278*(buffer_U[i][j] - 128);

      tempR += ((buffer_Y[i][j] - 16)*76310);
      tempG += ((buffer_Y[i][j] - 16)*76310);
      tempB += ((buffer_Y[i][j] - 16)*76310);
      
      {
	int r = CHOP((int)(tempR >> 16));
	int g = CHOP((int)(tempG >> 16));
	int b = CHOP((int)(tempB >> 16));
	int x = (r << 16) | (g << 8) | b;
	XPutPixel(ximage,j,i,x);
      }
    }
  }
  XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
  buffer_Y = ptr_buffer_Y;
  buffer_U = ptr_buffer_U;
  buffer_V = ptr_buffer_V;
  ftime(&tp);
  tiempo = tp.time*1000 + tp.millitm;
  {
    int tmp = tiempo - elapsed_time;
    fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	    frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
  }
  if(!feof(input_file)) {
    frame++;
  } else {
    /*ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo - elapsed_time;
    fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",
    argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));*/
    rewind(input_file);
  }
}

void display_rgb_image_on_color_display(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  if(read_more_data) fread(buffer,rows*cols*3,sizeof(unsigned char),input_file);
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      int r = *buffer++;
      int g = *buffer++;
      int b = *buffer++;
      int x = (r << 16) | (g << 8) | b;
      XPutPixel(ximage,j,i,x);
    }
  }
  XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
  buffer = ptr_buffer;
  ftime(&tp);
  tiempo = tp.time*1000 + tp.millitm;
  {
    int tmp = tiempo - elapsed_time;
    fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	    frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
  }
  if(!feof(input_file)) {
    frame++;
  } else {
      ftime(&tp);
      tiempo = tp.time*1000 + tp.millitm;
      elapsed_time = tiempo - elapsed_time;
      fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",
	      argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));
      exit(1);
  }
}

void display_gray8_image_on_color_display(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  if(read_more_data) fread(buffer,rows*cols,sizeof(unsigned char),input_file);
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      XPutPixel(ximage,j,i,RGB[*buffer++]);
    }
  }
  XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
  buffer = ptr_buffer;
  ftime(&tp);
  tiempo = tp.time*1000 + tp.millitm;
  {
    int tmp = tiempo - elapsed_time;
    fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	    frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
  }
  if(!feof(input_file)) {
    frame++;
  } else {
    /*ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo - elapsed_time;
    fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",
    argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));*/
    //exit(1);
    rewind(input_file);

  }
}

void display_gray8_image_on_gray_display(int signum /*Parámetro inútil, pero obligatorio */) {
  int i,j;
  fread(buffer,rows*cols,sizeof(unsigned char),input_file);
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) {
      XPutPixel(ximage,j,i,getc(input_file));
    }
  }
  XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
  buffer = ptr_buffer;
  ftime(&tp);
  tiempo = tp.time*1000 + tp.millitm;
  {
    int tmp = tiempo - elapsed_time;
    fprintf(stderr,"%4d frames in %.2f seconds (%.2f fps)\r",
	    frame,(float)(tmp)/1000.0,(float)frame/(float)((float)tmp/1000.0));
  }
  if(!feof(input_file)) {
    frame++;
  } else {
    ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo - elapsed_time;
    fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",
	    argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));
    exit(1);
  }
}

int main(int argc, char *argv[]) {
  if(ARGS__EXIST("-help")) {
    fprintf(stderr,"Presenta una secuencia de v'ideo\n");
    fprintf(stderr," [-input <input sequence file name>] (default stdin)\n");
    fprintf(stderr," [-y_dim <number of rows>] (default %d)\n",DEFAULT_ROWS);
    fprintf(stderr," [-x_dim <number of columns>] (default %d)\n",DEFAULT_COLS);
    fprintf(stderr," [-fps <frames per second>] (default %d)\n",DEFAULT_FPS);
    fprintf(stderr," [-rgb|yuv|eyuv|gray8] (default eyuv)\n");
    fprintf(stderr," [-step] frame by frame\n");
    fprintf(stderr," [-title] window title\n");
    fprintf(stderr,"/* Compilation date: %s %s */\n",__DATE__,__TIME__);
    fprintf(stderr,"/* Running under: %s */\n",getenv("HOSTTYPE"));
  } else {
    int i,j;
    int fps;

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
    } else {
      fprintf(stderr,"%s: Input File = stdin\n",argv[0]);
    }
    
    /* Leemos los argumentos de entrada */
    rows = DEFAULT_ROWS;
    if(ARGS__EXIST("-y_dim")) rows = atoi(ARGS__GET("-y_dim"));
    fprintf(stderr,"%s: rows = %d\n",argv[0],rows);
    cols = DEFAULT_COLS;
    if(ARGS__EXIST("-x_dim")) cols = atoi(ARGS__GET("-x_dim"));
    fprintf(stderr,"%s: cols = %d\n",argv[0],cols);
    fps = DEFAULT_FPS;
    if(ARGS__EXIST("-fps")) fps = atoi(ARGS__GET("-fps"));
    fprintf(stderr,"%s: fps = %d\n",argv[0],fps);
    
    /* Creamos la ventana de visualización */
    {
      unsigned int x, y;            /* window position */
      unsigned int borderwidth = 4;
      unsigned int display_width, display_height;
      unsigned int icon_width, icon_height;
      char *window_name = ARGS__GET("-title");
      char *icon_name;
      Pixmap icon_pixmap;
      XSizeHints size_hints;
      //XFontStruct *font_info;
      char *display_name = NULL;
      int window_size = 0;    /* OK, or too SMALL to display contents */
      XStandardColormap best_map_info;
      XColor *xcolor;
      XSetWindowAttributes attrib;
      XGCValues covals;
      XColor black, trueblack, white, truewhite;
      XSetWindowAttributes xswa;
      Colormap colormap;
      Drawable dd;
      unsigned long attribmask;
      XVisualInfo *vlist, vinfo_template, *v;
      Status visual_status;
      int result_x_match;
      int i,bits_per_rgb,colormap_size;
 
      /* connect to the X server */
      display=XOpenDisplay(display_name);
      if(display== NULL) {
	printf("%s : cannot connect to X server %s\n",argv[0], XDisplayName(display_name));
	exit(-1);
      }
      
      /* Determine the size of the display */
      screen_num = XDefaultScreen(display);
      screen_ptr = DefaultScreenOfDisplay(display);
      display_width = DisplayWidth(display, screen_num);
      display_height = DisplayHeight(display, screen_num);
      fprintf(stderr,"%s: display size = %d rows x %d cols\n",argv[0], display_height,display_width);
      
      /** Basic visual information */ 
      /*vinfo_template.class=StaticGray;*/
      vlist = XGetVisualInfo(display,/*VisualScreenMask|VisualClassMask*/ VisualNoMask,&vinfo_template, &visual_status); 
      if(!vlist) {
	fprintf(stderr,"%s: cannot get visual info\n",argv[0]);
	exit(-2);
      }
      bits_per_rgb=vlist[0].bits_per_rgb;
      fprintf(stderr,"%s: bits_per_component=%d\n",argv[0], bits_per_rgb);
      colormap_size=vlist[0].colormap_size;
      
      /* Computing RGB. Sólo para imágenes en B/N sobre displays en color  */
      for(i=0;i<colormap_size;i++) {
	RGB[i]=(i<<(8*2))|(i<<(8))|i;
      }
      if(bits_per_rgb==5) {
	for(i=0;i<256;i++) {
	  RGB[i]=((i/8)<<10)|((i/8)<<5)|(i/8);
	}
      }
      if(bits_per_rgb==6) {
	for(i=0;i<256;i++) {
	  RGB[i]=((i/8)<<11)|((i/8)<<6)|(i/8);
	}
      }
      /*if(bits_per_rgb==8) {
	
      }*/
      
      /** Determine depth of image plane */
      maxdepth = 0;
      while(visual_status > 0) {
	if(vlist[visual_status-1].depth > maxdepth)
	  maxdepth = vlist[visual_status-1].depth;
	visual_status--;
      }
      XFree((char *)vlist);
      fprintf(stderr,"%s: display depth = %d bits/pixel\n",argv[0],maxdepth);
      
      /* Set visual information */ 
      if(maxdepth==8) { /* 8 bpp */
	result_x_match = XMatchVisualInfo(display,DefaultScreen(display), maxdepth,StaticGray, &vinfo_template);
	for(i=0;i<colormap_size;i++) {
	  RGB[i]=i;
	}
      } else {
	result_x_match = XMatchVisualInfo(display,DefaultScreen(display),
					  maxdepth,
					  /*StaticGray*//*GrayScale*//*StaticColor*/
					  /*PseudoColor*/TrueColor/*DirectColor*/,
					  &vinfo_template);
      }
      if(result_x_match)
	visual=vinfo_template.visual;
      else {
	fprintf(stderr,"%s: no visual information available for %d bits/pixel\n",argv[0],maxdepth);
	exit(-2);
      }
      
      /* Create opaque window */
      /** Place window */
      x = display_width/8;
      y = display_height/8;
      mask=CWBackPixel|CWColormap|CWBorderPixel; 
      xswa.colormap=XCreateColormap(display,XRootWindow(display,screen_num), visual,AllocNone);
      xswa.background_pixel=BlackPixel(display,DefaultScreen(display));
      xswa.border_pixel=WhitePixel(display,DefaultScreen(display));
      win=XCreateWindow(display,RootWindow(display,screen_num),x,y,cols,rows,
			borderwidth,maxdepth,InputOutput,visual,mask,&xswa); 
      
      /*  win=XCreateSimpleWindow(display,RootWindow(display,screen_num),
	  x,y,width,height,borderwidth,1,1);*/
      /* create pixmap of depth 1 (bitmap) for icon */
      //#include "video_show.xpm"
      icon_pixmap=XCreateBitmapFromData(display,win,icon_bitmap_bits,
                                        icon_bitmap_width,
                                        icon_bitmap_height);
      
      /** Set resize hints */
      size_hints.flags = PPosition | PSize | PMinSize;
      size_hints.x = x;
      size_hints.y = y;
      size_hints.width = cols;
      size_hints.height = rows;
      size_hints.min_width = cols;
      size_hints.min_height = rows;
      
      /* select event types wanted */
      XSelectInput(display, win, ExposureMask | KeyPressMask | ButtonPressMask | ButtonReleaseMask | StructureNotifyMask);
      
      /* set Properties for window manager (always before mapping) */
      XSetStandardProperties(display, win, argv[0], argv[0], 
			     icon_pixmap, argv, argc, &size_hints);

      /* Nombre de la ventana */
      XStoreName(display, win, window_name);
      
      /** Mapping window to display */
      XMapWindow(display, win);
      
      /* Graphics function allocation */
      covals.function = GXcopy;
      my_gc = XCreateGC (display, win, GCFunction, &covals); 
      
      /* Display video window */ 
      XFlush(display);
      
      /* The window is visible after the first event */
      do XNextEvent(display,&report); while(report.type!=Expose);
      
      if(maxdepth==8) {
	image=(char *)malloc(rows*cols*sizeof(char));
	ximage=XCreateImage(display,visual,maxdepth,ZPixmap,0,image,cols,rows,8,cols);
	if(!ximage) {
	  fprintf(stderr,"%s: cannot create image\n",argv[0]);
	  exit(-4);
	}
      }
      
      if(maxdepth==16) {
	image=(char *)malloc(rows*cols*2);
	ximage=XCreateImage(display,visual,maxdepth,ZPixmap,0,image,cols,rows,8,cols*2);
	if(!ximage) {
	  fprintf(stderr,"%s: cannot create image\n",argv[0]);
	  exit(-4);
	}
      }
      
      if(maxdepth==24) {
	image=(char *)malloc(rows*cols*4);
	ximage=XCreateImage(display,visual,24,ZPixmap,0,image,cols,rows,8,cols*4);
	if(!ximage) {
	  fprintf(stderr,"%s: cannot create image\n",argv[0]);
	  exit(-4);
	}
      }
    } /* Fin inicialización X11 */

    
    if(ARGS__EXIST("-step")) {
      if(maxdepth>8) {

	if(ARGS__EXIST("-gray8")) {
	  buffer = (unsigned char *)malloc(rows*cols*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  do {
	    display_gray8_image_on_color_display(1);
	    do {
	      XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	      XNextEvent(display,&report);
	    } while(report.type!=ButtonPress);
	  } while(1);
	}

	if(ARGS__EXIST("-rgb")) {
	  buffer = (unsigned char *)malloc(rows*cols*3*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  do {
	    display_rgb_image_on_color_display(1);
	    do {
	      XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	      XNextEvent(display,&report);
	    } while(report.type!=ButtonPress);
	  } while(1);
	}

	if(ARGS__EXIST("-yuv")) {
	  buffer_Y = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_U = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_V = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  ptr_buffer_Y = buffer_Y;
	  ptr_buffer_U = buffer_U;
	  ptr_buffer_V = buffer_V;
	  do {
	    display_yuv_image_on_color_display(1);
	    do {
	      XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	      XNextEvent(display,&report);
	    } while(report.type!=ButtonPress);
	  } while(1);
	}

	if(/*args.exist_arg("-yuv")*/1) {
	  buffer_Y = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_U = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
	  buffer_V = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
	  ptr_buffer_Y = buffer_Y;
	  ptr_buffer_U = buffer_U;
	  ptr_buffer_V = buffer_V;
	  do {
	    display_eyuv_image_on_color_display(1);
	    do {
	      XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	      XNextEvent(display,&report);
	    } while(report.type!=ButtonPress);
	  } while(1);
	}

      } else { /* For 8 bpp displays */
	if(!ARGS__EXIST("-rgb")) { /* For B/W images */
	  buffer = (unsigned char *)malloc(rows*cols*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  fprintf(stderr,"%s: B/W image\n",argv[0]);
	  do {
	    display_gray8_image_on_gray_display(1);
	    do {
	      XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	      XNextEvent(display,&report);
	    } while(report.type!=ButtonPress);
	  } while(1);
	} else { /* For color images */
	  fprintf(stderr,"%s: sorry, can't display color images on 8 bpp displays\n",argv[0]);
	}
      }
      return 0;
    }
    
    if(/*args.exist_arg("-fps")*/1) {
      ftime(&tp);
      tiempo = tp.time*1000 + tp.millitm;
      elapsed_time = tiempo;
      /* Programamos el temporizador */
      i_sec=(int)(1000000.0/fps);
      itimer.it_interval.tv_usec =i_sec;
      itimer.it_interval.tv_sec = 0;
      itimer.it_value.tv_usec = i_sec;
      itimer.it_value.tv_sec = 0;
      
      if(maxdepth>8) {

	if(ARGS__EXIST("-gray8")) {
	  fprintf(stderr,"%s: gray8\n",argv[0]);
	  buffer = (unsigned char *)malloc(rows*cols*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  if (signal(SIGALRM, &display_gray8_image_on_color_display) == SIG_ERR) {
	    fprintf(stderr,"%s: unable to install the timer\n",argv[0]);
	  }
	} else if(ARGS__EXIST("-rgb")) {
	  buffer = (unsigned char *)malloc(rows*cols*3*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  if (signal(SIGALRM, &display_rgb_image_on_color_display) == SIG_ERR) {
	    fprintf(stderr,"%s: unable to install the timer\n",argv[0]);
	  }
	} else if(ARGS__EXIST("-yuv")) {
	  buffer_Y = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_U = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_V = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  ptr_buffer_Y = buffer_Y;
	  ptr_buffer_U = buffer_U;
	  ptr_buffer_V = buffer_V;
	  if (signal(SIGALRM, &display_yuv_image_on_color_display) == SIG_ERR) {
	    fprintf(stderr,"%s: unable to install the timer\n",argv[0]);
	  }
	} else {
	  buffer_Y = (unsigned char **)malloc__alloc_2d(rows,cols,sizeof(unsigned char));
	  buffer_U = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
	  buffer_V = (unsigned char **)malloc__alloc_2d(rows/2,cols/2,sizeof(unsigned char));
	  ptr_buffer_Y = buffer_Y;
	  ptr_buffer_U = buffer_U;
	  ptr_buffer_V = buffer_V;
	  if (signal(SIGALRM, &display_eyuv_image_on_color_display) == SIG_ERR) {
	    fprintf(stderr,"%s: unable to install the timer\n",argv[0]);
	  }
	}
      } else { /* 8 bpp display */
	if(!ARGS__EXIST("-rgb")) {
	  buffer = (unsigned char *)malloc(rows*cols*sizeof(unsigned char));
	  ptr_buffer = buffer;
	  if (signal(SIGALRM, &display_gray8_image_on_gray_display) == SIG_ERR) {
	    fprintf(stderr,"%s: unable to install the timer\n",argv[0]);
	  }
	} else {
	  fprintf(stderr,"video_show: sorry, can't display color images on 8 bpp displays\n");
	}
      }
      // Lanzamos la interrupción
      setitimer(ITIMER_MODE, &itimer, NULL);
      fprintf(stderr,"%s: press any mouse button on the image to pause/continue\n",argv[0]);
#ifdef _1_
      do {
	//XPutImage(display,win,my_gc,ximage,0,0,0,0,cols,rows);
	XNextEvent(display,&report);
      } while((report.type!=ButtonPress));
#endif

      do {
	XNextEvent(display,&report);
        if(report.type==ButtonPress) {
	  read_more_data = !read_more_data;
	  fprintf(stderr,"%d",read_more_data);
	}
      } while(!feof(input_file));

      ftime(&tp);
      tiempo = tp.time*1000 + tp.millitm;
      elapsed_time = tiempo - elapsed_time;
      fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));
      return 0;
    } /* -fps */

    ftime(&tp);
    tiempo = tp.time*1000 + tp.millitm;
    elapsed_time = tiempo - elapsed_time;
    fprintf(stderr,"%s: %d frames in %.2f seconds (%.2f fps)\n",argv_ptr[0],frame,(float)elapsed_time/1000.0,(float)frame/(float)((float)elapsed_time/1000.0));
    return 0;
  }
}


