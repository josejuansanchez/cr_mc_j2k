template <typename TYPE>
class Haar {

 public:
  
  static char *get_filter_name() {
    return "2/1 (Haar) Biorthogonal Perfect Reconstruction Filter Bank";
  }

  int get_tap() {
    return 2;
  }

  void even_analyze(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i, k;
    for (i = k = 0; k < n; i++, k += 2) {
      h[i] = s[k+1] - s[k];
      l[i] = s[k] + h[i]/2;
    }
  }

  void odd_analyze(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i, k;
    for (i = k = 0; k < (n-1); i++, k += 2) {
      h[i] = s[k+1] - s[k];
      l[i] = s[k] + h[i]/2;
    }
    l[i] = s[k];
  }

  void even_synthesize(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i, k;
    for (i = k = 0; k < n; i++, k += 2) {
      s[k] = l[i] - h[i]/2;
      s[k+1] = s[k] + h[i];
    }
  }

  void odd_synthesize (TYPE s[], TYPE l[], TYPE h[], int n) {
    int i, k;
    for (i = k = 0; k < (n-1); i++, k += 2) {
      s[k] = l[i] - h[i]/2;
      s[k+1] = s[k] + h[i];
    }
    s[k] = l[i];
  }

};
