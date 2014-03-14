#include "rgb2yuv.h"

/*inline void rgb2yuv(int r, int g, int b,
		    int *y, int *u, int *v) {
  *y = ( ( g << 1 ) + r + b ) >> 2;
  *u = b - g;
  *v = r - g;
}

inline void yuv2rgb(int y, int u, int v,
		    int *r, int *g, int *b) {
  *g = y - ( ( u + v ) >> 2 );
  *b = u + *g;
  *r = v + *g;
}
*/
/*inline */void rgb2yuv::rgb_to_yuv(int *rgb, int *yuv) throw() {
  yuv[0] = ( ( rgb[1] << 1 ) + rgb[0] + rgb[2] ) >> 2;
  yuv[1] = rgb[2] - rgb[1];
  yuv[2] = rgb[0] - rgb[1];
}

/*inline */void rgb2yuv::yuv_to_rgb(int *yuv, int *rgb) throw() {
  rgb[1] = yuv[0] - ( ( yuv[1] + yuv[2] ) >> 2 );
  rgb[2] = yuv[1] + rgb[1];
  rgb[0] = yuv[2] + rgb[1];
}
