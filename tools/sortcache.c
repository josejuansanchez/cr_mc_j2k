#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libcache.h"

int SaveCacheSorted(char filenameIn[], char filenameOut[], packet *packetList, int npa);

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

  printf("\n[sortcache][begin] packets in cache\n");
  total = GetNumberOfPackets(argv[1]);
  printf("\n[sortcache][end] # packets in cache: %d\n",total);

  /* Precincts */
  precinctList = (precinct *) malloc (total*sizeof(precinct));
  npr = 0;

  SetPrecinctList(precinctList, &npr, argv[1]);
  SortPrecinctList(precinctList, npr);
  printf("\n[sortcache][begin] precincts in cache\n");
  PrintPrecinctList(precinctList, npr);
  printf("\n[sortcache][end] # precincts in cache: %d\n",npr);

  /* Packets */
  packetList = (packet *) malloc (total*sizeof(packet));
  npa = 0;
  
  SetPacketList(packetList, &npa, argv[1]);
  // Begin: Only for debug purpose
  SortPacketList(packetList, npa);
  printf("\n[sortcache][debug purpose][begin] different packets in cache\n");
  PrintPacketList(packetList, npa);	
  printf("\n[sortcache][debug purpose][end] # different packets in cache: %d\n",npa);
  // End: Only for debug purpose
  SortPacketListByPacketId(packetList, npa);
  printf("\n[sortcache][begin] different packets in cache\n");  
  PrintPacketList(packetList, npa);
  printf("\n[sortcache][end] # different packets in cache: %d\n",npa);

  /* Create the new file */
  char filenameOut[255];
  strcpy(filenameOut, argv[1]);
  strcat(filenameOut,".ord");
  if (SaveCacheSorted(argv[1], filenameOut, packetList, npa)==-1)
  {
	printf("[sortcache] Failed to create file: %s.\n",filenameOut);
  }
  else
  {
	printf("[sortcache] File: %s created successfully.\n",filenameOut);
  }

  // TEST
  /*
  strcpy(filenameOut,"temp.j2c");
  if (CacheToJ2C(argv[1], filenameOut, packetList, npa)==-1)
  {
	printf("[sortcache] Failed to create file: %s.\n",filenameOut);
  }
  else
  {
	printf("[sortcache] File: %s created successfully.\n",filenameOut);
  }
  */
  return 0;
}

int SaveCacheSorted(char filenameIn[], char filenameOut[], packet *packetList, int npa)
{
	int id, rb, i;
	//char data[500];
  	char data[524288];	
	int l, r, c, py, px;
	FILE *fin;
	
	FILE *fout = fopen(filenameOut,"wb");
	if (!fout) return -1;

	/* Recorremos la lista de ids */
	for(i=0;i<npa;i++)
	{
		fin = fopen(filenameIn,"rb");
		if (!fin) return -1;

		/* Leemos los datos de un paquete del archivo de caché de entrada */
		fread(&id, sizeof(id), 1, fin);
		fread(&l, sizeof(l), 1, fin);
		fread(&r, sizeof(r), 1, fin);
		fread(&c, sizeof(c), 1, fin);
		fread(&py, sizeof(py), 1, fin);
		fread(&px, sizeof(px), 1, fin);
		fread(&rb, sizeof(rb), 1, fin);
		fread(&data, 1, rb, fin);

      	/* Get the packet id from de data */
      	/* FF      91      00      04      XX      XX  ... */      
      	int packetId = GetPacketId(data);

		/* Buscamos en el archivo todos los paquetes que tengan el id que buscamos */
		while(!feof(fin))
		{
			if (packetList[i].packetId == packetId)
			{
				/* Guardamos los datos en el archivo de salida */
				fwrite(&id, sizeof(id), 1, fout);
				fwrite(&l, sizeof(l), 1, fout);
				fwrite(&r, sizeof(r), 1, fout);
				fwrite(&c, sizeof(c), 1, fout);
				fwrite(&py, sizeof(py), 1, fout);
				fwrite(&px, sizeof(px), 1, fout);
				fwrite(&rb, sizeof(rb), 1, fout);
				fwrite(&data, 1, rb, fout);
			}

			/* Leemos un nuevo paquete de datos */
			fread(&id, sizeof(id), 1, fin);
			fread(&l, sizeof(l), 1, fin);
			fread(&r, sizeof(r), 1, fin);
			fread(&c, sizeof(c), 1, fin);
			fread(&py, sizeof(py), 1, fin);
			fread(&px, sizeof(px), 1, fin);
			fread(&rb, sizeof(rb), 1, fin);
			fread(&data, 1, rb, fin);

      		/* Get the packet id from de data */
      		/* FF      91      00      04      XX      XX  ... */      
      		packetId = GetPacketId(data);

		}
		fclose(fin);
	}
	fclose(fout);
	return 1;
}