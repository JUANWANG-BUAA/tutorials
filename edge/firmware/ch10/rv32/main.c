#include <stdint.h>
#include <stdbool.h>
#include "fault_recovery.h"

#define REG(a) (*(volatile uint32_t *)(a))

static CrashDump g_captured_crash;
static volatile bool g_fault_handled = false;

__attribute__((noreturn)) void finish(unsigned code) {
    const char *s = code ? "RV32 FAULT FAIL\n" : "RV32 FAULT PASS: mcause/mtval decode, token watchdog supervisor\n";
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
    for (;;) {}
}

void default_trap_handler(void) {
    uint32_t mcause, mepc, mtval;
    __asm__ volatile("csrr %0, mcause" : "=r"(mcause));
    __asm__ volatile("csrr %0, mepc"   : "=r"(mepc));
    __asm__ volatile("csrr %0, mtval"  : "=r"(mtval));

    /* Check for Breakpoint (cause 3) or Illegal instruction (cause 2) */
    if (mcause == 3 || mcause == 2) {
        crash_dump_save(&g_captured_crash, FAULT_ILLEGAL_INSTRUCTION, mepc, 0, mtval, mcause, 9999);
        g_fault_handled = true;
        /* Advance mepc past ebreak (2 or 4 bytes) */
        mepc += 4;
        __asm__ volatile("csrw mepc, %0" : : "r"(mepc) : "memory");
    } else {
        finish(1);
    }
}

/* Assembly entry for mtvec */
__attribute__((naked, aligned(4))) void trap_entry(void) {
    __asm__ volatile(
        "addi sp, sp, -64\n"
        "sw ra, 0(sp)\n"
        "sw t0, 4(sp)\n"
        "sw t1, 8(sp)\n"
        "sw a0, 12(sp)\n"
        "call default_trap_handler\n"
        "lw a0, 12(sp)\n"
        "lw t1, 8(sp)\n"
        "lw t0, 4(sp)\n"
        "lw ra, 0(sp)\n"
        "addi sp, sp, 64\n"
        "mret\n"
    );
}

int main(void) {
    if (fault_recovery_selftest() != 0) finish(1);

    /* 1. Install trap vector */
    __asm__ volatile("csrw mtvec, %0" : : "r"((uintptr_t)trap_entry) : "memory");

    /* 2. Run supervisor checkin simulation */
    WatchdogSupervisor ws;
    wdt_supervisor_init(&ws);
    wdt_register_task(&ws, 1, 5000, 15000);
    wdt_task_checkin(&ws, 1, 1, 0);
    wdt_supervisor_poll(&ws, 10000);

    /* 3. Deliberately trigger an ebreak to test crash capture */
    __asm__ volatile("ebreak\n nop");

    if (!g_fault_handled) finish(1);
    if (!crash_dump_validate(&g_captured_crash)) finish(1);
    if (g_captured_crash.status_reg != 3) finish(1); /* mcause must be 3 (Breakpoint) */

    finish(0);
}
