class mallok {

 public:

  struct bad_alloc {
  };

  void *alloc_1d(int x, int size) throw(bad_alloc);
  void **alloc_2d(int y, int x, int size) throw(bad_alloc);
  void ***alloc_3d(int z, int y, int x, int size) throw(bad_alloc);

  void free_1d(void *h) throw();
  void free_2d(void **h) throw();
  void free_3d(void ***h) throw();
};
