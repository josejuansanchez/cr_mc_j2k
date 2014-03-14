#include "dprfb.h"
#include "unitary.h"

void unitary::even_analyze(int n, int s[], int l[], int h[]) throw() {
  int i;
  for(i=0; i<n/2; i++) {
    l[i] = s[i<<1]+1;
  }
  for(i=0; i<n/2; i++) {
    h[i] = s[i<<1];
  }
}

void unitary::odd_analyze(int n, int s[], int l[], int h[]) throw() {
  int i;
  for(i=0; i<n/2; i++) {
    l[i] = s[i<<1]+1;
  }
  for(i=0; i<n/2; i++) {
    h[i] = s[i<<1];
  }
}

void unitary::even_synthesize(int n, int s[], int l[], int h[]) throw() {
}

void unitary::odd_synthesize(int n, int s[], int l[], int h[]) throw() {
}
