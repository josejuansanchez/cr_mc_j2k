/*
 * The 2D Redundant Discrete Wavelet Transform.
 * gse. 2006.
 */

class rdwt2d: public dwt2d {

 public:

  int ***aux;
  void aux_malloc(int /* max_number_of_levels*/) throw(mallok::bad_alloc);

  /* Orden de recorrido de las fases que expresa una ordenación espacial
     primero por columnas y luego por filas. */
  int **phase_order;
  void phase_order_malloc(int /* max_number_of_levels*/) throw(mallok::bad_alloc);
  void phase_order_compute(int /* max_number_of_levels*/) throw();
  void analyze_step(int **image,  /* [y][x] */
		    int **dwt,  /* [y][x] */
		    int y_phase, int x_phase,
		    int Y, int X,
		    class dprfb *f) throw ();

  void rdwt_analyze_step(int **image,  /* [y][x] */
			 int ***rdwt,  /* [0,1,2,3][y][x] (Banda->Fase,y,x)*/
			 int Y, int X,
			 class dprfb *f) throw ();

  void unsort_analyze(int ****data, /* [nivel de resolución][fase][y][x] */
		      int Y, int X,
		      int levels,
		      class dprfb *f) throw ();

  void rdwt_synthesize_step(int ***rdwt,  /* [0,1,2,3][y][x] */
			    int **image,  /* [y][x] */
			    int Y, int X,
			    class dprfb *f) throw ();

  void unsort_synthesize(int ****data, /* [nivel de resolución][fase][y][x] */
			 int Y, int X,
			 int levels,
			 class dprfb *f) throw ();

 public:

  //rdwt2d(int /* max_line_size */, int /* max_number_of_levels*/) throw(mallok::bad_alloc);
  rdwt2d() throw(/*mallok::bad_alloc*/);
  ~rdwt2d();

  void analyze
  (int **** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */,
   class dprfb * /* Los filtros */
   ) throw();

  void synthesize
  (int **** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */,
   class dprfb * /* Los filtros */
   ) throw();

   void set_max_line_size(int) throw(mallok::bad_alloc);
   void set_max_number_of_levels(int) throw(mallok::bad_alloc);
};

