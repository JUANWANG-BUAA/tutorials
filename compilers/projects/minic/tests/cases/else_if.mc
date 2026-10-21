// expect: -1
// expect: 0
// expect: 1
int classify(int x) {
    if (x < 0) {
        return 0 - 1;
    } else {
        if (x == 0) {
            return 0;
        } else {
            return 1;
        }
    }
}
int main() {
    print(classify(0 - 5));
    print(classify(0));
    print(classify(5));
    return 0;
}
