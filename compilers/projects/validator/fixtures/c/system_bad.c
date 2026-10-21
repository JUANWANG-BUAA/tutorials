#include <stdlib.h>

int main(void) {
    int rc = system("echo pwned");
    return rc == 0 ? 0 : 1;
}
