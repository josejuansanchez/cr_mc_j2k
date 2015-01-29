#include <string.h>
#include <iostream>
#include <math.h>
#include "jp2_area.h"


using namespace std;


int jp2_area::get_short(FILE *f, kdu_byte *buf)
{
  int a = fgetc(f);
  int b = fgetc(f);

  if (buf)
  {
    buf[0] = a;
    buf[1] = b;
  }

  return (a << 8) | b;
}

/*
void jp2_area::get_packet_data(FILE *f, packet_data& p)
{
  int c;

  p.length = 2;
  p.offset = ftell(f) - 2;

  for (;;)
  {
    if (fgetc(f) != 0xFF) p.length++;
    else
    {
      c = fgetc(f);
      if (c == 0x91 || c == 0xD9) break;
      else
      {
        p.length++;
        ungetc(c, f);
      }
    }
  }
}
*/

void jp2_area::get_packet_data(FILE *f, packet_data& p)
{
  int c1, c2, c3, c4;

  /* Cuando entra en esta función el cursor del archivo está 2 bytes desplazado */
  /* FF 91 AA BB ... (Estaría apuntando a "AA") */
  p.offset = ftell(f) - 2;

  c1 = fgetc(f);
  long numByte = 1; 
  while(!feof(f))
  {
    if (c1==0xFF)
    {
      c2 = fgetc(f);
      numByte++;      
      if (c2==0x91)
      {
        c3 = fgetc(f);
        c4 = fgetc(f);        
        if ((c3==0x00) && (c4==0x04)) 
        {
          ungetc(c3, f);
          ungetc(c4, f);

          p.length = numByte;
          //printf("End Of Packet\n");
          //printf("p.offset: %d\n", p.offset);
          //printf("p.length: %d\n\n", p.length);
          break;
        }

        numByte = numByte + 2;
      }
      else
      {
        // 0xFFD9: End of code-stream
        if(c2 == 0xD9) 
        {
          c3 = fgetc(f);
          if (feof(f)) {
            p.length = numByte;
            //printf("End of code-stream\n");
            //printf("p.offset: %d\n", p.offset);
            //printf("p.length: %d\n\n", p.length);
            break;

          } else {
            ungetc(c3, f);
          }          
        }
      }
    }
    c1 = fgetc(f);
    numByte++;
  }
}

bool jp2_area::open(char *fname)
{
	bool rhead;
	kdu_byte *plt;
	kdu_dims tdims;
	kdu_byte data[2];
	int m, mlen;
	int pinipos, tsize;
	int cont;
	
	FILE *f = fopen(fname, "rb");
	if(!f) return false;
	
	cur_name = strdup(fname);

	get_short(f, data);
	cache.addToMainHeader(data, 2);

	rhead = true;

	fprintf(stderr, "\n[%s]\nMarcadores encontrados:\n",fname);
	while((m = get_short(f, data)) != 0xFF93) {
		if(m == 0xFF58) {
			mlen = get_short(f) - 2;
			plt = new kdu_byte[mlen];
			fread(plt, mlen, 1, f);
		
		} else if(m == 0xFF90) {
			mlen = get_short(f) - 2;
			fseek(f, mlen, SEEK_CUR);
			cache.completeMainHeader();
			rhead = false;
		
		} else {
			if(rhead) cache.addToMainHeader(data, 2);
			else cache.addToTileHeader(data, 2);

			mlen = get_short(f, data) - 2;
			kdu_byte *mcon = new kdu_byte[mlen];
			fread(mcon, mlen, 1, f);

			fprintf(stderr, "\t%X\n", m);

			if(rhead) {
				cache.addToMainHeader(data, 2);
				cache.addToMainHeader(mcon, mlen);

			} else {
				cache.addToTileHeader(data, 2);
				cache.addToTileHeader(mcon, mlen);
			}

			delete [] mcon;
		}
	}
	
	fprintf(stderr, "\n");

	pinipos = ftell(f);

	cache.completeTileHeader();
	cache.setInitialScope();

	tsize = 0;	
	
	codestream.create(&cache);
	codestream.set_persistent();
	codestream.apply_input_restrictions(0, 0, 0, 0, NULL);

	codestream.get_valid_tiles(tdims);
	res = codestream.get_min_dwt_levels() + 1;
	kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

	fgetc(f); fgetc(f);

	num_l = tile.get_num_layers();
	num_r = new int[num_l];
	num_c = new int *[num_l];
	num_px = new int **[num_l];
	num_py = new int **[num_l];
	packets = new packet_data****[tile.get_num_layers()];

	for(int l = 0; l < tile.get_num_layers(); l++) {
		num_r[l] = res;
		num_c[l] = new int[res];
		num_px[l] = new int *[res];
		num_py[l] = new int *[res];
		packets[l] = new packet_data***[res];

		for(int r = 0; r < res; r++) {
			num_c[l][r] = tile.get_num_components();
			num_px[l][r] = new int[tile.get_num_components()];
			num_py[l][r] = new int[tile.get_num_components()];
			packets[l][r] = new packet_data**[tile.get_num_components()];

			for(int c = 0; c < tile.get_num_components(); c++) {
				kdu_tile_comp comp = tile.access_component(c);
				kdu_resolution res = comp.access_resolution(r);

				kdu_dims pdims;
				res.get_valid_precincts(pdims);

				//printf("\n** L: %d \t R: %d \t C: %d\n",l,r,c);
				//printf("\n** pdims.size.x: %d\n",pdims.size.x);
				//printf("\n** pdims.size.y: %d\n\n",pdims.size.y);
		
				num_px[l][r][c] = pdims.size.x;
				num_py[l][r][c] = pdims.size.y;
				packets[l][r][c] = new packet_data *[pdims.size.y];
				
				for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) 
					packets[l][r][c][py] = new packet_data[pdims.size.x]; 
			}
		}
	}
	
	//int prog;
	codestream.access_siz()->access_cluster(COD_params)->get(Corder, 0, 0, prog);
	
	if(prog == 1) {
		cerr << "Progresion: RLCP" << endl;
		
		num_packets = 0;
		for(int r = 0; r < res; r++) {
			for(int l = 0; l < tile.get_num_layers(); l++) {
				for(int c = 0; c < tile.get_num_components(); c++) {
					kdu_tile_comp comp = tile.access_component(c);
					kdu_resolution res = comp.access_resolution(r);

					kdu_dims pdims;
					res.get_valid_precincts(pdims);
				
					for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
						for(int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
							kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
							get_packet_data(f, packets[l][r][c][py][px]);
							tsize += packets[l][r][c][py][px].length;
							packets[l][r][c][py][px].id = pid;
							num_packets++;
						}
					}
				}
			}
		}
		
	} else if(prog == 0) {
		cerr << "Progresion: LRCP" << endl << endl;

		num_packets = 0;
		for(int l = 0; l < tile.get_num_layers(); l++) {
			for(int r = 0; r < res; r++) {
				for(int c = 0; c < tile.get_num_components(); c++) {
					kdu_tile_comp comp = tile.access_component(c);
					kdu_resolution res = comp.access_resolution(r);

					kdu_dims pdims;
					res.get_valid_precincts(pdims);

					//printf("\nl: %d \t r: %d \t c: %d \t pdims.size.y: %d \t pdims.size.x: %d\n",l,r,c,pdims.size.y,pdims.size.x);
				
					for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) 
					{
						for(int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
						{
							kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
							get_packet_data(f, packets[l][r][c][py][px]);
							tsize += packets[l][r][c][py][px].length;
							packets[l][r][c][py][px].id = pid;
							num_packets++;
						}
					}
				}
			}
		}
			
	} else if(prog == 2) {
		cerr << "Progresion: RPCL" << endl << endl;

		num_packets = 0;		
		for(int r = 0; r < res; r++) {
			kdu_tile_comp comp = tile.access_component(0);
			kdu_resolution res = comp.access_resolution(r);

			kdu_dims pdims;
			res.get_valid_precincts(pdims);
			
			for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
				for(int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
					for(int c = 0; c < tile.get_num_components(); c++) {
						comp = tile.access_component(c);
						res = comp.access_resolution(r);
									
						for(int l = 0; l < tile.get_num_layers(); l++) {
							kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
							get_packet_data(f, packets[l][r][c][py][px]);
							tsize += packets[l][r][c][py][px].length;
							packets[l][r][c][py][px].id = pid;
							num_packets++;
						}
					}
				}
			}
		}		
	}

	printf("\n[%s][open] # Paquetes Totales: %d",fname,num_packets);	

	tile.close();
	fclose(f);

	return true;
}

void jp2_area::close()
{
  if(!cur_name) return;

  delete [] cur_name;
  cur_name = NULL;

  for (int l = 0; l < num_l; l++)
  {
     for (int r = 0; r < num_r[l]; r++)
     {
       for (int c = 0; c < num_c[l][r]; c++)
       {
         for (int py = 0; py < num_py[l][r][c]; py++)
           delete [] packets[l][r][c][py];

         delete [] packets[l][r][c];
       }

       delete [] num_px[l][r];
       delete [] num_py[l][r];
       delete [] packets[l][r];
     }

     delete [] num_px[l];
     delete [] num_py[l];
     delete [] num_c[l];
     delete [] packets[l];
   }

  delete [] num_px;
  delete [] num_py;
  delete [] num_c;
  delete [] num_r;
  delete [] packets;

}


void jp2_area::clear_woi()
{
  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < num_r[l]; r++)
    {
      for (int c = 0; c < num_c[l][r]; c++)
      {
        for (int py = 0; py < num_py[l][r][c]; py++)
        {
          for (int px = 0; px < num_px[l][r][c]; px++)
	        {
            packets[l][r][c][py][px].woi = false;
	        }
        }
      }
    }
  }
}

//
// *** ORIGINAL ***
//
int jp2_area::load_woi_to_cache(JP2Cache& cache, double max_bytes, bool check_cached)
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;
	
  double num = 0;
  //kdu_byte data[500]; 
  kdu_byte data[524288];

  printf("\nID\t L\t R\t C\t PY\t PX\t OFFSET:LENGTH\t CACHE.getPrecinctLength\n");

  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < num_r[l]; r++)
    {
      for (int c = 0; c < num_c[l][r]; c++)
      {
        for (int py = 0; py < num_py[l][r][c]; py++)
        {
          for (int px = 0; px < num_px[l][r][c]; px++)
          {
            packet_data& packet = packets[l][r][c][py][px];

            if(packet.woi)  
	           {
          		/*
        		  printf("%d\t %d\t %d\t %d\t %d\t %d\t %10d:%d\t %d\t %d\n", 
        			packet.id,
        			l, r, c, py, px,
        			packet.offset,
        			packet.length,
        			cache.getPrecinctLength(packet.id),
        			packet.cached
        			);
          		*/						

              	int off = packet.offset;
              	int plen = packet.length;

              	if(check_cached) 
		            {
                	plen -= packet.cached;
                	off += packet.cached;

                	if(plen > (max_bytes - num))
                  		plen = (max_bytes - num);

                	if(plen < 0) plen = 0;
              	}

              	if(plen > 0) 
		            {
	                int rb = 0;
                	fseek(f, off, SEEK_SET);

                	for(int len = plen; len > 0; len -= rb) 
			            {
                  		rb = sizeof(data);
                  		if(len < rb) rb = len;

                  		if(fread(data, 1, rb, f) != rb) 
				              {
                    			fclose(f);
                    			return -1;
                  		}

                  		//cout << "Anado a " << packet.id << " " << rb << " bytes (" << packet.cached << "/" << packet.length << ")" << endl;
                  		cache.addToPrecinct(data, rb, packet.id);
                	}

                	if(check_cached)
                  		packet.cached += plen;

                	num += plen;
              	}

              	if(num >= max_bytes)
                	goto end_load_woi;
            }
          }
        }
      }
    }
  }

end_load_woi:
  fclose(f);
  return num;
}


int jp2_area::load_woi(double max_bytes)
{
  return load_woi_to_cache(cache, max_bytes, true);
}

//
// *** REVISAR ***
//
void jp2_area::set_woi(woi new_woi)
{
  //clear_woi();
	
  new_woi.r = res - 1 - new_woi.r;

  cur_woi = new_woi;

  kdu_dims roi, realroi;

  roi.pos = kdu_coords(cur_woi.x, cur_woi.y);
  roi.size = kdu_coords(cur_woi.w, cur_woi.h);

  /*
  printf("\n[%s][cur_woi.x: %d \t cur_woi.y: %d]\n", cur_name, cur_woi.x, cur_woi.y);
  printf("\n[%s][cur_woi.w: %d \t cur_woi.h: %d]\n", cur_name, cur_woi.w, cur_woi.h);
  printf("\n[%s][roi.pos.x: %d \t roi.pos.y: %d]\n", cur_name, roi.pos.x, roi.pos.y);
  printf("\n[%s][roi.size.x: %d \t roi.size.y: %d]\n", cur_name, roi.size.x, roi.size.y);
  */

  // Revisar el valor de "cur_woi.r"

  //codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, NULL);
  //codestream.map_region(0, roi, realroi);
  //codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, &realroi);

  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

  /*
  printf("\n[%s][realroi.pos.x: %d \t realroi.pos.y: %d]\n", cur_name, realroi.pos.x, realroi.pos.y);
  printf("\n[%s][realroi.size.x: %d \t realroi.size.y: %d]\n", cur_name, realroi.size.x, realroi.size.y);
  */

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

  long cont = 0;

  for (int l = 0; l < new_woi.q; l++)
  //for (int l = 0; l < tile.get_num_layers(); l++)
  {
    for (int r = 0; r < numr; r++)
    {
      for (int c = 0; c < tile.get_num_components(); c++)
      {
        kdu_tile_comp comp = tile.access_component(c);
        kdu_resolution res = comp.access_resolution(r);

        kdu_dims pdims;
        res.get_valid_precincts(pdims);

        //printf("\n[%s] l: %d \t r: %d \t c: %d \t pdims.size.y: %d \t pdims.size.x: %d",cur_name,l,r,c,pdims.size.y,pdims.size.x);		// REVISAR <------

        for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
        {
          for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
	        {
            packets[l][r][c][py][px].woi = true;
	          cont++;					

	         /*printf("%d\t %d\t %d\t %d\t %d\t %d\t %d:%d\n", 
                    packets[l][r][c][py][px].id,
		                l, r, c, py, px,
		                packets[l][r][c][py][px].offset,
		                packets[l][r][c][py][px].length);*/
	    
	         //kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
	         //printf("%d %d %d %d: %d %d %d %d %d: %ld\n", new_woi.x, new_woi.y, new_woi.w, new_woi.h, l, r, c, py, px, (long)pid);
          }
        }
      }
    }
  }  
  //printf("\n\n[%s][set_woi] # Paquetes marcados: %ld\n", cur_name, cont);
  tile.close();
}
//
// *** FIN REVISAR ***
//

kdu_byte *jp2_area::create_buffer()
{
  //return new kdu_byte[cur_woi.w * cur_woi.h * num_c[0][0]];
  //printf("\nNum Bytes: %d",woi_reconstructed.w * woi_reconstructed.h * num_c[0][0]);
  return new kdu_byte[woi_reconstructed.w * woi_reconstructed.h * num_c[0][0]];
}


bool jp2_area::decode_from_codestream(kdu_codestream& codestream, kdu_byte *buf)
{
  int stripe_heights[3];
  kdu_dims roi, realroi;
  kdu_stripe_decompressor decompressor;

  roi.pos = kdu_coords(woi_reconstructed.x, woi_reconstructed.y);
  roi.size = kdu_coords(woi_reconstructed.w, woi_reconstructed.h);

  codestream.apply_input_restrictions(0, 0, woi_reconstructed.r, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, woi_reconstructed.r, 0, &realroi);

  stripe_heights[0] = roi.size.y;
  stripe_heights[1] = roi.size.y;
  stripe_heights[2] = roi.size.y;

  decompressor.start(codestream);
  decompressor.pull_stripe(buf, stripe_heights);
  decompressor.finish();

  return true;
}


bool jp2_area::decode(kdu_byte *buf)
{
  return decode_from_codestream(codestream, buf);
}


bool jp2_area::decode_complete(kdu_byte *buf)
{
  int len;
  kdu_byte *data;
  JP2Cache cache_aux;

  len = cache.getMainHeaderLength();
  data = new kdu_byte[len];
  cache.setInitialScope();
  cache.read(data, len);
  cache_aux.addToMainHeader(data, len);
  cache_aux.completeMainHeader();
  delete [] data;

  len = cache.getTileHeaderLength();
  data = new kdu_byte[len];
  cache.set_tileheader_scope(0, 1);
  cache.read(data, len);
  cache_aux.addToTileHeader(data, len);
  cache_aux.completeTileHeader();
  delete [] data;

  load_woi_to_cache(cache_aux, INT_MAX, false);

  cache_aux.setInitialScope();
  
  kdu_codestream code_aux;
  code_aux.create(&cache_aux);
  code_aux.set_persistent();
  
  return decode_from_codestream(code_aux, buf);
}


int jp2_area::load_wois_cache_and_update_index_list(JP2Cache& cache, double max_bytes, bool check_cached)
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;

  double num = 0;
  //kdu_byte data[500];
  kdu_byte data[524288];  

  /* Creamos un archivo donde guardamos la cache */
  char *filename_cache = new char[255];
  strcpy(filename_cache, cur_name);
  strcat(filename_cache,".cache");
  FILE *fc = fopen(filename_cache,"wb");
  if (!fc) return -1;

  long cont_add = 0;

  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < num_r[l]; r++)
    {
      for (int c = 0; c < num_c[l][r]; c++)
      {
        for (int py = 0; py < num_py[l][r][c]; py++)
        {
          for (int px = 0; px < num_px[l][r][c]; px++)
          {
            packet_data& packet = packets[l][r][c][py][px];

            if(packet.woi)
	          {						
              	int off = packet.offset;
              	int plen = packet.length;

              	if(check_cached) 
		            {
                	plen -= packet.cached;
                	off += packet.cached;

                	if(plen > (max_bytes - num))
                  		plen = (max_bytes - num);

                	if(plen < 0) plen = 0;
              	}

              	if(plen > 0) 
		            {
	                int rb = 0;
                	fseek(f, off, SEEK_SET);

                	for(int len = plen; len > 0; len -= rb) 
			            {
                  		rb = sizeof(data);
                  		if(len < rb) rb = len;

                  		if(fread(data, 1, rb, f) != rb) 
				              {
                    			fclose(f);
                    			return -1;
                  		}
				              //printf("\n %d %d %d %d %d",l,r,c,py,px);
                  		//cout << "[" << packet.id << "]** Anado a " << packet.id << " " << rb << " bytes (" << packet.cached << "/" << packet.length << ")" << endl;
                  		cache.addToPrecinct(data, rb, packet.id);
			
				              /* Guardamos el id , la longitud y los datos del paquete en un archivo con toda la cache */
				              fwrite(&packet.id, sizeof(packet.id), 1, fc);
				              fwrite(&l, sizeof(l), 1, fc);
				              fwrite(&r, sizeof(r), 1, fc);
				              fwrite(&c, sizeof(c), 1, fc);
				              fwrite(&py, sizeof(py), 1, fc);
				              fwrite(&px, sizeof(px), 1, fc);
				              fwrite(&rb, sizeof(rb), 1, fc);
				              fwrite(&data, 1, rb, fc);

				              cont_add++;

				              /* Actualizamos la lista de ids */
				              id_list[packet.id] = true;
                	}

                	if(check_cached)
                  		packet.cached += plen;

                	num += plen;
       		      }  

		            /* Guardamos los índices del paquete que acabamos de meter en la caché */
		            index_list[ne] = index_packet(l,r,c,py,px);
		            ne++;			

              	if(num >= max_bytes)
		            {
       	        	goto end_load_woi;
		            }

	           }
          }
        }
      }
    }
  }

end_load_woi:
  fclose(f);
  fclose(fc);

  printf("\n[%s][load_wois_cache_and_update_index_list] # Paquetes en caché: %d \t # Bytes: %.0lf",cur_name,ne,num);
  printf("\n[%s][load_wois_cache_and_update_index_list] # cache.adds: %ld \n",cur_name,cont_add);

  return num;
}

//
// Recorremos los paquetes de la imagen de background y solo incluimos en la cache aquellos paquetes que no
// se hayan obtenido de la siguiente imagen.
//
// Sólo se utiliza en el paso 0
//
int jp2_area::load_wois_cache(JP2Cache& cache, double max_bytes, bool check_cached, index_packet index_list[], int ne)
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;

  double num = 0;
  //kdu_byte data[500];
  kdu_byte data[524288];

  /* Creamos un archivo donde guardamos la cache */
  char *filename_cache = new char[255];
  strcpy(filename_cache, cur_name);
  strcat(filename_cache,".cache");
  FILE *fc = fopen(filename_cache,"wb");
  if (!fc) return -1;

  long cont = 0;
  long cont_encontrados = 0;
  long cont_add = 0;

  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < num_r[l]; r++)
    {
      for (int c = 0; c < num_c[l][r]; c++)
      {
        for (int py = 0; py < num_py[l][r][c]; py++)
        {
          for (int px = 0; px < num_px[l][r][c]; px++)
          {
            packet_data& packet = packets[l][r][c][py][px];

            if(packet.woi)
	          {					
              	int off = packet.offset;
              	int plen = packet.length;

              	if(check_cached) 
		            {
                	plen -= packet.cached;
                	off += packet.cached;

                	if(plen > (max_bytes - num))
                  		plen = (max_bytes - num);

                	if(plen < 0) plen = 0;
              	}

		            // NOTA: Con este método sólo se eliminan los paquetes de una determinada capa de calidad
		            // REVISAR Y MEJORAR
		            //----
		            bool encontrado = false;
		            for(int i=0; i<ne; i++)
		            {
			             if ((index_list[i].l==l) && (index_list[i].r==r) && (index_list[i].c==c) && (index_list[i].py==py) && (index_list[i].px==px))
			             {
				              encontrado = true;
				              cont_encontrados++;
				              break;
			             }
		            }
		            //----

		            /* Solamente metemos en la cache aquellos paquetes que no estén incluidos en la la lista de índices de paquetes */
		            if(!encontrado)
		            {
			            /* Incrementamos el número de paquetes marcados */
			            cont++;
		
	              	if(plen > 0) 
			            {
		                int rb = 0;
	                	fseek(f, off, SEEK_SET);

	                	for(int len = plen; len > 0; len -= rb) 
				            {
	                  		rb = sizeof(data);
	                  		if(len < rb) rb = len;

	                  		if(fread(data, 1, rb, f) != rb) 
					              {
	                    			fclose(f);
	                    			return -1;
	                  		}
	                  		//cout << "["<< packet.id <<"]Anado a " << packet.id <<" "<< rb <<" bytes ("<< packet.length << ") " << l << " " << r << " " << c << " " << py << " " << px << endl;
	                  		cache.addToPrecinct(data, rb, packet.id);

					              /* Guardamos el id , la longitud y los datos del paquete en un archivo con toda la cache */
					              fwrite(&packet.id, sizeof(packet.id), 1, fc);
					              fwrite(&l, sizeof(l), 1, fc);
					              fwrite(&r, sizeof(r), 1, fc);
					              fwrite(&c, sizeof(c), 1, fc);
					              fwrite(&py, sizeof(py), 1, fc);
					              fwrite(&px, sizeof(px), 1, fc);
					              fwrite(&rb, sizeof(rb), 1, fc);
					              fwrite(&data, 1, rb, fc);

					              cont_add++;
	                	}

	                	if(check_cached)
	                  		packet.cached += plen;
	
	                	num += plen;
              		}

	              	if(num >= max_bytes)
			            {
        	        	goto end_load_woi;
			            }
		            }
	           }
          }
        }
      }
    }
  }

end_load_woi:
  fclose(f);
  fclose(fc);

  printf("\n[%s][load_wois_cache] # Nuevos paquetes añadidos a la caché: %ld \t # Bytes: %.0lf",cur_name,cont,num);
  printf("\n[%s][load_wois_cache] # Paquetes que ya estaban en la caché: %ld",cur_name,cont_encontrados);
  printf("\n[%s][load_wois_cache] # cache.adds: %ld \n",cur_name,cont_add);

  return num;
}

bool jp2_area::decode(kdu_byte *buf, JP2Cache& cache_aux, index_packet index_list[], int ne)
{
  int len;
  kdu_byte *data;
  //JP2Cache cache_aux;

  len = cache.getMainHeaderLength();
  data = new kdu_byte[len];
  cache.setInitialScope();
  cache.read(data, len);
  cache_aux.addToMainHeader(data, len);
  cache_aux.completeMainHeader();
  delete [] data;

  len = cache.getTileHeaderLength();
  data = new kdu_byte[len];
  cache.set_tileheader_scope(0, 1);
  cache.read(data, len);
  cache_aux.addToTileHeader(data, len);
  cache_aux.completeTileHeader();
  delete [] data;

  load_wois_cache(cache_aux, INT_MAX, false, index_list, ne);

  cache_aux.setInitialScope();
  
  kdu_codestream code_aux;
  code_aux.create(&cache_aux);
  code_aux.set_persistent();
  
  return decode_from_codestream(code_aux, buf);
}

void jp2_area::create_index_and_id_list()
{
	/* Reservamos memoria para la lista de índices de paquetes */
	index_list = new index_packet[num_packets];

	/* Inicializamos el número de elementos de la lista */
	ne = 0;

	/* Reservamos memoria para la lista de ids de paquetes. */
	/* Comprobamos el tipo de progresión para dividir correctamente */
	switch(prog)
	{
		// LRCP
		case 0: ne_id_list = num_packets/num_l; break;
		// RLCP
		case 1: ne_id_list = num_packets/res; break;
		// RPCL
		case 2: ne_id_list = num_packets/res; break;
	}

	id_list = new bool[ne_id_list];

	/* Inicializamos el vector a falso */
	for(int i=0;i<ne_id_list;i++)
	{
		id_list[i] = false;
	}
}

//
// Leemos la cache de un archivo y vamos incluyendo en la caché aquellos paquetes que no estén incluidos.
// Generamos un archivo de salida con todos los nuevos paquetes que se han incluido a la caché.
//
bool jp2_area::load_cache_from_file(JP2Cache& cache, char *filename_cache)
{
  int id, rb;
  //kdu_byte data[500];
  kdu_byte data[524288];
  int l, r, c, py, px;

  FILE *fc = fopen(filename_cache,"rb");
  if (!fc) return false;

  fread(&id, sizeof(id), 1, fc);
  fread(&l, sizeof(l), 1, fc);
  fread(&r, sizeof(r), 1, fc);
  fread(&c, sizeof(c), 1, fc);
  fread(&py, sizeof(py), 1, fc);
  fread(&px, sizeof(px), 1, fc);
  fread(&rb, sizeof(rb), 1, fc);
  fread(&data, 1, rb, fc);

  int cont=0;
  int cont_add = 0;

  FILE *ftemp = fopen("temp.cache","wb");					// <-- MEJORAR
  if (!ftemp) return false;

  while(!feof(fc))
  {
	cont++;

	//printf("\n[%10d] %10d %10d",cont,id,rb);

	/* NOTA: Sólo añadimos el paquete a la cache en caso de ser necesario */
	if (id_list[id]==false)
	{
		cache.addToPrecinct(data, rb, id);
		cont_add++;

		/* Guardamos los datos en un archivo temporal de cache */	// <-- MEJORAR
  	fwrite(&id, sizeof(id), 1, ftemp);
		fwrite(&l, sizeof(l), 1, ftemp);
		fwrite(&r, sizeof(r), 1, ftemp);
		fwrite(&c, sizeof(c), 1, ftemp);
		fwrite(&py, sizeof(py), 1, ftemp);
		fwrite(&px, sizeof(px), 1, ftemp);
		fwrite(&rb, sizeof(rb), 1, ftemp);
  	fwrite(&data, 1, rb, ftemp);

		//printf("\n[load_cache_from_file: cache.add] %10d %10d",id,rb);
	}
	else
	{
		//printf("\n[load_cache_from_file: Descartado] %10d %10d",id,rb);
	}
  	fread(&id, sizeof(id), 1, fc);
  	fread(&l, sizeof(l), 1, fc);
  	fread(&r, sizeof(r), 1, fc);
 	  fread(&c, sizeof(c), 1, fc);
  	fread(&py, sizeof(py), 1, fc);
  	fread(&px, sizeof(px), 1, fc);
  	fread(&rb, sizeof(rb), 1, fc);
  	fread(&data, 1, rb, fc);
  }
  fclose(fc);
  fclose(ftemp);

  printf("\n[load_cache_from_file] # Paquetes leídos de cache: \t%10d",cont);
  printf("\n[load_cache_from_file] # Paquetes añadidos a la cache: \t%10d",cont_add);
  printf("\n[load_cache_from_file] # Paquetes descartados:  \t%10d\n",cont-cont_add);

  return true;
}

bool jp2_area::load_cache_from_file_without_id_list(JP2Cache& cache, char *filename_cache)
{
  int id, rb;
  //kdu_byte data[500];
  kdu_byte data[524288];
  int l, r, c, py, px;

  FILE *fc = fopen(filename_cache,"rb");
  if (!fc) return false;

  fread(&id, sizeof(id), 1, fc);
  fread(&l, sizeof(l), 1, fc);
  fread(&r, sizeof(r), 1, fc);
  fread(&c, sizeof(c), 1, fc);
  fread(&py, sizeof(py), 1, fc);
  fread(&px, sizeof(px), 1, fc);
  fread(&rb, sizeof(rb), 1, fc);
  fread(&data, 1, rb, fc);

  int cont_add = 0;

  //printf("\nid from GetPacketId: %d", GetPacketId(data));
  printf("\nid from GetPacketId: %d -\t l: %d \t r: %d \t c: %d \t py: %d \t px: %d \t rb: %d", GetPacketId(data),l,r,c,py,px,rb);

  while(!feof(fc))
  {
	  //printf("\n[%10d] %10d %10d",cont_add,id,rb);

	  cache.addToPrecinct(data, rb, id);
	  cont_add++;

  	fread(&id, sizeof(id), 1, fc);
  	fread(&l, sizeof(l), 1, fc);
  	fread(&r, sizeof(r), 1, fc);
 	  fread(&c, sizeof(c), 1, fc);
  	fread(&py, sizeof(py), 1, fc);
  	fread(&px, sizeof(px), 1, fc);
  	fread(&rb, sizeof(rb), 1, fc);
  	fread(&data, 1, rb, fc);

    //printf("\nid from GetPacketId: %d", GetPacketId(data));   
    printf("\nid from GetPacketId: %d -\t l: %d \t r: %d \t c: %d \t py: %d \t px: %d \t rb: %d", GetPacketId(data),l,r,c,py,px,rb);
  }
  fclose(fc);

  printf("\n[load_cache_from_file_without_id_list] # Paquetes leídos/añadidos de cache: \t%10d\n",cont_add);

  return true;
}

int jp2_area::GetPacketId(kdu_byte data[]) {
   /* Get the packet id from de data */
   /* FF      91      00      04      XX      XX  ... */
   /* data[0] data[1] data[2] data[3] data[4] data[5] */
   int packetId;
   char *p = (char *)&packetId;

   p[3] = 0;
   p[2] = 0;
   p[1] = data[4];
   p[0] = data[5];

   return packetId;
}

bool jp2_area::decode_from_cache(kdu_byte *buf, JP2Cache& cache_aux)
{
  int len;
  kdu_byte *data;

  len = cache.getMainHeaderLength();
  data = new kdu_byte[len];
  cache.setInitialScope();
  cache.read(data, len);
  cache_aux.addToMainHeader(data, len);
  cache_aux.completeMainHeader();
  delete [] data;

  len = cache.getTileHeaderLength();
  data = new kdu_byte[len];
  cache.set_tileheader_scope(0, 1);
  cache.read(data, len);
  cache_aux.addToTileHeader(data, len);
  cache_aux.completeTileHeader();
  delete [] data;

  cache_aux.setInitialScope();
  
  kdu_codestream code_aux;
  code_aux.create(&cache_aux);
  code_aux.set_persistent();

  // Info: /home/josejuan/Aplicaciones/Kakadu/SourceCode/v6_4_1-00305L/documentation/index.html
  //code_aux.set_resilient(true);
  //***************************
  
  return decode_from_codestream(code_aux, buf);
}


// Guardamos en una cache todos los paquetes que están incluidos en la WOI de entrada, hasta alcanzar el número máximo de bytes
//
double jp2_area::set_woi_and_load_cache(woi new_woi, JP2Cache& cache, double sum_bytes, double max_bytes, int woi_number)
{
  /* Set WOI Variables */
  new_woi.r = 0;
  cur_woi = new_woi;
  kdu_dims roi, realroi;

  roi.pos = kdu_coords(cur_woi.x, cur_woi.y);
  roi.size = kdu_coords(cur_woi.w, cur_woi.h);

  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

  /* Load Cache Variables */
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;

  //kdu_byte data[500];
  kdu_byte data[524288];

  /* Creamos un archivo donde guardamos la cache */
  char *filename_cache = new char[255];
  strcpy(filename_cache, cur_name);
  strcat(filename_cache,".cache");
  FILE *fc = fopen(filename_cache,"wb");
  if (!fc) return -1;

  long cont = 0;
  long cont_encontrados = 0;
  long cont_add = 0;

  double num = sum_bytes;
  
  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < numr; r++)
    {
      for (int c = 0; c < tile.get_num_components(); c++)
      {
        kdu_tile_comp comp = tile.access_component(c);
        kdu_resolution res = comp.access_resolution(r);

        kdu_dims pdims;
        res.get_valid_precincts(pdims);

	     //printf("\n[%s] l: %d \t r: %d \t c: %d \t pdims.size.y: %d \t pdims.size.x: %d",cur_name,l,r,c,pdims.size.y,pdims.size.x);		// REVISAR <------

        for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
        {
          for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
	        {
            packets[l][r][c][py][px].woi = true;
            packets[l][r][c][py][px].woi_number = woi_number;

            packet_data& packet = packets[l][r][c][py][px];

            int off = packet.offset;
            int plen = packet.length;

	          printf("\nID: %5d Offset: %5d Length: %5d\n",packet.id,packet.offset,packet.length);

 	          /* Incrementamos el número de paquetes marcados */
	         cont++;
		
	         if(plen > 0) 
	         {
		         int rb = 0;
	           fseek(f, off, SEEK_SET);

	           for(int len = plen; len > 0; len -= rb) 
		         {
			         rb = sizeof(data);
	             if(len < rb) rb = len;

	             if(fread(data, 1, rb, f) != rb) 
			         {
	               fclose(f);
				         return -1;
	             }
			         printf("\n %d %d %d %d %d",l,r,c,py,px);
			         cout << "[" << packet.id << "]** Anado a " << packet.id << " " << rb << " bytes (" << packet.length << ")" << endl;
			         cache.addToPrecinct(data, rb, packet.id);

			         /* Guardamos el id , la longitud y los datos del paquete en un archivo con toda la cache */
			         fwrite(&packet.id, sizeof(packet.id), 1, fc);
			         fwrite(&l, sizeof(l), 1, fc);
			         fwrite(&r, sizeof(r), 1, fc);
			         fwrite(&c, sizeof(c), 1, fc);
			         fwrite(&py, sizeof(py), 1, fc);
			         fwrite(&px, sizeof(px), 1, fc);
			         fwrite(&rb, sizeof(rb), 1, fc);
			         fwrite(&data, 1, rb, fc);

			         cont_add++;

			         /* Actualizamos la lista de ids */
			         id_list[packet.id] = true;
		          }
           	 num += plen;
	          }

	          printf("\n\t** ne: %d \t numpackets: %d",ne,num_packets);

	          /* Guardamos los índices del paquete que acabamos de meter en la caché */
	          index_list[ne] = index_packet(l,r,c,py,px);
	          ne++;

	          if(num >= max_bytes)
	          {
        	     goto end_load_woi;
	          }
	         }
        }
      }
    }
  }

end_load_woi:

  tile.close();

  fclose(f);
  fclose(fc);

  printf("\n[%s][set_woi_and_load_cache] # Nuevos paquetes añadidos a la caché: %ld \t # Bytes: %.0lf",cur_name,cont,num);
  printf("\n[%s][set_woi_and_load_cache] # Paquetes que ya estaban en la caché: %ld",cur_name,cont_encontrados);
  printf("\n[%s][set_woi_and_load_cache] # cache.adds: %ld",cur_name,cont_add);
  printf("\n[%s][set_woi_and_load_cache] # woi_number: %ld \n",cur_name,woi_number);

  return num;
}


long jp2_area::get_precint_id(int l, int r, int c, int py, int px)
{
	kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
	kdu_tile_comp comp = tile.access_component(c);
	kdu_resolution res = comp.access_resolution(r);
	kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
	tile.close();
	return (long) pid;
}

void jp2_area::id_to_lrcp(long id, int &l, int &r, int &c, int &py, int &px)
{
	for (l = 0; l < num_l; l++)
  	{
    		for (r = 0; r < num_r[l]; r++)
    		{
      			for (c = 0; c < num_c[l][r]; c++)
      			{
        			for (py = 0; py < num_py[l][r][c]; py++)
        			{
          				for (px = 0; px < num_px[l][r][c]; px++)
          				{
            					packet_data& packet = packets[l][r][c][py][px];
						
						          if (packet.id == id)
					        	    goto end_id_to_lrcp;
	  				      }
				      }
      			}
    		}
  	}

end_id_to_lrcp:
	printf("[%s][id_to_lrcp] id: %d : %d %d %d %d %d \n",cur_name,id,l,r,c,py,px);
}

// Devuelve las coordenadas de todos los precintos que están dentro de la woi
bool jp2_area::woi_to_lrcp_original(char filename_woi[], int w, int h, int r, int q)
{
  int x, y;
  FILE *f = fopen(filename_woi,"r");
  if(!f) return false;

  char *filename_out = new char[255];
  strcpy(filename_out, cur_name);
  strcat(filename_out,".lrcp");
  FILE *fc = fopen(filename_out,"w");
  if(!fc) return false;

  while(!feof(f))
  {
    fscanf(f, "%d %d\n",&x, &y);
    woi ww = woi(x, y, w, h, r, q);

    kdu_dims roi, realroi;

    roi.pos = kdu_coords(ww.x, ww.y);
    roi.size = kdu_coords(ww.w, ww.h);

    codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
    codestream.map_region(0, roi, realroi);
    codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

    int numr = codestream.get_min_dwt_levels() + 1;
    kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

    for (int l = 0; l < q; l++)
    //for (int l = 0; l < tile.get_num_layers(); l++)
    {
      for (int resolution = 0; resolution < r; resolution++)
      //for (int r = 0; r < numr; r++)        
      {
        for (int c = 0; c < tile.get_num_components(); c++)
        {
          kdu_tile_comp comp = tile.access_component(c);
          kdu_resolution res = comp.access_resolution(resolution);

          kdu_dims pdims;
          res.get_valid_precincts(pdims);

          for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
          {
            for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
	          {    
	             kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
	             fprintf(fc,"%d %d %d %d: %d %d %d %d %d: %ld\n", ww.x, ww.y, ww.w, ww.h, l, resolution, c, py, px, (long)pid);
	          }
          }
        }
      }
    }  
    tile.close();
  }
  fclose(f);
  fclose(fc);	

  return true;
}

// Sólo devuelve las coordenadas de los precintos que coinciden con las coordenadas de la WOI
bool jp2_area::woi_to_lrcp_modified(char filename_woi[], int w, int h, int r, int q)
{
  int x, y;
  FILE *f = fopen(filename_woi,"r");
  if(!f) return false;

  char *filename_out = new char[255];
  strcpy(filename_out, cur_name);
  strcat(filename_out,".lrcp");
  FILE *fc = fopen(filename_out,"w");
  if(!fc) return false;

  // ****************************************************
  // Obtenemos el número de precintos que hay en cada nivel de resolución  
  kdu_dims idims;
  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.get_dims(0, idims);
  printf("\nImage dimension: %d - %d\n", idims.size.x, idims.size.y);

  kdu_dims roi, realroi;
  roi.pos = kdu_coords(0, 0);
  roi.size = kdu_coords(idims.size.x, idims.size.y);

  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
  kdu_tile_comp comp = tile.access_component(0);

  kdu_dims *precincts_in_each_resolution = new kdu_dims[numr];
  kdu_dims *resolution_size = new kdu_dims[numr];  
  kdu_dims *precincts_size_in_each_resolution = new kdu_dims[numr];

  for (int resolution = 0; resolution < numr; resolution++) {
    printf("Resolution: %d\n", resolution);

    kdu_resolution res = comp.access_resolution(resolution);

    kdu_dims rdims;
    res.get_dims(rdims);
    printf("\tDimension.\t x: %5d \t y: %5d\n", rdims.size.x, rdims.size.y);
    resolution_size[resolution] = rdims;

    kdu_dims pdims;
    res.get_valid_precincts(pdims);
    printf("\t# of precincts.\t x: %5d \t y: %5d\n", pdims.size.x, pdims.size.y);
    precincts_in_each_resolution[resolution] = pdims;

    precincts_size_in_each_resolution[resolution].size.x = rdims.size.x / pdims.size.x;
    precincts_size_in_each_resolution[resolution].size.y = rdims.size.y / pdims.size.y;
    printf("\tPrecincts size.\t x: %5d \t y: %5d\n", precincts_size_in_each_resolution[resolution].size.x, precincts_size_in_each_resolution[resolution].size.x);
  }
  tile.close();  
  // ****************************************************

  while(!feof(f))
  {
    fscanf(f, "%d %d\n",&x, &y);
    woi ww = woi(x, y, w, h, r, q);

    kdu_dims roi, realroi;

    roi.pos = kdu_coords(ww.x, ww.y);
    roi.size = kdu_coords(ww.w, ww.h);

    codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
    codestream.map_region(0, roi, realroi);
    codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

    int numr = codestream.get_min_dwt_levels() + 1;
    kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

    for (int l = 0; l < q; l++)
    //for (int l = 0; l < tile.get_num_layers(); l++)
    {
      for (int resolution = 0; resolution < r; resolution++)
      //for (int r = 0; r < numr; r++)        
      {
        for (int c = 0; c < tile.get_num_components(); c++)
        {
          kdu_tile_comp comp = tile.access_component(c);
          kdu_resolution res = comp.access_resolution(resolution);

          kdu_dims pdims;
          res.get_valid_precincts(pdims);

          for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
          {
            for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
            {    
               kdu_long pid = res.get_precinct_id(kdu_coords(px, py));            
               
               float scale_factor = pow(2, r - 1 - resolution);
               //printf("\n%d / %f = %f \t %f \t %d\n", ww.x, scale_factor, ww.x / scale_factor, (ww.x / scale_factor) / precincts_size_in_each_resolution[resolution].size.x, px);
               //printf("%d / %f = %f \t %f \t %d\n", ww.y, scale_factor, ww.y / scale_factor, (ww.y / scale_factor) / precincts_size_in_each_resolution[resolution].size.y, py);
               //printf("%d %d %d %d: %d %d %d %d %d: %ld\n", ww.x, ww.y, ww.w, ww.h, l, resolution, c, py, px, (long)pid);

               // Eliminamos los precintos que no coincidan exactamente con la región de la WOI.
               // Kakadu incluye algunos precintos de los bordes.
               if (((int)((ww.x / scale_factor) / precincts_size_in_each_resolution[resolution].size.x) == px) &&
                   ((int)((ww.y / scale_factor) / precincts_size_in_each_resolution[resolution].size.y) == py)) {
                  fprintf(fc,"%d %d %d %d: %d %d %d %d %d: %ld\n", ww.x, ww.y, ww.w, ww.h, l, resolution, c, py, px, (long)pid);
                  //printf("\n\t*** ----> %d %d %d %d: %d %d %d %d %d: %ld\n", ww.x, ww.y, ww.w, ww.h, l, resolution, c, py, px, (long)pid);
               }
            }
          }
        }
      }
    }  
    tile.close();
  }
  fclose(f);
  fclose(fc); 

  return true;
}

// Ordenamos el archivo que contiene los paquetes en coordenadas LRCP
// Vamos cogiendo el primero paquete de cada precinto.
bool jp2_area::sort_lrcp_file_type_1(int layersLevel, int resolutionLevels)
{
  /* Archivo de donde vamos a ir leyendo las coordenadas de los paquetes */
  char *filename = new char[255];
  strcpy(filename, cur_name);
  strcat(filename,".lrcp");
  FILE *fwois = fopen(filename,"r");
  if (!fwois) return false;

  /* Archivo donde vamos a ir guardando las coordenadas lrcp en diferente orden */
  char *filename_sort = new char[255];
  strcpy(filename_sort, cur_name);
  strcat(filename_sort,".lrcp.sort");
  FILE *fsort = fopen(filename_sort,"w");
  if (!fsort) return false;

  int x, y, w, h, l, r, c, py, px;
  long id;
  int cont;

  for(int i=0; i < layersLevel*resolutionLevels; i++){

    //printf("\n ----> i: %d\n", i);

    /* Indica cuántas líneas tenemos que saltarnos del primer bloque */
    for(int j=0; j < i; j++){
      //printf("\n\t -- j: %d\n", j);
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\t---> DISCARD: %d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      cont++;
    }
    
    fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
    //printf("\t\t---> Sort. %d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
    fprintf(fsort,"%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);    
    cont++;

    /* Indica cuántas líneas tenemos que saltarnos del primer bloque */
    for(int j=i+1; j < layersLevel*resolutionLevels; j++){
      //printf("\n\t -- j: %d\n", j);
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\t---> DISCARD: %d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
    }

    /* Reseteamos el contador */
    cont = 0;

    while(!feof(fwois))
    {  
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\tCont: %d - %d %d %d %d: %d %d %d %d %d: %ld\n", cont, x, y, w, h, l, r, c, py, px, id);      

      if (cont == i) {
        //printf("\t\t---> Sort. Cont: %d - %d %d %d %d: %d %d %d %d %d: %ld\n", cont, x, y, w, h, l, r, c, py, px, id);
        fprintf(fsort,"%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      }

      cont++;

      if (cont == layersLevel*resolutionLevels) {
        /* Reseteamos el contador */
        cont = 0;
      }
    }

    /* Ponemos el cursor del archivo en el inicio */
    fseek(fwois, 0, SEEK_SET);
  }

  fclose(fwois);
  fclose(fsort);
  return true;
}

// Ordenamos el archivo que contiene los paquetes en coordenadas LRCP.
// Vamos cogiendo todos los paquetes de una capa de calidad de cada precinto.
bool jp2_area::sort_lrcp_file_using_knapsack_method_1(int layersLevel, int resolutionLevels)
{
  /* Archivo de donde vamos a ir leyendo las coordenadas de los paquetes */
  char *filename = new char[255];
  strcpy(filename, cur_name);
  strcat(filename,".lrcp");
  FILE *fwois = fopen(filename,"r");
  if (!fwois) return false;

  /* Archivo donde vamos a ir guardando las coordenadas lrcp en diferente orden */
  char *filename_sort = new char[255];
  strcpy(filename_sort, cur_name);
  strcat(filename_sort,".lrcp.sort");
  FILE *fsort = fopen(filename_sort,"w");
  if (!fsort) return false;

  int x, y, w, h, l, r, c, py, px;
  long id;
  int cont = 0;
  int discard = 0;

  for(int i=0; i < layersLevel; i++){
  
    /* Indica cuántas líneas tenemos que saltarnos del primer bloque */
    for(int j=0; j < discard; j++){
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      cont++;
    }
    
    /* Leemos tantas líneas como niveles de resolución tengamos */
    for(int j=0; j < resolutionLevels; j++){
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\t\t---> %d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      fprintf(fsort,"%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      cont++;    
      discard++;
    }

    /* Indica cuántas líneas tenemos que saltarnos del primer bloque */
    for(int j=cont; j < layersLevel*resolutionLevels; j++){
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
    }

    /* Reseteamos el contador */
    cont = 0;

    while(!feof(fwois))
    {  
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\tCont: %d - %d %d %d %d: %d %d %d %d %d: %ld\n", cont, x, y, w, h, l, r, c, py, px, id);      

      //printf("cont: (%d) >= discard - resolutionLevels (%d) && cont: (%d) < discard (%d) \n", cont, discard - resolutionLevels, cont, discard);

      if ((cont >= discard - resolutionLevels) && (cont < discard)) {
        //printf("\t\t---> Sort. Cont: %d - %d %d %d %d: %d %d %d %d %d: %ld\n", cont, x, y, w, h, l, r, c, py, px, id);
        fprintf(fsort,"%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      }

      cont++;

      if (cont == layersLevel*resolutionLevels) {
        /* Reseteamos el contador */
        cont = 0;
      }
    }

    /* Ponemos el cursor del archivo en el inicio */
    fseek(fwois, 0, SEEK_SET);
  }

  fclose(fwois);
  fclose(fsort);
  return true;
}

// Ordenamos el archivo que contiene los paquetes en coordenadas LRCP.
// Vamos cogiendo todos los paquetes hasta una capa de calidad máxima para cada precinto.
bool jp2_area::sort_lrcp_file_using_knapsack_method_2(int layersLevel, int resolutionLevels, int until_this_quality_layer)
{
  /* Archivo de donde vamos a ir leyendo las coordenadas de los paquetes */
  char *filename = new char[255];
  strcpy(filename, cur_name);
  strcat(filename,".lrcp");
  FILE *fwois = fopen(filename,"r");
  if (!fwois) return false;

  /* Archivo donde vamos a ir guardando las coordenadas lrcp en diferente orden */
  char *filename_sort = new char[255];
  strcpy(filename_sort, cur_name);
  strcat(filename_sort,".lrcp.sort");
  FILE *fsort = fopen(filename_sort,"w");
  if (!fsort) return false;

  int x, y, w, h, l, r, c, py, px;
  long id;
  int cont = 0;

  while(!feof(fwois))
  {
    /* Leemos tantas líneas como niveles de resolución tengamos y capas de calidad que queramos incluir */
    for(int j=0; j < resolutionLevels*until_this_quality_layer; j++){
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
      //printf("\t\t---> %d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
      fprintf(fsort,"%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);      
      cont++;    
    }

    /* Indica cuántas líneas tenemos que saltarnos del primer bloque */
    for(int j=cont; j < layersLevel*resolutionLevels; j++){
      fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
    }    

    /* Reseteamos el contador */
    cont = 0;
  }

  fclose(fwois);
  fclose(fsort);
  return true;
}

// REVISAR ****************
//

int jp2_area::load_wois_cache_and_update_index_list_TEST(JP2Cache& cache, double max_bytes, int lrcp_type)
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;

  double num = 0;
  //kdu_byte data[500];
  kdu_byte data[524288];

  /* Creamos un archivo donde guardamos la cache */
  char *filename_cache = new char[255];
  strcpy(filename_cache, cur_name);
  strcat(filename_cache,".cache");
  FILE *fc = fopen(filename_cache,"wb");
  if (!fc) return -1;

  /* Archivo de donde vamos a ir leyendo las coordenadas paquetes */
  char *filename = new char[255];
  strcpy(filename, cur_name);

  switch(lrcp_type){
    /* Leemos las coordenadas del archivo siguiendo el orden LRCP */
    case 0: strcat(filename,".lrcp");
            break;

    /* Leemos las coordenadas del archivo que hemos ordenado previamente */
    case 1:
    case 2: strcat(filename,".lrcp.sort");
            break;
  }
  
  FILE *fwois = fopen(filename,"r");
  if (!fwois) return -1;

  /* Archivo donde vamos a ir guardando las coordenadas de las WOIs que se han solicitado */
  char *filename_woi = new char[255];
  strcpy(filename_woi, cur_name);
  strcat(filename_woi,".woi");
  FILE *fw = fopen(filename_woi,"w");
  if (!fw) return -1;

  long cont_add = 0;
  long cont = 0;
  long cont_encontrados = 0;

  int x, y, w, h, l, r, c, py, px;
  long id;

  while(!feof(fwois))
  {
	    fscanf(fwois,"%d %d %d %d: %d %d %d %d %d: %ld\n", &x, &y, &w, &h, &l, &r, &c, &py, &px, &id);
	    cont++;
	
	    packet_data& packet = packets[l][r][c][py][px];

      if(packet.woi)
	    {
		    /* Guardamos las coordenadas de la WOI */
    		fprintf(fw,"%d %d\n", x, y);

		    // Buscamos si el paquete ya lo hemos incluido en la caché
		    bool encontrado = false;
		    for(int i=0; i<ne; i++)
		    {
			     if ((index_list[i].l==l) && (index_list[i].r==r) && (index_list[i].c==c) && (index_list[i].py==py) && (index_list[i].px==px))
			     {
				      encontrado = true;
				      cont_encontrados++;			
				      break;
			     }
		    }
		    if (!encontrado)
		    {
           // NEW CHANGE
           if(num + packet.length > max_bytes)
           {
              goto end_load_woi;
           }

	         int off = packet.offset;
	         int plen = packet.length;

	    		 printf("\n%d %d %d %d: %d %d %d %d %d: %ld\n", x, y, w, h, l, r, c, py, px, id);
		       printf("ID: %5d Offset: %5d Length: %5d\n",packet.id,packet.offset,packet.length);

	         if(plen > 0) 
			     {
              int rb = 0;
	            fseek(f, off, SEEK_SET);

              for(int len = plen; len > 0; len -= rb) 
              {
                  rb = sizeof(data);
                  if(len < rb) rb = len;

                  if(fread(data, 1, rb, f) != rb) 
                  {
                    fclose(f);
                    return -1;
                  }
                  //cout << "[" << packet.id << "]** Anado a " << packet.id << " " << rb << " bytes (" << packet.cached << "/" << packet.length << ")" << endl;
                  cache.addToPrecinct(data, rb, packet.id);
			
                  // Guardamos el id , la longitud y los datos del paquete en un archivo con toda la cache
                  fwrite(&packet.id, sizeof(packet.id), 1, fc);
                  fwrite(&l, sizeof(l), 1, fc);
                  fwrite(&r, sizeof(r), 1, fc);
                  fwrite(&c, sizeof(c), 1, fc);
                  fwrite(&py, sizeof(py), 1, fc);
                  fwrite(&px, sizeof(px), 1, fc);
                  fwrite(&rb, sizeof(rb), 1, fc);
                  fwrite(&data, 1, rb, fc);
                  cont_add++;

                  // Actualizamos la lista de ids
                  id_list[packet.id] = true;
              }

              num += plen;
	       	}

          // Actualizamos la lista de paquetes de la caché			
          index_list[ne] = index_packet(l,r,c,py,px);
          ne++;

          if(num >= max_bytes)
          {
            goto end_load_woi;
          }
        }
	    }
  }

  end_load_woi:
  fclose(f);
  fclose(fc);
  fclose(fw);
  fclose(fwois);

  printf("\n[%s][load_wois_cache_and_update_index_list_test] # Líneas leídas del archivo: %ld",cur_name,cont);
  printf("\n[%s][load_wois_cache_and_update_index_list_test] # Paquetes repetidos: %ld",cur_name,cont_encontrados);
  printf("\n[%s][load_wois_cache_and_update_index_list_test] # Paquetes en caché: %d \t # Bytes: %.0lf",cur_name,ne,num);
  printf("\n[%s][load_wois_cache_and_update_index_list_test] # cache.adds: %ld",cur_name,cont_add);

  return num;
}

int jp2_area::save_packets_to_file()
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;

  double num = 0;
  //kdu_byte data[500];
  kdu_byte data[524288];

  /* Creamos un archivo donde guardamos la cache */
  char *filename_cache = new char[255];
  strcpy(filename_cache, cur_name);
  strcat(filename_cache,".packets.cache");
  FILE *fc = fopen(filename_cache,"wb");
  if (!fc) return -1;

  long cont = 0;
  long cont_encontrados = 0;
  long cont_add = 0;

  for (int l = 0; l < num_l; l++)
  {
    for (int r = 0; r < num_r[l]; r++)
    {
      for (int c = 0; c < num_c[l][r]; c++)
      {
        for (int py = 0; py < num_py[l][r][c]; py++)
        {
          for (int px = 0; px < num_px[l][r][c]; px++)
          {
            	packet_data& packet = packets[l][r][c][py][px];

              	int off = packet.offset;
              	int plen = packet.length;

		            // REVISAR Y MEJORAR
		            //----
		            bool encontrado = false;
		            for(int i=0; i<ne; i++)
		            {
			             if ((index_list[i].l==l) && (index_list[i].r==r) && (index_list[i].c==c) && (index_list[i].py==py) && (index_list[i].px==px))
			             {
				              encontrado = true;
				              cont_encontrados++;
				              break;
			             }
		            }
		            //----

		            /* Solamente metemos en la cache aquellos paquetes que no estén incluidos en la lista de índices de paquetes */
		            if(!encontrado)
		            {
			             /* Incrementamos el número de paquetes marcados */
			             cont++;
		
	              	if(plen > 0) 
			            {
		                int rb = 0;
	                	fseek(f, off, SEEK_SET);

	                	for(int len = plen; len > 0; len -= rb) 
				            {
	                  		rb = sizeof(data);
	                  		if(len < rb) rb = len;

	                  		if(fread(data, 1, rb, f) != rb) 
					              {
	                    			fclose(f);
	                    			return -1;
	                  		}
	                  		//cout << "["<< packet.id <<"]Anado a " << packet.id <<" "<< rb <<" bytes ("<< packet.length << ") " << l << " " << r << " " << c << " " << py << " " << px << endl;

					              /* Guardamos el id , la longitud y los datos del paquete en un archivo con toda la cache */
					              fwrite(&packet.id, sizeof(packet.id), 1, fc);
					              fwrite(&l, sizeof(l), 1, fc);
					              fwrite(&r, sizeof(r), 1, fc);
					              fwrite(&c, sizeof(c), 1, fc);
					              fwrite(&py, sizeof(py), 1, fc);
					              fwrite(&px, sizeof(px), 1, fc);
					              fwrite(&rb, sizeof(rb), 1, fc);
					              fwrite(&data, 1, rb, fc);

					             cont_add++;
	                	}
	
	                	num += plen;
              		}
		          }
          }
        }
      }
    }
  }
  fclose(f);
  fclose(fc);

  printf("\n[%s][save_packets_to_file] # Paquetes añadidos a la caché: %ld \t # Bytes: %.0lf",cur_name,cont,num);
  printf("\n[%s][save_packets_to_file] # Paquetes que ya estaban en la caché: %ld",cur_name,cont_encontrados);
  printf("\n[%s][save_packets_to_file] # cache.adds: %ld \n",cur_name,cont_add);

  return num;
}

void jp2_area::show_codestream_properties() {
  // Obtenemos el número de precintos que hay en cada nivel de resolución  
  kdu_dims idims;
  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.get_dims(0, idims);
  printf("\nImage dimension: %d x %d\n", idims.size.x, idims.size.y);

  kdu_dims roi, realroi;
  roi.pos = kdu_coords(0, 0);
  roi.size = kdu_coords(idims.size.x, idims.size.y);

  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
  kdu_tile_comp comp = tile.access_component(0);

  kdu_dims *precincts_in_each_resolution = new kdu_dims[numr];
  kdu_dims *resolution_size = new kdu_dims[numr];  
  kdu_dims *precincts_size_in_each_resolution = new kdu_dims[numr];

  int numl = tile.get_num_layers();
  printf("# of quality layers: %d\n", numl);
  long total_number_of_packets = 0;

  printf("# of resolution levels: %d\n\n", numr);

  for (int resolution = 0; resolution < numr; resolution++) {
    printf("Resolution: %d\n", resolution);

    kdu_resolution res = comp.access_resolution(resolution);

    kdu_dims rdims;
    res.get_dims(rdims);
    printf("\tDimension.\t x: %5d \t y: %5d\n", rdims.size.x, rdims.size.y);
    resolution_size[resolution] = rdims;

    kdu_dims pdims;
    res.get_valid_precincts(pdims);
    printf("\t# of precincts.\t x: %5d \t y: %5d\n", pdims.size.x, pdims.size.y);
    precincts_in_each_resolution[resolution] = pdims;

    precincts_size_in_each_resolution[resolution].size.x = rdims.size.x / pdims.size.x;
    precincts_size_in_each_resolution[resolution].size.y = rdims.size.y / pdims.size.y;
    printf("\tPrecincts size.\t x: %5d \t y: %5d\n", precincts_size_in_each_resolution[resolution].size.x, precincts_size_in_each_resolution[resolution].size.x);

    long number_of_packets = pdims.size.x * pdims.size.y * numl;
    printf("\t# of packets   \t  : %5ld\n", number_of_packets);
    total_number_of_packets = total_number_of_packets + number_of_packets;
  }
  printf("\nTotal # of packets: %ld\n", total_number_of_packets);
  tile.close();  
}