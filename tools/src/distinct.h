typedef struct
{
	long offset;
	long length;
} offset;

int NumeroDeOffsetList(char *filename);
int LeerOffsetList(char *filename, offset *lista, long *ne);
int EscribirOffsetList(char *filename, offset *lista, long ne);
void EliminarRepetidosOne(offset *listaIn, long neIn, offset *listaOut, long *neOut);
void EliminarRepetidosTwo(offset *listaA, long neA, offset *listaB, long neB, offset *listaOut, long *neOut);
double SumBytes(offset *lista, long ne);
void OrdenarSeleccionDirecta(offset precints[], long np);