%{
import java.lang.Math;
import java.io.*;
import java.util.StringTokenizer;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
%}
%token NUMBER LINE RIGHT CIRCULO RECTANGULO COLOR PRINT
%start list
%%
list :
     | list ';'
     | list inst ';'   { 
             maq.code("print"); maq.code("STOP"); return 1 ;
     }   
     ;
inst:  NUMBER  { ((Algo)$$.obj).inst=maq.code("constpush");
                maq.code(((Algo)$1.obj).simb); }

      | LINE NUMBER NUMBER NUMBER NUMBER NUMBER
 {		maq.code("constpush");
                maq.code(((Algo)$6.obj).simb);
		maq.code("color");
		maq.code("constpush");
                maq.code(((Algo)$2.obj).simb);
		maq.code("constpush");
		maq.code(((Algo)$3.obj).simb);
		maq.code("constpush");
                maq.code(((Algo)$4.obj).simb);
		maq.code("constpush");
                maq.code(((Algo)$5.obj).simb); maq.code("line");
}

      | CIRCULO NUMBER NUMBER NUMBER NUMBER
	{
		maq.code("constpush");
                maq.code(((Algo)$5.obj).simb);
 		maq.code("color");
		maq.code("constpush");
                maq.code(((Algo)$2.obj).simb);
                maq.code("constpush");
                maq.code(((Algo)$3.obj).simb);
                maq.code("constpush");
                maq.code(((Algo)$4.obj).simb); maq.code("circulo");
	}

      |RECTANGULO NUMBER NUMBER NUMBER NUMBER NUMBER 
	{
		maq.code("constpush");
		maq.code(((Algo)$6.obj).simb);
		maq.code("color");
		maq.code("constpush");
		maq.code(((Algo)$2.obj).simb);
		maq.code("constpush");
		maq.code(((Algo)$3.obj).simb);
		maq.code("constpush");
		maq.code(((Algo)$4.obj).simb);
		maq.code("constpush");
		maq.code(((Algo)$5.obj).simb);maq.code("rectangulo");	
	}

      | COLOR NUMBER { maq.code("constpush");
                maq.code(((Algo)$2.obj).simb); maq.code("color");}
      ;
%%
class Algo {
	Simbolo simb;
	int inst;
	public Algo(int i){ inst=i; }
	public Algo(Simbolo s, int i){
		simb=s;
                inst=i;
	}
}
Tabla tabla;
Maquina maq;

StringTokenizer st;
boolean newline;

int yylex(){
	String s;
	int tok;
	Double d;
	Simbolo simbo;
   	if (!st.hasMoreTokens())
    	if (!newline) {
        	newline=true; 
		 	return ';';  
			}
   		else
      		return 0;
   		s = st.nextToken();
   		try {
      		d = Double.valueOf(s);
      		yylval = new ParserVal(new Algo(tabla.install("", NUMBER, d.doubleValue()),0) );
      		tok = NUMBER;
   			} catch (Exception e){
   		if(Character.isLetter(s.charAt(0))){
      		if((simbo=tabla.lookup(s))==null)
         		yylval = new ParserVal(new Algo(simbo, 0));
	 			tok= simbo.tipo;	
	      		}
			else {
    			tok = s.charAt(0);
		      }
   			}
   		return tok;
	}

void yyerror(String s){
   System.out.println("parser error: "+s);
}

static Parser par = new Parser(0);
static JFrame f;
static JTextField t=new JTextField(20);
static JButton bcalc;
static JLabel lmuestra=new JLabel("                                 ");
static Canvas canv;
static Graphics g;
Parser(int foo){
   f=new JFrame("Calcula");
   bcalc=new JButton("Ejecuta");
   bcalc.addActionListener(new ManejaBoton());
   canv=new Canvas();
   canv.setSize(300,300);
   f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);  
}

public static void main(String args[]){
  f.add("North", t);
  f.add("Center", canv);
  f.add("South", bcalc);
  f.setSize( 300, 400);
  f.setResizable(false);
  f.setVisible(true);
  g=canv.getGraphics();
}
class ManejaBoton implements ActionListener {
   public void actionPerformed(ActionEvent e){
      JButton jb=(JButton)e.getSource();
      if(jb == bcalc){
         maq=new Maquina(g);
	 tabla=new Tabla();
	 tabla.install("line", LINE, 0.0);
     tabla.install("circulo", CIRCULO, 0.0);
	 tabla.install("rectangulo", RECTANGULO, 0.0);
     tabla.install("color", COLOR, 0.0);
	 tabla.install("print", PRINT, 0.0);
	 st = new StringTokenizer(t.getText());
    	 newline=false;
	 for(maq.initcode(); par.yyparse ()!=0; maq.initcode())
	    maq.execute(maq.progbase);
      }
   }
}
