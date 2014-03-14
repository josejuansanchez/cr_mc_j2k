/*
 * Operaciones sencillas sobre componentes.
 */

//#define PIXELS_IN_X_MAX 4096 // Anchura máxima de una componente
#define PIXELS_IN_X_MAX 32768

template <typename IO_TYPE, typename CPU_TYPE>
class texture {

private:
  IO_TYPE line[PIXELS_IN_X_MAX];

public:

  CPU_TYPE **alloc(int y_dim, int x_dim, int border_dim) {
    CPU_TYPE **data = new CPU_TYPE * [ y_dim + border_dim*2 ];
    for(int y=0; y<(y_dim + border_dim*2); y++) {
      data[y] = new CPU_TYPE [ x_dim + border_dim*2 ];
    }

    for(int y=0; y<y_dim; y++) {
      data[y] += border_dim;
    }
    data += border_dim;

    return data;
  }

  void fill_border(CPU_TYPE **data, int y_dim, int x_dim, int border_dim) {

    /* Región 1: Esquina superior izquierda. */
    for(int y=0-border_dim; y<0; y++) {
      for(int x=0-border_dim; x<0; x++) {
	data[y][x] = data[0][0];
      }
    }
    
    /* Región 2: Parte superior. */
    for(int y=0-border_dim; y<0; y++) {
      for(int x=0; x<x_dim; x++) {
	data[y][x] = data[0][x];
      }
    }
    
    /* Región 3: Esquina superior derecha. */
    for(int y=0-border_dim; y<0; y++) {
      for(int x=x_dim; x<x_dim+border_dim; x++) {
	data[y][x] = data[0][x_dim-1];
      }
    }
    
    /* Región 4: Lateral izquierdo. */
    for(int y=0; y<y_dim; y++) {
      for(int x=0-border_dim; x<0; x++) {
	data[y][x] = data[y][0];
      }
    }
    
    /* Región 5: Lateral derecho. */
    for(int y=0; y<y_dim; y++) {
      for(int x=x_dim; x<x_dim+border_dim; x++) {
	data[y][x] = data[y][x_dim-1];
      }
    }
    
    /* Región 6: Esquina inferior izquierda. */
    for(int y=y_dim; y<y_dim+border_dim; y++) {
      for(int x=0-border_dim; x<0; x++) {
	data[y][x] =  data[y_dim-1][x_dim-1];
      }
    }
    
    /* Región 7: Parte inferior. */
    for(int y=y_dim; y<y_dim+border_dim; y++) {
      for(int x=0; x<x_dim; x++) {
	data[y][x] = data[y_dim-1][x];
      }
    }
    
    /* Región 8: Esquina inferior derecha. */
    for(int y=y_dim; y<y_dim+border_dim; y++) {
      for(int x=x_dim; x<x_dim+border_dim; x++) {
	data[y][x] = data[y_dim-1][x_dim-1];
      }
    }

  }

  void read(FILE *fd, CPU_TYPE **img, int y_dim, int x_dim) {
    for(int y=0; y<y_dim; y++) {
      int read = fread(line, sizeof(IO_TYPE), x_dim, fd);
      for(int x=0; x<x_dim; x++) {
	img[y][x] = line[x];
      }
    }
  }

  void write(FILE *fd, CPU_TYPE **img, int y_dim, int x_dim) {
    for(int y=0; y<y_dim; y++) {
      for(int x=0; x<x_dim; x++) {
	line[x] = img[y][x];
      }
      fwrite(line, sizeof(IO_TYPE), x_dim, fd);
    }
  }

};

#ifdef _1_
/*
template <typename TYPE>
class matrix_ops {

  void zerome(TYPE **data, int y_dim, int x_dim) {
    for(int y=0; y<y_dim; y++) {
      memset(data[y], 0, x_dim*sizeof(TYPE));
    }
  }

  void zerome(TYPE **data, int y, int x, int y_dim, int x_dim) {
    for(int _y=y; _y<y+y_dim; _y++) {
      memset(data[y] + x, 0, x_dim*sizeof(TYPE));
    }
  }

  void make_border(TYPE **data, int y_dim, int x_dim, int border_dim) {
  }

};
*/

template <typename TYPE>
void zero(TYPE **data, int y_dim, int x_dim) {
  for(int y=0; y<y_dim; y++) {
    memset(data[y], 0, x_dim*sizeof(TYPE));
  }
}

template <typename TYPE>
void zero(TYPE **data, int y, int x, int y_dim, int x_dim) {
  for(int _y=y; _y<y+y_dim; _y++) {
    memset(data[y] + x, 0, x_dim*sizeof(TYPE));
  }
}

template <typename TYPE>
void alloc_border(TYPE **data, int y_dim, int border_dim) {
  for(int y=0; y<y_dim; y++) {
    data[y] += border_dim;
  }
  data = border_dim;
}

template <typename TYPE>
void fill_border(TYPE **data, int y_dim, int x_dim, int border_dim) {

  /* Región 1: Esquina superior izquierda. */
  for(int y=0-border_dim; y<0; y++) {
    for(int x=0-border_dim; x<0; x++) {
      data[y][x] = data[0][0];
    }
  }

  /* Región 2: Parte superior. */
  for(int y=0-border_dim; y<0; y++) {
    for(int x=0; x<x_dim; x++) {
      data[y][x] = data[0][x];
    }
  }

  /* Región 3: Esquina superior derecha. */
  for(int y=0-border_dim; y<0; y++) {
    for(int x=x_dim; x<x_dim+border_dim; x++) {
      data[y][x] = data[0][x_size[c]-1];
    }
  }

  /* Región 4: Lateral izquierdo. */
  for(int y=0; y<y_dim; y++) {
    for(int x=0-border_dim; x<0; x++) {
      data[y][x] = data[y][0];
    }
  }

  /* Región 5: Lateral derecho. */
  for(int y=0; y<y_dim; y++) {
    for(int x=x_dim; x<x_dim+border_dim; x++) {
      data[y][x] = data[y][x_size[c]-1];
    }
  }

  /* Región 6: Esquina inferior izquierda. */
  for(int y=y_dim; y<y_dim+border_dim; y++) {
    for(int x=0-border_dim; x<0; x++) {
      data[y][x] =  data[y_size[c]-1][x_size[c]-1];
    }
  }

  /* Región 7: Parte inferior. */
  for(int y=y_dim; y<y_dim+border_dim; y++) {
    for(int x=0; x<x_dim; x++) {
      data[y][x] = data[y_size[c]-1][x];
    }
  }

  /* Región 8: Esquina inferior derecha. */
  for(int y=y_dim; y<y_dim+border_dim; y++) {
    for(int x=x_dim; x<x_dim+border_dim; x++) {
      data[y][x] = data[y_size[c]-1][x_size[c]-1];
    }
  }
}

// Separar cada función, en principio diferente, en ficheros
// distintos.

#endif
