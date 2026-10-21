// expect: 42
int bump(int x) {
    x = x + 1;
    return x;
}
int main() {
    print(bump(41));
    return 0;
}
