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

int main(int argc, char **argv)
{
	jp2_area jarea;

	if(argc < 6) 
	{
		fprintf(stderr, "\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Imagen J2C> <Ancho Img.> <Alto Img.> <r> <l>\n\n",argv[0]);
		return 1;
	}
	
	kdu_customize_warnings(&warn_collector);
	kdu_customize_errors(&err_collector);
	
	fprintf(stderr, "\nImagen: '%s'\n", argv[1]);

	/* Abrimos la imagen */
	if(!jarea.open(argv[1])) 
	{
		fprintf(stderr, "\nError: No se ha podido abrir el archivo (%s)!!!\n\n",argv[1]);
		return 1;
	}

	/* Marcamos todos los paquetes de la imagen */
    	woi ww = woi(0, 0, atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
    	jarea.set_woi(ww);

	/* Creamos la lista de índices de paquetes */
	jarea.create_index_and_id_list();

	/* Guardamos los paquetes marcados en un archivo de caché */
	jarea.save_packets_to_file();

	return 0;
}

