// Arithmetic, precedence and short-circuit logic.
int main() {
    int a = 2 + 3 * 4;
    int b = (2 + 3) * 4;
    print(a);
    print(b);
    print(a < b);
    print(0 && (1 / 0));
    print(1 || (1 / 0));
    print(-a + 100);
    return 0;
}
