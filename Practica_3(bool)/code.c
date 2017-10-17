#include "hoc.h" 
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

#define NSTACK 256
static  NodoArb* stack[NSTACK];  /* la pila */
static  NodoArb* *stackp; 
 
#define NPROG   2000
Inst    prog[NPROG];    /* la máquina */
Inst    *progp;         /* siguiente lugar libre para la generación de código */
Inst    *pc;	/* contador de programa durante la ejecución */

int symid = 0;
int tot = 0;

initcode()      /* inicialización para la generación de código */ {
progp = prog;
stackp = stack;
}

push(NodoArb* d)	/*  meter d en la pila  */
{
if (stackp >= &stack[NSTACK]) {
puts("Stack Overflow");
//YYABORT;
}
//printf("addto: %s\n", d->value);
*(stackp++) = d;
}


NodoArb* pop( )     /* sacar y retornar de la pila el elemento del tope */
{
if (stackp <= stack) {
puts("Stack Underflow");
//YYABORT;
}
return  *(--stackp);
}

adc( )	/* meter una constante a la pila  */ //T // F
{	
	NodoArb* nvo;
	nvo = (NodoArb*)malloc(sizeof(NodoArb));
	if(!nvo) {
		puts("no hay memoria para crear NodoL");
	}
	nvo->der = NULL;
	nvo->izq = NULL;
	nvo->value = ((char *)*pc++);
	nvo->type = 0;
	push(nvo);
}

adv()	/* meter una variable a la pila   */
{
NodoArb *nvo;
nvo = (NodoArb *)malloc(sizeof(NodoArb));
if(!nvo) {
	puts("no hay memoria para crear NodoL");
}
nvo->der = NULL;
nvo->izq = NULL;

int lim = strlen((char*) *pc) + 1;
char *myop = (char *) malloc(sizeof (char) * lim);

int i;
for (i = 0; i < lim; ++i) myop[i] = ((char *)*pc)[i];
myop[lim] = '\0';

*pc++;
nvo->value = myop;
nvo->type = 1;
*stackp = nvo;
stackp++;
}

ado( )	/*   sumar los dos elementos superiores de la pila   */
{
NodoArb *nvo;
nvo = (NodoArb *)malloc(sizeof(NodoArb));
if(!nvo) {
	puts("no hay memoria para crear NodoL");
}
//type == 0 boolean;
//type == 1 varname;
//type == 2 operator;
char *myop;
int lim = strlen((char*) *pc);
int i;
myop = (char *) malloc(sizeof (char) * lim);
for (i = 0; i < lim; ++i) myop[i] = ((char *)*pc)[i];
myop[lim] = '\0';
*pc++;
//printf("myop:%s\n", myop);
nvo->der = pop();
if (myop[0] == '~') nvo->izq = NULL;
else nvo->izq = pop();
nvo->value = myop;
nvo->type = 2;
*stackp = nvo;
//printf("varval3: %s\n", (*stackp)->value);
stackp++;
//push(nvo);
} 


void imprimeArb(NodoArb *raiz){
   if(!raiz) return;
   imprimeArb(raiz->izq);
   printf("ima: %s\n", raiz->value);
   imprimeArb(raiz->der);       
}


int isLeaf(NodoArb *raiz) { return ((int)((!(raiz->izq)) && (!((raiz->der))))); }

void labeling(NodoArb *raiz){
   if(!raiz) return;
   labeling(raiz->izq);
   if (isLeaf(raiz)) {
	   int j = 0;
	   Symbol *sm = getSymList();
	   for (j = 0; j <= tot; ++j, sm = sm->next) if (j == (tot - symid)) raiz->value = sm->name; 
	   symid++;
   } 
   //printf("ima: %s\n", raiz->value);
   labeling(raiz->der);       
}
//var ^ (vas | (~c))


int operacion(char op, bool a, bool b){
	if (op == '|') return a || b;
	if (op == '^') return a && b;
	return !b;
}

bool evaluaArb(NodoArb *raiz) {
	if (!raiz) return 0;
	//printf("\nvalor del nodo actual: %s\n", (char*)(raiz->value));
	if (isLeaf(raiz)) {
		if (raiz->type) return (lookup(raiz->value))->val;
		return (raiz->value)[0] == 'T';
	}
	return operacion((raiz->value)[0], evaluaArb(raiz->izq), evaluaArb(raiz->der));
}

imp() {

	NodoArb* raiz = stack[0];
	symid = 0;
	tot = 0;
	Symbol * sp = getSymList();
	for (; sp != (Symbol *)0; sp = sp->next) tot++; 
	tot--;
	labeling(raiz);
	imprimeArb(raiz);
	
	int manysymbs = 0;
	Symbol *it;
	int wdt = 15, ind;
	for (it = getSymList(); it != (Symbol *)0; it = it->next, ++manysymbs) {
	    printf("%s", it->name);
		for (ind = 0; ind < wdt - strlen(it->name); ++ind) printf(" ");
	}
	printf("RESULTADO:\n");
	int lim = (1 << manysymbs), id = 1;
	for (id = 1; id <= lim; ++id) {
		//evalua
		for (it = getSymList(); it != (Symbol *)0; it = it->next) {
			printf("%c", (it->val)?'T':'F');
			for (ind = 0; ind < wdt - 1; ++ind) printf(" ");
		}
		printf("%c\n", ((evaluaArb(raiz))?'T':'F'));
		//puts("");
		//cambia
		int cnt = 0;
		for (it = getSymList(); it != (Symbol *)0; it = it->next) it->val = (id >> (manysymbs - ++cnt)) & 1;
	}
}


Inst   *code(Inst f) /*   instalar una instrucción u operando   */
{
Inst *oprogp = progp;
	if (progp >= &prog [ NPROG ]) {
		puts("Program Too Big");
		//YYABORT;
	}
	*(progp++) = f;
	int i = 0;
	//for  (pc  =  prog;   pc != progp; pc++) printf("p %d: %c\n", ++i, ((char*)*pc)[0]);
	//printf("variable llego--: %s\n", (char *)f);
	//printf("adding: %s\n", (char*)f);
	//printf("addingop: %d\n", (Inst)f);
	return oprogp;
}

Inst   *codes(char* f) /*   instalar una instrucción u operando   */
{
Inst *oprogp = progp;
	if (progp >= &prog [ NPROG ]) {
		puts("Program Too Big");
		//YYABORT;
	}
	*progp = f;
	//printf("variable llego--: %s\n", (char *)*progp);
	//printf("variable llego--: %s\n", (char *)*progp);
	progp++;
	int i = 0;
	//for  (pc  =  prog;   pc != progp; pc++) printf("p %d: %c\n", ++i, ((char*)*pc)[0]);
	//printf("adding: %s\n", (char*)f);
	//printf("addingop: %d\n", (Inst)f);
	return oprogp;
}


execute()	/*   ejecución con la máquina   */
{
	int i = 0;
//for  (pc  =  prog;   pc != progp; pc++) printf("p %d: %s\n", ++i, (char*)*pc);
for  (pc  =  prog;   *pc != STOP; ) {
	(*(*pc++))();
	//puts("PASO");
}
}

