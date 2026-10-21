// expect: 1
// expect: 1
// expect: 0
// expect: 1
int main() {
    print(5 && 2);
    print(0 || 7);
    print(0 && 7);
    print(5 || 0);
    return 0;
}
