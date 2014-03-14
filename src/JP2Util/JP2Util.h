#ifndef __JP2_UITL__
#define __JP2_UTIL___

#include <stdio.h>

#include "kdu_elementary.h"
#include "kdu_messaging.h"
#include "kdu_params.h"
#include "kdu_compressed.h"
#include "kdu_sample_processing.h"
#include "kdu_file_io.h"
#include "kdu_stripe_decompressor.h"
#include "kdu_region_decompressor.h"
#include "jp2.h"

#include <vector>
using namespace std;


/**
	Esta clase facilita el trabajo con la clase kdu_cache.
*/
class JP2Cache :public kdu_cache
{
public:
  void addToMainHeader(kdu_byte *data, int len)
  {
    add_to_databin(KDU_MAIN_HEADER_DATABIN, 0, 0, data,
      get_databin_length(KDU_MAIN_HEADER_DATABIN, 0, 0),
      len, false
    );
  }

  int getMainHeaderLength() 
  {
    return get_databin_length(KDU_MAIN_HEADER_DATABIN, 0, 0);
  }

  void completeMainHeader() 
  {
    add_to_databin(KDU_MAIN_HEADER_DATABIN, 0, 0, NULL,
      get_databin_length(KDU_MAIN_HEADER_DATABIN, 0, 0),
      0, true);
  }

  void addToTileHeader(kdu_byte *data, int len, int tileID) 
  {
    add_to_databin(KDU_TILE_HEADER_DATABIN, 0, tileID, data,
      get_databin_length(KDU_TILE_HEADER_DATABIN, 0, tileID),
      len, false
    );
  }

  void addToTileHeader(kdu_byte *data, int len)
  {
    addToTileHeader(data, len, 0);
  }

  int getTileHeaderLength(int tileID)
  {
    return get_databin_length(KDU_TILE_HEADER_DATABIN, 0, tileID);
  }

  int getTileHeaderLength() 
  {
    return getTileHeaderLength(0);
  }

  void completeTileHeader(int tileID) 
  {
    add_to_databin(KDU_TILE_HEADER_DATABIN, 0, tileID, NULL,
      get_databin_length(KDU_TILE_HEADER_DATABIN, 0, tileID),
      0, true
    );
  }

  void completeTileHeader() 
  {
    completeTileHeader(0);
  }

  void addToPrecinct(kdu_byte *data, int len, int precID) 
  {
    add_to_databin(KDU_PRECINCT_DATABIN, 0, precID, data,
      get_databin_length(KDU_PRECINCT_DATABIN, 0, precID),
      len, false
    );
  }

  int getPrecinctLength(int precID)
  {
    return get_databin_length(KDU_PRECINCT_DATABIN, 0, precID);
  }

  void completePrecinct(int precID)
  {
    add_to_databin(KDU_PRECINCT_DATABIN, 0, precID, NULL,
      get_databin_length(KDU_PRECINCT_DATABIN, 0, precID),
      0, true
    );
  }

  void setInitialScope() 
  {
    set_read_scope(KDU_MAIN_HEADER_DATABIN, 0, 0);
  }

  virtual bool set_precinct_scope(kdu_long unique_id)
  {
	  return kdu_cache::set_precinct_scope(unique_id);
  }
};


/**
	Contiene la informacion de un paquete, tal como su offset dentro
	del archivo de la imagen, su longitud en bytes, su identificador
	tal y como define la libreria Kakadu, y el bloque al que pertenece.
*/
struct PacketInfo
{
	int id;					///< Identificador
	int offset;				///< Offset
	int length;				///< Longitud
	int block;				///< Bloque
	
	int l, r, c, py, px;	///< Posicion asociada

	PacketInfo()
	{
		id = 0;
		block = 0;
		offset = 0;
		length = 0;
	}
};

/**
	Este tipo identifica la informacion de un bloque.
*/
typedef vector<PacketInfo *> BlockInfo;

/**
	Este tipo identifica un vector de enteros.
*/
typedef vector<int> IntVector;

/**
	Esta estructura define una WOI o Window Of Interest.
*/
struct WOI
{
	int r;		///< Nivel de resolucion
	int x, y;	///< Coordenadas del extremo superior izquierdo
	int w, h;	///< Ancho y alto
	
	WOI() { r = x = y = w = h = 0; }
	
	/*WOI(int pr, int px, int py, int pw, int ph) 
	{
		r = pr;
		x = px; y = py;
		w = pw; h = ph;
	}*/
	
	int Parse(char *cad);
};

/**
	Esta estructura contiene la informacion que se envia a un cliente
	tras una peticion de una WOI determinada.
*/
struct ClientResponse
{
	IntVector blocks;		///< Indice de los bloques
	vector<IntVector *> offsets;	///< Offsets para cada bloque
};

/**
	Esta clase la empleara el servidor para manejar las imagenes JPEG2000. 
	Las imagenes que maneja esta clase son las J2C con progresion LRCP,
	que deben contener marcadores SOP y un unico tile/tile-part.
*/
class JP2ServerImage
{
private:
	FILE *fim;			///< Archivo de la imagen
	int headerLen;			///< Longitud de la cabecera
	JP2Cache cache;			///< Cache asociada para procesamiento	
	PacketInfo *****packets;	///< Indice de los paquetes
	int minBlockSize;		///< Tamaño minimo de bloque actual
	vector<BlockInfo *> blockList;	///< Informacion de los bloques
	kdu_codestream codestream;	///< Manejador del codestream
	int numLayers;
	int *numLevels;
	int **numComps;
	int ***numPrecsX;
	int ***numPrecsY;
	
public:
	JP2ServerImage()
	{
		fim = NULL;
	}
	
	int SetMinBlockSize(int minSize);
	
	int GetMinBlockSize()
	{
		return minBlockSize;
	}
	
	int Open(char *name);
	
	void Close();
	
	int GetNumLayers() { return numLayers; }
	int GetNumLevels(int l) { return numLevels[l]; }
	int GetNumComps(int l, int r) { return numComps[l][r]; }
	int GetNumPrecsX(int l, int r, int c) { return numPrecsX[l][r][c]; }
	int GetNumPrecsY(int l, int r, int c) { return numPrecsY[l][r][c]; }
	
	int GetResponse(WOI& woi, ClientResponse& resp);
	
	int GetBlockData(int idx, char *buf, int& bufLen);
	
	BlockInfo *GetBlockInfo(int idx) { return blockList[idx]; }
	
	int GetNumBlocks() { return (int)blockList.size(); }
};

typedef unsigned int dword;
typedef unsigned char byte;


void writeVBAS(byte **buf, dword val);

inline void writeVBAS(byte *buf, dword val)
{
	writeVBAS(&buf, val);
}

dword readVBAS(byte **buf);

inline dword readVBAS(byte *buf)
{
	return readVBAS(&buf);
}

typedef byte *pbyte;

/**
	Esta clase la empleara el client para poder reconstruir las imagenes
	recibidas del servidor.
*/
class JP2ClientImage
{
private:
	WOI woi;			///< WOI a generar
	JP2Cache cache;			///< Cache asociada para procesamiento	
	int *****packets;		///< Paquetes asociados a la WOI
	kdu_codestream codestream;	///< Manejador del codestream
	int numLayers;			///< Numero de capas
	int *numLevels;			///< Numero de niveles de resolucion
	int **numComps;			///< Numero de componentes
	int ***numPrecsX;		///< Numero de precintos en X
	int ***numPrecsY;		///< Numero de precintos en Y
	int l, r, c, px, py;		///< Posicionamiento actual
	
	int IncPos();			///< Incrementa la posicion actual
	int NextPos();			///< Avanza hasta la siguiente posicion
	
public:
	int GetNumLayers() { return numLayers; }
	int GetNumLevels(int l) { return numLevels[l]; }
	int GetNumComps(int l, int r) { return numComps[l][r]; }
	int GetNumPrecsX(int l, int r, int c) { return numPrecsX[l][r][c]; }
	int GetNumPrecsY(int l, int r, int c) { return numPrecsY[l][r][c]; }
	
	int BeginBuild(byte *hdr, int hdrlen, WOI& w);
	
	int AddBlock(byte *blk, int blklen, IntVector *offs);
	int AddBlockPacket(pbyte& blk, byte *bend, IntVector& offs, int& opos);
	
	int AllocForImage(byte **iout);
	
	int GenerateImage(byte *iout);
	
	int EndBuild();
};
#endif


