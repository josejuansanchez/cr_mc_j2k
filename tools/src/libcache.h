typedef struct
{
  int precinctId;
  int packetId;
  int l;
  int r;
  int c;
  int py;
  int px;
  int rb;
} packet;

typedef struct 
{
  int id;
  int cont;
} precinct;


int GetNumberOfPackets(char filename[]);
int SetPacketList(packet *packetList, int *npa, char filename[]);
int SetPrecinctList(precinct *precinctList, int *npr, char filename[]);
int SearchPacket(packet *packetList, int npa, int id, int l, int r, int c, int py, int px);
int SearchPrecinct(precinct *precinctList, int npr, int id);
void PrintPacketList(packet *packetList, int npa);
void PrintPrecinctList(precinct *precinctList, int npr);
void SortPacketList(packet *packetList, int npa);
void SortPacketListByPacketId(packet *packetList, int npa);
void SortPrecinctList(precinct *precinctList, int npr);
void FindPendingPackets(packet *packetListFull, int npaFull, packet *packetList, int npa, packet *emptyList, int *npe);
int GetPacketId(char data[]);
void CreateEmptyPackets(packet *emptyList, int npe);
int CacheToJ2C(char filenameIn[], char filenameOut[], packet *packetList, int npa);