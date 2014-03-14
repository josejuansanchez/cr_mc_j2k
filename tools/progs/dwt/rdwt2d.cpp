/*
 * Redundant Discrete Wavelet Transform 2D.
 * gse. 2006.
 */

/*
 * Nota importante:
 *
 * Esta implementación de la 2D-RDWT se basa en la idea de usar la
 * 2D-DWT aplicada con diferentes desplazamientos para calcular las
 * distintas fases. La otra posibilidad es calcular la RDWT a partir
 * de los filtros unidimensionales críticos (decimated) aplicados
 * sobre las señales con las muestras replicadas dos veces cada una y
 * de forma consecutiva.
 */

#include "mallok.h"
#include "dprfb.h"
#include "dwt2d.h"
#include "rdwt2d.h"
#include <stdio.h>
#include <string.h>
//#include <stdlib.h>

void rdwt2d::phase_order_malloc(int levels) throw(mallok::bad_alloc) {
  int l;
  phase_order = (int **)alloc_1d(levels,sizeof(int *));
  for(l=1; l<levels; l++) {
    phase_order[l] = (int *)mallok::alloc_1d(1<<(2*(l-0)),sizeof(int));
  }
}

void rdwt2d::aux_malloc(int levels) throw(mallok::bad_alloc) {
  aux = (int ***)mallok::alloc_1d((1<<(2*(levels-0))),sizeof(int **));
}


/* Calcula el bit y-ésimo del entero x.*/
int bit(int x, int y) {
  return (x >> y)%2;
}

/* Devuelve la posición adecuada de la fase en una ordenación espacial,
   primero por filas y luego por columnas.

  La matriz de ordenación espacial de las fases se genera de la
  siguiente manera:
  
  2 niveles, 4 fases:
  ------------------
  
  En decimal:

  0 1
  2 3

  En binario:

  00 01
  10 11

  Como puede verse, el orden de los bits es natural.
  
  0 -> 0
  1 -> 1
  
  3 niveles, 16 fases:
  -------------------

  En decimal:

   0  4  1  5
   8 12  9 13
   2  6  3  7
  10 14 11 15

  En binario:
  
  0000 0100 0001 0101
  1000 1100 1001 1101
  0010 0110 0011 0111
  1010 1110 1011 1111

  El cambio ha sido:

  0000 -> 0000
  0001 -> 0100
  0010 -> 0001
  0011 -> 0101
  0100 -> 1000
  0101 -> 1100
  0110 -> 1001
  0111 -> 1101
  1000 -> 0010
  1001 -> 0110
  1010 -> 0011
  1011 -> 0111
  1100 -> 1010
  1101 -> 1110
  1110 -> 1011
  1111 -> 1111
  
  Como puede verse, el orden de los bits es:

  0 -> 2
  1 -> 0
  2 -> 3
  3 -> 1
  
  4 niveles, 64 fases:
  -------------------

  En decimal:

   0,  16,   4,  20,   1,  17,   5,  21,
  32,  48,  36,  52,  33,  49,  37,  53,   
   8,  24,  12,  28,   9,  25,  13,  29,
  40,  56,  44,  60,  41,  57,  45,  61,
   2,  18,   6,  22,   3,  19,   7,  23,
  34,  50,  38,  54,  35,  51,  39,  55,   
  10,  26,  14,  30,  11,  27,  15,  31,  
  42,  58,  46,  62,  43,  59,  47,  63
  
  En este caso, el orden de los bits ha sido:

  0 -> 4
  1 -> 2
  2 -> 0
  3 -> 5
  4 -> 3
  5 -> 1

  5 niveles, 256 fases:
  
  0 -> 6
  1 -> 4
  2 -> 2
  3 -> 0
  4 -> 7
  5 -> 5
  6 -> 3
  7 -> 1

 */

int sort_phase(int phase, int levels) {
  int _phase = 0;
  int c = 2*(levels/*-1*/)-1;
  // Bits impares
  int b;
  for(b=1; b<2*(levels/*-1*/); b+=2) {
    _phase |= (bit(phase,c)<<b);
    c--;
  }
  // Bit pares
  for(b=0; b<2*(levels/*-1*/); b+=2) {
    _phase |= (bit(phase,c)<<b);
    c--;
  }
  return _phase;
} 

void rdwt2d::phase_order_compute(int levels) throw() {
  int l;
  for(l=1; l<levels; l++) {
    int p;
    for(p=0; p<(1<<(2*(l-0))); p++) {
      phase_order[l][p] = sort_phase(p,l);
    }
  }
}
/*rdwt2d::rdwt2d(int max_Y_X, int max_levels) throw(mallok::bad_alloc) : dwt2d(max_Y_X) {
  aux_malloc(max_levels);
  phase_order_malloc(max_levels);
  phase_order_compute(max_levels);
}*/

rdwt2d::rdwt2d() throw() {}

void rdwt2d::set_max_line_size(int max_line_size) throw(mallok::bad_alloc) {
  dwt2d::set_max_line_size(max_line_size);
}

void rdwt2d::set_max_number_of_levels(int max_number_of_levels) throw(mallok::bad_alloc) {
   aux_malloc(max_number_of_levels);
   phase_order_malloc(max_number_of_levels);
   phase_order_compute(max_number_of_levels);
}

rdwt2d::~rdwt2d() {
  //int l;

}

//////////////
//          //
// Análisis //
//          //
//////////////

int clip(int a, int b) {
  if(a<0) return 0;
  if(a<b) return a;
  return b-1;
}

/*
 * Cálculo de la DWT de un nivel, de una matriz a otra, teniendo en
 * cuenta la fase.
 *
 *     image             dwt
 * +-----------+    +-----+-----+
 * |           |    | LL  | LH  |
 * |           |    |     |     |
 * |           | -> +-----+-----+
 * |           |    | HL  | HH  |
 * |           |    |     |     |
 * +-----------+    +-----+-----+
 * 
 */
void rdwt2d::analyze_step(int **image,  /* [y][x] */
			  int **dwt,  /* [y][x] */
			  int y_phase, int x_phase,
			  int Y, int X,
			  class dprfb *f
			  ) throw () {
  int y,x;
  for(y=0; y<Y; y++) {
    for(x=0; x<X; x++) {
      dwt[y][x] = image[clip(y+y_phase,Y)][clip(x+x_phase,X)];
    }
  }
  dwt2d::analyze(dwt,Y,X,1,f);
}

/*
 * Cálculo de la RDWT de un nivel, de una matriz a 4 matrices, una
 * para cada fase.
 *
 *     image           rdwt[0]          rdwt[3]
 * +-----------+    +-----+-----+    +-----+-----+
 * |           |    | LL  | LH  |    | LL  | LH  |
 * |           |    |     |     |    |     |     |
 * |           | -> +-----+-----+    +-----+-----+
 * |           |    | HL  | HH  |    | HL  | HH  |
 * |           |    |     |     |    |     |     |
 * +-----------+    +-----+-----+....+-----+-----+
 *                      fase 0           fase 3
 *
 * El dominio redundante es 4 veces más grande que el crítico, puesto
 * que hay 4 fases. Si R-LL representa a la banda LL del dominio
 * redundante, se cumple que:
 *
 * R-LL  [y*2]  [x*2] = rdwt[0][y][x]
 * R-LL  [y*2][x*2+1] = rdwt[1][y][x]
 * R-LL[y*2+1]  [x*2] = rdwt[2][y][x]
 * R-LL[y*2+1][x*2+1] = rdwt[3][y][x]
 *
 * donde el índice más interno de rdwt denota la fase, el segundo la
 * coordenada Y en el dominio crítico y el tercero la coordenada X.
 */
void rdwt2d::rdwt_analyze_step(int **image,  /* [y][x] */
			      int ***rdwt,  /* [0,1,2,3][y][x] (Banda->Fase,y,x)*/
			      int Y, int X,
			      class dprfb *f) throw () {
  /* Fase (0,0) */
  analyze_step(image,rdwt[0],0,0,Y,X,f);
  /* Fase (0,1) */
  analyze_step(image,rdwt[1],0,1,Y,X,f);
  /* Fase (1,0) */
  analyze_step(image,rdwt[2],1,0,Y,X,f);
  /* Fase (1,1) */
  analyze_step(image,rdwt[3],1,1,Y,X,f);
} 

/*
 * Algoritmo RDWT-2D de N niveles:
 * 1. Realizar la RDWT-2D de 1 nivel.
 * 2. Aplicar 1 a cada LL obtenido en 1.
 *
 * Se cumple que:
 * Nivel 1 -> 4 fases de tamaño X*Y.
 * Nivel 2 -> 16 fases de tamaño (X/2)*(Y/2).
 * Nivel 3 -> 64 fases de tamaño (X/4)*(Y/4).
 * Nivel 4 -> 256 fases de tamaño (X/8)*(Y/8).
 * Nivel 5 -> 1024 fases de tamaño (X/16)*(Y/16).
 * :
 * Nivel N -> 4^(2*N) fases de tamaño (X/(2^N))*(Y/(2^N)).
 *
 * El árbol de dependencia entre las fases, para 3 niveles de
 * resolución, es el siguiente:
 *
 * rdwt[0][0] -> La imagen original
 *  |
 *  +--- rdwt[1][0] -> Fase (0,0) del nivel de resolución 1
 *  |     |
 *  |     +--- rdwt[2][0] -> Fase (0,0) del nivel de resolución 2
 *  |     |
 *  |     +--- rdwt[2][1] -> Fase (0,1) del nivel de resolución 2
 *  |     |
 *  |     +--- rdwt[2][2] -> Fase (0,2) del nivel de resolución 2
 *  |     |
 *  |     +--- rdwt[2][3] -> Fase (0,3) del nivel de resolución 2
 *  |
 *  +--- rdwt[1][1] -> Fase (0,1) del nivel de resolución 1
 *  |     |
 *  |     +--- rdwt[2][4] -> Fase (1,0) del nivel de resolución 2
 *  |     |
 *  |     +--- rdwt[2][5]
 *  |     |
 *  |     +--- rdwt[2][6]
 *  |     |
 *  |     +--- rdwt[2][7]
 *  |
 *  +--- rdwt[1][2] -> Fase (1,0) del nivel de resolución 1
 *  |     |
 *  |     +--- rdwt[2][8]
 *  |     |
 *  |     +--- rdwt[2][9]
 *  |     |
 *  |     +--- rdwt[2][10]
 *  |     |
 *  |     +--- rdwt[2][11]
 *  |
 *  +--- rdwt[1][3] -> Fase (1,1) del nivel de resolución 1
 *        |
 *        +--- rdwt[2][12]
 *        |
 *        +--- rdwt[2][13]
 *        |
 *        +--- rdwt[2][14]
 *        |
 *        +--- rdwt[2][15] -> Fase (3,3) del nivel de resolución 2
 */
void rdwt2d::unsort_analyze(int ****data, /* [nivel de resolución][fase][y][x] */
		    int Y, int X,
		    int levels,
		    class dprfb *f) throw () {
  int l;
  for(l=1;l<levels;l++) {
    /* 1, 2, ... */
    int phase;
    for(phase=0; phase<(1<<(2*(l-1))); phase++) { 
      /*
	 0, (lv=1)
	 0, 1, 2, 3, (lv=2)
	 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
	 ...
      */
      //int _phase = sort_phase(phase,lv);
      rdwt_analyze_step(data[l-1][phase],
			data[l]+phase*4,
			/*Y/(1<<(l-1))*/Y>>(l-1),
			/*X/(1<<(l-1))*/X>>(l-1),
			f);
    }
  }
}

void rdwt2d::analyze(int ****data, /* [nivel de resolución][fase][y][x] */
		     int Y, int X,
		     int levels,
		     class dprfb *f) throw() {
  int l;
  unsort_analyze(data,Y,X,levels,f);
  for(l=1; l<levels; l++) {
    int phase;
    for(phase=0; phase<(1<<(2*(l-0))); phase++) { 
      aux[phase] = data[l][phase_order[l][phase]];
    }
    for(phase=0; phase<(1<<(2*(l-0))); phase++) {
      data[l][phase] = aux[phase];
    }
  } 
}


//////////////
//          //
// Síntesis //
//          //
//////////////

/* No hay synthesize_step */

void rdwt2d::rdwt_synthesize_step(int ***rdwt,  /* [0,1,2,3][y][x] */
				 int **image,  /* [y][x] */
				 int Y, int X,
				 class dprfb *f) throw () {
  int x,y;
  dwt2d::synthesize(rdwt[0],Y,X,1,f);
  dwt2d::synthesize(rdwt[1],Y,X,1,f);
  dwt2d::synthesize(rdwt[2],Y,X,1,f);
  dwt2d::synthesize(rdwt[3],Y,X,1,f);
  for(y=0; y<Y; y++) {
    for(x=0; x<X; x++) {
      image[y][x] = (rdwt[0][y][x] +
		     rdwt[1][y][clip(x-1,X)] +
		     rdwt[2][clip(y-1,Y)][x] +
		     rdwt[3][clip(y-1,Y)][clip(x-1,X)])
	/4;
    }
  }
}

void rdwt2d::unsort_synthesize(int ****data, /* [nivel de resolución][fase][y][x] */
		       int Y, int X,
		       int levels,
		       class dprfb *f) throw () {
  int l;
  for(l=levels-1;l>=1;l--) {
    int phase;
    for(phase=0; phase<(1<<(2*(l-1))); phase++) {
      rdwt_synthesize_step(data[l]+phase*4,
			   data[l-1][phase],
			   /*Y/(1<<(l-1))*/Y>>(l-1),
			   /*X/(1<<(l-1))*/X>>(l-1),
			   f);
    }
  }
}

void rdwt2d::synthesize(int ****data, /* Nivel, fase, y, x */
			int Y, int X,
			int levels,
			class dprfb *f) throw () {
  int l;
  for(l=1; l<levels; l++) {
    int phase;
    for(phase=0; phase<(1<<(2*(l-0))); phase++) {
      aux[phase_order[l][phase]] = data[l][phase];
    }
    for(phase=0; phase<(1<<(2*(l-0))); phase++) {
      data[l][phase] = aux[phase];
    }
  }
  unsort_synthesize(data,Y,X,levels,f);
}
