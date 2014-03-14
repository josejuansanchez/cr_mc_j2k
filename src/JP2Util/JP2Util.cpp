#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <math.h>
#include "JP2Util.h"


//#define RESPONSE_LOG

class kdu_stream_message : public kdu_message {
public: 
	kdu_stream_message(std::ostream *stream) { this->stream = stream; }
	void put_text(const char *string) { (*stream) << string; }
	void flush(bool end_of_message = false) { stream->flush(); }

private: 
	std::ostream *stream;
};

static kdu_stream_message cout_message(&std::cout);
static kdu_stream_message cerr_message(&std::cerr);
static kdu_message_formatter pretty_cout(&cout_message);
static kdu_message_formatter pretty_cerr(&cerr_message);


static int get_short(FILE *f, kdu_byte *buf = NULL)
{
	int a = fgetc(f);
	int b = fgetc(f);

	if(buf) {
		buf[0] = a;
		buf[1] = b;
	}

	return (a << 8) | b;
}


static int get_packet_data(FILE *f, PacketInfo& p)
{
	int c;

	p.length = 2;
	p.offset = ftell(f) - 2;
	
	//printf(":: %X\n", p.offset);

	for(;;) {
		c = fgetc(f);
		
		if(c < 0) return 0;
		else if(c != 0xFF) p.length++;
		else {
			c = fgetc(f);
			if(c == 0x91 || c == 0xD9) return 1;
			else {
				p.length++;
				ungetc(c, f);
			}
		}
	}
}

/*static void get_packet_data2(FILE *f, PacketInfo& p)
{
	int c;

	p.length = 2;
	p.offset = ftell(f) - 2;

	for(;;) {
		if(fgetc(f) != 0xFF) p.length++;
		else {
			c = fgetc(f);
			if(c == 0x91 || c == 0xD9) break;
			else {
				p.length++;
				ungetc(c, f);
			}
		}
	}
}*/

int WOI::Parse(char *cad)
{
	return (sscanf(cad, "(%d,%d,%d,%d,%d)", &x, &y, &w, &h, &r) == 5);
}

int JP2ServerImage::Open(char *name)
{
	Close();
	
	if((fim = fopen(name, "rb")) == NULL) return 0;
	
	fseek(fim, 0, SEEK_END);
	int orgLen = ftell(fim);
	fseek(fim, 0, SEEK_SET);
	
	kdu_byte data[2];

	get_short(fim, data);
	cache.addToMainHeader(data, 2);

	int m, mlen;
	kdu_byte *plt;
	bool rhead = true;

	/**/printf("Marcadores encontrados: ");
	
	while((m = get_short(fim, data)) != 0xFF93) {
		if(m == 0xFF58) {
			mlen = get_short(fim) - 2;
			plt = new kdu_byte[mlen];
			fread(plt, mlen, 1, fim);
		
		} else if(m == 0xFF90) {
			headerLen = ftell(fim) - 2;
			mlen = get_short(fim) - 2;
			fseek(fim, mlen, SEEK_CUR);
			cache.completeMainHeader();
			rhead = false;
		
		} else {
			if(rhead) cache.addToMainHeader(data, 2);
			else cache.addToTileHeader(data, 2);

			mlen = get_short(fim, data) - 2;
			kdu_byte *mcon = new kdu_byte[mlen];
			fread(mcon, mlen, 1, fim);

			/**/printf("%X, ", m);

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
	
	/**/printf("FIN\n");

	int pinipos = ftell(fim);

	cache.completeTileHeader();
	cache.setInitialScope();

	int tsize = 0;

	codestream.create(&cache);
	codestream.set_persistent();
	codestream.apply_input_restrictions(0, 0, 0, 0, NULL);

	kdu_dims tdims;
	codestream.get_valid_tiles(tdims);
	int numr = codestream.get_min_dwt_levels() + 1;
	kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));

	fgetc(fim); fgetc(fim);
	
	/*int np = 0;
	PacketInfo pp;
	do {
		np++; 
	} while(get_packet_data(fim, pp));
	printf("====> %d\n", np);
	exit(-1);*/

	int totp = 0;

	numLayers = tile.get_num_layers();
	numLevels = new int[numLayers];
	numComps = new int *[numLayers];
	numPrecsX = new int **[numLayers];
	numPrecsY = new int **[numLayers];
	packets = new PacketInfo****[numLayers];

	for(int l = 0; l < numLayers; l++) {
		numLevels[l] = numr;
		numComps[l] = new int[numr];
		numPrecsX[l] = new int *[numr];
		numPrecsY[l] = new int *[numr];
		packets[l] = new PacketInfo***[numr];

		for(int r = 0; r < numr; r++) {
			numComps[l][r] = tile.get_num_components();
			numPrecsX[l][r] = new int[tile.get_num_components()];
			numPrecsY[l][r] = new int[tile.get_num_components()];
			packets[l][r] = new PacketInfo**[tile.get_num_components()];

			for(int c = 0; c < tile.get_num_components(); c++) {
				kdu_tile_comp comp = tile.access_component(c);
				kdu_resolution res = comp.access_resolution(r);

				kdu_dims pdims;
				res.get_valid_precincts(pdims);

				numPrecsX[l][r][c] = pdims.size.x;
				numPrecsY[l][r][c] = pdims.size.y;
				packets[l][r][c] = new PacketInfo *[pdims.size.y];
				
				for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
					packets[l][r][c][py] = new PacketInfo[pdims.size.x]; 
					for(int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
						kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
						get_packet_data(fim, packets[l][r][c][py][px]);
						tsize += packets[l][r][c][py][px].length;
						packets[l][r][c][py][px].id = pid;
						totp++;
						
						packets[l][r][c][py][px].l = l;
						packets[l][r][c][py][px].r = r;
						packets[l][r][c][py][px].c = c;
						packets[l][r][c][py][px].py = py;
						packets[l][r][c][py][px].px = px;
						
						//printf("%d (%d, %d, %d, %d, %d)\n", packets[l][r][c][py][px].length, l, r, c, py, px); 
						//fprintf(stderr, "%d\n", packets[l][r][c][py][px].length);
					}
				}
			}
		}
	}

	tile.close();
	
	if((pinipos + tsize + 2) != orgLen) {
		printf("Error de lectura: %d bytes\n", orgLen - (pinipos + tsize + 2));
		return 0;
	}
	
	/**/printf("Tamano total de la imagen: %d\n", pinipos + tsize + 2);
	/**/printf("Numero de paquetes de la imagen: %d\n", totp);
	
	return 1;
}

int JP2ServerImage::SetMinBlockSize(int minSize)
{
	int nb;
	int psize;
	BlockInfo *info;
	
	nb = 0;
	psize = 0;
	info = new BlockInfo;
	
	//printf("Bloques generados:\n");
	
	for(int l = 0; l < numLayers; l++) {
		for(int r = 0; r < numLevels[l]; r++) {
			for(int c = 0; c < numComps[l][r]; c++) {
				for(int py = 0; py < numPrecsY[l][r][c]; py++) {
					for(int px = 0; px < numPrecsX[l][r][c]; px++) {
						info->push_back(&(packets[l][r][c][py][px]));
						psize += packets[l][r][c][py][px].length;
						packets[l][r][c][py][px].block = nb;
						
						//printf("%d: (%d,%d,%d,%d,%d) [%d]\n", nb, l, r, c, py, px, packets[l][r][c][py][px].length);
						
						if(psize >= minSize) {
							blockList.push_back(info);
							info = new BlockInfo;
							psize = 0;
							nb++;
						}
					}
				}
			}
		}
	}
	
	blockList.push_back(info);
	minBlockSize = minSize;
	
	//printf("Numero de bloques generados: %d\n", nb);
	
	return 1;
}

int JP2ServerImage::GetResponse(WOI& woi, ClientResponse& resp)
{
	int nb = 0;
	int ppos = 0;
	PacketInfo *pk;
	BlockInfo *blk;
	kdu_dims roi, realroi;
	
	resp.blocks.clear();
	for(int i = 0; i < (int)resp.offsets.size(); i++) 
		delete resp.offsets[i];
	resp.offsets.clear();
	
	roi.pos = kdu_coords(woi.x, woi.y);
	roi.size = kdu_coords(woi.w, woi.h);
	
	codestream.apply_input_restrictions(0, 0, woi.r, 100, NULL);
	codestream.map_region(0, roi, realroi);
	codestream.apply_input_restrictions(0, 0, woi.r, 100, &realroi);
	
	int numr = codestream.get_min_dwt_levels() + 1;
	kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
	
	#ifdef RESPONSE_LOG
	/**/int ud = 0;
	/**/int totp = 0;
	/**/int notud = 0;
	/**/BlockInfo *antblk;
	#endif

	for(int l = 0; l < tile.get_num_layers(); l++) {
		for(int r = 0; r < numr; r++) {
			for(int c = 0; c < tile.get_num_components(); c++) {
				kdu_tile_comp comp = tile.access_component(c);
				if(r >= comp.get_num_resolutions()) break;
				kdu_resolution res = comp.access_resolution(r);

				kdu_dims pdims;
				res.get_valid_precincts(pdims);
				for(int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
					for(int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
						pk = &(packets[l][r][c][py][px]);
						blk = blockList[pk->block];
						
						//printf("%d: (%d,%d,%d,%d,%d) [%d]\n", pk->block, l, r, c, py, px, pk->length);
						
						#ifdef RESPONSE_LOG
						/**/ud += pk->length;
						#endif
									
						if((resp.blocks.size() == 0) || (pk->block != resp.blocks[nb])) {
							resp.offsets.push_back(new IntVector);
							resp.blocks.push_back(pk->block);
							nb = resp.blocks.size() - 1;
							
							#ifdef RESPONSE_LOG
							/**/if(nb != 0) {
							/**/	while(ppos < (int)antblk->size()) 
							/**/		notud += (*antblk)[ppos++]->length;
							/**/}
							/**/antblk = blk;
							/**/printf("\n--> %d : ", pk->block); 
							#endif
							
							ppos = 0;
						}
						
						if(((*blk)[ppos] != pk) || (ppos == 0)) {
							int off = 0;
							
							while((*blk)[ppos] != pk) {
								off += (*blk)[ppos]->length;
								
								#ifdef RESPONSE_LOG
								/**/notud += (*blk)[ppos]->length;
								#endif
								
								ppos++;
							}
							
							resp.offsets[nb]->push_back(off);
							
							#ifdef RESPONSE_LOG
							/**/printf("%X{", off);
							#endif
						}
						
						#ifdef RESPONSE_LOG
						/**/printf("%d ", pk->length);
						/**/totp++;
						#endif
						
						ppos++;
					}
				}
			}
		}
	}

	#ifdef RESPONSE_LOG
	/**/printf("\nNumero de paquetes marcados: %d\n", totp);
	/**/printf("Numero de bloques marcados: %d\n", resp.blocks.size());
	/**/printf("Informacion valida/no valida: %d/%d\n", ud, notud);
	/**/printf("Porcentaje de informacion valida: %.1f%%\n", ((double)(ud) / (double)(ud + notud)) * 100.0);
	/**/printf("Sobrecarga de cabeceras HTTP (300xMens.): %d\n", resp.blocks.size() * 300);
	#endif
	
	tile.close();
	return 0;
}

int JP2ServerImage::GetBlockData(int idx, char *buf, int& bufLen)
{
	if(!fim || (idx >= (int)blockList.size())) {
		bufLen = 0;
		return 0;
	}
	
	if(idx < 0) {
		if(bufLen < headerLen) {
			bufLen = headerLen;
			return 0;
			
		} else {
			fseek(fim, 0, SEEK_SET);
			fread(buf, 1, headerLen, fim);
			bufLen = headerLen;
			return 1;
		}
		
	} else {
		int bsize = 0;
		BlockInfo::iterator pos;
		BlockInfo *block = blockList[idx];
		
		//printf(":: ");
		
		for(pos = block->begin(); pos != block->end(); ++pos) {
			if(bsize + (*pos)->length <= bufLen) {
				//printf("%X ", (*pos)->offset);
				fseek(fim, (*pos)->offset, SEEK_SET);
				fread(buf, 1, (*pos)->length, fim);
				buf += (*pos)->length;
			}
			
			bsize += (*pos)->length;
		}
		
		//printf("\n");
		
		if(bsize <= bufLen) {
			bufLen = bsize;
			return 1;
			
		} else {
			bufLen = bsize;
			return 0;
		}
	}
}

void JP2ServerImage::Close()
{
	if(fim) fclose(fim);
}

void writeVBAS(byte **buf, dword val)
{
	byte c, n;
	
	n = (val & 127) << 1;
	
	//printf("--->>> %d\n", val);
	
	do {
		c = n;
		val >>= 7;
		n = (val & 127) << 1;
		if(n != 0) c |= 1;
		**buf = c;
		
		//printf("---> %d\n", (int)c);
		
		(*buf)++;
	} while(n != 0);
}

dword readVBAS(byte **buf)
{
	dword i = 0;
	dword val = 0;
	
	for(;;) {
		//printf("<--- %d\n", (int)**buf);
		
		val |= (((dword)(**buf >> 1)) << (7 * i));
		if(!(**buf & 1)) break;
		(*buf)++;
		i++;
	}
	
	(*buf)++;
	
	return val;
}

int JP2ClientImage::BeginBuild(byte *hdr, int hdrlen, WOI& w)
{
	woi = w;
	
	cache.addToMainHeader(hdr, hdrlen);
	cache.completeMainHeader();
	cache.completeTileHeader();
	cache.setInitialScope();

	codestream.create(&cache);
	codestream.set_persistent();
	codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
	
	kdu_dims tdims;
	codestream.get_valid_tiles(tdims);
	int numr = codestream.get_min_dwt_levels() + 1;
	kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
	
	numLayers = tile.get_num_layers();
	numLevels = new int[numLayers];
	numComps = new int *[numLayers];
	numPrecsX = new int **[numLayers];
	numPrecsY = new int **[numLayers];
	packets = new int****[numLayers];

	for(l = 0; l < numLayers; l++) {
		numLevels[l] = numr;
		numComps[l] = new int[numr];
		numPrecsX[l] = new int *[numr];
		numPrecsY[l] = new int *[numr];
		packets[l] = new int***[numr];

		for(r = 0; r < numr; r++) {
			numComps[l][r] = tile.get_num_components();
			numPrecsX[l][r] = new int[tile.get_num_components()];
			numPrecsY[l][r] = new int[tile.get_num_components()];
			packets[l][r] = new int**[tile.get_num_components()];

			for(c = 0; c < tile.get_num_components(); c++) {
				kdu_tile_comp comp = tile.access_component(c);
				kdu_resolution res = comp.access_resolution(r);

				kdu_dims pdims;
				res.get_valid_precincts(pdims);

				numPrecsX[l][r][c] = pdims.size.x;
				numPrecsY[l][r][c] = pdims.size.y;
				packets[l][r][c] = new int*[pdims.size.y];
				
				for(py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
					packets[l][r][c][py] = new int[pdims.size.x]; 
					for(px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
						packets[l][r][c][py][px] = -1;
					}
				}
			}
		}
	}

	tile.close();
	
	kdu_dims roi, realroi;
	
	roi.pos = kdu_coords(woi.x, woi.y);
	roi.size = kdu_coords(woi.w, woi.h);
	
	codestream.apply_input_restrictions(0, 0, woi.r, 100, NULL);
	codestream.map_region(0, roi, realroi);
	codestream.apply_input_restrictions(0, 0, woi.r, 100, &realroi);
	
	numr = codestream.get_min_dwt_levels() + 1;
	tile = codestream.open_tile(kdu_coords(0, 0));

	for(l = 0; l < tile.get_num_layers(); l++) {
		for(r = 0; r < numr; r++) {
			for(c = 0; c < tile.get_num_components(); c++) {
				kdu_tile_comp comp = tile.access_component(c);
				if(r >= comp.get_num_resolutions()) break;
				kdu_resolution res = comp.access_resolution(r);

				kdu_dims pdims;
				res.get_valid_precincts(pdims);
				for(py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++) {
					for(px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) {
						packets[l][r][c][py][px] = res.get_precinct_id(kdu_coords(px, py));
						if(packets[l][r][c][py][px] < 0) {
							printf("Un paquete no puede tener un ID negativo!!\n");
							return 0;
						}
					}
				}
			}
		}
	}
	
	tile.close();
	
	l = r = c = px = py = 0;
	
	return 1;
}

int JP2ClientImage::NextPos()
{
	while(packets[l][r][c][py][px] == -1) {
		if(!IncPos()) return 0;
	}
	return 1;
}

int JP2ClientImage::IncPos()
{
	if(px < (numPrecsX[l][r][c] - 1)) px++;
	else { 
		px = 0; 
		if(py < (numPrecsY[l][r][c] - 1)) py++;
		else {
			py = 0;
			if(c < (numComps[l][r] - 1)) c++;
			else {
				c = 0;
				if(r < (numLevels[l] - 1)) r++;
				else {
					r = 0;
					if(l < (numLayers - 1)) l++;
					else {
						//printf("Nos hemos salido del rango!!\n");
						return 0;
					}
				}
			}
		}
	}

	return 1;
}

static dword get_short(byte *buf)
{
	dword a = buf[0];
	dword b = buf[1];

	return (a << 8) | b;
}
	
int JP2ClientImage::AddBlockPacket(pbyte& blk, byte *bend, IntVector& offs, int& opos)
{
	int psize;
	byte *bpos;
	
	if(blk >= bend) {
		if(opos >= (int)offs.size()) return 0;
		else return -1;
	}
	
	if((opos == 0) || (packets[l][r][c][py][px] == -1)) {
		if(opos >= (int)offs.size()) return 0;
		else {
			blk += offs[opos++];
			if(!NextPos()) return -1;
		}
	}
	
	bpos = blk + 2;
	while((bpos != (bend - 2)) && (get_short(bpos) != 0xFF91)) bpos++;
	if(bpos == (bend - 2)) bpos += 2;
	psize = bpos - blk;
		
	//printf("Anado paquete de %d bytes (%d, %d, %d, %d, %d) [%d]\n", bpos - blk, l, r, c, py, px, packets[l][r][c][py][px]);
	cache.addToPrecinct((kdu_byte *)blk, bpos - blk, packets[l][r][c][py][px]);
		
	if(!IncPos()) return -1;
		
	blk = bpos;
		
	return psize;
	
#if 0
	int psize;
	byte *bpos;
	
	if(opos == 0) {
		if(!NextPos()) return 0;
		blk += offs[opos++];
	}

	if(blk >= bend) {
		printf("Nos hemos salido del bloque!!\n");
		return 0;
	}
		
	bpos = blk + 2;
	while((bpos != (bend - 2)) && (get_short(bpos) != 0xFF91)) bpos++;
	if(bpos == (bend - 2)) bpos += 2;
	psize = bpos - blk;
		
	/**/printf("Anado paquete de %d bytes (%d, %d, %d, %d, %d) [%d]\n", bpos - blk, l, r, c, py, px, packets[l][r][c][py][px]);
	cache.addToPrecinct((kdu_byte *)blk, bpos - blk, packets[l][r][c][py][px]);
		
	if(!IncPos()) return 0;
		
	blk = bpos;
		
	if(bpos >= bend) {
		if(opos >= (int)offs.size()) return 0;
		else {
			/**/printf("Se alcanzo el final del bloque antes de lo previsto!!\n");
			return 0;
		}
	}
		
	if(packets[l][r][c][py][px] == -1) {
		if(opos >= (int)offs.size()) return 0;
		else {
			blk += offs[opos++];
			if(!NextPos()) return 0;
		}
	}
		
	return psize;
#endif
}

int JP2ClientImage::AddBlock(byte *blk, int blklen, IntVector *offs)
{
	int opos;
	byte *bpos, *bend;
	
	if(!NextPos()) return 0;
	
	opos = 0;
	bend = blk + blklen;
	blk += (*offs)[opos++];

	for(;;) {
		if(blk >= bend) {
			printf("Nos hemos salido del bloque!!\n");
			return 0;
		}
		
		/*int wd;
		if((wd = get_short(blk)) != 0xFF91) {
			printf("Bloque invalido!!! (%X)\n", wd);
			return 0;
		}*/
		
		bpos = blk + 2;
		while((bpos != (bend - 2)) && (get_short(bpos) != 0xFF91)) bpos++;
		if(bpos == (bend - 2)) bpos += 2;
		
		//printf("Anado paquete de %d bytes (%d, %d, %d, %d, %d) [%d]\n", bpos - blk, l, r, c, py, px, packets[l][r][c][py][px]);
		cache.addToPrecinct((kdu_byte *)blk, bpos - blk, packets[l][r][c][py][px]);
		
		if(!IncPos()) return 1;
		
		blk = bpos;
		
		if(bpos >= bend) {
			if(opos >= (int)offs->size()) return 1;
			else {
				/**/printf("Se alcanzo el final del bloque antes de lo previsto!!\n");
				return 0;
			}
		}
		
		if(packets[l][r][c][py][px] == -1) {
			if(opos >= (int)offs->size()) return 1;
			else {
				blk += (*offs)[opos++];
				if(!NextPos()) return 0;
			}
		}
	}
	
	return 1;
}

int JP2ClientImage::AllocForImage(byte **iout)
{
	kdu_dims roi;
	roi.pos = kdu_coords(woi.x, woi.y);
	roi.size = kdu_coords(woi.w, woi.h);
	
	*iout = (byte *)(new kdu_int32 [roi.area()]);
	if(!(*iout)) return 0;
	else return 1;
}
	
int JP2ClientImage::GenerateImage(byte *iout)
{
	kdu_dims roi;
	roi.pos = kdu_coords(woi.x, woi.y);
	roi.size = kdu_coords(woi.w, woi.h);
		
	int bufferSize = roi.area();
	kdu_int32 *buffer = (kdu_int32 *)iout;
	
	kdu_dims a, b;
	a.assign(roi);

	kdu_channel_mapping channels;
	channels.configure(codestream);

	kdu_region_decompressor decompressor;
	
	/*kdu_dims kk = decompressor.get_rendered_image_dims(codestream, &channels, 
						0, woi.r, kdu_coords(1, 1),
						kdu_coords(1, 1));
						
	printf("!!-> %d %d %d %d\n", kk.pos.x, kk.pos.y, kk.size.x, kk.size.y);*/
	
	decompressor.start(codestream, &channels, 0, woi.r, 100, a, kdu_coords(1, 1));
	
	while(decompressor.process(buffer, kdu_coords(0, 0), 0, 0, bufferSize, a, b));
	decompressor.finish();
	
	//printf("Generacion realizada.\n");
	
	return 1;
}
	
int JP2ClientImage::EndBuild()
{
	cache.close();	
	codestream.destroy();
	
	for(int l = 0; l < numLayers; l++) {
		for(int r = 0; r < numLevels[l]; r++) {
			for(int c = 0; c < numComps[l][r]; c++) {
				for(int py = 0; py < numPrecsY[l][r][c]; py++) 
					delete [] packets[l][r][c][py];
				
				delete [] packets[l][r][c];
			}
			
			delete [] packets[l][r];
			delete [] numPrecsX[l][r];
			delete [] numPrecsY[l][r];
		}
		
		delete [] numComps[l];
		delete [] numPrecsX[l];
		delete [] numPrecsY[l];
		delete [] packets[l];
	}
	
	delete [] numLevels;
	delete [] numComps;
	delete [] numPrecsX;
	delete [] numPrecsY;
	delete [] packets;
	
	return 1;
}
