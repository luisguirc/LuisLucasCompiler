#include <stdio.h>
#include <string.h>
int main() {
    int a;
    int b;
    double c;
    char x[100];
    char y[100];
    printf("Ola mundo");
    scanf("%lf", &a);
    printf("%d", a);
    c = a;
    if (c>5) {
        printf("maior que 5");
    }
    else {
        printf("menor ou igual a 5");
        do {
            printf("processando");
            b = 2+1;
        } while (b==3);
    }
    while (a>5) {
        printf("maior que 5");
        a = a-1;
    }
    do {
        printf("escrevendo");
        b = 2;
        strcpy(x, "abc");
    } while (b==3);
    for (a = 1; a  <= 3; a  += 1) {
        printf("loop for");
        a = 4+2/2;
    }
    return 0;
}

