// expect: 5
// expect: 10
// expect: 7
int main() {
    int i = 0;
    int n = 0;
    while (i < 10 && i != 5) {
        i = i + 1;
        n = n + 2;
    }
    print(i);
    print(n);
    if (!(i == 5) || n > 100) {
        print(99);
    } else {
        print(7);
    }
    return 0;
}
