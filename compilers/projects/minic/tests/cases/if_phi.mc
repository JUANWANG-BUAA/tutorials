// expect: 42
int main() {
    int x;
    if (1) {
        x = 40;
    } else {
        x = 2;
    }
    print(x + 2);
    return 0;
}
