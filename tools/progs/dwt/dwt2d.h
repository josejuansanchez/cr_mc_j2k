/*
 * The 2D Discrete Wavelet Transform.
 * gse. 2006.
 */

class dwt2d: public mallok {

 private:

  struct context;
  context *data;

  //int *in_line;
  //int *out_line;

 public:

  dwt2d() throw(mallok::bad_alloc);
  ~dwt2d();

  void analyze
  (int ** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */,
   class dprfb */* Filtros */
   ) throw();

  void analyze
  (int ** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */
   ) throw();

  void synthesize
  (int ** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */,
   class dprfb */* Filtros */
   ) throw();

  void synthesize
  (int ** /* La matriz de datos */,
   int /* Dimensión Y */,
   int /* Dimensión X */,
   int /* Número de niveles */
   ) throw();

   void set_filter(class dprfb *) throw();
   void set_max_line_size(int) throw(mallok::bad_alloc);

};

