/*
 * File: pnm_in.h
 * Description: Reading of the PNM (Portable Network Map) header.
 * Last modificacion: 2003, August 1.
 * Programmer: gse.
 *
 * Usage example:
 *
 * #include <iostream>
 * #include <fstream>
 * using namespace std;
 * #include "pnm_in.h"
 * 
 * ifstream file;
 * file.open("test.ppm");
 * if(!file) {
 *   cerr << "No puedo abrir \"test.ppm\" para lectura\n";
 * }
 * pnm_in pnm_file;
 * try {
 *   pnm_file.read_header(file);
 * } catch (istream::failure e) {
 *   cerr << e.what() << '\n';
 * }
 * file.close();

 */
struct pnm_in {
  int dim_x;                     /* Width of the image */
  int dim_y;                     /* Height of the image */
  int n_comp;                    /* Number of components (tipically 1 or 3) */
  int maxval;                    /* Maximun pixel value (255 or 65535) */
  /* Read the PNM header */
  void read_header(std::FILE *in) throw();
};
