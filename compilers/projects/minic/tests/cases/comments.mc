// expect: 7
/* A block comment
   spanning lines. */
int main() {
    int x = 3; // line comment
    int y = 4; /* trailing block comment */
    print(x + y);
    return 0;
}
