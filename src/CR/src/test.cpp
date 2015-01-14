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

	if(argc < 3) 
 	{
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Imagen J2C> <Imagen Out>\n\n",argv[0]);
		return -1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nImagen J2C: '%s'\n", argv[1]);
	
	/* Abrimos la imagen J2C */
	if(!jarea.open(argv[1])) 
	{
		fprintf(stderr, "\nError: No se ha podido abrir el archivo (%s)!!!\n\n",argv[1]);
		return -1;
	}

	/* Marcamos todos los paquetes de la imagen */
    	woi ww = woi(0, 0, 1024, 1024, 1, 8);
    	jarea.set_woi(ww);

	/* Creamos la lista de índices de paquetes */
	jarea.create_index_and_id_list();

	/* Guardamos los paquetes marcados en un archivo de caché */
	jarea.save_packets_to_file();

	JP2Cache cache;

  	char *filename_cache = new char[255];
  	strcpy(filename_cache, argv[1]);
  	strcat(filename_cache,".packets.cache");

	/* Leemos la caché de un archivo */
	if(!jarea.load_cache_from_file_without_id_list(cache, filename_cache))
	{
		printf("\nError: No se ha podido leer el archivo de caché (%s)!!!\n\n",argv[1]);
		return -1;
	}


	/* Características de la imagen que queremos reconstruir */
	jarea.woi_reconstructed.x = 0;
	jarea.woi_reconstructed.y = 0;	
	jarea.woi_reconstructed.w = 1024;
	jarea.woi_reconstructed.h = 1024;
	jarea.woi_reconstructed.r = 0;

	/* Descomprimimos los precintos seleccionados y generamos una imagen de salida */
	kdu_byte *org = jarea.create_buffer();
	jarea.decode_from_cache(org, cache);
	write_image(argv[2], org, 1, jarea.woi_reconstructed.h, jarea.woi_reconstructed.w);

	return 0;
}

