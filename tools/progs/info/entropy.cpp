#include <cmath>
#include <cstdlib>
#include <iostream>
#include <iomanip>
#include "entropy.h"

using namespace std;

double entropy(unsigned long *count, int alphabet_size) throw() {
  double entropy = 0.0;
  unsigned long total_count = 0;
  for(int i=0; i<alphabet_size; i++) {
    total_count += count[i];
  }

  for(int i=0; i<alphabet_size; i++) {
    if(count[i]) {
      double prob = (double)count[i]/total_count;
      entropy += prob*log(prob)/log(2.0);
    }
  }
  return -entropy;
}
