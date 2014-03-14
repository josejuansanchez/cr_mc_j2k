/*
 * The 2D Discrete Wavelet Transform.
 * gse. 2006.
 */

#include "mallok.h"
#include "dprfb.h"
#include "dwt2d.h"
#include <string.h>

struct dwt2d::context {
  int *in_line;
  int *out_line;
  class dprfb *f;
};

dwt2d::dwt2d() throw(mallok::bad_alloc) {
  data = (context *)mallok::alloc_1d(1,sizeof(context));
  data->in_line = (int *)mallok::alloc_1d(1,sizeof(int));
  data->out_line = (int *)mallok::alloc_1d(1,sizeof(int));
}

dwt2d::~dwt2d() {
  mallok::free_1d(data->out_line);
  mallok::free_1d(data->in_line);
  mallok::free_1d(data);
}

void dwt2d::set_max_line_size(int max_line_size) throw(mallok::bad_alloc) {
  mallok::free_1d(data->out_line);
  mallok::free_1d(data->in_line);
  data->in_line = (int *)mallok::alloc_1d(max_line_size,sizeof(int));
  data->out_line = (int *)mallok::alloc_1d(max_line_size,sizeof(int));
}

void dwt2d::set_filter(class dprfb *f) throw() {
  data->f = f;
}

void dwt2d::analyze(int **image,
		    int y,
		    int x,
		    int levels/*,
		    class dprfb *f*/) throw() {
  int lv;
  int i,j;

  for(lv=0;lv<levels;lv++) {
    int nx, ny;

    nx = x; x >>= 1;
    ny = y; y >>= 1;
    if(y == 0) y = 1; /* Nuevo */
    if(x == 0) x = 1; /* Nuevo */

    /* Transformamos las filas */
    if(nx & 1) { /* N'umero impar de columnas */
      for(j=0;j<ny;j++) {
        memcpy(data->in_line,image[j],nx*sizeof(int));
        data->f->odd_analyze(nx,data->in_line,image[j],image[j]+x+1);
      }
    } else { /* N'umero par de columnas */
      for(j=0;j<ny;j++) {
        memcpy(data->in_line,image[j],nx*sizeof(int));
        data->f->even_analyze(nx,data->in_line,image[j],image[j]+x);
      }
    }

    /* Transformamos las columnas */
    if(ny & 1) { /* N'umero impar de filas */
      for(i=0;i<nx;i++) {
        for(j=0;j<ny;j++) data->in_line[j]=image[j][i];
        data->f->odd_analyze(ny,data->in_line,data->out_line,data->out_line+y+1);
        for(j=0;j<ny;j++) image[j][i]=data->out_line[j];
      }
    } else { /* N'umero par de filas */
      for(i=0;i<nx;i++) {
        for(j=0;j<ny;j++) data->in_line[j]=image[j][i];
        data->f->even_analyze(ny,data->in_line,data->out_line,data->out_line+y);
        for(j=0;j<ny;j++) image[j][i]=data->out_line[j];
      }
    }
  }
}

void dwt2d::analyze(int **image,
		    int y,
		    int x,
		    int levels,
		    class dprfb *f) throw() {
  data->f = f;
  analyze(image,y,x,levels);
}

void dwt2d::synthesize(int **image,
		       int y,
		       int x,
		       int levels/*,
		       class dprfb *f*/) throw() {
  int nx, ny, lv;
  int i,j;

  nx = x>>levels;
  ny = y>>levels;

  for (lv = levels-1; lv>=0; lv--) {
    int mx, my;
    mx = nx; nx=x>>lv;
    my = ny; ny=y>>lv;
    if(nx==0) nx=1; /* Nuevo */
    if(ny==0) ny=1; /* Nuevo */

    /* Transformamos las columnas */
    if(ny & 1) { /* N'umero de filas impar */
      for(i=0;i<nx;i++) {
        for(j=0;j<ny;j++) data->in_line[j]=image[j][i];
        data->f->odd_synthesize(ny,data->out_line,data->in_line,data->in_line+my+1);
        for(j=0;j<ny;j++) image[j][i]=data->out_line[j];
      }
    } else { /* N'umero de filas par */
      for(i=0;i<nx;i++) {
        for(j=0;j<ny;j++) data->in_line[j]=image[j][i];
        data->f->even_synthesize(ny,data->out_line,data->in_line,data->in_line+my);
        for(j=0;j<ny;j++) image[j][i]=data->out_line[j];
      }
    }

    /* Transformamos las columnas (i) */
    if(nx & 1) { /* N'umero impar de columnas */
      for(j=0;j<ny;j++) {
        memcpy(data->in_line,image[j],nx*sizeof(int));
        data->f->odd_synthesize(nx,image[j],data->in_line,data->in_line+mx+1);
      }
    } else { /* N'umero par de columas */
      for(j=0;j<ny;j++) {
        memcpy(data->in_line,image[j],nx*sizeof(int));
        data->f->even_synthesize(nx,image[j],data->in_line,data->in_line+mx);
      }
    }
  }
}

void dwt2d::synthesize(int **image,
		       int y,
		       int x,
		       int levels,
		       class dprfb *f) throw() {
  data->f = f;               
  synthesize(image, y, x, levels);
}
