#include <stdio.h>

//#define MAX_PRECINCT 180	// stockholm and tree
#define MAX_PRECINCT 90			// speedway
#define MAX_LAYERS 1

int main()
{
	int width, height;
	int l, r, c, p;
	int i,j;
	long cont;
	long total = 0;

	cont = 0;
	for(i=0; i<MAX_PRECINCT; i++) {
		cont = i;
		printf("Precinct: %d \t Packets: ",i);
		for(j=0; j<MAX_LAYERS; j++) {
			printf("%ld ", cont);
			cont = cont + MAX_PRECINCT;
		}
		printf("\n");
	}
	return 0;
}
