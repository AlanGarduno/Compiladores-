struct nodoArb {
	struct nodoArb* izq;
	struct nodoArb* der;
	int type;
	char *value;
};
typedef struct nodoArb  NodoArb;
void imprimeArb(NodoArb *raiz, void (*f)(void *));
int EvaluaArb(NodoArb *raiz);
void imprimeEvalArb(NodoArb *raiz);
//type == 0 boolean;
//type == 1 varname;
//type == 2 operator;
NodoArb *creaNodoArb(char *dato, int tipo, NodoArb *izq, NodoArb *der);
void imprimeCadena(void *p);


