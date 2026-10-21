// if/else with a join: the value of y differs on the two paths.
int classify(int x) {
    int y;
    if (x < 0) {
        y = 0 - 1;
    } else {
        if (x == 0) {
            y = 0;
        } else {
            y = 1;
        }
    }
    return y;
}

int main() {
    print(classify(0 - 42));
    print(classify(0));
    print(classify(42));
    return 0;
}
