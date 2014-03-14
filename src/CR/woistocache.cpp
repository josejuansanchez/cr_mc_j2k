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

static bool set_multiple_wois(char *fname, jp2_area *jarea, int w, int h, int r, int q)
{
  int x, y;
  woi ww;

  FILE *f = fopen(fname, "r");
  if(!f) return false;

  fscanf(f, "%d %d\n",&x, &y);
  ww = woi(x, y, w, h, r, q);
  (*jarea).set_woi(ww);
  //printf("WOI (%d, %d, %d, %d, %d, %d)\n",x,y,w,h,r,q);
  while(!feof(f))
  {
    fscanf(f, "%d %d\n",&x, &y);
    ww = woi(x, y, w, h, r, q);
    (*jarea).set_woi(ww);
    //printf("WOI (%d, %d, %d, %d, %d, %d)\n",x,y,w,h,r,q);
  }
  fclose(f);

  return true;
}

static bool write_bytes_readed(long numBytes)
{
  /* Creamos un archivo donde guardamos los bytes leídos */
  FILE *f = fopen("bytes.readed", "w");
  if(!f) return false;

  fprintf(f,"%ld",numBytes);
  fclose(f);
}


int main(int argc, char **argv)
{
	jp2_area jarea;
	int WprecinctSize, HprecinctSize, r, l, pSelectionMode;
	double bitRate;

	if(argc < 9) 
 	{
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Imagen J2C> <Lista de WOIs .txt> <W Precinct size> <H Precinct size> <r> <l> <BitRate (Bytes)> <Precincts Selection Mode>\n\n",argv[0]);
		fprintf(stderr, "Precincts Selection Mode = 0. Los precintos se seleccionan tal y como lo hace KAKADU.\n");
		fprintf(stderr, "Precincts Selection Mode = 1. Los precintos se seleccionan sólo cuando coinciden con la WOI.\n");
		return -1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nImagen J2C: '%s'\n", argv[1]);
	fprintf(stderr, "\nLista de WOIs: '%s'\n", argv[2]);
	
	WprecinctSize = atoi(argv[3]);
	HprecinctSize = atoi(argv[4]);
	r = atoi(argv[5]);
	l = atoi(argv[6]);
	bitRate= atof(argv[7]);
	pSelectionMode = atoi(argv[8]);

	/* Abrimos la imagen J2C */
	if(!jarea.open(argv[1])) 
	{
		fprintf(stderr, "\nError: No se ha podido abrir el archivo (%s)!!!\n\n",argv[1]);
		return -1;
	}

	/* Creamos la lista de índices y id de paquetes */
	jarea.create_index_and_id_list();

	/* Marcamos las WOIs */
	set_multiple_wois(argv[2], &jarea, WprecinctSize, HprecinctSize, r, l);

	/* Actualizamos la caché con los paquetes de las WOIs seleccionadas */
	switch(pSelectionMode) {
		/* Seleccionamos los precintos tal y como lo hace KAKADU */
		case 0: jarea.woi_to_lrcp_original(argv[2], WprecinctSize, HprecinctSize, r, l);
				break;

		/* Seleccionamos los precintos sólo cuando coinciden con la WOI */
		case 1: jarea.woi_to_lrcp_modified(argv[2], WprecinctSize, HprecinctSize, r, l);
				
				/* <---------------------------- */
				/* Vamos cogiendo el primer paquete de cada precinto. */
				//jarea.sort_lrcp_file_type_1(l,r);
				
				/* Vamos cogiendo todos los paquetes de una capa de calidad de cada precinto. */
				jarea.sort_lrcp_file_type_2(l,r);
				/* <---------------------------- */

				break;
	}

	JP2Cache cache;
	long numBytes = jarea.load_wois_cache_and_update_index_list_TEST(cache, bitRate, pSelectionMode);

	/* Guardamos los bytes leídos en un archivo */
	write_bytes_readed(numBytes);

	return 0;
}