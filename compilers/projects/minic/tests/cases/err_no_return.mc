// error: may reach the end
int f(int x) {
    if (x) return 1;
}
int main() {
    print(f(1));
    return 0;
}
