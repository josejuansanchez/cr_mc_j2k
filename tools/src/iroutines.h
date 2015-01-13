
typedef struct
{
	double countDifferences;
	long offsetx;
	long offsety;
	long qualitylayer;
} precint;

void allocate2D(unsigned char** image, int rows, int cols);
void deallocate2D(unsigned char** image, int rows);
void differences(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols);
void drawCodeblock(unsigned char **image, long offsetx, long offsety, long color, long precinctSize);
void drawAllCodeblocks(unsigned char **image, long rows, long cols, long precinctSize);
void countDifferences(unsigned char **image, long rows, long cols, unsigned char precision, precint *precincts, long precinctSize, int metricDistance);
void printCodeblock(unsigned char **image, long offsetx, long offsety, long precinctSize);
double averageDifference(precint *precincts, long np);
void averageStats(precint *precincts, long np, double avg, long *contUp, long *contDown, long *contEqual);
void initializeImage(unsigned char **image, long rows, long cols, unsigned char value);
void printPrecinctsList(precint *precincts, long np);
void precinctsAvgUpToImage(precint *precincts, long np, double avg, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize);
void precinctsAvgDownToImage(precint *precincts, long np, double avg, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize);
void OrdenarSeleccionDirecta(precint *precincts, long np);
int writePrecinctsToFile(precint *precincts, long np, char *filename);
int readPrecinctsToFile(precint *precincts, long *np, char *filename);
int writePrecinctsAvgDownToFile(precint *precincts, long np, char *filename, double avg);
int writePrecinctsAvgUpToFile(precint *precincts, long np, char *filename, double avg);
void MaxPrecinctsToImage(precint *precincts, long np, long max, unsigned char **imageIn, unsigned char **imageOut, long rows, long cols, long precinctSize);
void sum(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols);
int writePrecinctsToFileTXT(precint *precincts, long start, long end, char *filename);
void printPrecinctsListQualityLayer(precint *precincts, long np);
void CalculateQualityLayer(precint *precincts, long np, long maxqualitylayer);
int writePrecinctsWithQualityLayerToFile(precint *precincts, long np, char *filename);
int readPrecinctsWithQualityLayerFromFile(precint *precincts, long *np, char *filename);
int readPrecinctsFromFileTXT(precint *precincts, long *np, char *filename);
void differencesABS(unsigned char **imageA, unsigned char **imageB, unsigned char **imageC, long rows, long cols);
long countPrecinctsFromFileTXT(char *filename);
int TXTtoDAT(char *filenameIn, char *filenameOut);
void drawCodeblock_WH(unsigned char **image, long offsetx, long offsety, long color, long WprecinctSize, long HprecinctSize);
