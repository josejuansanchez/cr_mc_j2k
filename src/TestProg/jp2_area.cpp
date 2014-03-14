#include <string.h>
#include <iostream>
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


bool jp2_area::open(char *fname)
{
	bool rhead;
	kdu_byte *plt;
	kdu_dims tdims;
	kdu_byte data[2];
	int m, mlen;
	int pinipos, tsize;
	
	FILE *f = fopen(fname, "rb");
	if(!f) return false;
	
	cur_name = strdup(fname);

	get_short(f, data);
	cache.addToMainHeader(data, 2);

	rhead = true;

	fprintf(stderr, "Marcadores encontrados:\n");
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

				num_px[l][r][c] = pdims.size.x;
				num_py[l][r][c] = pdims.size.y;
				packets[l][r][c] = new packet_data *[pdims.size.y];
				
				for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) 
					packets[l][r][c][py] = new packet_data[pdims.size.x]; 
			}
		}
	}
	
	int prog;
	codestream.access_siz()->access_cluster(COD_params)->get(Corder, 0, 0, prog);
	
	if(prog == 1) {
		cerr << "Progresion: RLCP" << endl;
		
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
						}
					}
				}
			}
		}
		
	} else if(prog == 0) {
		cerr << "Progresion: LRCP" << endl << endl;
		
		for(int l = 0; l < tile.get_num_layers(); l++) {
			for(int r = 0; r < res; r++) {
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
						}
					}
				}
			}
		}	
			
	} else if(prog == 2) {
		cerr << "Progresion: RPCL" << endl << endl;
		
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
						}
					}
				}
			}
		}		
	}
	

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
            packets[l][r][c][py][px].woi = false;
        }
      }
    }
  }
}

// Modificado
//
int jp2_area::load_woi_to_cache(JP2Cache& cache, int max_bytes, bool check_cached, int qlayer)
{
  FILE *f = fopen(cur_name, "rb");
  if(!f) return -1;
	
  int num = 0;
  kdu_byte data[500];

  // Comprobamos que no se intente acceder a una capa de calidad que no existe
  if (qlayer > num_l)
  {
	qlayer = num_l;
  }

  for (int l = 0; l <= qlayer; l++)
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

            if(packet.woi) {
							/*printf("%d\t %d\t %d\t %d\t %d\t %d\t %d:%d\t %d\n", 
										packet.id,
										l, r, c, py, px,
										packet.offset,
										packet.length,
										cache.getPrecinctLength(packet.id)
										);*/		
						
						
              int off = packet.offset;
              int plen = packet.length;

              if(check_cached) {
                plen -= packet.cached;
                off += packet.cached;

                if(plen > (max_bytes - num))
                  plen = (max_bytes - num);

                if(plen < 0) plen = 0;
              }

              if(plen > 0) {
                int rb = 0;
                fseek(f, off, SEEK_SET);

                for(int len = plen; len > 0; len -= rb) {
                  rb = sizeof(data);
                  if(len < rb) rb = len;

                  if(fread(data, 1, rb, f) != rb) {
                    fclose(f);
                    return -1;
                  }

                  //cout << "Anado a " << packet.id << " " << rb << "bytes (" << packet.cached << "/" << packet.length << ")" << endl;
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


// Modificado
//
int jp2_area::load_woi(int max_bytes, int qlayer)
{
  return load_woi_to_cache(cache, max_bytes, true, qlayer);
}


void jp2_area::set_woi(woi new_woi)
{
  clear_woi();
	
  new_woi.r = res - 1 - new_woi.r;

  cur_woi = new_woi;

  kdu_dims roi, realroi;

  roi.pos = kdu_coords(cur_woi.x, cur_woi.y);
  roi.size = kdu_coords(cur_woi.w, cur_woi.h);

  codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, &realroi);

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

  for (int l = 0; l < tile.get_num_layers(); l++)
  {
    for (int r = 0; r < numr; r++)
    {
      for (int c = 0; c < tile.get_num_components(); c++)
      {
        kdu_tile_comp comp = tile.access_component(c);
        if (r >= comp.get_num_resolutions()) break;
        kdu_resolution res = comp.access_resolution(r);

        kdu_dims pdims;
        res.get_valid_precincts(pdims);

        for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
        {
          for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
            packets[l][r][c][py][px].woi = true;
						
						/*printf("%d\t %d\t %d\t %d\t %d\t %d\t %d:%d\n", 
							packets[l][r][c][py][px].id,
							l, r, c, py, px,
							packets[l][r][c][py][px].offset,
							packets[l][r][c][py][px].length);*/
					}
        }
      }
    }
  }

  tile.close();
}


kdu_byte *jp2_area::create_buffer()
{
  return new kdu_byte[cur_woi.w * cur_woi.h * num_c[0][0]];
}


bool jp2_area::decode_from_codestream(kdu_codestream& codestream, kdu_byte *buf)
{
  int stripe_heights[3];
  kdu_dims roi, realroi;
  kdu_stripe_decompressor decompressor;

  roi.pos = kdu_coords(cur_woi.x, cur_woi.y);
  roi.size = kdu_coords(cur_woi.w, cur_woi.h);

  codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, NULL);	// Dimensiones en cur_woi.r
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, cur_woi.r, 100, &realroi);  // Dimensiones en cur_woi.r

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


// Modificado
//
bool jp2_area::decode_complete(kdu_byte *buf, int qlayer)
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

  load_woi_to_cache(cache_aux, INT_MAX, false, qlayer);

  cache_aux.setInitialScope();

  kdu_codestream code_aux;
  code_aux.create(&cache_aux);
  code_aux.set_persistent();

  return decode_from_codestream(code_aux, buf);
}

// Descripción: Devuelve la suma (bytes) de los paquetes, hasta una determinada capa de calidad
//
long jp2_area::sum_qlayer_bytes_packets(int qlayer)
{
  // Comprobamos que no se intente acceder a una capa de calidad que no existe
  if (qlayer > num_l)
  {
	qlayer = num_l;
  }
	
  printf("\nID\t L\t R\t C\t PY\t PX\t OFFSET:LENGTH\n");

  long cont = 0;
  long sum = 0;

  for (int l = 0; l <= qlayer; l++)
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
		printf("%d\t %d\t %d\t %d\t %d\t %d\t %d:%d\n", 
			packet.id,
			l, r, c, py, px,
			packet.offset,
			packet.length
		);

		sum = sum + packet.length;
		cont = cont + 1;
            }
          }
        }
      }
    }
  }

  printf("\n# paquetes: %ld",cont);
  return sum;
}
