// expect: 0
// expect: 1
int main() {
    print(0 && (1 / 0));
    print(1 || (1 / 0));
    return 0;
}
