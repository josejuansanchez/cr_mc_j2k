/*
 * The 2D Discrete Wavelet Transform.
 */

#include <string.h>

template <typename TYPE, class FILTER>
class dwt2d: public FILTER/*, public mallok*/ {
    
private:
  TYPE *in_line;
  TYPE *out_line;
  
public:
  
  dwt2d() {
    /*in_line = (TYPE *)mallok::alloc_1d(1,sizeof(TYPE));
      out_line = (TYPE *)mallok::alloc_1d(1,sizeof(TYPE));*/
    in_line = new TYPE [1];
    out_line = new TYPE [1];
  }

  ~dwt2d() {
    /*mallok::free_1d(out_line);
      mallok::free_1d(in_line);*/
    delete out_line;
    delete in_line;
  }

  void set_max_line_size(int max_line_size) {
    /*mallok::free_1d(out_line);
    mallok::free_1d(in_line);
    in_line = (TYPE *)mallok::alloc_1d(max_line_size,sizeof(TYPE));
    out_line = (TYPE *)mallok::alloc_1d(max_line_size,sizeof(TYPE));*/
    delete out_line;
    delete in_line;
    in_line = new TYPE [max_line_size];
    out_line = new TYPE [max_line_size];
  }

  void analyze(TYPE **signal, int y, int x, int levels) {
    for(int lv=0;lv<levels;lv++) {
      int nx = x; x >>= 1;
      int ny = y; y >>= 1;
      if(y == 0) y = 1; /* Nuevo */
      if(x == 0) x = 1; /* Nuevo */
      
      /* Transformamos las filas */
      if(nx & 1) { /* N'umero impar de columnas */
	for(int j=0;j<ny;j++) {
	  memcpy(in_line, signal[j], nx*sizeof(TYPE));
	  odd_analyze(in_line, signal[j], signal[j] + x + 1, nx);
	}
      } else { /* N'umero par de columnas */
	for(int j=0;j<ny;j++) {
	  memcpy(in_line, signal[j], nx*sizeof(TYPE));
	  even_analyze(in_line, signal[j], signal[j] + x, nx);
	}
      }
      
      /* Transformamos las columnas */
      if(ny & 1) { /* N'umero impar de filas */
	for(int i=0;i<nx;i++) {
	  for(int j=0;j<ny;j++) {
	    in_line[j]=signal[j][i];
	  }
	  odd_analyze(in_line, out_line, out_line + y + 1, ny);
	  for(int j=0;j<ny;j++) {
	    signal[j][i]=out_line[j];
	  }
	}
      } else { /* N'umero par de filas */
	for(int i=0;i<nx;i++) {
	  for(int j=0;j<ny;j++) {
	    in_line[j]=signal[j][i];
	  }
	  even_analyze(in_line, out_line, out_line + y, ny);
	  for(int j=0;j<ny;j++) {
	    signal[j][i]=out_line[j];
	  }
	}
      }
    }
  }

  void synthesize(TYPE **signal, int y, int x, int levels) {
    int nx = x>>levels;
    int ny = y>>levels;
    
    for(int lv = levels-1; lv>=0; lv--) {
      int mx, my;
      mx = nx; nx=x>>lv;
      my = ny; ny=y>>lv;
      if(nx==0) nx=1; /* Nuevo */
      if(ny==0) ny=1; /* Nuevo */
      
      /* Transformamos las columnas */
      if(ny & 1) { /* N'umero de filas impar */
	for(int i=0;i<nx;i++) {
	  for(int j=0;j<ny;j++) {
	    in_line[j] = signal[j][i];
	  }
	  odd_synthesize(out_line, in_line, in_line + my + 1, ny);
	  for(int j=0;j<ny;j++) {
	    signal[j][i] = out_line[j];
	  }
	}
      } else { /* N'umero de filas par */
	for(int i=0;i<nx;i++) {
	  for(int j=0;j<ny;j++) {
	    in_line[j] = signal[j][i];
	  }
	  even_synthesize(out_line, in_line, in_line + my, ny);
	  for(int j=0;j<ny;j++) {
	    signal[j][i] = out_line[j];
	  }
	}
      }
      
      /* Transformamos las columnas (i) */
      if(nx & 1) { /* N'umero impar de columnas */
	for(int j=0;j<ny;j++) {
	  memcpy(in_line, signal[j], nx*sizeof(TYPE));
	  odd_synthesize(signal[j], in_line, in_line + mx + 1, nx);
	}
      } else { /* N'umero par de columas */
	for(int j=0;j<ny;j++) {
	  memcpy(in_line, signal[j], nx*sizeof(TYPE));
	  even_synthesize(signal[j], in_line, in_line + mx, nx);
	}
      }
    }
  }

};