template <typename TYPE>
class _5_3 {

 public:
  
  static char *get_filter_name() {
    return "5/3 (Lineal) Biorthogonal Perfect Reconstruction Filter Bank";
  }

  int get_tap() {
    return 5;
  }

  void even_analyze(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i;
    for(i=0;i<n/2-1;i++) {
      int i2 = i<<1;
      h[i] = s[i2+1] - (s[i2]+s[i2+2])/2;
    }
    h[i] = s[n-1] - s[n-2];
    
    l[0] = s[0] + h[0]/2;
    for(i=1;i<n/2;i++) {
      int i2 = i<<1;
      l[i] = s[i2] + (h[i]+h[i-1])/4;
    }
  }

  void odd_analyze(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i;
    for(i=0;i<n/2;i++) {
      int i2 = i<<1;
      h[i] = s[i2+1] - (s[i2]+s[i2+2])/2;
    }
    
    l[0] = s[0] + h[0]/2;
    for(i=1;i<n/2;i++) {
      int i2 = i<<1;
      l[i] = s[i2] + (h[i]+h[i-1])/4;
    }
    l[i] = s[n-1] + h[i-1]/2;
  }

  void even_synthesize(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i;
    s[0] = l[0] - h[0]/2;
    for(i=1;i<n/2;i++) {
      int i2 = i<<1;
      s[i2] = l[i] - (h[i]+h[i-1])/4;
    }
    
    for(i=0;i<n/2-1;i++) {
      int i2 = i<<1;
      s[i2+1] = h[i] + (s[i2]+s[i2+2])/2;
    }
    s[n-1] = h[i] + s[n-2];
  }

  void odd_synthesize(TYPE s[], TYPE l[], TYPE h[], int n) {
    int i;
    s[0] = l[0] - h[0]/2;
    for(i=1;i<n/2;i++) {
      int i2 = i<<1;
      s[i2] = l[i] - (h[i]+h[i-1])/4;
    }

    s[n-1] = l[i] - h[i-1]/2;
    for(i=0;i<n/2;i++) {
      int i2 = i<<1;
      s[i2+1] = h[i] + (s[i2]+s[i2+2])/2;
    } 
  }

};
