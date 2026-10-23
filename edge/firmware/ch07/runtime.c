#include <stddef.h>
void *memset(void *dst, int value, size_t count) {
 unsigned char *d = dst;
 for (size_t i=0; i<count; ++i) d[i]=(unsigned char)value;
 return dst;
}
void *memcpy(void *dst, const void *src, size_t count) {
 unsigned char *d=dst; const unsigned char *s=src;
 for (size_t i=0; i<count; ++i) d[i]=s[i];
 return dst;
}
#if defined(__arm__)
void __aeabi_memclr(void *dst, size_t n) { (void)memset(dst, 0, n); }
void __aeabi_memclr4(void *dst, size_t n) { (void)memset(dst, 0, n); }
void __aeabi_memclr8(void *dst, size_t n) { (void)memset(dst, 0, n); }
void __aeabi_memcpy(void *d, const void *s, size_t n) { (void)memcpy(d,s,n); }
void __aeabi_memcpy4(void *d, const void *s, size_t n) { (void)memcpy(d,s,n); }
void __aeabi_memcpy8(void *d, const void *s, size_t n) { (void)memcpy(d,s,n); }
#endif
