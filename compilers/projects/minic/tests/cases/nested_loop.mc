// expect: 36
int main() {
    int i = 1;
    int total = 0;
    while (i <= 3) {
        int j = 1;
        while (j <= 3) {
            total = total + i * j;
            j = j + 1;
        }
        i = i + 1;
    }
    print(total);
    return 0;
}
