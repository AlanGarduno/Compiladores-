public class Vector {

    private double[] numeros;

    public Vector(){}

    public Vector(double[] numeros){
        this.numeros = numeros;
    }

    public double[] getNumeros() {
        return numeros;
    }

    public void setNumeros(double[] numeros) {
        this.numeros = numeros;
    }
    
    @Override
    public String toString(){
        String resultado = "{ ";
        for(int i = 0; i < numeros.length; i++){
			resultado += numeros[i] + " , ";
        }
		resultado =  resultado.substring(0,resultado.length()-3) + " }";
        return resultado;
    }

}