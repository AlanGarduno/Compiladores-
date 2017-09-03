
struct vector {
	char name;
	int n;
	double *vec;
};
typedef struct vector Vector;
Vector *creaVector(int n);
void imprimeVector(Vector *a);
Vector *copiaVector(Vector *a);
Vector *sumaVector(Vector *a, Vector *b);
Vector *restaVector(Vector *a, Vector *b);
double ppunto(Vector*a, Vector*b);
Vector* mulEscalar(Vector* a, int escalar);
Vector* pcruz(Vector*a, Vector*b);
//Vector *multiVector(Vector *a, Vector *b);
