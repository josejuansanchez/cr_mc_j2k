/*
 * rgb2yuv.c
 *
 * Convierte una secuencia RGB en YUV.
 * gse. 2006.
 */

class rgb2yuv {
 public:
  /*inline */void rgb_to_yuv(int *rgb, int *yuv) throw();
  /*inline */void yuv_to_rgb(int *yuv, int *rgb) throw();
};
