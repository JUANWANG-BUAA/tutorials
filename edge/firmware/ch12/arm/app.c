#include "platform.h"
#define REG(a) (*(volatile uint32_t *)(uintptr_t)(a))
volatile uint32_t entry_sp, ticks;
volatile uint32_t initialized = 0x1234abcd;
void SysTick_Handler(void) {
    REG(0xe000e010) = 0;
    ++ticks;
}
int main(void) {
    uint32_t control, primask;
    __asm__ volatile("mrs %0, control" : "=r"(control));
    __asm__ volatile("mrs %0, primask" : "=r"(primask));
    if (control || primask != 1 || entry_sp != 0x2000e000 ||
        ticks || initialized != 0x1234abcd || REG(0xe000ed08) != APP_BASE ||
        (REG(0xe000e010) & 3) || REG(0xe000e100) || REG(0xe000e200)) fault();
    REG(0xe000e014) = 10000;
    REG(0xe000e018) = 0;
    REG(0xe000e010) = 7;
    __asm__ volatile("cpsie i" ::: "memory");
    for (uint32_t k = 0; k < 1000000 && ticks == 0; ++k) __asm__ volatile("nop");
    if (ticks != 1) fault();
#if APP_SLOT == 0
    platform_puts("ARM OTA APP A PASS: new MSP, CRT0, VTOR, own SysTick\n");
#else
    platform_puts("ARM OTA APP B PASS: new MSP, CRT0, VTOR, own SysTick\n");
#endif
    platform_exit(0);
}
