#ifndef __LIM_SOCK__
#define __LIM_SOCK__


class LimSock
{
private:
	int sock;
	double bandWidth;
	
public:
	LimSock(int s = 0, double bw = 0);
	
	double GetBandWidth() 
	{
		return bandWidth;
	}
	
	void SetBandWidth(double bw)
	{
		bandWidth = bw;
	}
	
	int Send(void *msg, int len);
	int Recv(void *msg, int len);
	
	operator int()
	{
		return sock;
	}
	
	int *operator&()
	{
		return &sock;
	}
	
	int operator=(int s)
	{
		return (sock = s);
	}
};


#endif
