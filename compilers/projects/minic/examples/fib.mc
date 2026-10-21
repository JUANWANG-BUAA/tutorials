// Fibonacci: recursion plus a loop in main.
int fib(int n) {
    if (n < 2) return n;
    return fib(n - 1) + fib(n - 2);
}

int main() {
    int i = 0;
    while (i <= 10) {
        print(fib(i));
        i = i + 1;
    }
    return 0;
}
