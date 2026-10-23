#include "platform.h"
#define REG(a) (*(volatile uint32_t *)(uintptr_t)(a))
volatile uint32_t entry_sp, ticks;
volatile uint32_t initialized = 0x1234abcd;
int main(void) {
    uint32_t status, mie, mtvec;
    __asm__ volatile("csrr %0, mstatus" : "=r"(status));
    __asm__ volatile("csrr %0, mie" : "=r"(mie));
    __asm__ volatile("csrr %0, mtvec" : "=r"(mtvec));
    if ((status & 8) || mie || mtvec != APP_BASE + 256 ||
        entry_sp != 0x80410000 || ticks || initialized != 0x1234abcd) fault();
    uint32_t hi, lo, again;
    do { hi = REG(0x0200bffc); lo = REG(0x0200bff8); again = REG(0x0200bffc); } while (hi != again);
    uint32_t target = lo + 10000;
    hi += target < lo;
    REG(0x02004000) = UINT32_MAX;
    REG(0x02004004) = hi;
    REG(0x02004000) = target;
    __asm__ volatile("li t0, 128; csrw mie, t0; csrsi mstatus, 8" ::: "t0", "memory");
    for (uint32_t k = 0; k < 1000000 && ticks == 0; ++k) __asm__ volatile("nop");
    if (ticks != 1) fault();
#if APP_SLOT == 0
    platform_puts("RV32 OTA APP A PASS: new gp/sp, CRT0, own MTIP vector\n");
#else
    platform_puts("RV32 OTA APP B PASS: new gp/sp, CRT0, own MTIP vector\n");
#endif
    platform_exit(0);
}
