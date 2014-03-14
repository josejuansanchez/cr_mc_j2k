/*
 * File: Entropy.h
 * Description: Compute the entropy of an histogram.
 * Last modification: 2003, September 29.
 * Programmer. gse.
 *
 * Information:
 * 
 * The entropy of a information source Z is:
 *
 *          N-1
 * H(Z) = - Sum P(i)*log_2(P(i))
 *          i=0
 *
 * where N is the size of the alphabet (number of different symbols)
 * and P(i) is the probability of find the symbol "i".
 * 
 * Usage:
 *
 * #include "entropy.h"
 *
 * #define ALPHABET_SIZE 256
 *
 * unsigned long *count = new unsigned long[ALPHABET_SIZE];
 * // You should be sure that count[i]=0 for each i
 * for(;;) {
 *   int x;
 *   x=file.get();
 *   if(x==EOF) break;
 *   count[x]++;
 * }
 * double entropy_value = entropy(count,ALPHABET_SIZE); 
 */

double entropy(unsigned long *count, int alphabet_size) throw();

