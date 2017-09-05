%{
#include <stdio.h>
#include <math.h>
#include "vector_cal.h"
void yyerror (char *s);
int yylex ();
void warning(char *s, char *t);
#define YYSTYPE Vector*
%}
%union{
	char index;
	double ival;
	Vector *vec;
}
%token <index>VAR
%token <ival>NUMBER
%token <vec>VECTOR
%left '+' '-'
%left '*' '.'
%left 'x'
%%
list:
	| list'\n'
  | list vector '\n'  { imprimeVector($2); }
	;
exp:      NUMBER          { $$ = $1;     }
        | exp '+' exp     {$$ = sumaVector($1,$3);}
        | exp '-' exp     {$$ = restaVector($1,$3); }
        | exp '*' exp     {$$ = mulEscalar($1,$3);  }
        | exp '.' exp     {$$ = ppunto($1,$3);}
				| exp 'x' exp     {$$ = pcruz($1,$3); }
        | '(' exp ')'     { $$ = $2;  }
				;
%%

#include <stdio.h>
#include <ctype.h>
char *progname;
int lineno = 1;

void main (int argc, char *argv[]){
	progname=argv[0];
  	yyparse ();
}
int yylex (){
  	int c;

  	while ((c = getchar ()) == ' ' || c == '\t')
  		;
 	if (c == EOF)
    		return 0;
  	if (c == '.' || isdigit (c)) {
      		ungetc (c, stdin);
      		scanf ("%lf", &yylval);
	      return NUMBER;
    	}
  	if(c == '\n')
		lineno++;
  	return c;
}
void yyerror (char *s) {
	warning(s, (char *) 0);
}
void warning(char *s, char *t){
	fprintf (stderr, "%s: %s", progname, s);
	if(t)
		fprintf (stderr, " %s", t);
	fprintf (stderr, "cerca de la linea %d\n", lineno);
}
