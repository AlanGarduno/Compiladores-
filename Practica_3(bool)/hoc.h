typedef enum { false, true } bool;
typedef struct Symbol { /* entrada de la tabla de símbolos */
	char   *name;
	bool val;	
	struct Symbol   *next;  /* para ligarse a otro */ 
} Symbol;
Symbol *install(char *s, bool d), *lookup(char *s), *getSymList();

//ARBOL
struct nodoArb {
	struct nodoArb* izq;
	struct nodoArb* der;
	int type;
	char *value;
};
typedef struct nodoArb  NodoArb;
void imprimeArb(NodoArb *raiz);
int EvaluaArb(NodoArb *raiz);
//type == 0 boolean;
//type == 1 varname;
//type == 2 operator;
NodoArb *creaNodoArb(char *dato, int tipo, NodoArb *izq, NodoArb *der);
void imprimeCadena(void *p);

//MAQVIRTUAL
typedef int (*Inst)();  /* instrucción de máquina */ 

/*a(int x, int y) {
	return x + y;
}
Inst func;
func = a;
int suma = *(func)(6, 7);
#define VALOR 200
#define PI 3.1416
const int VALOR = 200;
const double PI = 3.1416;

int var = VALOR-(;
//error near 200
//error near VALOR
double area = PI * radio * radio;
int arr[VALOR];
printf("%d", VALOR);
*/
#define STOP (Inst) 0
extern	Inst prog[];
extern adv(), adc(), ado(), imp();