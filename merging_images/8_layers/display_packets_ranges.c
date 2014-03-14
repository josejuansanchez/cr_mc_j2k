#include <stdio.h>

int main()
{
	int width, height;
	int l, r, c, p;
	int i,j;
	long cont;
	long total = 0;

	/*
	width = 1280;
	height = 768;

	int id = 0;
	for(l=0; l<8; l++) {
		printf("\n\nLayer: %d\n", l);
		for(r=0; r<3; r++) {
			printf("Resolution %d\n", r);
			for(p=0; p<60; p++) {
				printf(" %d ", id);
				id++;
			}
			printf("\n");
		}
	}
	*/

	cont = 0;
	for(i=0; i<=179; i++) {
		cont = i;
	   	printf("Precinct: %d \t Packets: ",i);
	   	for(j=0; j<=7; j++) {
			printf("%ld ", cont);
			cont = cont + 180;
	   	}
	   	printf("\n");
	}
	return 0;
}
