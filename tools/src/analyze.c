#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *f;
	long idframe;
	double psnrpreci, psnrtrunc;	
	long contgt, contlt, conteq;
	double diff, maxdiff;
	double sum;

	if (argc != 2)
	{
		printf("\nUso: %s <filename_in>\n",argv[0]);
		exit(1);
	}

	f = fopen(argv[1],"r");
	if (f==NULL)
	{
		printf("\nError al abrir el archivo: %s.\n",argv[1]);
		exit(1);
	}

	contgt = 0;
	contlt = 0;
	conteq = 0;
	maxdiff = 0;
	sum = 0;

	fscanf(f,"%ld %lf %lf",&idframe,&psnrpreci,&psnrtrunc);
	while(!feof(f))
	{
		if (psnrpreci > psnrtrunc)
		{
			contgt = contgt + 1;

			// Calculamos diferencia entre PSNRs
			diff = psnrpreci - psnrtrunc;

			if (diff > maxdiff)
			{
				maxdiff = diff;
			}

			// Incrementamos la diferencia de PSNRs
			sum = sum + diff;
		}
		else
		{
			if (psnrpreci < psnrtrunc)
			{
				contlt = contlt + 1;
			}
			else
			{
				conteq = conteq + 1;
			}
		}


		//printf("\n%ld %lf %lf",idframe,psnrpreci,psnrtrunc);
		fscanf(f,"%ld %lf %lf",&idframe,&psnrpreci,&psnrtrunc);
	}

	printf("\ncontgt: %ld \t contlt: %ld \t conteq: %ld",contgt, contlt, conteq);
	printf("\nmaxdiff: %lf",maxdiff);
	printf("\nsum: %lf \n",sum);

	fclose(f);
	
	return 0;
}

