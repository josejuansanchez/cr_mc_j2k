/*
 * Estimación del movimiento por bloques de tamaño variable usando
 * sólo la luminancia. Cada bloque genera dos vectores de movimiento,
 * uno haciendo referencia a la imagen anterior y otro a la
 * posterior. Se planea utilizar un quad-tree para codificar la
 * situación y el tamaño de los bloques y que los bloques puedan tener
 * cualquier tamaño.
 */

/*
 * Algoritmo:
 *
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdarg.h>
#include <string.h>
#include "display.cpp"
#include "Haar.cpp"
#include "5_3.cpp"
//#include "13_7.cpp"
//#include "SP.cpp"
#include "dwt2d.cpp"
#include "texture.cpp"
#include "motion.cpp"

#define FAST_SEARCH

#define TC_IO_TYPE unsigned char
#define TC_CPU_TYPE short
#define TEXTURE_INTERPOLATION_FILTER _5_3
#define MOTION_INTERPOLATION_FILTER Haar
//#define MVC_TYPE char
#define MVC_IO_TYPE short
#define MVC_CPU_TYPE short

//#define DEBUG

// Outputs the motion vectors to the stdout
//#define GNUPLOT

// Set to zero the motion vectors
//#define CLEAR_MVS

#if defined FAST_SEARCH /* Acelera mucho el proceso de estimación de
   movimiento, aunque la búsqueda es sub-óptima. */

/* Estima el movimiento de un bloque de la imagen de referencia en la
   imagen predicha usando un área de búsqueda de +-1. Utiliza una
   búsqueda en espiral, terminando en (0,0).

   El movimiento se estima a partir de un punto de búsqueda
   determinado por el valor actual de los vectores de movimiento. Por
   ejemplo, si el valor de entrada de un vector de movimiento es
   (-1,0), los puntos realmente chequedados son (-2,-1), (-2,0),
   (-2,1), (-1,-1), (-1,0), (-1,1), (0,-1), (0,0) y (0,1).
   
*/
void local_me_for_block
(
 MVC_CPU_TYPE ****mv,/* [PREV|NEXT][Y|X][coor_y][coor_x] */
 TC_CPU_TYPE ***ref, /* [PREV|NEXT][coor_y][coor_x] */
 TC_CPU_TYPE **pred, /* [coor_y][coor_x] */
 int luby, int lubx, /* Coordenada superior-izquierda del bloque */
 int rbby, int rbbx, /* Coordenada inferior-derecha del bloque */
 int by, int bx      /* Coordenadas del vector en el campo de movimiento */
 ) {
  /* Error mínimo cometido para todas las posiciones
     chequeadas. min_error[PREV] se refiere a la imagen previa y
     min_error[NEXT] a la siguiente. */
  int min_error[2];

  /* Mejor vector de movimiento calculado en cada
     dirección. (vy[PREV], vx[PREV]) apunta a la imagen previa y
     (vy[NEXT], vx[NEXT]) a la imagen posterior. */
  int vy[2], vx[2];

  MVC_CPU_TYPE mv_prev_y_by_bx = mv[PREV][Y_FIELD][by][bx];
  MVC_CPU_TYPE mv_prev_x_by_bx = mv[PREV][X_FIELD][by][bx];
  MVC_CPU_TYPE mv_next_y_by_bx = mv[NEXT][Y_FIELD][by][bx];
  MVC_CPU_TYPE mv_next_x_by_bx = mv[NEXT][X_FIELD][by][bx];

#define COMPUTE_ERRORS(_y,_x)						\
  MVC_CPU_TYPE y[2] = {mv_prev_y_by_bx + _y, mv_next_y_by_bx - _y};		\
  MVC_CPU_TYPE x[2] = {mv_prev_x_by_bx + _x, mv_next_x_by_bx - _x};		\
  int error[2] = {0, 0};						\
									\
  for(int py=luby; py<rbby; py++) {					\
    TC_CPU_TYPE *pred_py = pred[py];					\
      for(int px=lubx; px<rbbx; px++) {					\
	error[PREV] += abs						\
	  (pred_py[px] - ref[PREV][py + y[PREV]][px + x[PREV]]);	\
	error[NEXT] += abs						\
	  (pred_py[px] - ref[NEXT][py + y[NEXT]][px + x[NEXT]]);	\
      }									\
    }									\
    
#define UPDATE_VECTORS							\
  if(error[PREV] <= min_error[PREV]) {					\
    vy[PREV] = y[PREV];							\
    vx[PREV] = x[PREV];							\
    min_error[PREV] = error[PREV];					\
  }									\
									\
  if(error[NEXT] <= min_error[NEXT]) {					\
    vy[NEXT] = y[NEXT];							\
    vx[NEXT] = x[NEXT];							\
    min_error[NEXT] = error[NEXT];					\
  }

  /* 1. Posición (-1,-1). Arriba - izquierda. */ {
    COMPUTE_ERRORS(-1,-1);
    
    min_error[PREV] = error[PREV];
    vy[PREV] = y[PREV];
    vx[PREV] = x[PREV];

    min_error[NEXT] = error[NEXT];
    vy[NEXT] = y[NEXT];
    vx[NEXT] = x[NEXT];
  }
  
  /* 2. Posición (-1,1). Arriba - derecha. */ {
    COMPUTE_ERRORS(-1,1);
    UPDATE_VECTORS;
  }
  
  /* 3. Posición (1,-1). Abajo - izquierda. */ {
    COMPUTE_ERRORS(1,-1);
    UPDATE_VECTORS;
  }
  
  /* 4. Posición (1,1). Abajo - derecha. */ {
    COMPUTE_ERRORS(1,1);
    UPDATE_VECTORS;
  }
  
  /* 5. Posición (-1,0). Arriba. */ {
    COMPUTE_ERRORS(-1,0);
    UPDATE_VECTORS;
  }
  
  /* 6. Posición (1,0). Abajo. */ {
    COMPUTE_ERRORS(1,0);
    UPDATE_VECTORS;
  }
  
  /* 7. Posición (0,1). Derecha. */ {
    COMPUTE_ERRORS(0,1);
    UPDATE_VECTORS;
  }
  
  /* 8. Posición (0,-1). Izquierda. */ {
    COMPUTE_ERRORS(0,-1);
    UPDATE_VECTORS;
  }
  
  /* 9. Posición (0,0). */ {
    COMPUTE_ERRORS(0,0);
    UPDATE_VECTORS;
  }
  
#undef COMPUTE_ERRORS
#undef UPDATE_VECTORS
  
  mv[PREV][Y_FIELD][by][bx] = vy[PREV];
  mv[PREV][X_FIELD][by][bx] = vx[PREV];
  mv[NEXT][Y_FIELD][by][bx] = vy[NEXT];
  mv[NEXT][X_FIELD][by][bx] = vx[NEXT];

} /* local_me_for_block() */

/*
 * Estima el movimiento de todos los bloques de la imagen predicha
 * usando un área de búsqueda de +-1.
 */
void local_me_for_image
(
 MVC_CPU_TYPE ****mv,         /* [PREV|NEXT][Y|X][coor_y][coor_x] */
 TC_CPU_TYPE ***ref,          /* [PREV|NEXT][coor_y][coor_x] */
 TC_CPU_TYPE **pred,          /* [coor_y][coor_x] */
 int block_size,
 int border_size,
 int blocks_in_y,
 int blocks_in_x
) {
  
  for(int by=0; by<blocks_in_y; by++) {
#if defined DEBUG_
    info("%d/%d ", by, blocks_in_y); info_flush();
#endif
    for(int bx=0; bx<blocks_in_x; bx++) {
	
      /* Región que ocupa el bloque (incluido el borde) */
      int luby = (by  ) * block_size - border_size;
      int lubx = (bx  ) * block_size - border_size;
      int rbby = (by+1) * block_size + border_size;
      int rbbx = (bx+1) * block_size + border_size;
      
      local_me_for_block(mv, ref, pred, luby, lubx, rbby, rbbx, by, bx);
    }
  }
#if defined DEBUG
  info("\n");
#endif
}

int desp(int x, int y) {
  int i;
  for(i=0; i<y; i++) x = (x+1)/2;
  return x;
}

# endif /* FAST_SEARCH */

/* Divide predicted_pic en bloques cuadrados disjuntos y los busca en
   reference_pic[0] y reference_pic[1]. Sólo se utiliza la luma para
   estimar el movimiento.

   Como resultado devuelve en mv los vectores de movimiento
   calculados. Estos vectores son también un parámetro de entrada
   cuando queremos buscar en un área cercana a un desplazamiento ya
   precalculado (por ejemplo, en un nivel de resolución temporal
   superior).
*/
void me_for_image
(MVC_CPU_TYPE ****mv,           /* [PREV|NEXT][y_field|x_field][y_coor][x_coor] */
 TC_CPU_TYPE ***ref,            /* [PREV|NEXT][y_coor][x_coor] */
 TC_CPU_TYPE **pred,            /* [y_coor][x_coor] */
 int pixels_in_y,
 int pixels_in_x,
 int block_size,
 int border_size,
 int subpixel_accuracy,
 int search_range,
 int blocks_in_y,
 int blocks_in_x,
 class dwt2d < TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER < TC_CPU_TYPE > > *pic_dwt,
 class dwt2d < MVC_CPU_TYPE, MOTION_INTERPOLATION_FILTER < MVC_CPU_TYPE > > *mv_dwt) {

#if defined FAST_SEARCH
  
  int dwt_levels = (int)rint(log((double)search_range)/log(2.0)) - 1;
#if defined DEBUG
  info("motion_estimate: dwt_levels = %d\n", dwt_levels);
#endif

  /* DWT de las imágenes. */
  pic_dwt->analyze(ref[PREV], pixels_in_y, pixels_in_x, dwt_levels);
  pic_dwt->analyze(ref[NEXT], pixels_in_y, pixels_in_x, dwt_levels);
  pic_dwt->analyze(pred, pixels_in_y, pixels_in_x, dwt_levels);

  /* Estimación sobre-pixel. */
#if defined DEBUG
  info("motion_estimate: over-pixel motion estimation level=%d\n", dwt_levels);
#endif

  local_me_for_image(mv,
		     ref,
		     pred,
		     block_size,
		     border_size,
		     desp(blocks_in_y, dwt_levels),
		     desp(blocks_in_x, dwt_levels));
    
  for(int l=dwt_levels-1; l>=0; --l) {
    int Y_l = desp(pixels_in_y, l);
    int X_l = desp(pixels_in_x, l);
    int blocks_in_y_l = desp(blocks_in_y, l);
    int blocks_in_x_l = desp(blocks_in_x, l);

    /* Ampliamos las imágenes en un factor de 2. */
    pic_dwt->synthesize(ref[PREV], Y_l, X_l, 1);
    pic_dwt->synthesize(ref[NEXT], Y_l, X_l, 1);
    pic_dwt->synthesize(pred, Y_l, X_l, 1);

    /* Ampliamos los campos de movimiento en un factor de 2. Esto es
       necesario porque en la siguiente iteración las imágenes de
       referencia y predicha son el doble de grandes. */
    mv_dwt->synthesize(mv[PREV][Y_FIELD], blocks_in_y_l, blocks_in_x_l, 1);
    mv_dwt->synthesize(mv[NEXT][Y_FIELD], blocks_in_y_l, blocks_in_x_l, 1);
    mv_dwt->synthesize(mv[PREV][X_FIELD], blocks_in_y_l, blocks_in_x_l, 1);
    mv_dwt->synthesize(mv[NEXT][X_FIELD], blocks_in_y_l, blocks_in_x_l, 1);
    
    /* Multiplicamos por dos los vectores de movimiento, porque los
       valores calculados referencian ahora a una imagen el doble de
       grande en cada dimensión. */
    for(int by=0; by<blocks_in_y_l; by++) {
      for(int bx=0; bx<blocks_in_x_l; bx++) {

	mv[PREV][Y_FIELD][by][bx] *= 2;
	if(mv[PREV][Y_FIELD][by][bx] > search_range)
	  mv[PREV][Y_FIELD][by][bx] = search_range;
	if(mv[PREV][Y_FIELD][by][bx] < -search_range)
	  mv[PREV][Y_FIELD][by][bx] = -search_range;

	mv[NEXT][Y_FIELD][by][bx] *= 2;
	if(mv[NEXT][Y_FIELD][by][bx] > search_range)
	  mv[NEXT][Y_FIELD][by][bx] =  search_range;
	if(mv[NEXT][Y_FIELD][by][bx] < -search_range)
	  mv[NEXT][Y_FIELD][by][bx] = -search_range;

	mv[PREV][X_FIELD][by][bx] *= 2;
	if(mv[PREV][X_FIELD][by][bx] > search_range)
	  mv[PREV][X_FIELD][by][bx] =  search_range;
	if(mv[PREV][X_FIELD][by][bx] < -search_range)
	  mv[PREV][X_FIELD][by][bx] = -search_range;

	mv[NEXT][X_FIELD][by][bx] *= 2;
	if(mv[NEXT][X_FIELD][by][bx] > search_range)
	  mv[NEXT][X_FIELD][by][bx] =  search_range;
	if(mv[NEXT][X_FIELD][by][bx] < -search_range)
	  mv[NEXT][X_FIELD][by][bx] = -search_range;
      }
    }
#if defined DEBUG
    info("motion_estimate: over-pixel motion estimation level=%d\n",l);
#endif
    local_me_for_image(mv,
		       ref,
		       pred,
		       block_size,
		       border_size,
		       blocks_in_y_l, blocks_in_x_l);
  }
  
  /* Estimación sub-pixel. */
  for(int l=1; l<=subpixel_accuracy; l++) {
#if defined DEBUG
    info("motion_estimate: sub-pixel motion estimation level=%d\n",l);
#endif
    
    /* Ampliamos las imágenes en un factor de 2. */
    pic_dwt->synthesize(ref[PREV], pixels_in_y<<l, pixels_in_x<<l, 1);
    pic_dwt->synthesize(ref[NEXT], pixels_in_y<<l, pixels_in_x<<l, 1);
    pic_dwt->synthesize(pred, pixels_in_y<<l, pixels_in_x<<l, 1);
    
    /* Multiplicamos los vectores de movimiento por 2. */
    for(int by=0; by<blocks_in_y; by++) {
      for(int bx=0; bx<blocks_in_x; bx++) {

	mv[PREV][Y_FIELD][by][bx] *= 2;
	if(mv[PREV][Y_FIELD][by][bx]>(search_range<<subpixel_accuracy))
	  mv[PREV][Y_FIELD][by][bx] = search_range<<subpixel_accuracy;
	if(mv[PREV][Y_FIELD][by][bx]<-(search_range<<subpixel_accuracy))
	  mv[PREV][Y_FIELD][by][bx]= -(search_range<<subpixel_accuracy);

	mv[NEXT][Y_FIELD][by][bx] *= 2;
	if(mv[NEXT][Y_FIELD][by][bx]>(search_range<<subpixel_accuracy))
	  mv[NEXT][Y_FIELD][by][bx] = search_range<<subpixel_accuracy;
	if(mv[NEXT][Y_FIELD][by][bx]<-(search_range<<subpixel_accuracy))
	  mv[NEXT][Y_FIELD][by][bx]= -(search_range<<subpixel_accuracy);

	mv[PREV][X_FIELD][by][bx] *= 2;
	if(mv[PREV][X_FIELD][by][bx]>(search_range<<subpixel_accuracy))
	  mv[PREV][X_FIELD][by][bx] = (search_range<<subpixel_accuracy);
	if(mv[PREV][X_FIELD][by][bx]<-(search_range<<subpixel_accuracy))
	  mv[PREV][X_FIELD][by][bx]= -(search_range<<subpixel_accuracy);

	mv[NEXT][X_FIELD][by][bx] *= 2;
	if(mv[NEXT][X_FIELD][by][bx]>(search_range<<subpixel_accuracy))
	  mv[NEXT][X_FIELD][by][bx] = (search_range<<subpixel_accuracy);
	if(mv[NEXT][X_FIELD][by][bx]<-(search_range<<subpixel_accuracy))
	  mv[NEXT][X_FIELD][by][bx]= -(search_range<<subpixel_accuracy);
      }
    }
    
    local_me_for_image(mv,
		       ref,
		       pred,
		       block_size<<l,
		       border_size>>l,
		       blocks_in_y, blocks_in_x);
  }

  /* Dejamos las imágenes como estaban, para la siguiente búsqueda. */
  pic_dwt->analyze(ref[PREV], pixels_in_y << subpixel_accuracy, pixels_in_x << subpixel_accuracy, subpixel_accuracy);
  pic_dwt->analyze(ref[NEXT], pixels_in_y << subpixel_accuracy, pixels_in_x << subpixel_accuracy, subpixel_accuracy);
  pic_dwt->analyze(pred, pixels_in_y << subpixel_accuracy, pixels_in_x << subpixel_accuracy, subpixel_accuracy);

  //pic_dwt->analyze(reference_pic, Y<<subpixel_accuracy, X<<subpixel_accuracy, subpixel_accuracy);
  //pic_dwt->analyze(predicted_pic, Y<<subpixel_accuracy, X<<subpixel_accuracy, subpixel_accuracy);

#else /* !defined FAST_SEARCH */

  pic_dwt->synthesize(reference_pic[0], Y<<subpixel_accuracy, X<<subpixel_accuracy, subpixel_accuracy);
  pic_dwt->synthesize(reference_pic[1], Y<<subpixel_accuracy, X<<subpixel_accuracy, subpixel_accuracy);
  pic_dwt->synthesize(predicted_pic, Y<<subpixel_accuracy, X<<subpixel_accuracy, subpixel_accuracy);
  
  block_size <<= subpixel_accuracy;
  search_range <<= subpixel_accuracy;
  border_size <<= subpixel_accuracy;
  
  int blocks_in_y = (Y<<subpixel_accuracy)/block_size;
  int blocks_in_x = (X<<subpixel_accuracy)/block_size;
  
  for(int by=0; by<blocks_in_y; by++) {
    print("%d/%d ",by,blocks_in_y); fflush(stderr);
    for(int bx=0; bx<blocks_in_x; bx++) {
      int min_error = 999999999;
      int vy, vx;
      
      /* Para cada punto del área de búsqueda. */
      for(int ry=by*block_size-search_range; ry<=by*block_size+search_range; ry++) {
	for(int rx=bx*block_size-search_range; rx<=bx*block_size+search_range; rx++) {
	  /* Para cada punto del bloque a buscar. */
	  int error = 0;
	  for(int y=-border_size; y<block_size+border_size; y++) {
	    for(int x=-border_size; x<block_size+border_size; x++) {
	      error += abs(predicted_pic[by*block_size+y][bx*block_size+x] -
			   reference_pic
			   [0]
			   [ry + mv[NEXT][Y][by][bx] + y]
			   [rx + mv[NEXT][X][by][bx] + x]);
	      error += abs(predicted_pic[by*block_size+y][bx*block_size+x] -
			   reference_pic
			   [1]
			   [by*block_size*2 - ry + mv[PREV][Y][by][bx] + y]
			   [bx*block_size*2 - rx + mv[PREV][X][by][bx] + x]);
	    }
	  }
	  if(error < min_error) {
	    min_error = error;
	    vy = ry-by*block_size;
	    vx = rx-bx*block_size;
	  }
	  /*print("\n%d,%d  %d,%d %d %d",
	    ry + mv[NEXT][Y][by][bx],
	    rx + mv[NEXT][X][by][bx],
	    by*block_size*2 - ry + mv[PREV][Y][by][bx],
	    bx*block_size*2 - rx + mv[PREV][X][by][bx],
	    error, min_error
	    );*/
	}
      }
      
      mv[NEXT][Y][by][bx] += vy;
      mv[NEXT][X][by][bx] += vx;
      mv[PREV][Y][by][bx] += -vy;
      mv[PREV][X][by][bx] += -vx;
      
      //print("\nvector = %d,%d,%d,%d",mv[NEXT][Y][by][bx],mv[NEXT][X][by][bx],mv[PREV][Y][by][bx],mv[PREV][X][by][bx]);
    }
  }

#endif /* FAST_SEARCH */

} /* me_for_image */

#include <getopt.h>

int main(int argc, char *argv[]) {

#if defined DEBUG
  info("%s ", argv[0]);
  for(int i=1; i<argc; i++) {
    info("%s ", argv[i]);
  }
  info("\n");
#endif

  int block_size = 16;
  int border_size = 0;
  char *imotion_fn = (char *)"imotion";
  char *motion_fn = (char *)"motion";
  char *predicted_fn = (char *)"odd";
  int pictures = 33;
  int pixels_in_x = 352;
  int pixels_in_y = 288;
  char *reference_fn = (char *)"even";
  int search_range = 4;
  int subpixel_accuracy = 0;
  
  /* http://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html */
  int c;
  while(1) {
    
    static struct option long_options[] = {
      {"block_size", required_argument, 0, 'b'},
      {"border_size", required_argument, 0, 'd'},
      {"imotion_fn", required_argument, 0, 'i'},
      {"motion_fn", required_argument, 0, 'm'},
      {"pictures", required_argument, 0, 'p'},
      {"pixels_in_x", required_argument, 0, 'x'},
      {"pixels_in_y", required_argument, 0, 'y'},
      {"predicted_fn", required_argument, 0, 'c'},
      {"reference_fn", required_argument, 0, 'r'},
      {"search_range", required_argument, 0, 's'},
      {"subpixel_accuracy", required_argument, 0, 'a'},
      {"help", no_argument, 0, '?'},
      {0, 0, 0, 0}
    };

    int option_index = 0;
    
    c = getopt_long(argc, argv, "b:d:e:i:m:o:p:x:y:s:a:?", long_options, &option_index);

    if(c==-1) {
      /* Ya no hay más opciones. */
      break;
    }
    
    switch (c) {
    case 0:
      /* If this option set a flag, do nothing else now. */
      if (long_options[option_index].flag != 0)
	break;
      info("option %s", long_options[option_index].name);
      if (optarg)
	info(" with arg %s", optarg);
      info("\n");
      break;
      
    case 'b':
      block_size = atoi(optarg);
#if defined DEBUG
      info("%s: block_size=%d\n", argv[0], block_size);
#endif
      break;
      
    case 'i':
      imotion_fn = optarg;
#if defined DEBUG
      info("%s: imotion_fn=\"%s\"\n", argv[0], imotion_fn);
#endif
      break;

    case 'm':
      motion_fn = optarg;
#if defined DEBUG
      info("%s: motion_fn=\"%s\"\n", argv[0], motion_fn);
#endif
      break;

    case 'd':
      border_size = atoi(optarg);
#if defined DEBUG
      info("%s: border_size=%d\n", argv[0], border_size);
#endif
      break;

    case 'p':
      pictures = atoi(optarg);
#if defined DEBUG
      info("%s: pictures=%d\n", argv[0], pictures);
#endif
      break;
      
    case 'x':
      pixels_in_x = atoi(optarg);
 #if defined DEBUG
     info("%s: pixels_in_x=%d\n", argv[0], pixels_in_x);
#endif
      break;
      
    case 'y':
      pixels_in_y = atoi(optarg);
#if defined DEBUG
      info("%s: pixels_in_y=%d\n", argv[0], pixels_in_y);
#endif
      break;
      
    case 'c':
      predicted_fn = optarg;
#if defined DEBUG
      info("%s: predicted_fn=\"%s\"\n", argv[0], predicted_fn);
#endif
      break;

    case 'r':
      reference_fn = optarg;
#if defined DEBUG
      info("%s: reference_fn=\"%s\"\n", argv[0], reference_fn);
#endif
      break;

    case 's':
      search_range = atoi(optarg);
#if defined DEBUG
      info("%s: search_range=%d\n", argv[0], search_range);
#endif
      break;
      
    case 'a':
      subpixel_accuracy = atoi(optarg);
#if defined DEBUG
      info("%s: subpixel_accuracy=%d\n", argv[0], subpixel_accuracy);
#endif
      break;
      
    case '?':
      printf("+----------------------+\n");
      printf("| MCTF motion_estimate |\n");
      printf("+----------------------+\n");
      printf("\n");
      printf("   Block-based time-domain motion estimation.\n");
      printf("\n");
      printf("  Parameters:\n");
      printf("\n");
      printf("   -[-b]lock_size = size of the blocks in the motion estimation process (%d)\n", block_size);
      printf("   -[-]bor[d]der_size = size of the border of the blocks in the motion estimation process (%d)\n", border_size);
      printf("   -[-r]eferences_fn = input file with the reference pictures (\"%s\")\n", reference_fn);
      printf("   -[-i]motion_fn = input file with the initial motion fields (\"%s\")\n", imotion_fn);
      printf("   -[-m]otion_fn = output file with the motion fields (\"%s\")\n", imotion_fn);
      printf("   -[-p]ictures = number of images to process (%d)\n", pictures);
      printf("   -[-]pixels_in_[x] = size of the X dimension of the pictures (%d)\n", pixels_in_x);
      printf("   -[-]pixels_in_[y] = size of the Y dimension of the pictures (%d)\n", pixels_in_y);
      printf("   -[-]predi[c]ted_fn = input file with predicted pictures (\"%s\")\n", predicted_fn);
      printf("   -[-s]earch_range = size of the searching area of the motion estimation (%d)\n", search_range);
      printf("   -[-]subpixel_[a]ccuracy = sub-pixel accuracy of the motion estimation (%d)\n", subpixel_accuracy);
      printf("\n");
      exit(1);
      break;
      
    default:
      error("%s: Unrecognized argument. Aborting ...\n", argv[0]);
      abort();
    }
  }
  
  int reuse_motion = 1;

  FILE *motion_fd; {
    motion_fd = fopen(motion_fn, "r");
    if(!motion_fd) {
      reuse_motion = 0;
#if defined DEBUG
      info("%s: computing motion information\n", argv[0]);
#endif
      motion_fd = fopen(motion_fn, "w");
      if(!motion_fd) {
	error("%s: unable to create the file \"%s\" ... aborting!\n",
	      argv[0], motion_fn);
	abort();
      }
    } else {
#if defined DEBUG
      info("%s: reusing motion information \"%s\"\n",
	   argv[0], motion_fn);
#endif
    }
  }

  if(reuse_motion) return(0);

  FILE *imotion_fd; {
    imotion_fd = fopen(imotion_fn, "r");
    if(!imotion_fd) {
#if defined DEBUG
      info("%s: \"%s\" does not exist: initial_motion_fn = \"%s\"\n",
	   argv[0], imotion_fn, "/dev/zero");
#endif
      imotion_fd = fopen("/dev/zero", "r");
      /* /dev/zero debería siempre existir. */
    }
  }

  FILE *reference_fd; {
    reference_fd = fopen(reference_fn, "r");
    if(!reference_fd) {
      error("%s: \"%s\" does not exist ... aborting!\n",
	    argv[0], reference_fn);
      abort();
    }
  }

  FILE *predicted_fd; {
    predicted_fd = fopen(predicted_fn, "r");
    if(!predicted_fd) {
      error("%s: \"%s\" does not exist ... aborting!\n",
	    argv[0], predicted_fn);
      abort();
    }
  }

  int picture_border_size = search_range + border_size;

  texture < TC_IO_TYPE, TC_CPU_TYPE > texture;

  TC_CPU_TYPE **reference[2];
  for(int i=0; i<2; i++) {
    reference[i] =
      texture.alloc(pixels_in_y << subpixel_accuracy,
		    pixels_in_x << subpixel_accuracy,
		    picture_border_size << subpixel_accuracy/**2*/);

    /* Esta inicialización parece no hacer nada. */
    for(int y=0; y<pixels_in_y << subpixel_accuracy; y++) {
      for(int x=0; x<pixels_in_x <<subpixel_accuracy; x++) {
	reference[i][y][x] = 0;
      }
    }
  }
  
  TC_CPU_TYPE **predicted =
    texture.alloc(pixels_in_y << subpixel_accuracy,
		  pixels_in_x << subpixel_accuracy,
		  picture_border_size << subpixel_accuracy/**2*/);

    /* Esta inicialización parece no hacer nada. */
  for(int y=0; y<pixels_in_y << subpixel_accuracy; y++) {
    for(int x=0; x<pixels_in_x <<subpixel_accuracy; x++) {
      predicted[y][x] = 0;
    }
  }

  int blocks_in_y = pixels_in_y/block_size;
  int blocks_in_x = pixels_in_x/block_size;
#if defined DEBUG
  info("%s: blocks_in_y=%d\n", argv[0], blocks_in_y);
  info("%s: blocks_in_x=%d\n", argv[0], blocks_in_x);
#endif

  motion < MVC_TYPE > motion;
  MVC_CPU_TYPE ****mv = motion.alloc(blocks_in_y, blocks_in_x);

  class dwt2d <
  TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER <
  TC_CPU_TYPE > > *texture_dwt
    = new class dwt2d <
  TC_CPU_TYPE, TEXTURE_INTERPOLATION_FILTER <
  TC_CPU_TYPE > >;
  texture_dwt->set_max_line_size(PIXELS_IN_X_MAX);

  class dwt2d < 
  MVC_CPU_TYPE, MOTION_INTERPOLATION_FILTER <
  MVC_CPU_TYPE > > *motion_dwt
    = new class dwt2d <
  MVC_CPU_TYPE, MOTION_INTERPOLATION_FILTER <
  MVC_CPU_TYPE > >;
  motion_dwt->set_max_line_size(PIXELS_IN_X_MAX);

  /* Leemos la luma de reference[0]. */
  texture.read(reference_fd, reference[0], pixels_in_y, pixels_in_x);

  /* Y saltamos las cromas. */
  fseek(reference_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);
  fseek(reference_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);

  /* Rellenamos el borde de la imagen leída. */
  texture.fill_border(reference[0],
		      pixels_in_y,
		      pixels_in_x,
		      picture_border_size);

  for(int i=0; i<pictures/2; i++) {

#if defined DEBUG
    info("%s: reading predicted picture %d of \"%s\".\n",
	 argv[0], i, predicted_fn);
#endif

    /* Luma. */
    texture.read(predicted_fd, predicted, pixels_in_y, pixels_in_x);

    /* Cromas. */
    fseek(predicted_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);
    fseek(predicted_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);

#if defined DEBUG
    info("%s: reading picture %d of \"%s\".\n",
	 argv[0], i, reference_fn);
#endif
    /* OJO. Esta inicialización parece no hacer nada. */
    for(int y=0; y<pixels_in_y << subpixel_accuracy; y++) {
      for(int x=0; x<pixels_in_x <<subpixel_accuracy; x++) {
	reference[1][y][x] = 0;
      }
    }

    /* Luma. */
    texture.read(reference_fd, reference[1], pixels_in_y, pixels_in_x);

    /* Cromas. */
    fseek(reference_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);
    fseek(reference_fd, (pixels_in_y/2) * (pixels_in_x/2) * sizeof(unsigned char), SEEK_CUR);

    /* Rellenamos el borde de la imagen leída. */
    texture.fill_border(reference[1],
			pixels_in_y,
			pixels_in_x,
			picture_border_size);

#if defined DEBUG
    info("%s: reading initial motion vectors.\n", argv[0]);
#endif
    //motion.read(imotion_fd, mv, blocks_in_y, blocks_in_x);
    // Esto tampoco hace nada (dejar lo de arriba).
    for(int by=0; by<blocks_in_y; by++) {
      for(int bx=0; bx<blocks_in_x; bx++) {
	mv[PREV][Y_FIELD][by][bx] = mv[PREV][X_FIELD][by][bx] = mv[NEXT][Y_FIELD][by][bx] = mv[NEXT][X_FIELD][by][bx] = 0;
      }
    }

    me_for_image(mv,
		 reference,
		 predicted,
		 pixels_in_y, pixels_in_x,
		 block_size,
		 border_size,
		 subpixel_accuracy,
		 search_range,
		 blocks_in_y,
		 blocks_in_x,
		 texture_dwt,
		 motion_dwt);
    
#ifdef CLEAR_MVS
    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {
	mv[PREV][Y_FIELD][y][x] = 0;
	mv[PREV][X_FIELD][y][x] = 0;
	mv[NEXT][Y_FIELD][y][x] = 0;
	mv[NEXT][X_FIELD][y][x] = 0;
      }
    }
#endif

#if defined DEBUG
    info("Backward motion vector field:");
    for(int y=0; y<blocks_in_y; y++) {
      info("\n");
      for(int x=0; x<blocks_in_x; x++) {
	static char aux[80];
	sprintf(aux,"%3d,%3d",
	     mv[PREV][Y_FIELD][y][x],
	     mv[PREV][X_FIELD][y][x]);
	info("%8s",aux);
      }
    }
    info("\n");

    info("Forward motion vector field:");
    for(int y=0; y<blocks_in_y; y++) {
      info("\n");
      for(int x=0; x<blocks_in_x; x++) {
	static char aux[80];
	sprintf(aux,"%3d,%3d",
	     mv[NEXT][Y_FIELD][y][x],
	     mv[NEXT][X_FIELD][y][x]);
	info("%8s",aux);
      }
    }
    info("\n");
#endif

#if defined GNUPLOT
    for(int y=0; y<blocks_in_y; y++) {
      for(int x=0; x<blocks_in_x; x++) {
	printf("GNUPLOT %d %d %f %f %f %f\n",
	       x*block_size, y*block_size,
	       (float)mv[PREV][X_FIELD][y][x], (float)mv[PREV][Y_FIELD][y][x],
	       (float)mv[NEXT][X_FIELD][y][x], (float)mv[NEXT][Y_FIELD][y][x]);
      }
    }
#endif

#if defined DEBUG
    info("%s: writing motion vector field %d in \"%s\".\n",
	 argv[0], i, motion_fn);
#endif
    motion.write(motion_fd, mv, blocks_in_y, blocks_in_x);

    /* SWAP(&reference_pic[0], &reference_pic[1]). */ {
      TC_CPU_TYPE **tmp = reference[0];
      reference[0] = reference[1];
      reference[1] = tmp;
    }
  }

  delete motion_dwt;
  delete texture_dwt;

}
