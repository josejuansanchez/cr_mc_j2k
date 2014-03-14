#include <stdio.h>
#include <cmath>
#include <cstdlib>
#include <iostream>
#include <iomanip>
#include "entropy.h"

using namespace std;

int main() {
  unsigned long *count = (unsigned long *)calloc(256, sizeof(unsigned long));
  for(;;) {
    int x = getc(stdin);
    if(x==EOF) break;
    count[x]++;
  }
  for(int i=0; i<256; i++) {
    cerr << setw(3) << i << ' ';
    cerr << count[i] << '\n';
  }
  cerr << "Entropy = ";
  cout << entropy(count,256) << '\n';
  cerr << " bits of information/symbol\n";
}
