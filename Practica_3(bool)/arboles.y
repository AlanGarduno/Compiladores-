%{ 
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "hoc.h"

#define YYSTYPE char*

#define code2(c1, c2) code(c1); code(c2);

#include "y.tab.h"
void yyerror(char *s); 
void warning(char *s, char *t); 
int yylex(void);
%} 
%token VAR
%token BOOLEAN
%left '|' '^' '~'

%% 
list: 
  | list '\n' 
  | list expr '\n' { code2(imp, STOP); return 1;} 
; 
expr: BOOLEAN { code(adc); codes($1); } 
    | VAR { code(adv); codes($1); }
    | expr '|' expr { code2(ado, (Inst)("|")); } 
    | expr '^' expr { code2(ado, (Inst)("^")); }  
    | '~' expr { code2(ado, (Inst)("~")); }
    | '(' expr ')'  
; 
%% 

char *progname; 
int lineno = 1; 

int yylex() { 
   int c; 
   int val;
   while((c=getchar()) == ' ' || c == '\t') 
      ; 
   if(c == EOF)
	 return 0; 
   if(c == 'T' || c == 'F') {
	  char *aux = (char *)malloc(sizeof(char) * 1);
	  aux[0] = c;
	  aux[1] = '\0';
      yylval = aux;
      return BOOLEAN; 
   } 
   if(isalpha(c)){
		Symbol *s;
		char sbuf[200], *p=sbuf;
		do {
			*p++=c;
		} while ((c=getchar())!=EOF && isalnum(c));
		ungetc(c, stdin);
		*p='\0';
		if((s=lookup(sbuf))==(Symbol *)NULL)
			s=install(sbuf, 0);
		//printf("lastval: %d\n", s->val);
		//printf("variable llego: %s\n", sbuf);
		yylval = sbuf;   
        return VAR;
	}
   if(c == '\n') 
      lineno++; 
   return c; 
} 
void yyerror(char *s) { 
   warning(s, (char *)0); 
} 
void warning(char *s, char *t) { 
   fprintf(stderr, "%s: %s", progname, s); 
    if(t) 
       fprintf(stderr, " %s",t); 
    fprintf(stderr, " near line %d\n", lineno); 
} 
void main(int argc, char *argv[]) { 
    progname = argv[0];
    for(initcode(); yyparse(); initcode())
		execute(); 
	return;
}
