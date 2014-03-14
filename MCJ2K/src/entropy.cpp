#include <math.h>
#include "entropy.h"

float entropy(int *count, int alphabet_size) {
  float entropy = 0.0;
  int total_count = 0;
  for(int i=0; i<alphabet_size; i++) {
    total_count += count[i];
  }

  for(int i=0; i<alphabet_size; i++) {
    if(count[i]) {
      float prob = (float)count[i]/total_count;
      entropy += prob*(float)(log(prob)/log(2.0));
    }
  }
  return -entropy;
}
