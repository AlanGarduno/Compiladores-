%{
#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include "vector_cal.h"
#include <signal.h>
#include <setjmp.h>

void yyerror (char *s);
int yylex ();
void warning(char *s, char *t);
%}
%union{
	char index;
	double ival;
	Vector *vec;
}
%token <index> VAR
%token <ival> NUMBER
%token <vec> VECTOR 
%left '+' '-'
%left ':' '#'
%left '*' 
%type <vec> vector term
%type <ival> number
%type <vec> assign
%% 
list:   
		| list'\n'				{ printf(">> ");					}
        | list assign'\n'       { printf(">> ");					}
        | list number'\n'       { printf(">> %lf\n", $2);			}
        | list vector'\n'       { printf(">> "); imprimeVector($2); }
	;
assign: 
		 VAR '=' vector			{ actualizarValor($1, $3); printf(">> "); imprimeVector($3);}
	;
number: 
		NUMBER                  { $$ = $1;                          }
		| vector ':' vector     { $$ = productoPuntoVector($1, $3); }
		| '|' vector '|'        { $$ = magnitudVector($2);          } 
	;
		
vector: 
		  term                  { $$ = $1;                          }
		| vector '+' vector     { $$ = sumaVector($1, $3);          }
        | vector '-' vector     { $$ = restaVector($1, $3);         }
        | NUMBER '*' vector     { $$ = escalarVector($1, $3);       }
        | vector '*' NUMBER     { $$ = escalarVector($3, $1);       }
        | vector '#' vector     { $$ = productoCruzVector ($1, $3); }
	;
	
term:
	      VECTOR                { $$ = $1;                          }
		 | VAR                  { $$ = obtenerValor($1);            }
	;
%%



char *progname;
int lineno = 1;

int main (int argc, char *argv[]){
	progname=argv[0];
  	yyparse ();
	return 0;
}
int yylex (){
  	int c;
  	while ((c = getchar ()) == ' ' || c == '\t')  
  		;
 	if (c == EOF)                            
    		return 0;
  	if (c == '.' || isdigit (c)) {
      		ungetc (c, stdin);
      		scanf ("%lf", &yylval.ival);
	      return NUMBER;
    	}
  	if(c == '['){
  		Vector* c;
  		int cont = 0;
  		char car;
  		int ban = 0, i;
		double aux[22];
  		while (ban == 0){
  			scanf ("%lf", &aux[cont]);
  			cont++;
  			scanf (" %c", &car);
  			if (car == ']')
  				ban = 1;
  		}
  		c = creaVector(cont);
  		for (i = 0; i < cont; i++)
  			c->vec[i] = aux[i];
  		yylval.vec = c;
  		return VECTOR;
  	}
  	if (isalpha(c)){
  		yylval.index = c;
  		return VAR;
  	}
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
	fprintf (stderr, " cerca de la linea %d\n", lineno);
}




