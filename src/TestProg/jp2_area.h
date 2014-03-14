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

  packet_data()
  {
    offset = 0;
    length = 0;
    woi = false;
    cached = 0;
  }
};


struct woi
{
  int x;
  int y;
  int w;
  int h;
  int r;

  woi()
  {
    x = 0;
    y = 0;
    w = 0;
    h = 0;
    r = 0;
  }

  woi(int x, int y, int w, int h, int r)
  {
    this->x = x;
    this->y = y;
    this->w = w;
    this->h = h;
    this->r = r;
  }
};


class jp2_area
{
private:
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
  int load_woi_to_cache(JP2Cache& cache, int max_bytes, bool check_cached, int qlayer);
  bool decode_from_codestream(kdu_codestream& codestream, kdu_byte *buf);

public:
  jp2_area()
  {
    cur_name = NULL;
  }

  bool open(char *fname);

  void set_woi(woi new_woi);
  void clear_woi();
  int load_woi(int max_bytes, int qlayer);

  kdu_byte *create_buffer();
  bool decode(kdu_byte *buf);

  bool decode_complete(kdu_byte *buf, int qlayer);

  void close();

  long sum_qlayer_bytes_packets(int qlayer);

  virtual ~jp2_area()
  {
    close();
  }
};


#endif
