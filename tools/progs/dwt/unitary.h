class unitary: public dprfb {

 public:
  
  char *get_filter_name() {
    return "Weights (in log_2) of the wavelet coefficients to generate an unitary transform";
  }

  void even_analyze   (int items_in_signal, int signal[], int low[], int high[]) throw();
  void odd_analyze    (int items_in_signal, int signal[], int low[], int high[]) throw();
  void even_synthesize(int items_in_signal, int signal[], int low[], int high[]) throw();
  void odd_synthesize (int items_in_signal, int signal[], int low[], int high[]) throw();

};
