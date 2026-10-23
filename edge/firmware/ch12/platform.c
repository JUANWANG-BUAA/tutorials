#include "platform.h"
void platform_puts(const char *s) {
#ifdef __arm__
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
#else
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
#endif
}
_Noreturn void platform_exit(uint32_t code) {
    if (code) {
#ifdef __arm__
        platform_puts("ARM OTA FAIL\n");
#else
        platform_puts("RV32 OTA FAIL\n");
#endif
    }
#ifdef __arm__
    uint32_t args[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = args;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
#else
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
#endif
    for (;;) {}
}
_Noreturn void fault(void) { platform_exit(1); }
