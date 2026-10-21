#include <stdio.h>

int main(void) {
    long a = 0;
    long b = 0;
    if (scanf("%ld %ld", &a, &b) != 2) {
        fprintf(stderr, "bad input\n");
        return 2;
    }
    printf("%ld\n", a + b);
    return 0;
}
