int yylex (){
  	int c;
  	while ((c = getchar ()) == ' ' || c == '\t')
  		;
 	if (c == EOF)
    		return 0;
  	if (c == '.' || isdigit (c)){
      		ungetc (c, stdin);
      		scanf ("%d", &yylval.ival);
	      	return NUMBER;
    	}
	if(islower(c)){
		yylval.index=c-'a';
		return VAR;
	}
  	return c;
}
void init(){
   int i;
   for(i = 0;i < 26;i++)
      mem[i]=creaVector(3);
}
void main() {
   //init();
   yyparse();
}
int yyerror(const char* s) {
  printf("%s\n", s);
  return 0;
}
Vector *creaVector(int n){
   Vector *vec;
   int i;
   vec=(Vector *)malloc(sizeof(Vector));
   vec->n = n;
   vec->vec = (double *)malloc(sizeof(double)*n);
   return vec;
}
void imprimeVector(Vector *v){
   int i;
   for(i=0; i< v->n; i++)
      printf("%f ", v->vec[i]);
   printf("\n");
}
Vector *copiaVector(Vector *v){
   int i;
   Vector *copy=creaVector(v->n);
   for(i = 0; i< v->n; i++)
      copy->vec[i]=v->vec[i];
   return copy;
}
Vector *sumaVector(Vector *a, Vector *b){
Vector *c;
int i;
   c=creaVector(a->n);
   for(i=0; i< a->n;i++)
      c->vec[i]=a->vec[i]+b->vec[i];
   return c;
}
Vector *restaVector(Vector *a, Vector *b){
Vector *c;
int i;
   c=creaVector(a->n);
   for(i=0; i< a->n;i++)
      c->vec[i]=a->vec[i]-b->vec[i];
   return c;
}

double ppunto(Vector*a, Vector*b){
  Vector* aux;
  aux = creaVector(a->n);
  int i,j;
  double sum=0;
  for(i=0;i<a->n;i++){
    aux->vec[i]=a->vec[i]*b->vec[i];
  }
  for (j = 0; j < count; j++) {
    sum = sum + aux->vec[j];
  }

  return sum;
}

Vector* pcruz(Vector*a, Vector*b){
  Vector* aux;
  aux=creaVector(a->n);
  double i,j,k;
  i =(a->vec[1] *  b->vec[2]) - (a->vec[2]*b->vec[1]);
  j =(a->vec[0] *  b->vec[3]) - (a->vec[3]*b->vec[0]);
  k =(a->vec[0] *  b->vec[1]) - (a->vec[0]*b->vec[1]);
  aux[0]=i;
  aux[1]=j;
  aux[2]=k;
  return aux;

}

Vector* mulEscalar(Vector* a, int escalar){
  Vector* aux,res;
  aux = creaVector(a->n);
  res = creaVector(a->n)
  int i,j;
  for(i = 0; i < a->n; i++) {
    aux->vec[i]=escalar*a->vec[i];
  }
  return aux;
}

/*
Vector *multiVector(Vector *a, Vector *b){
Vector *c;
int i,j, k;
double acu;
        c=creaVector(a->n);
	for(i=0; i< a->n;i++)
		for(j=0; j < a->n;j++){
			acu=0;
			for(k=0; k < a->n;k++){

				acu=acu+a->mat[i][k]*b->mat[k][j];
				//printf("<%f,%f,%f> ",a->mat[i][k],b->mat[k][j],acu);
                        }
                        //printf("\n");
			c->mat[i][j]=acu;
		}
	return c;
}*/
