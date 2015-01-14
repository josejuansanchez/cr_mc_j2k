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



int main(int argc, char **argv)
{
	jp2_area jarea;
	JP2Cache cache;
	int r;

	if(argc < 6) 
	{
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Caché> <Imagen OUT> <Ancho Img. Reconst> <Alto Img. Reconst> <Imagen con header info> [Nivel de Resolución]\n\n",argv[0]);
		fprintf(stderr, "[Nivel de Resolución = 0]. Descomprime la imagen con el mayor nivel de resolución posible.\n");		
		return -1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nCaché: '%s'\n", argv[1]);

// TODO: SOLUCIONAR SIN USAR ESTA LÍNEA
//---------------------------------------
	/* Abrimos la imagen J2C */
	if(!jarea.open(argv[5])) 
	{
		fprintf(stderr, "\nError: No se ha podido abrir el archivo (%s)!!!\n\n",argv[1]);
		return -1;
	}
//---------------------------------------

	/* Leemos la caché de un archivo */
	if(!jarea.load_cache_from_file_without_id_list(cache, argv[1]))
	{
		printf("\nError: No se ha podido leer el archivo de caché (%s)!!!\n\n",argv[1]);
		return -1;
	}

	/* Comprobamos si el nivel de resolución está entre los parámetros de entrada. 		   */
	/* Si no está presente lo establecemos a 0 por defecto (el máximo nivel de resolución) */
	if (argc > 6) {
		r = atoi(argv[6]);
	} else {
		r = 0;
	}

	printf("Nivel de resolución: %d\n", r);
	printf("Nota: 0 es el máximo nivel de resolución de la imagen\n");

	/* Características de la imagen que queremos reconstruir */
	jarea.woi_reconstructed.x = 0;
	jarea.woi_reconstructed.y = 0;	
	jarea.woi_reconstructed.w = atoi(argv[3]);
	jarea.woi_reconstructed.h = atoi(argv[4]);
	jarea.woi_reconstructed.r = r;

	/* Descomprimimos los precintos seleccionados y generamos una imagen de salida */
	kdu_byte *org = jarea.create_buffer();
	jarea.decode_from_cache(org, cache);
	write_image(argv[2], org, 1, jarea.woi_reconstructed.h, jarea.woi_reconstructed.w);

	return 0;
}