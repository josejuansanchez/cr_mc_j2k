#include "dprfb.h"
#include "5_3.h"

void _5_3::even_analyze(int n, int s[], int l[], int h[]) throw() {
  int i;
  for(i=0;i<n/2-1;i++) {
    int i2 = i<<1;
    h[i] = s[i2+1] - ((s[i2]+s[i2+2])>>1);
  }
  h[i] = s[n-1] - s[n-2];

  l[0] = s[0] + ((h[0]+1)>>1);
  for(i=1;i<n/2;i++) {
    int i2 = i<<1;
    l[i] = s[i2] + ((h[i]+h[i-1]+2)>>2);
  }
}

void _5_3::odd_analyze(int n, int s[], int l[], int h[]) throw() {
  int i;
  for(i=0;i<n/2;i++) {
    int i2 = i<<1;
    h[i] = s[i2+1] - ((s[i2]+s[i2+2])>>1);
  }

  l[0] = s[0] + ((h[0]+1)>>1);
  for(i=1;i<n/2;i++) {
    int i2 = i<<1;
    l[i] = s[i2] + ((h[i]+h[i-1]+2)>>2);
  }
  l[i] = s[n-1] + ((h[i-1]+1)>>1);

}

void _5_3::even_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i;
  s[0] = l[0] - ((h[0]+1)>>1);
  for(i=1;i<n/2;i++) {
    int i2 = i<<1;
    s[i2] = l[i] - ((h[i]+h[i-1]+2)>>2);
  }

  for(i=0;i<n/2-1;i++) {
    int i2 = i<<1;
    s[i2+1] = h[i] + ((s[i2]+s[i2+2])>>1);
  }
  s[n-1] = h[i] + s[n-2];
}

void _5_3::odd_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i;
  s[0] = l[0] - ((h[0]+1)>>1);
  for(i=1;i<n/2;i++) {
    int i2 = i<<1;
    s[i2] = l[i] - ((h[i]+h[i-1]+2)>>2);
  }
  s[n-1] = l[i] - ((h[i-1]+1)>>1);

  for(i=0;i<n/2;i++) {
    int i2 = i<<1;
    s[i2+1] = h[i] + ((s[i2]+s[i2+2])>>1);
  }

}
