%{
	import java.lang.Math;
	import java.io.*;
	import java.util.StringTokenizer;
%}

%token FNCT
%token FUNC
%token PARAMETRO
%token NUMBER
%token VAR

%right '='
%left '+' '-'
%left '#'
%left '.'
%left '*'
%left ';'
%left '!'

%%
	list:
		| list '\n'
	  	| list linea '\n'
		;

	linea: exp ';' {$$ = $1;}
		|linea exp ';' {$$ = $1;}
		;

	exp:  VAR {
				$$ = new ParserVal(maquina.agregarOperacion("varPush_Eval"));
				maquina.agregar($1.sval);
			}
		|NUMBER {
				$$ = new ParserVal(maquina.agregarOperacion("constPush"));
				maquina.agregar($1.dval);
			}
		|VAR '[' initNum ']' '=' '{' lista '}' {
				vAux = new Vector(auxiliar);
				$$ = new ParserVal(maquina.agregarOperacion("constPush"));
       			maquina.agregar(vAux);
       			maquina.agregarOperacion("varPush");
		        maquina.agregar($1.sval);
		        maquina.agregarOperacion("asignar");
		        maquina.agregarOperacion("varPush_Eval");
				maquina.agregar($1.sval);
			}
		| VAR '=' exp {
				$$ = new ParserVal($3.ival);
				maquina.agregarOperacion("varPush");
		        maquina.agregar($1.sval);
		        maquina.agregarOperacion("asignar");
		        maquina.agregarOperacion("varPush_Eval");
				maquina.agregar($1.sval);
			}
		| exp '#' exp {
				$$ = new ParserVal($1.ival);
				maquina.agregarOperacion("productoCruz");
			}
		| exp '+' exp {
				$$ = new ParserVal($1.ival);
				maquina.agregarOperacion("sumar");
			}
		| exp '.' exp {
			$$ = new ParserVal($1.ival);
			maquina.agregarOperacion("productoPunto");
			}
		| exp '-' exp {
				$$ = new ParserVal($1.ival);
				maquina.agregarOperacion("restar");
			}
		| exp '*' exp {
				$$ = new ParserVal($1.ival);
				maquina.agregarOperacion("productoEscalar");
			}
		| '|' exp '|' {
				$$ = new ParserVal($2.ival);
				maquina.agregarOperacion("norma");
			}
		|'(' exp ')' {
				$$ = new ParserVal($2.ival);
			}
		| '!' exp {
				maquina.agregarOperacion("negar");
				$$ = $2;
			}
		| FNCT '[' exp ']' {
				$$ = new ParserVal($3.ival);
      			maquina.agregar((Funcion)($1.obj));
			}
		;
		
	instrucciones: { $$ = new ParserVal(maquina.agregarOperacion("nop"));}
		|exp {$$ = $1;}
		|instrucciones ',' exp {$$ = $1;}
		;

	initNum: NUMBER {i = 0; auxiliar = new double[(int)$1.dval];}
		;
		
	lista:	NUMBER {auxiliar[i] = $1.dval; i++;}
		| lista ',' NUMBER {auxiliar[i] = $3.dval; i++;}
		;


%%



TablaDeSimbolos tablaDeSimbolos = new TablaDeSimbolos();
MaquinaDePila maquina = new MaquinaDePila(tablaDeSimbolos);
int i = 0;
double[] auxiliar;
Vector vAux = new Vector();
Funcion funcionAux;
boolean huboError;

String ins;
StringTokenizer st;

void yyerror(String s){
	huboError = true;
	System.out.println("error:"+s);
}

boolean newline;
int yylex(){
	String s;
	int tok = 0;
	Double d;
	if (!st.hasMoreTokens()){
		if (!newline){
			newline=true;
			return '\n'; //So we look like classic YACC example
		}
		else
			return 0;
	}
	s = st.nextToken();
	try{
		d = Double.valueOf(s);/*this may fail*/
		yylval = new ParserVal(d.doubleValue()); //SEE BELOW
		return NUMBER;
	}
	catch (Exception e){}
	if(esVariable(s)){
		if(s.charAt(0) == '$'){
			yylval = new ParserVal((int)Integer.parseInt(s.substring(1)));
			return PARAMETRO;
		}
		if(s.equals("func")){
			return FUNC;
		}
		boolean esFuncion = false;
		Object objeto = tablaDeSimbolos.encontrar(s);
		if(objeto instanceof Funcion){
			funcionAux = (Funcion)objeto;
			yylval = new ParserVal(objeto);
			esFuncion = true;
			return FNCT;
		}
		if(!esFuncion){
			yylval = new ParserVal(s);
			return VAR;
		}
	}
	else{
		tok = s.charAt(0);
	}
	//System.out.println("Token: " + tok);
	return tok;
}

String reservados[] = {"=", "{", "}", ",", "#", "+", "-", "(", ")", "|", "[", "]", ";", "!", ".", "*"};

boolean esVariable(String s){
	boolean cumple = true;
	for(int i = 0; i < reservados.length; i++)
		if(s.equals(reservados[i]))
			cumple = false;
	return cumple;
}

void dotest() throws Exception{
	tablaDeSimbolos.insertar("Imprimir", new MaquinaDePila.Imprimir());
	tablaDeSimbolos.insertar("Sumar", new MaquinaDePila.Sumar());
	BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
	while (true){
		huboError = false;
		try{
			ins = in.readLine();
		}
		catch (Exception e){}
		st = new StringTokenizer(ins);
		newline=false;
		//maquina = new MaquinaDePila(tablaDeSimbolos);
		yyparse();
		if(!huboError)
			maquina.ejecutar();
	}
}

public static void main(String args[]) throws Exception{
	System.out.println("Bienvenido");
	Parser par = new Parser(false);
	par.dotest();
}

/*
rm *.class
rm Parser*.java
byaccj -J P3.y
javac *.java -nowarn
java Parser
*/
