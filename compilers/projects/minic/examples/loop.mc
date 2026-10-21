// A loop-carried variable: its value on entry and on the back edge
// must be merged by a phi node.
int main() {
    int i = 1;
    int sum = 0;
    while (i <= 100) {
        sum = sum + i;
        i = i + 1;
    }
    print(sum);
    return 0;
}
