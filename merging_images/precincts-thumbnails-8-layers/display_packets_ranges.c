#include <stdio.h>

#define MAX_R 3
#define MAX_L 8
#define MAX_P 30

int main()
{
	int l, r, p;
	long idprecinct;
	long idpacket;

	// RLCP
	for(r = 0; r < MAX_R; r++) {
		for(p = 0; p < MAX_P; p++) {

			idprecinct = p + (r * MAX_P);
			idpacket = p + (r * MAX_P * MAX_L);

			printf("Precinct: %ld \t Packets: ",idprecinct);

			for(l = 0; l < MAX_L; l++) {
				printf("%ld ", idpacket);
				idpacket = idpacket + MAX_P;
			}
			printf("\n");
		}
	}

	return 0;
}
