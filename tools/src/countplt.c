#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *f;
	int c1, c2;
	long cont;

	if (argc<2)
	{
		printf("\nUso: %s <archivo.j2c>\n",argv[0]);
		return 0;
	}

	f=fopen(argv[1],"rb");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s\n",argv[1]);
		return 0;
	}

	cont = 0;
	c1=fgetc(f);
	while(!feof(f))
	{
		if (c1==0xFF)
		{
			c2 = fgetc(f);
			//printf("\n%X",c2);
			if (c2==0x58)
			{
				cont++;
			}
		}
		c1 = fgetc(f);
	}
	fclose(f);

	printf("\n# PLTs: %ld\n", cont);

	return 0;
}