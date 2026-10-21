// expect: 0
int main() {
    int i = 0;
    while (i < 0) {
        i = i + 1;
    }
    print(i);
    return 0;
}
