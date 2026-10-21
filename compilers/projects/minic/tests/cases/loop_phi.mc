// expect: 55
// expect: 11
int main() {
    int i = 1;
    int sum = 0;
    while (i <= 10) {
        sum = sum + i;
        i = i + 1;
    }
    print(sum);
    print(i);
    return 0;
}
