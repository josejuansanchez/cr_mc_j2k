#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libcache.h"

int main(int argc, char *argv[])
{
  int npa, npr, total;
  packet *packetList;
  precinct *precinctList;

  if (argc<2)
  {
    printf("\nUso: %s <filename.j2c.cache>\n",argv[0]);
    return -1;
  }  

  printf("\n[viewcache][begin] packets in cache\n");
  total = GetNumberOfPackets(argv[1]);
  printf("\n[viewcache][end] # packets in cache: %d\n",total);

  /* Precincts */
  precinctList = (precinct *) malloc (total*sizeof(precinct));
  npr = 0;

  SetPrecinctList(precinctList, &npr, argv[1]);
  SortPrecinctList(precinctList, npr);
  printf("\n[viewcache][begin] precincts in cache\n");
  PrintPrecinctList(precinctList, npr);
  printf("\n[viewcache][end] # precincts in cache: %d\n",npr);

  /* Packets */
  packetList = (packet *) malloc (total*sizeof(packet));
  npa = 0;

  SetPacketList(packetList, &npa, argv[1]);
  SortPacketList(packetList, npa);
  printf("\n[viewcache][begin] different packets in cache\n");
  PrintPacketList(packetList, npa);
  printf("\n[viewcache][end] # different packets in cache: %d\n",npa);

  return 0;
}