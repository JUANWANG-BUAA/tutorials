#include <stdint.h>
#include <stdbool.h>
#include "power_model.h"

#define REG(a) (*(volatile uint32_t *)(a))

/* ARM System Control Block SCR register */
#define SCB_SCR         0xE000ED10UL
#define SCR_SLEEPONEXIT (1UL << 1)
#define SCR_SLEEPDEEP   (1UL << 2)
#define SCR_SEVONPEND   (1UL << 4)

/* SysTick Registers */
#define SYST_CSR        0xE000E010UL
#define SYST_RVR        0xE000E014UL
#define SYST_CVR        0xE000E018UL

/* Stellaris LM3S Clock Gating Registers */
#define SYSCTL_RCGC0    0x400FE100UL
#define SYSCTL_SCGC0    0x400FE110UL
#define SYSCTL_DCGC0    0x400FE120UL

static volatile uint32_t g_wake_count = 0;

static void puts_host(const char *s) {
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}

__attribute__((noreturn)) static void finish(uint32_t code) {
    puts_host(code ? "ARM POWER FAIL\n" : "ARM POWER PASS: SCB->SCR, SLEEPONEXIT, clock gating, 64 wake cycles\n");
    uint32_t block[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = block;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
    for (;;) {}
}

void fault(void) { finish(1); }

void SysTick_Handler(void) {
    g_wake_count++;
    if (g_wake_count >= 64) {
        /* Stop SysTick */
        REG(SYST_CSR) = 0;
        /* Disable SLEEPONEXIT so we can return to thread mode and finish */
        REG(SCB_SCR) &= ~SCR_SLEEPONEXIT;
    }
}

int main(void) {
    if (power_model_selftest() != 0) finish(1);

    /* 1. Configure Clock Gating: enable only required peripherals */
    REG(SYSCTL_RCGC0) |= (1UL << 16); /* ADC in run mode */
    REG(SYSCTL_SCGC0) &= ~(1UL << 16); /* Gate ADC in sleep mode */
    REG(SYSCTL_DCGC0) &= ~(1UL << 16); /* Gate ADC in deep sleep */

    /* 2. Configure System Control Register (SCR) */
    /* Set SLEEPONEXIT: upon returning from ISR, CPU directly enters sleep! */
    REG(SCB_SCR) |= SCR_SLEEPONEXIT;
    if (!(REG(SCB_SCR) & SCR_SLEEPONEXIT)) finish(1);

    /* 3. Configure SysTick for periodic wakeups */
    REG(SYST_RVR) = 5000; /* Reload count */
    REG(SYST_CVR) = 0;
    /* Enable SysTick, enable interrupt, use core clock */
    REG(SYST_CSR) = 7;

    /* 4. Open global interrupts and enter sleep via WFI */
    __asm__ volatile("cpsie i\n dsb\n isb" ::: "memory");
    
    /* Wait for event-driven wakeups */
    while (g_wake_count < 64) {
        __asm__ volatile("wfi");
    }

    if (g_wake_count != 64) finish(1);

    finish(0);
}
