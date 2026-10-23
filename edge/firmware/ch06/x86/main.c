#include <stdint.h>
#include <stddef.h>
#include "can_core.h"
void *memcpy(void *dst, const void *src, size_t n) {
 unsigned char *d=dst; const unsigned char *s=src;
 for (size_t i=0; i<n; ++i) d[i]=s[i];
 return dst;
}
void *memset(void *dst, int value, size_t n) {
 unsigned char *d=dst;
 for (size_t i=0; i<n; ++i) d[i]=(unsigned char)value;
 return dst;
}
static void output(const char *s) {
 while (*s) { __asm__ volatile("outb %0, $0xe9" : : "a"((unsigned char)*s) : "memory"); ++s; }
}
__attribute__((noreturn)) void kernel_main(void) {
 uint64_t cr0, cr4; uint32_t lo, hi;
 __asm__ volatile("mov %%cr0, %0" : "=r"(cr0));
 __asm__ volatile("mov %%cr4, %0" : "=r"(cr4));
 __asm__ volatile("rdmsr" : "=a"(lo), "=d"(hi) : "c"(0xc0000080u));
 (void)hi;
 int failed = !(cr0 & (1u << 31)) || !(cr4 & (1u << 5)) || !(lo & (1u << 10));
 if (!failed) failed = can_core_selftest();
 output(failed ? "X86 CAN CORE FAIL\n" : "X86 CAN CORE PASS: long mode, CRC/stuff/arbitration/confinement tests\n");
 uint32_t code = failed ? 0x11 : 0x10;
 __asm__ volatile("outl %0, $0xf4" : : "a"(code) : "memory");
 for (;;) __asm__ volatile("hlt");
}
