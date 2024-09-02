import java.util.Scanner;
public class meuPrograma { 
    public static void main(String args[]) { 
    Scanner _scTrx = new Scanner(System.in);
    int a;
    int b;
    String x;
    String y;
    System.out.println("Ola mundo");
    System.out.println("Fim do programa");
    a = _scTrx.nextInt();
    System.out.println(a);
    if (a>5) {
        System.out.println("maior que 5");
        a = 5.1;
    }
    else {
        System.out.println("menor ou igual a 5");
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
        a = a+1;
    }
    }
}
