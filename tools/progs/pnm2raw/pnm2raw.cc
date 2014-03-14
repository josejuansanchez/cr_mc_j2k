#include <iostream>

#include <cstdio>
#include <cstdlib>
//#include <fstream>

using namespace std;

#include "pnm_in.h"
#include "args.h"

int main(int argc, char *argv[]) {
  args args(argc, argv);
  if(args.exist_arg((char *)"-help")) {
    cerr << "Converts a pgm or ppm file into raw\n";
    cerr << " [-verbose]\n";
    cerr << " < input_file > output_file\n";
  } else {
    FILE *input = stdin;
    FILE *output = stdout;
    pnm_in image;
    image.read_header(input);
    if(args.exist_arg((char *)"-verbose")) {
      cerr << argv[0] << ": number of components = " << image.n_comp << '\n';
      cerr << argv[0] << ": number of rows = " << image.dim_y << '\n';
      cerr << argv[0] << ": number of columns = " << image.dim_x << '\n';
    }
    int size = image.dim_x*image.n_comp;
    char *h=(char *)malloc(size);
    for(int y=0; y<image.dim_y; y++) {
      fread(h,1,size,input);
      fwrite(h,1,size,output);
    }
    free(h);
  }
}
