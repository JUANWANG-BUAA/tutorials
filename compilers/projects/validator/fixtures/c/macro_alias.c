#include <stdlib.h>

#define LAUNCH system

int main(void) {
    return LAUNCH("echo hidden") == 0 ? 0 : 1;
}
