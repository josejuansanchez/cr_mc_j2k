#include "cstring" /* strstr() */
#include "args.h"

bool args::exist_arg(char *str_to_find) {
  int i;
  for(i=0;i<argc;i++) {
    if(strstr(argv[i],str_to_find)) {
      ptr = argv[i+1];
      return true;
    }
  }
  return false;
}
char *args::get_arg() {
    return ptr;
}

