/*
 * args.c -- Manipulaci'on de los par'ametros de entrada.
 * gse. 2005.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
//#include "/home/vruiz/src/print/print.h"
#include "args.h"

#define HELP_CODE 1

/* Ayuda */
int args__help(char **arg,char *s,...) {
  if(arg[1]) {
    if((arg[1][0]=='-') & (arg[1][1]=='h')) {
      char *ss;                   /* Cadena para recorrer ... */
      char *aux;                  /* Cadena auxiliar */
      va_list args;               /* Puntero a ... */
      unsigned lmax;              /* Longitud de la cadena m s larga */
      unsigned i;                 /* Iterador */
      
      va_start(args,s);           /* argptr apunta al array de cosas ... */
      
      /* Primero averiguamos cu'al es la cadena de m'as longitud */
      lmax=strlen(s);             /* Longitud de la primera cadena */
      ss=(char *)va_arg(args,char *);     /* Extraemos la primera cadena de ... */
      while(ss) {                         /* Mientras ss!=NULL */
        unsigned lss=strlen(ss);              /* Longitud de la cadena extraida */
        if(lss>lmax) lmax=lss;           /* Nos quedamos con la m xima longitud */
        ss=(char *)va_arg(args,char *);  /* Leemos la siguiente cadena de ... */
      }
      
      /* Podemos asignar memoria a la cadena auxliar */
      aux=(char *)calloc(lmax+4,sizeof(char));
      if(!aux) {
        printf("Help: Sin memoria para aux. lmax=%d",lmax);
        exit(HELP_CODE);
      }
      
      /* Colocamos los filos de la cadena auxiliar  */
      for(i=0;i<lmax+4;i++) {
        aux[i]=' ';
      }
      aux[0]='|';
      aux[lmax+3]='|';
      aux[lmax+4]=(char)NULL;
      
      /* Ahora imprimimos las cadenas */
      /* printf("%s\n",AiNo(arg[0]));*/
      /* Pintamos la fila de arriba del recuadro */
      {
        printf("+");
        for(i=0;i<lmax+2;i++) {
          printf("-");
        }
        printf("+\n");
      }
      
      /* Copiamos dentro del frame la primera cadena */
      for(i=0;i<strlen(s);i++) {
        aux[i+2]=s[i];
      }
      
      printf("%s\n",aux); /* Pintamos la primera cadena */
      
      va_start(args,s);         /* arpptr apunta al array de cosas ... */
      ss=(char *)va_arg(args,char *);
      while(ss) {
        if(ss[0]=='#') {            /* Orden de pintar una linea vertical */
          printf("+");
          for(i=0;i<lmax+2;i++) {
            printf("-");
          }
          printf("+\n");
          
          /* Desechamos el '#' */
          ss=(char *)va_arg(args,char *);
        }
        /* Borramos la cadena de salida, excepto los filos */
        for(i=1;i<lmax+3;i++) {
          aux[i]=' ';
        }
        
        /* Copiamos la cadena a sacar sobre la cadena auxiliar limpita */
        for(i=0;i<strlen(ss);i++) {
          aux[i+2]=ss[i];
        }
        printf("%s\n",aux);
        ss=(char *)va_arg(args,char *);
      }
      /*	va_end(argptr);*/
      va_end(args);
      
      /* Pintamos la fila de abajo del recuadro */
      {
        printf("+");
        for(i=0;i<lmax+2;i++) {
          printf("-");
        }
        printf("+\n");
      }
      printf("/* Compilation date: %s %s */\n",__DATE__,__TIME__);
      printf("/* Running under: %s */\n",getenv("HOSTTYPE"));
      printf("/* gse. 2000. */\n");
      return (HELP_CODE);
    }
  } else return 0;
}

/*
 * Busca la cadena 'str_to_find' en el array de cadenas 'arg'.
 * Si la encuentra, devuelve la siguiente cadena situada a continuacio'n.
 * En caso contrario devuelve NULL.
 */
char *args__get(char *str_to_find, int narg, char **arg) {
    int i;                              /* Iterador */
    for(i=0;i<narg;i++)                 /* Para cada argumento de entrada */
        if(strstr(arg[i],str_to_find))  /* Si encontramos la cadena buscada */
            return arg[i+1];            /* Retornamos el siguiente argumento */
    return NULL;                        /* Si no encontramos la cadena */
}


/*
 * Return 1 if the strind 'str_to_find' is in the command line 'arg'
 */
int args__exist(char *str_to_find, int narg, char **arg) {
  int i;
  for(i=0;i<narg;i++)
    if(strstr(arg[i],str_to_find)) return 1;
  return 0;
}
