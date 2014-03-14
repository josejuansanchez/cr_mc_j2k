#include <errno.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include "LimSock.h"


static int nsleep(double sleep_time)
{
	int rval;
	timespec tv;

 	tv.tv_sec = (time_t)sleep_time;
 	tv.tv_nsec = (long)((sleep_time - tv.tv_sec) * 1e+9);

 	while(1)
 	{
  		rval = nanosleep (&tv, &tv);
  		if(rval == 0) return 0;
  		else if(errno == EINTR) continue;
		else return rval;
 	}
	
 	return 0;
}

LimSock::LimSock(int s, double bw)
{
	sock = s;
	bandWidth = bw;
}

int LimSock::Send(void *msg, int len)
{
	int nb = send(sock, msg, len, 0);
	
	if((nb >= 0) && (bandWidth > 0)) nsleep((double)nb / bandWidth); 
	
	return nb;
}
		
int LimSock::Recv(void *msg, int len)
{
	int nb = recv(sock, msg, len, 0);
	
	if((nb >= 0) && (bandWidth > 0)) nsleep((double)nb / bandWidth); 
	
	return nb;	
}
	
