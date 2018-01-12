public class Operacion{
	public static Vector productoCruz(Vector vA, Vector vB){
        double[] A = vA.getNumeros();
        double[] B = vB.getNumeros();
        double[] C = new double[0];
        if(A.length == B.length && A.length == 3){
            C = new double[A.length];
            C[0] =  A[1]*B[2] - A[2]*B[1];
            C[1] =  A[2]*B[0] - A[0]*B[2];
            C[2] =  A[0]*B[1] - A[1]*B[0];
        }
        Vector vC = new Vector();
        vC.setNumeros(C);
        return vC;
    }
	
	public static double productoPunto(Vector vA, Vector vB){
        double[] A = vA.getNumeros();
        double[] B = vB.getNumeros();
		double resultado = 0;
        if(A.length == B.length && A.length == 3){
            for(int i = 0; i < A.length; i++){
				resultado += A[i] * B[i];
			}
			return resultado;
        }
		return resultado;
    }
    
    public static Vector productoEscalar(double A, Vector vB){
        double[] C = vB.getNumeros();
        for(int i = 0; i < C.length; i++)
			C[i] = C[i]*A;
        //vB.setNumeros(B);
        //return vB;
        Vector vC = new Vector();
        vC.setNumeros(C);
        return vC;
    }    
    
    public static Vector suma(Vector vA, Vector vB){
        double[] A = vA.getNumeros();
        double[] B = vB.getNumeros();
        double[] C = new double[0];
        if(A.length == B.length && A.length > 0){
			C = new double[A.length];
			for(int i = 0; i <A.length; i++)
				C[i] = A[i] + B[i];
		}
        Vector vC = new Vector(C);
        return vC;
    }
    
    public static Vector resta(Vector vA, Vector vB){
        double[] A = vA.getNumeros();
        double[] B = vB.getNumeros();
        double[] C = new double[0];
        if(A.length == B.length && A.length > 0){
			C = new double[A.length];
			for(int i = 0; i < A.length; i++)
				C[i] = A[i] - B[i];
		}
        Vector vC = new Vector(C);
        return vC;
    }
    
    public static Vector menosVector(Vector vA){
        double[] A = vA.getNumeros();
		if(A.length > 0)
			for(int i = 0; i < A.length; i++)
				A[i] = -A[i];
				
        return new Vector(A);
    }

    public static boolean comparar(Vector vA, Vector vB){
        double[] A = vA.getNumeros();
        double[] B = vB.getNumeros();
		if(A.length == B.length && A.length > 0){
			for(int i = 0; i < A.length; i++){
                if(A[i] != B[i])
                    return false;
            }
		}
        return true;
    }
    
    public static void imprimir(Vector vA){
        double[] A = vA.getNumeros();
        for(int i = 0; i < A.length; i++){
			System.out.print(""+A[i]+" "); 
        }
    }

    public static double sumaDeComponentes(Vector vA){
        double[] A = vA.getNumeros();
        double total = 0;
        for(int i = 0; i < A.length; i++)
			total += A[i];
        return total;
    }
	
	public static double norma(Vector vA){
		double[] A = vA.getNumeros();
		double norma = 0;
		if(A.length > 0){
			for(int i = 0; i < A.length; i++)
				norma += Math.pow(A[i],2);
		}
		
		norma = Math.sqrt(norma);
		
		return norma;
	}
}
