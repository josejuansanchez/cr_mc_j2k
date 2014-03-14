#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libcache.h"

int main(int argc, char *argv[])
{
  int npaFull, nprFull, totalFull;
  packet *packetListFull;
  precinct *precinctListFull;

  int npa, npr, total;
  packet *packetList;
  precinct *precinctList;

  int npe;
  packet *emptyList;

  if (argc<3)
  {
    printf("\nUso: %s <response.j2c.cache> <full.j2c.cache>\n",argv[0]);
    printf("\nIn: <response.j2c.cache> <full.j2c.cache>");
    printf("\nOut: <temp.j2c>\n");
    return -1;
  }  

  /* Response */
  total = GetNumberOfPackets(argv[1]);
  printf("\n[cookcache] # packets in cache: %d\n",total);

  /* Precincts */
  precinctList = (precinct *) malloc (total*sizeof(precinct));
  npr = 0;

  SetPrecinctList(precinctList, &npr, argv[1]);
  SortPrecinctList(precinctList, npr);
  PrintPrecinctList(precinctList, npr);
  printf("\n[cookcache] # precincts in cache: %d\n",npr);

  /* Packets */
  packetList = (packet *) malloc (total*sizeof(packet));
  npa = 0;

  SetPacketList(packetList, &npa, argv[1]);
  SortPacketList(packetList, npa);
  PrintPacketList(packetList, npa);
  printf("\n[cookcache] # different packets in cache: %d\n",npa);

  /*****************************************************************/

  /* Full */
  totalFull = GetNumberOfPackets(argv[2]);
  printf("\n[cookcache] # packets in cache: %d\n",totalFull);

  /* Precincts */
  precinctListFull = (precinct *) malloc (totalFull*sizeof(precinct));
  nprFull = 0;

  SetPrecinctList(precinctListFull, &nprFull, argv[2]);
  SortPrecinctList(precinctListFull, nprFull);
  PrintPrecinctList(precinctListFull, nprFull);
  printf("\n[cookcache] # precincts in cache: %d\n",nprFull);

  /* Packets */
  packetListFull = (packet *) malloc (totalFull*sizeof(packet));
  npaFull = 0;

  SetPacketList(packetListFull, &npaFull, argv[2]);
  SortPacketList(packetListFull, npaFull);
  PrintPacketList(packetListFull, npaFull);
  printf("\n[cookcache] # different packets in cache: %d\n",npaFull);

  /*****************************************************************/

  /* List of empty packets */
  emptyList = (packet *) malloc (totalFull*sizeof(packet));
  npe = 0;

  /* Cooking */
  FindPendingPackets(packetListFull, npaFull, packetList, npa, emptyList, &npe);
  PrintPacketList(emptyList, npe);
  CreateEmptyPackets(emptyList, npe);

  return 0;
}