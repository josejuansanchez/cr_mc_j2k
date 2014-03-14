#include "dprfb.h"
#include "Haar.h"

void Haar::even_analyze(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  for (i = k = 0; k < n; i++, k += 2) {
    h[i] = s[k+1] - s[k];
    l[i] = s[k] + h[i]/2;
  }
}

void Haar::odd_analyze(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  for (i = k = 0; k < (n-1); i++, k += 2) {
    h[i] = s[k+1] - s[k];
    l[i] = s[k] + h[i]/2;
  }
  l[i] = s[k];
}

void Haar::even_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  for (i = k = 0; k < n; i++, k += 2) {
    s[k] = l[i] - h[i]/2;
    s[k+1] = s[k] + h[i];
  }
}

void Haar::odd_synthesize(int n, int s[], int l[], int h[]) throw() {
  int i, k;
  for (i = k = 0; k < (n-1); i++, k += 2) {
    s[k] = l[i] - h[i]/2;
    s[k+1] = s[k] + h[i];
  }
  s[k] = l[i];
}
