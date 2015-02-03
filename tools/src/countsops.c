#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *f;
	int c1, c2, c3, c4;
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
	long numByte = 1;
	long startByte = -1;
	while(!feof(f))
	{
		if (c1==0xFF)
		{
			c2 = fgetc(f);
			numByte++;
			//printf("\n%X",c2);
			if (c2==0x91)
			{
				c3 = fgetc(f);
				numByte++;
				if (c3==0x00)
				{
					c4 = fgetc(f);
					numByte++;
					if (c4==0x04)
					{
						if (startByte != -1) {
							printf(" \t Size: %ld\n\n", (numByte - startByte));
						}
						startByte = numByte;

						printf("Cont: %ld \t Start at Byte: %ld \t - %X %X - ", cont, (numByte - 4), c1, c2);
						cont++;
					}
				}
			}
		}
		c1 = fgetc(f);
		numByte++;
	}
	fclose(f);

	// NOTA: El último paquete incluye el marcador 0xFFD9 - EOC (End Of Code-stream)
	printf(" \t Size: %ld\n\n", (numByte - startByte) + 1);
	printf("\n# SOPs: %ld\n", cont);

	return 0;
}