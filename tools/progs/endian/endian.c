#include <stdio.h>

/*
 * big-endian -> Primero el byte más significativo.
 * little-endian -> Primero el byte menos significativo.
 */

int main(int argc, char *argv[]) {
  int x = 1;
  (*(char*)&x) ? printf("little-endian\n") : printf("big-endian\n");
  return 0;
}
