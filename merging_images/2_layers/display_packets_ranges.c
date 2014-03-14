#include <stdio.h>

int main()
{
	int width, height;
	int l, r, c, p;
	int i,j;
	long cont;
	long total = 0;

	cont = 0;
	for(i=0; i<=179; i++) {
		cont = i;
	   	printf("Precinct: %d \t Packets: ",i);
	   	for(j=0; j<=1; j++) {
			printf("%ld ", cont);
			cont = cont + 180;
	   	}
	   	printf("\n");
	}
	return 0;
}
