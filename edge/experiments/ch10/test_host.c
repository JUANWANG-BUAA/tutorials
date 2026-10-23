#include "fault_recovery.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

/* Simulated 1 KB Battery-Backed / Non-Volatile SRAM for Crash Dump */
static uint8_t g_sim_nvram[1024];

static void test_persistent_crash_triage(void) {
    memset(g_sim_nvram, 0, sizeof(g_sim_nvram));
    CrashDump *nv_dump = (CrashDump *)g_sim_nvram;

    /* 1. System crashes due to HardFault at PC=0x08002A40, accessing address 0xE000ED28 */
    crash_dump_save(nv_dump, FAULT_HARD_FAULT, 0x08002A40, 0x08001122, 0xE000ED28, 0x00020000, 543210);

    /* 2. System reboots (simulated by verifying NVRAM content) */
    assert(crash_dump_validate(nv_dump));
    assert(nv_dump->magic == CRASH_DUMP_MAGIC);
    assert(nv_dump->fault_reason == FAULT_HARD_FAULT);
    assert(nv_dump->faulting_pc == 0x08002A40);
    assert(nv_dump->faulting_address == 0xE000ED28);

    printf("MODEL crash dump triage: valid signature in NVRAM, Reason=HardFault, PC=0x%08X, Target=0x%08X\n",
           nv_dump->faulting_pc, nv_dump->faulting_address);
}

static void test_multitask_liveliness_stream(void) {
    WatchdogSupervisor ws;
    wdt_supervisor_init(&ws);

    /* Register:
       Task 10 (Motor FOC, 10ms +/- 2ms: 8ms..12ms)
       Task 20 (CAN TX,    50ms +/- 10ms: 40ms..60ms) */
    wdt_register_task(&ws, 10, 8000, 12000);
    wdt_register_task(&ws, 20, 40000, 60000);

    /* Simulate 500 ms of healthy operation */
    uint32_t t_us = 0;
    uint32_t t10_token = 1, t20_token = 1;

    /* Initial sync */
    wdt_task_checkin(&ws, 10, t10_token++, t_us);
    wdt_task_checkin(&ws, 20, t20_token++, t_us);

    while (t_us < 500000) {
        t_us += 1000; /* Step 1 ms */

        /* Task 10 checks in every 10 ms */
        if ((t_us % 10000) == 0) {
            bool ok = wdt_task_checkin(&ws, 10, t10_token++, t_us);
            assert(ok);
        }

        /* Task 20 checks in every 50 ms */
        if ((t_us % 50000) == 0) {
            bool ok = wdt_task_checkin(&ws, 20, t20_token++, t_us);
            assert(ok);
        }

        /* Supervisor polls every 5 ms */
        if ((t_us % 5000) == 0) {
            bool ok = wdt_supervisor_poll(&ws, t_us);
            assert(ok);
        }
    }

    assert(ws.hardware_wdt_feed_count == 100);
    assert(ws.last_fault == FAULT_NONE);
    printf("MODEL supervisor: 500ms continuous multitask window check-in, 100 feeds, 0 faults\n");
}

int main(void) {
    int res = fault_recovery_selftest();
    if (res != 0) {
        fprintf(stderr, "FAULT RECOVERY FAIL at selftest line %d\n", res);
        return 1;
    }
    puts("MODEL PASS fault core: window supervisor, early kick rejection, late timeout, FTTI budget");

    test_persistent_crash_triage();
    test_multitask_liveliness_stream();

    /* Quantitative FTTI verification:
       FTTI requirement for automotive electronic throttle: 50 ms (50,000 us).
       Window WDT maximum interval: 15 ms.
       Fault detection latency: 15 ms.
       Reaction & shutdown (Safe state transition): 5 ms.
       Total = 20 ms <= 50 ms (30 ms safety margin). */
    FttiBudget throttle_safety = {
        .ftti_limit_us = 50000,
        .fault_detect_time_us = 15000,
        .reaction_time_us = 1000,
        .safe_state_transition_us = 4000
    };
    assert(ftti_verify_budget(&throttle_safety));
    puts("MODEL FTTI budget: 20ms total fault reaction <= 50ms FTTI limit verified");

    return 0;
}
