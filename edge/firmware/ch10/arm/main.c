#include <stdint.h>
#include <stdbool.h>
#include "fault_recovery.h"

#define REG(a) (*(volatile uint32_t *)(a))

/* Stellaris LM3S6965 Watchdog 0 Base */
#define WDT_BASE       0x40000000UL
#define WDT_LOAD       (WDT_BASE + 0x000)
#define WDT_VALUE      (WDT_BASE + 0x004)
#define WDT_CTL        (WDT_BASE + 0x008)
#define WDT_ICR        (WDT_BASE + 0x00C)
#define WDT_RIS        (WDT_BASE + 0x010)
#define WDT_LOCK       (WDT_BASE + 0xC00)
#define WDT_UNLOCK_KEY 0x1ACCE551UL

/* System Control System Reset Cause */
#define SYSCTL_RESC    0x400FE05CUL

/* Cortex-M3 SCB Fault Registers */
#define SCB_CFSR       0xE000ED28UL
#define SCB_HFSR       0xE000ED2CUL
#define SCB_MMFAR      0xE000ED34UL
#define SCB_BFAR       0xE000ED38UL

static volatile uint32_t g_wdt_kicks = 0;
static CrashDump g_captured_crash;
static volatile bool g_hardfault_handled = false;

static void puts_host(const char *s) {
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}

__attribute__((noreturn)) static void finish(uint32_t code) {
    puts_host(code ? "ARM FAULT FAIL\n" : "ARM FAULT PASS: WDT key unlock, HardFault stack frame decode, CFSR\n");
    uint32_t block[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = block;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
    for (;;) {}
}

void fault(void) { finish(1); }

void watchdog_irq_handler(void) {
    g_wdt_kicks++;
    /* Writing any value to WDTICR clears the interrupt and reloads counter */
    REG(WDT_ICR) = 1;
}

/* HardFault C decoder invoked by hardfault_asm_entry */
void hardfault_c_decoder(uint32_t *stacked_sp, uint32_t exc_return) {
    (void)exc_return;
    uint32_t stacked_r0  = stacked_sp[0];
    uint32_t stacked_r1  = stacked_sp[1];
    uint32_t stacked_r2  = stacked_sp[2];
    uint32_t stacked_r3  = stacked_sp[3];
    uint32_t stacked_r12 = stacked_sp[4];
    uint32_t stacked_lr  = stacked_sp[5];
    uint32_t stacked_pc  = stacked_sp[6];
    uint32_t stacked_psr = stacked_sp[7];
    (void)stacked_r0; (void)stacked_r1; (void)stacked_r2; (void)stacked_r3;
    (void)stacked_r12; (void)stacked_psr;

    uint32_t cfsr = REG(SCB_CFSR);
    uint32_t hfsr = REG(SCB_HFSR);
    (void)hfsr;

    crash_dump_save(&g_captured_crash, FAULT_HARD_FAULT, stacked_pc, stacked_lr,
                    REG(SCB_BFAR), cfsr, 123456);

    g_hardfault_handled = true;

    /* To resume testing without infinite fault loop, advance stacked PC past the faulting instruction (2 bytes) */
    stacked_sp[6] += 2;
}

/* Function containing a deliberate test crash trigger */
__attribute__((noinline)) void trigger_deliberate_crash(void) {
    /* Execute undefined Thumb instruction: 0xDE00 triggers UsageFault/HardFault */
    __asm__ volatile(".short 0xde00");
}

int main(void) {
    if (fault_recovery_selftest() != 0) finish(1);

    /* 1. Test Hardware Watchdog Timer programming */
    /* Must unlock before configuration */
    REG(WDT_LOCK) = WDT_UNLOCK_KEY;
    REG(WDT_LOAD) = 50000; /* Load count */
    REG(WDT_CTL)  = 1;     /* INTIEN enable */
    /* Lock registers */
    REG(WDT_LOCK) = 0;

    /* Verify counter counts down */
    uint32_t val1 = REG(WDT_VALUE);
    for (volatile int i = 0; i < 500; ++i) {}
    uint32_t val2 = REG(WDT_VALUE);
    if (val2 >= val1) finish(1); /* Counter must tick down! */

    /* Feed watchdog */
    REG(WDT_LOCK) = WDT_UNLOCK_KEY;
    REG(WDT_ICR)  = 1;
    REG(WDT_LOCK) = 0;

    /* 2. Test HardFault Stack Decoding */
    trigger_deliberate_crash();

    /* Verify that HardFault handler captured the crash dump */
    if (!g_hardfault_handled) finish(1);
    if (!crash_dump_validate(&g_captured_crash)) finish(1);
    if (g_captured_crash.fault_reason != FAULT_HARD_FAULT) finish(1);

    finish(0);
}
