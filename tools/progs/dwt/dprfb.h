/*
 * Decimated Perfect Reconstruction Filter Bank.
 * gse. 2007.
 */

class dprfb {

 private:
 
 public:

  /* Filtro de análisis para un número de muestras pares. */
  virtual void even_analyze   (int items_in_signal,
			       int signal[],
			       int low[],
			       int high[]) = 0;

  /* Filtro de análisis para un número de muestras impares. */
  virtual void odd_analyze    (int items_in_signal,
			       int signal[],
			       int low[],
			       int high[]) = 0;

  /* Filtro de síntesis para un número de muestras pares. */
  virtual void even_synthesize(int items_in_signal,
			       int signal[],
			       int low[],
			       int high[]) = 0;

  /* Filtro de síntesis para un número de muestras impares. */
  virtual void odd_synthesize (int items_in_signal,
			       int signal[],
			       int low[],
			       int high[]) = 0;

  /* Devuelve el nombre del filtro usado. */
  virtual char *get_filter_name() = 0;

};
