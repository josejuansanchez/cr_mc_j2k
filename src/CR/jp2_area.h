#ifndef __JP2_AREA__
#define __JP2_AREA__


#include <stdio.h>
#include <limits.h>
#include "../JP2Util/JP2Util.h"


struct packet_data
{
  int id;
  int offset;
  int length;
  bool woi;
  int cached;
  int qlayer;
  int woi_number;

  packet_data()
  {
    offset = 0;
    length = 0;
    woi = false;
    cached = 0;
    qlayer = 0;
    woi_number = -1;
  }
};


struct woi
{
  int x;
  int y;
  int w;
  int h;
  int r;
  int q;

  woi()
  {
    x = 0;
    y = 0;
    w = 0;
    h = 0;
    r = 0;
    q = 0;
  }

  woi(int x, int y, int w, int h, int r, int q)
  {
    this->x = x;
    this->y = y;
    this->w = w;
    this->h = h;
    this->r = r;
    this->q = q;
  }
};

struct index_packet
{
    int l;
    int r;
    int c;
    int py;
    int px;

    index_packet()
    {
	     l = 0;
    	 r = 0;
	     c = 0;
	     py = 0;
	     px = 0;
    }

    index_packet(int l, int r, int c, int py, int px)
    {
	     this->l = l;
	     this->r = r;
	     this->c = c;
	     this->py = py;
	     this->px = px;
    }
};

class jp2_area
{
public:
//private:
  JP2Cache cache;
  kdu_codestream codestream;

  woi cur_woi;
  char *cur_name;

  int res;
  int num_l;
  int *num_r;
  int **num_c;
  int ***num_px;
  int ***num_py;
  packet_data *****packets;

  int get_short(FILE *f, kdu_byte *buf = NULL);
  void get_packet_data(FILE *f, packet_data& p);
  int load_woi_to_cache(JP2Cache& cache, double max_bytes, bool check_cached);
  bool decode_from_codestream(kdu_codestream& codestream, kdu_byte *buf);

//public:

  woi woi_reconstructed;
  index_packet *index_list;
  int ne;
  int num_packets;
  bool *id_list;
  int ne_id_list;
  int prog;		// Tipo de progresión. 0: LRCP / 1: RLCP / 2: RPCL /

  jp2_area()
  {
    cur_name = NULL;
  }

  bool open(char *fname);
  void close();

  void set_woi(woi new_woi);
  double set_woi_and_load_cache(woi new_woi, JP2Cache& cache, double sum_bytes, double max_bytes, int woi_number);
  void clear_woi();

  kdu_byte *create_buffer();

  bool decode(kdu_byte *buf);
  bool decode_complete(kdu_byte *buf);
  bool decode(kdu_byte *buf, JP2Cache& cache_aux, index_packet index_list[], int ne);
  bool decode_from_cache(kdu_byte *buf, JP2Cache& cache_aux);

  int load_woi(double max_bytes);
  int load_wois_cache(JP2Cache& cache, double max_bytes, bool check_cached, index_packet index_list[], int ne);
  int load_wois_cache_and_update_index_list(JP2Cache& cache, double max_bytes, bool check_cached);
  bool load_cache_from_file(JP2Cache& cache, char *filename_cache);
  bool load_cache_from_file_without_id_list(JP2Cache& cache, char *filename_cache);

  void create_index_and_id_list();

  long get_precint_id(int l, int r, int c, int py, int px);
  bool woi_to_lrcp_original(char filename_woi[], int w, int h, int r, int q);
  bool woi_to_lrcp_modified(char filename_woi[], int w, int h, int r, int q);
  bool sort_lrcp_file_type_1(int layersLevel, int resolutionLevels);
  bool sort_lrcp_file_type_2(int layersLevel, int resolutionLevels);  
  int load_wois_cache_and_update_index_list_TEST(JP2Cache& cache, double max_bytes, int lrcp_type);
  void id_to_lrcp(long id, int &l, int &r, int &c, int &py, int &px);
  int save_packets_to_file();

  int GetPacketId(kdu_byte data[]);

  virtual ~jp2_area()
  {
    close();
  }
};


#endif