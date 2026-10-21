// expect: 3
// expect: 2
// expect: -3
// expect: -2
// expect: 2
int main() {
    print(17 / 5);
    print(17 % 5);
    print((0 - 17) / 5);
    print((0 - 17) % 5);
    print(17 % (0 - 5));
    return 0;
}
