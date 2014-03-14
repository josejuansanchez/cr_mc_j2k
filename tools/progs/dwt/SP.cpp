#include "dprfb.h"
#include "SP.h"

void SP::even_analyze(int n, int s[], int l[], int h[]) throw() {
  int i, k, mm = n/2 - 1;
  int d1, d2;

  for (i = k = 0; k < n; i++, k += 2) {
    l[i] = (s[k] + s[k+1]) >> 1;
    h[i] =  s[k] - s[k+1];
  }
  if(n>2) {
    h[0] -= (d2 = l[0] - l[1]) >> 2;
    for (i = 1; i < mm; i++) {
      d1 = d2;  d2 = l[i] - l[i+1];
      h[i] -= (((d1 + d2 - h[i+1]) << 1) + d2 + 3) >> 3;
    }
    h[i] -= d2 >> 2;
  }
}

void SP::odd_analyze(int n, int s[], int l[], int h[]) throw() {
  int i, k, mm = n/2 - 1;
  int d1, d2;

  for (i = k = 0; k < (n-1); i++, k += 2) {
    l[i] = (s[k] + s[k+1]) >> 1;
    h[i] =  s[k] - s[k+1];
  }
  l[i] = s[n-1];
  if(n>2) {
    h[0] -= (d2 = l[0] - l[1]) >> 2;
    for (i = 1; i < mm; i++) {
      d1 = d2;  d2 = l[i] - l[i+1];
      h[i] -= (((d1 + d2 - h[i+1]) << 1) + d2 + 3) >> 3;
    }
    h[i] -= d2 >> 2;
  }
}

void SP::even_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  int d1, d2, m=n/2;
  if(n>2) {
    h[m-1] += (d1 = l[m-2] - l[m-1]) >> 2;
    for (i = m - 2; i > 0; i--) {
      d2 = d1;  d1 = l[i-1] - l[i];
      h[i] += (((d1 + d2 - h[i+1]) << 1) + d2 + 3) >> 3;
    }
    h[0] += d1 >> 2;
  }
  for (i = k = 0; k < n; i++, k += 2) {
    s[k] = l[i] + ((h[i] + 1) >> 1);
    s[k+1] = s[k] - h[i];
  }
}

void SP::odd_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  int d1, d2, m=n/2;
  if(n>2) {
    h[m-1] += (d1 = l[m-2] - l[m-1]) >> 2;
    for (i = m - 2; i > 0; i--) {
      d2 = d1;  d1 = l[i-1] - l[i];
      h[i] += (((d1 + d2 - h[i+1]) << 1) + d2 + 3) >> 3;
    }
    h[0] += d1 >> 2;
  }
  for (i = k = 0; k < (n-1); i++, k += 2) {
    s[k] = l[i] + ((h[i] + 1) >> 1);
    s[k+1] = s[k] - h[i];
  }
  s[k] = l[i];
}
