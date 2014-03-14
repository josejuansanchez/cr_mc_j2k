#include <iostream>
//#include <fstream>
#include <string.h>
#include <cstdio>
using namespace std;
#include "pnm_in.h"

static void eat_white_and_comments(FILE *in) {
  int ch;
  bool in_comment;
  
  in_comment = false;
  while (/*!(in.get(ch)).fail()*/(ch = getc(in))!=EOF) {
    if (ch == '#')
      in_comment = true;
    else if (ch == '\n')
      in_comment = false;
    else if ((!in_comment) && (ch != ' ') && (ch != '\t') && (ch != '\r')) {
      //in.putback(ch);
      ungetc(ch,in);
      return;
    }
  }
}

void pnm_in::read_header(/*istream &in*/FILE *in) throw (/*istream::failure*/) {
  //try {
    char magic[3];
    //in.get(magic,3);
    fgets(magic, 3, in);
    if (strcmp(magic,"P5") == 0)
      n_comp = 1;
    else if (strcmp(magic,"P6") == 0)
      n_comp = 3;
    else
      n_comp = 0;
    
    if(n_comp != 0) {
      eat_white_and_comments(in); fscanf(in,"%d",&dim_x); //in >> dim_x;
      eat_white_and_comments(in); fscanf(in,"%d",&dim_y); //in >> dim_y;
      eat_white_and_comments(in); fscanf(in,"%d",&maxval);//in >> maxval;
    }
    
    int ch;
    while (/*!(in.get(ch)).fail()*/(ch = getc(in))!=EOF) {
      if (ch == '\n')
	break;
    }
    //throw istream::failure("");
    //} catch (istream::failure) {
    //throw istream::failure("pnm_in::read_header: input error");
    //}
}
