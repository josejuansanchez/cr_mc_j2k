class _13_7: public dprfb {

 public:
  
  char *get_filter_name() {
    return "13/7 (Cubic) Birthogonal Perfect Reconstruction Filter Bank";
  }

  void even_analyze(int /* dim */, int /* s */[], int /* l */[], int /* h */[]) throw();
  void odd_analyze(int /* dim */, int /* s */[], int /* l */[], int /* h */[]) throw();
  void even_synthesize(int /* dim */, int /* s */[], int /* l */[], int /* h */[]) throw();
  void odd_synthesize(int /* dim */, int /* s */[], int /* l */[], int /* h */[]) throw();

};
