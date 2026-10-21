// error: does not support 'for'
int main() {
    for (int i = 0; i < 3; i = i + 1) {
        print(i);
    }
    return 0;
}
