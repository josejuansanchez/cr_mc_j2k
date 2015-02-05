#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *f;
	int c;
	long cont1, cont2;

	if (argc<4)
	{
		printf("\nUso: %s <archivo.j2c> <offset> <length>\n",argv[0]);
		return 0;
	}

	f=fopen(argv[1],"rb");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s\n",argv[1]);
		return 0;
	}

	long offset = atoi(argv[2]);
	long length = atoi(argv[3]);
	
	fseek(f, offset, SEEK_SET );

	cont1 = 0;
	cont2 = 0;
	c=fgetc(f);
	while(!feof(f) && cont1<length)
	{
		cont1++;
		cont2++;

		//printf("%2x ",c);
		if (c<=15) printf("0");
		printf("%x ",c);

		if (cont2==8) 
		{
			printf(" ");
		}
		else
		{
			if (cont2==16)
			{
		 		printf("\n"); 
				cont2=0;
			}
		}
		c = fgetc(f);
	}
	printf("\n");
	fclose(f);

	return 0;
}