#include <string.h>
#include "Args.h"


Args::Args()
{
	argc = 0;
	argv = NULL;
}

Args::Args(char **l, int nl)
{
	argc = nl;
	argv = l;
}

Args& Args::Attach(char **l, int nl)
{
	argc = nl;
	argv = l;
	return *this;
}
	
char *Args::Get(char *c)
{
	for(int i = 0; i < argc; i++)
		if(!strcmp(argv[i], c) && (i < (argc - 1))) 
			return argv[i + 1];
	
	return NULL;	
}
