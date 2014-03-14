#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/times.h>
#include <list>
#include <string>
#include <iostream>
#include <sstream>
#include "../Util/Args.h"
#include "jp2_area.h"


using namespace std;


class kdu_my_message : public kdu_message 
{
public: 
	void start_message() { }
	void flush(bool end_of_message) { }
	void put_text(const char *str) { cerr << str << endl; }
 };

static kdu_my_message err_collector;
static kdu_my_message warn_collector;
static kdu_message_formatter warn_formatter(&warn_collector, 50);
static kdu_message_formatter err_formatter(&err_collector, 50);


static bool write_image(char *fname, kdu_byte *buffer, int num_components, int height, int width)
{
  FILE *out = fopen(fname, "wb");

  if(!out) return false;

  if(num_components == 1) fprintf(out, "P5\n%d %d\n255\n", width, height);
  else if(num_components == 3) fprintf(out, "P6\n%d %d\n255\n", width, height);
  else {
    fclose(out);
    return false;
  }

  if(!fwrite((char *)buffer, 1, num_components * width * height, out)) {
    fclose(out);
    return false;
  }

  fclose(out);
  return true;
}


int main(int argc, char **argv)
{
	jp2_area jarea;
	int x, y, w, h, r, l;
	long totalBytes;

	if(argc < 9) {
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <imagen J2C> <x> <y> <w> <h> <r> <l> <imagen OUT>\n\n",argv[0]);
		return -1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nImagen: '%s'\n", argv[1]);
	
	x = atoi(argv[2]);
	y = atoi(argv[3]);
	w = atoi(argv[4]);
	h = atoi(argv[5]);
	r = atoi(argv[6]);
	l = atoi(argv[7]);
	
	fprintf(stderr, "WOI: (%d, %d, %d, %d, %d)\n\n", x, y, w, h, r);
	
	if(!jarea.open(argv[1])) {
		fprintf(stderr, "\nError: No se ha podido abrir el archivo!!!\n\n"); 
		return -1;
	}
	
	woi ww = woi(x, y, w, h, r);
	jarea.set_woi(ww);
	
	totalBytes = jarea.sum_qlayer_bytes_packets(l);

	printf("\nTotal Bytes: %ld", totalBytes);
	printf("\nTotal KBytes: %lf", (double)totalBytes/1024);
	printf("\nTotal MBytes: %lf\n", (double)totalBytes/(1024*1024));
	
	//kdu_byte *org = jarea.create_buffer();
	//jarea.decode_complete(org,l);
	//write_image(argv[8], org, 1, ww.h, ww.w);

	return 0;
}

