#include <stdio.h>
#include <stdlib.h>

#define DEBUG 0

int main(int argc, char *argv[])
{
	int width_image, height_image;
	int width_precinct_size, height_precinct_size;
	int total_number_of_wois;
    int i, j;

	if (argc < 5) {
		printf("\nUsage: %s <width_image> <height_image> <width_precinct_size> <height_precinct_size>\n", argv[0]);
		exit(1);
	}

	width_image = atoi(argv[1]);
	height_image = atoi(argv[2]);	
	width_precinct_size = atoi(argv[3]);
	height_precinct_size = atoi(argv[4]);

	if (DEBUG) {
		printf("width_image: %d\n", width_image);
		printf("height_image: %d\n", height_image);
		printf("width_precinct_size: %d\n", width_precinct_size);
		printf("height_precinct_size: %d\n", height_precinct_size);		
	}

    // Calculate the total number of WOIs
    total_number_of_wois = (height_image/height_precinct_size)*(width_image/width_precinct_size);

    if (DEBUG) printf("Total number of WOIS: %d\n", total_number_of_wois);

    for(i=0; i<height_image; i=i+height_precinct_size)
    {
    	for(j=0; j<width_image; j=j+width_precinct_size)
        {
        	if (DEBUG) 
        		printf("j: %4d \t i: %4d\n", j, i);
        	else 
        		printf("%4d %4d\n", j, i);
        }
        if (DEBUG) printf("\n");
    }

	return 0;
}