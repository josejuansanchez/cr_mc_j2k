#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libcache.h"

int GetNumberOfPackets(char filename[])
{
  int id, rb, packetId;
  //char data[500];  
  char data[524288];
  int l, r, c, py, px;

  FILE *fc = fopen(filename,"rb");
  if (!fc) return -1;

  fread(&id, sizeof(id), 1, fc);
  fread(&l, sizeof(l), 1, fc);
  fread(&r, sizeof(r), 1, fc);
  fread(&c, sizeof(c), 1, fc);
  fread(&py, sizeof(py), 1, fc);
  fread(&px, sizeof(px), 1, fc);
  fread(&rb, sizeof(rb), 1, fc);
  fread(&data, 1, rb, fc);

  int cont=0;

  while(!feof(fc))
  {
    cont++;

    printf("\n[# %5d] precinctId: %5d \t %5d %5d %5d %5d %5d : %5d",cont,id,l,r,c,py,px,rb);

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

  return cont;
}

int SetPacketList(packet *packetList, int *npa, char filename[])
{
  int id, rb;
  //char data[500];
  char data[524288];
  int l, r, c, py, px;
  long numbyte = 0;

  FILE *fc = fopen(filename,"rb");
  if (!fc) return -1;

  fread(&id, sizeof(id), 1, fc);
  fread(&l, sizeof(l), 1, fc);
  fread(&r, sizeof(r), 1, fc);
  fread(&c, sizeof(c), 1, fc);
  fread(&py, sizeof(py), 1, fc);
  fread(&px, sizeof(px), 1, fc);
  fread(&rb, sizeof(rb), 1, fc);
  fread(&data, 1, rb, fc);

  while(!feof(fc))
  {
    int pos = SearchPacket(packetList,*npa,id,l,r,c,py,px);
    if (pos==-1)
    {
      packetList[*npa].precinctId = id;
      packetList[*npa].l = l;
      packetList[*npa].r = r;      
      packetList[*npa].c = c;
      packetList[*npa].py = py;
      packetList[*npa].px = px;
      packetList[*npa].rb = rb;

      /* Get the packet id from de data */
      /* FF      91      00      04      XX      XX  ... */
      /* data[0] data[1] data[2] data[3] data[4] data[5] */
      int packetId = GetPacketId(data);
      packetList[*npa].packetId = packetId;
      *npa = *npa + 1;

      // TEMPORAL
      // Utilizamos el valor 1440 porque con los parámetros de configuración actuales
      // no podemos tener más de 1440 packets. 
      // Habría que modificarlo para que este valor se cogiese automáticamente.
      // *********************************
      // 3 resolution levels * 60 precints / level = 180 * 8 layers = 1440
      //if (packetId > 1440) {      
      //if (packetId > 1560) {
      //  printf("*********** Error [numByte: %ld]. precinctId: %d \t l: %d \t r: %d \t c: %d \t py: %d \t px: %d \t rb: %4d \t packetId: %d\n", numbyte, id, l, r, c, py, px, rb, packetId);
      //  exit(2);
      //} else {
      //  printf("[numByte: %ld]. precinctId: %d \t l: %d \t r: %d \t c: %d \t py: %d \t px: %d \t rb: %4d \t packetId: %d\n", numbyte, id, l, r, c, py, px, rb, packetId);        
      //}      
      // *********************************

    } else {
      packetList[pos].rb = packetList[pos].rb + rb;
    }

    numbyte += sizeof(id) + sizeof(l) + sizeof(r) + 
             sizeof(c) + sizeof(py) + sizeof(px) + 
             sizeof(rb) + rb;

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
  return 1;
}

int SetPrecinctList(precinct *precinctList, int *npr, char filename[])
{
  int id, rb;
  //char data[500];
  char data[524288];
  int l, r, c, py, px;

  FILE *fc = fopen(filename,"rb");
  if (!fc) return -1;

  fread(&id, sizeof(id), 1, fc);
  fread(&l, sizeof(l), 1, fc);
  fread(&r, sizeof(r), 1, fc);
  fread(&c, sizeof(c), 1, fc);
  fread(&py, sizeof(py), 1, fc);
  fread(&px, sizeof(px), 1, fc);
  fread(&rb, sizeof(rb), 1, fc);
  fread(&data, 1, rb, fc);

  while(!feof(fc))
  {
    int pos = SearchPrecinct(precinctList,*npr,id);  
    if (pos==-1)
    {
      precinctList[*npr].id = id;
      precinctList[*npr].cont = 1;
      *npr = *npr + 1;
    }
    else
    {
      precinctList[pos].cont++;
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
  return 1;
}

int SearchPacket(packet *packetList, int npa, int id, int l, int r, int c, int py, int px)
{
  int pos, i;

  pos = -1;
  for(i=0;i<npa;i++)
  {
    if (packetList[i].precinctId==id && packetList[i].l==l && packetList[i].r==r && packetList[i].c==c && 
        packetList[i].py==py && packetList[i].px==px)
    {
      pos = i;
      break;
    }
  }
  return pos;
}

int SearchPrecinct(precinct *precinctList, int npr, int id)
{
  int pos, i;

  pos = -1;
  for(i=0;i<npr;i++)
  {
    if (precinctList[i].id==id)
    {
      pos = i;
      break;
    }
  }
  return pos;
}

void PrintPacketList(packet *packetList, int npa)
{
  int i;

  int id;
  int l;
  int r;
  int c;
  int py;
  int px;
  int rb;

  for (i=0;i<npa;i++)
  {
    printf("\n[# %5d] precinctId: %5d \t packetId: %5d \t l: %5d \t r: %5d \t c: %5d \t py: %5d \t px: %5d \t rb: %5d",
    i, packetList[i].precinctId, packetList[i].packetId, packetList[i].l, packetList[i].r, 
    packetList[i].c, packetList[i].py, packetList[i].px, packetList[i].rb);
  }
  printf("\n");
}

void PrintPrecinctList(precinct *precinctList, int npr)
{
  int i;

  for (i=0;i<npr;i++)
  {
    printf("\n[%5d] id: %3d \t # packets: %d",i,precinctList[i].id,precinctList[i].cont);
  }
  printf("\n");
}

void SortPacketList(packet *packetList, int npa)
{
    long i,j,k;
    packet aux;

    for(i=0;i<=npa-2;i++)
    {
      k = i;
      for(j=i+1;j<=npa-1;j++)
      {
        if (packetList[j].precinctId < packetList[k].precinctId ||
            ((packetList[j].precinctId == packetList[k].precinctId) && packetList[j].l < packetList[k].l) ||
            ((packetList[j].precinctId == packetList[k].precinctId) && (packetList[j].l == packetList[k].l) && (packetList[j].r < packetList[k].r)) ||
            ((packetList[j].precinctId == packetList[k].precinctId) && (packetList[j].l == packetList[k].l) && (packetList[j].r == packetList[k].r) && (packetList[j].c < packetList[k].c)) ||            
            ((packetList[j].precinctId == packetList[k].precinctId) && (packetList[j].l == packetList[k].l) && (packetList[j].r == packetList[k].r) && (packetList[j].c== packetList[k].c) && (packetList[j].py < packetList[k].py))
            )
        {
          k = j;
        }
      }
      aux = packetList[k];
      packetList[k] = packetList[i];
      packetList[i] = aux;
    }
}

void SortPacketListByPacketId(packet *packetList, int npa)
{
    long i,j,k;
    packet aux;

    for(i=0;i<=npa-2;i++)
    {
      k = i;
      for(j=i+1;j<=npa-1;j++)
      {
        if (packetList[j].packetId <= packetList[k].packetId)
        {
          k = j;
        }
      }
      aux = packetList[k];
      packetList[k] = packetList[i];
      packetList[i] = aux;
    }
}


void SortPrecinctList(precinct *precinctList, int npr)
{
    long i,j,k;
    precinct aux;

    for(i=0;i<=npr-2;i++)
    {
      k = i;
      for(j=i+1;j<=npr-1;j++)
      {
        if (precinctList[j].id < precinctList[k].id)
        {
          k = j;
        }
      }
      aux = precinctList[k];
      precinctList[k] = precinctList[i];
      precinctList[i] = aux;
    }
}

void FindPendingPackets(packet *packetListFull, int npaFull, packet *packetList, int npa, packet *emptyList, int *npe)
{

  int i, j;
  for(i=0; i<npa; i++) 
  {
      for(j=0; j<npaFull; j++) {         
         if (packetList[i].precinctId == packetListFull[j].precinctId) {

            int pos = SearchPacket(packetList, npa, packetListFull[j].precinctId, 
               packetListFull[j].l, packetListFull[j].r, packetListFull[j].c, packetListFull[j].py, packetListFull[j].px);

            if (pos == -1) {

               int posel = SearchPacket(emptyList, *npe, packetListFull[j].precinctId, 
                  packetListFull[j].l, packetListFull[j].r, packetListFull[j].c, packetListFull[j].py, packetListFull[j].px);

               if (posel == -1) {

                  emptyList[*npe] = packetListFull[j];
                  *npe = *npe + 1;

                  printf("[PrecinctId: %5d] \t PacketId: %5d \t l: %d \t r: %d \t c: %d \t py: %d \t px: %d\n", 
                     packetListFull[j].precinctId, packetListFull[j].packetId, packetListFull[j].l, 
                     packetListFull[j].r, packetListFull[j].c, packetListFull[j].py, packetListFull[j].px);
               }
            }
         }
      }
      //printf("\n");
  }
}

int GetPacketId(char data[]) {
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

void CreateEmptyPackets(packet *emptyList, int npe) {

   /* Create an empty packet */
   /* FF 91 00 04 XX XX 80 00 */

   unsigned char sop_0 = 255;
   unsigned char sop_1 = 145;
   unsigned char lsop_0 = 0;
   unsigned char lsop_1 = 4;
   unsigned char body_0 = 0; //128;
   //unsigned char body_1 = 0;

   FILE *f;
   char filename[256] = "emptypackets";
   strcat(filename, ".j2c.cache");
   f = fopen(filename, "wb");

   int i;
   for(i=0; i<npe; i++) {

      short nsop = emptyList[i].packetId;

      unsigned char c1, c2;
      c1 = nsop & 255;
      c2 = (nsop >> 8) & 255;
      short nsop_reverse= (c1 << 8) + c2;   

      fwrite(&emptyList[i].precinctId, sizeof(emptyList[i].precinctId), 1, f);
      fwrite(&emptyList[i].l, sizeof(emptyList[i].l), 1, f);
      fwrite(&emptyList[i].r, sizeof(emptyList[i].r), 1, f);
      fwrite(&emptyList[i].c, sizeof(emptyList[i].c), 1, f);
      fwrite(&emptyList[i].py, sizeof(emptyList[i].py), 1, f);
      fwrite(&emptyList[i].px, sizeof(emptyList[i].px), 1, f);
      
      int rb = 7; //8;
      fwrite(&rb, sizeof(rb), 1, f);

      fwrite(&sop_0, sizeof(unsigned char), 1, f);
      fwrite(&sop_1, sizeof(unsigned char), 1, f);
      fwrite(&lsop_0, sizeof(unsigned char), 1, f);
      fwrite(&lsop_1, sizeof(unsigned char), 1, f);
      fwrite(&nsop_reverse, sizeof(short), 1, f);
      fwrite(&body_0, sizeof(unsigned char), 1, f);
      //fwrite(&body_1, sizeof(unsigned char), 1, f);
   }

   fclose(f);
}

int CacheToJ2C(char filenameIn[], char filenameOut[], packet *packetList, int npa)
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
        fwrite(&data, 1, rb, fout);

        printf("packetId: %d\n", packetId);
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