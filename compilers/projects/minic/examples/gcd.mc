// Euclid's algorithm: six-parameter limit not needed here, but the loop
// exercises a phi for both a and b.
int gcd(int a, int b) {
    while (b != 0) {
        int t = b;
        b = a % b;
        a = t;
    }
    return a;
}

int main() {
    print(gcd(48, 18));
    print(gcd(17, 5));
    return 0;
}
