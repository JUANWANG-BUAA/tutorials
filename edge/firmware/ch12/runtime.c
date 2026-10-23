#include <stddef.h>
void *memset(void *d, int c, size_t n) {
    unsigned char *p = d;
    for (size_t i = 0; i < n; ++i) p[i] = (unsigned char)c;
    return d;
}
void *memcpy(void *d, const void *s, size_t n) {
    unsigned char *p = d; const unsigned char *q = s;
    for (size_t i = 0; i < n; ++i) p[i] = q[i];
    return d;
}
int memcmp(const void *a, const void *b, size_t n) {
    const unsigned char *p = a, *q = b;
    for (size_t i = 0; i < n; ++i) if (p[i] != q[i]) return p[i] < q[i] ? -1 : 1;
    return 0;
}
#ifdef __arm__
void __aeabi_memclr(void *d, size_t n) { (void)memset(d, 0, n); }
void __aeabi_memclr4(void *d, size_t n) { (void)memset(d, 0, n); }
void __aeabi_memcpy(void *d, const void *s, size_t n) { (void)memcpy(d, s, n); }
void __aeabi_memcpy4(void *d, const void *s, size_t n) { (void)memcpy(d, s, n); }
#endif
