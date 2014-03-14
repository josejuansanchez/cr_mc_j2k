
// Writing endian-independent code in C
// http://www.ibm.com/developerworks/aix/library/au-endianc/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	if(argc < 2) 
	{
		printf("\nError: Numero de parametros incorrecto!!!\n"
		       "\nUso: %s <Nsop>\n\n",argv[0]);
		return -1;
	}


	short nsop = atoi(argv[1]);
	
	if ((nsop < 0) || (nsop > 65535)) {
		printf("\nError: Numero de SOP incorrecto!!!\n");
		return -1;
	}


	unsigned char sop_0 = 255;
	unsigned char sop_1 = 145;
	unsigned char lsop_0 = 0;
	unsigned char lsop_1 = 4;
	unsigned char body_0 = 192;
	unsigned char body_1 = 0;

	
   	unsigned char c1, c2;
        c1 = nsop & 255;
        c2 = (nsop >> 8) & 255;
        short nsop_reverse= (c1 << 8) + c2;
	

	FILE *f;
	char filename[256] = "";
	strcat(filename, argv[1]);
	strcat(filename, ".j2c");
	f = fopen(filename, "wb");
	fwrite(&sop_0, sizeof(unsigned char), 1, f);
        fwrite(&sop_1, sizeof(unsigned char), 1, f);
	fwrite(&lsop_0, sizeof(unsigned char), 1, f);
	fwrite(&lsop_1, sizeof(unsigned char), 1, f);
	fwrite(&nsop_reverse, sizeof(short), 1, f);
	fwrite(&body_0, sizeof(unsigned char), 1, f);
	fwrite(&body_1, sizeof(unsigned char), 1, f);
	fclose(f);
	
	return 0;
}
