
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
double productoPuntoVector(Vector*a, Vector*b);
Vector* escalarVector(Vector* a, double escalar);
Vector* productoCruzVector(Vector*a, Vector*b);
double magnitudVector(Vector *a);
Vector* obtenerValor(double a);
void actualizarValor(Vector*a, Vector*b);
//Vector *multiVector(Vector *a, Vector *b);
