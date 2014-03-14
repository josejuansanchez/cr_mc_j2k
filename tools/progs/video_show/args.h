#ifdef __cplusplus
extern "C" {
#endif

int   args__help(char **arg,char *s,...);
char *args__get( char *str_to_find, int narg, char **arg);
int   args__exist(char *str_to_find, int narg, char **arg);

#define ARGS__GET(str)   args__get(  str,argc,argv)
#define ARGS__EXIST(str) args__exist(str,argc,argv)

#ifdef __cplusplus
}
#endif
