#define PREV     0 // Previous picture
#define NEXT     1 // Next picture
#define X_FIELD  0
#define Y_FIELD  1

//#define PIXELS_IN_X_MAX 4096 // Anchura máxima de una componente
#define PIXELS_IN_X_MAX 32768

#define MVC_TYPE short

template <typename TYPE>
class motion {

public:

  TYPE ****alloc(int y_dim, int x_dim) {
    TYPE ****data = new TYPE *** [ 2 ]; /* PREV | NEXT */
    for(int i=0; i<2; i++) {
      data[i] = new TYPE ** [2]; /* Y_FIELD | X_FIELD */
      for(int f=0; f<2; f++) {
	data[i][f] = new TYPE * [y_dim];
	for(int y=0; y<y_dim; y++) {
	  data[i][f][y] = new TYPE [x_dim];
	}
      }
    }
    return data;
  }

  void free(TYPE ****data, int y_dim) {
    for(int i=0; i<2; i++) {
      for(int f=0; f<2; f++) {
	for(int y=0; y<y_dim; y++) {
	  delete data[i][f][y];
	}
 	delete data[i][f];
      }
      delete data[i];
    }
  }

  void read(FILE *fd, TYPE ****data, int y_dim, int x_dim) {
    for(int i=0; i<2; i++) {
      for(int f=0; f<2; f++) {
	for(int y=0; y<y_dim; y++) {
	  int read = fread(data[i][f][y], x_dim, sizeof(TYPE), fd);
#if defined DEBUG /* signos y magnitud ... */
	  for(int x=0; x<x_dim; x++) {
	    info("%d ", data[i][f][y][x]);
	  }
#endif
	}
      }
    }
  }

  void write(FILE *fd, TYPE ****data, int y_dim, int x_dim) {
    for(int i=0; i<2; i++) {
      for(int f=0; f<2; f++) {
	for(int y=0; y<y_dim; y++) {
	  fwrite(data[i][f][y], x_dim, sizeof(TYPE), fd);
	}
      }
    }
  }

};
