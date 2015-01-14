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
#include "../../Util/Args.h"
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

static bool set_multiple_wois_and_load_cache(char *fname, jp2_area *jarea, int w, int h, int r, int q, JP2Cache& cache, double max_bytes)
{
  int x, y;
  woi ww;
  FILE *f = fopen(fname, "r");

  if(!f) return false;

  int woi_number = 0;

  fscanf(f, "%d %d\n",&x, &y);
  ww = woi(x, y, w, h, r, q);
  double sum_bytes = (*jarea).set_woi_and_load_cache(ww,cache,0,max_bytes,woi_number);
  //printf("WOI (%d, %d, %d, %d, %d, %d)\n",x,y,w,h,r,q);

  while((!feof(f)) && (sum_bytes<max_bytes))
  {
    woi_number++;

    fscanf(f, "%d %d\n",&x, &y);
    ww = woi(x, y, w, h, r, q);
    sum_bytes = (*jarea).set_woi_and_load_cache(ww,cache,sum_bytes,max_bytes,woi_number);
    //printf("WOI (%d, %d, %d, %d, %d, %d)\n",x,y,w,h,r,q);
  }
  fclose(f);

  return true;
}

int main(int argc, char **argv)
{
	jp2_area jareaA, jareaB;
	int precinctSize, r, l;
	double bitRate;

	if(argc < 11) {
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Caché (A)> <imagen J2C (B)> <lista precintos UP> <precinct size> <r> <l> <imagen OUT> <Ancho Img. Reconst> <Alto Img. Reconst> <BitRate (Bytes)>\n",argv[0]);
		fprintf(stderr, "\n<l>: Empieza en 0\n\n");
		return -1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nCaché A: '%s'\n", argv[1]);
	fprintf(stderr, "\nImagen B: '%s'\n", argv[2]);
	fprintf(stderr, "\nLista de precintos UP: '%s'\n", argv[3]);
	
	precinctSize = atoi(argv[4]);
	r = atoi(argv[5]);
	l = atoi(argv[6]);
	bitRate= atof(argv[10]);

	/* Abrimos la imagen B */
	if(!jareaB.open(argv[2])) 
	{
		fprintf(stderr, "\nError: No se ha podido abrir el archivo (%s)!!!\n\n",argv[2]);
		return -1;
	}

	/* Creamos la lista de índices y id de paquetes */
	jareaB.create_index_and_id_list();

	/* Marcamos las WOIs 'B' */
	set_multiple_wois(argv[3], &jareaB, precinctSize, precinctSize, r, l);

	/* Actualizamos la caché con los paquetes de las WOIs seleccionadas de B */
	JP2Cache cache;
	jareaB.load_wois_cache_and_update_index_list(cache, bitRate, false);

	/* Leemos la caché de A de un archivo */
	//
	/* NOTA: Los IDs de precintos que se hayan leído en el paso anterior (load_wois_cache_and_update_index_list) se descartan */
	/* y no se incluyen en la nueva caché */
	//
	if(!jareaB.load_cache_from_file(cache, argv[1]))		
	{
		printf("\nError: No se ha podido leer el archivo de caché (%s)!!!\n\n",argv[1]);
		return -1;
	}

	/* Características de la imagen que queremos reconstruir */
	jareaB.woi_reconstructed.x = 0;
	jareaB.woi_reconstructed.y = 0;	
	jareaB.woi_reconstructed.w = atoi(argv[8]);
	jareaB.woi_reconstructed.h = atoi(argv[9]);
	jareaB.woi_reconstructed.r = 0;

	/* Descomprimimos los precintos seleccionados y generamos una imagen de salida */
	kdu_byte *org = jareaB.create_buffer();
	jareaB.decode_from_cache(org, cache);
	write_image(argv[7], org, 1, jareaB.woi_reconstructed.h, jareaB.woi_reconstructed.w);

	return 0;
}

