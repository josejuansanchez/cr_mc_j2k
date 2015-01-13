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

	c1=fgetc(f);
	cont = 1;
	while(!feof(f))
	{
		if (c1==0xFF)
		{
			c2 = fgetc(f);
			cont++;
			printf("\n%X",c2);
			if (c2==0x93)
			{
				break;
			}
		}
		c1 = fgetc(f);
		cont++;
	}
	fclose(f);

	printf("\n# Bytes: %ld\n", cont);

	return 0;
}

