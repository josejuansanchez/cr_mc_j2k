#ifndef __ARGS_H__
#define __ARGS_H__


class Args
{
private:
	int argc;
	char **argv;
	
public:
	Args();
	Args(char **l, int nl);
	
	Args& Attach(char **l, int nl);
	
	char *Get(char *c);
	
	char *operator[](char *c)
	{
		return Get(c);
	}
};

#endif
