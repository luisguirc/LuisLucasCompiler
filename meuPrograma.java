import java.util.Scanner;
public class meuPrograma { 
    public static void main(String args[]) { 
    Scanner _scTrx = new Scanner(System.in);
    int a;
    int b;
    double c;
    String x;
    String y;
    System.out.println("Ola mundo");
    a = _scTrx.nextInt();
    System.out.println(a);
    c = _scTrx.nextDouble();
    c = a;
    if (c>5) {
        System.out.println("maior que 5");
    }
    else {
        System.out.println("menor ou igual a 5");
        do {
            System.out.println("processando");
            b = 2+1;
        } while (b==3);
    }
    while (a>5) {
        System.out.println("maior que 5");
        a = a-1;
    }
    do {
        System.out.println("escrevendo");
        b = 2;
        x = "abc";
    } while (b==3);
    for (a = 1; a  <= 3; a  += 1) {
        System.out.println("loop for");
        a = 4+2/2;
    }
    }
}
