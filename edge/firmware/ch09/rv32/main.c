#include <stdint.h>
#include <stdbool.h>
#include "power_model.h"

#define REG(a) (*(volatile uint32_t *)(a))

__attribute__((noreturn)) void finish(unsigned code) {
    const char *s = code ? "RV32 POWER FAIL\n" : "RV32 POWER PASS: WFI sleep, mtimecmp timer wakeup, 64 cycles\n";
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
    for (;;) {}
}

static uint64_t read_mtime(void) {
    uint32_t hi, lo, again;
    do {
        hi = REG(0x0200bffc);
        lo = REG(0x0200bff8);
        again = REG(0x0200bffc);
    } while (hi != again);
    return ((uint64_t)hi << 32) | lo;
}

static void set_mtimecmp(uint64_t val) {
    REG(0x02004000) = UINT32_MAX;
    __asm__ volatile("fence io,io" ::: "memory");
    REG(0x02004004) = (uint32_t)(val >> 32);
    __asm__ volatile("fence io,io" ::: "memory");
    REG(0x02004000) = (uint32_t)val;
    __asm__ volatile("fence io,io" ::: "memory");
}

static volatile uint32_t g_wake_count = 0;

void trap_handler(void) {
    uint32_t mcause;
    __asm__ volatile("csrr %0, mcause" : "=r"(mcause));
    /* Check if MTIP (Machine Timer Interrupt, bit 31 set + cause 7) */
    if (mcause == 0x80000007UL) {
        g_wake_count++;
        /* Schedule next timer interrupt */
        set_mtimecmp(read_mtime() + 2000ULL);
    }
}

int main(void) {
    if (power_model_selftest() != 0) finish(1);

    /* 1. Set trap vector */
    extern void default_trap_entry(void);
    /* In this simple test, enable timer interrupt and WFI */
    uint32_t mie_val = (1UL << 7); /* MTIE: Machine Timer Interrupt Enable */
    __asm__ volatile("csrs mie, %0" : : "r"(mie_val) : "memory");

    /* Schedule first timer interrupt */
    set_mtimecmp(read_mtime() + 2000ULL);

    /* 2. Run WFI sleep loop */
    while (g_wake_count < 64) {
        /* In RISC-V: when mstatus.MIE=0, WFI still wakes on pending interrupt!
           The pending bit (mip.MTIP) is set, waking the core without taking a trap. */
        __asm__ volatile("wfi");
        
        /* Check if timer expired */
        uint32_t mip;
        __asm__ volatile("csrr %0, mip" : "=r"(mip));
        if (mip & (1UL << 7)) {
            g_wake_count++;
            set_mtimecmp(read_mtime() + 2000ULL);
        }
    }

    if (g_wake_count < 64) finish(1);

    finish(0);
}
