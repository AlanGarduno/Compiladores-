#include "hoc.h"
#include <stdio.h>
static Symbol *symlist=0;    /* tabla de simbolos: lista ligada */

Symbol *lookup(char *s)    /* encontrar s en la tabla de símbolos */
{
Symbol  *sp;
	for (sp = symlist; sp != (Symbol *)0; sp = sp->next) 
		if (strcmp(sp->name, s)== 0) 
			return sp;
	return 0;      /* 0 ==> no se encontró */ 
}

Symbol *install(char *s, bool d) /* instalar s en la tabla de símbolos */
{
	Symbol *sp;
	char *emalloc();
	sp = (Symbol *) emalloc(sizeof(Symbol));
	sp->name = emalloc(strlen(s)+ 1) ; /* +1 para '\0' */
	strcpy(sp->name, s);
	sp->val = d;
	sp->next  =  symlist;   /*  poner al frente de la lista   */
	symlist = sp; 
    return sp; 
}

Symbol *getSymList() {
	return symlist;
}

char  *emalloc(unsigned n)	/*   revisar el regreso desde malloc  */
{
char *p,   *malloc();
	p = malloc(n); 
	if(p == 0)
		printf("OUT OF MEMORY ON SYMBOL\n"); 
	return p; 
}
