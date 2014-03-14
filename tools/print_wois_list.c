#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
	int height, width, WprecinctSize, HprecinctSize;
	int offsetx, offsety;

	if (argc!=5)
	{
		printf("\nUso: %s <width> <height> <w_precint_size> <h_precint_size>.\n",argv[0]);
		exit(0);
    	}
	
	width = atoi(argv[1]);	
	height = atoi(argv[2]);
	
    WprecinctSize = atoi(argv[3]);
    HprecinctSize = atoi(argv[4]);

    for(offsetx=0; offsetx<height; offsetx=offsetx + HprecinctSize)
    {
		for(offsety=0; offsety<width; offsety=offsety + WprecinctSize)
		{
			printf("%d %d\n",offsetx,offsety);
		}
	}
	return 0;
}