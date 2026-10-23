#include "fault_recovery.h"

static uint32_t calc_checksum(const CrashDump *d) {
    uint32_t sum = d->magic ^ d->fault_reason ^ d->faulting_pc ^ d->faulting_lr ^
                   d->faulting_address ^ d->status_reg ^ d->timestamp_us;
    return sum ^ 0xA5A5A5A5U;
}

void wdt_supervisor_init(WatchdogSupervisor *ws) {
    if (!ws) return;
    ws->num_tasks = 0;
    ws->supervisor_now_us = 0;
    ws->hardware_wdt_feed_count = 0;
    ws->last_fault = FAULT_NONE;
    ws->faulting_task_id = 0;
    for (unsigned i = 0; i < MAX_WATCHDOG_TASKS; ++i) {
        ws->tasks[i].active = false;
        ws->tasks[i].task_id = 0;
        ws->tasks[i].min_interval_us = 0;
        ws->tasks[i].max_interval_us = 0;
        ws->tasks[i].last_kick_us = 0;
        ws->tasks[i].token = 0;
    }
}

bool wdt_register_task(WatchdogSupervisor *ws, uint32_t task_id, uint32_t min_us, uint32_t max_us) {
    if (!ws || ws->num_tasks >= MAX_WATCHDOG_TASKS || min_us >= max_us) return false;
    for (unsigned i = 0; i < ws->num_tasks; ++i) {
        if (ws->tasks[i].task_id == task_id) return false;
    }
    unsigned idx = ws->num_tasks++;
    ws->tasks[idx].task_id = task_id;
    ws->tasks[idx].min_interval_us = min_us;
    ws->tasks[idx].max_interval_us = max_us;
    ws->tasks[idx].last_kick_us = 0;
    ws->tasks[idx].token = 0;
    ws->tasks[idx].active = true;
    return true;
}

bool wdt_task_checkin(WatchdogSupervisor *ws, uint32_t task_id, uint32_t token, uint32_t now_us) {
    if (!ws) return false;
    WatchdogTaskEntry *entry = NULL;
    for (unsigned i = 0; i < ws->num_tasks; ++i) {
        if (ws->tasks[i].active && ws->tasks[i].task_id == task_id) {
            entry = &ws->tasks[i];
            break;
        }
    }
    if (!entry) return false;

    /* If not the first check-in, evaluate window bounds */
    if (entry->token > 0) {
        uint32_t elapsed = (now_us >= entry->last_kick_us) ? (now_us - entry->last_kick_us) : 0;
        
        /* 1. Early kick violation: task is spinning out of control! */
        if (elapsed < entry->min_interval_us) {
            ws->last_fault = FAULT_WDT_EARLY_KICK;
            ws->faulting_task_id = task_id;
            return false;
        }

        /* 2. Token must strictly increase to prevent replay */
        if (token <= entry->token) {
            ws->last_fault = FAULT_CORRUPT_STATE;
            ws->faulting_task_id = task_id;
            return false;
        }
    }

    entry->last_kick_us = now_us;
    entry->token = token;
    return true;
}

bool wdt_supervisor_poll(WatchdogSupervisor *ws, uint32_t now_us) {
    if (!ws) return false;
    ws->supervisor_now_us = now_us;

    /* Check each active task for late kick (deadline violation) */
    for (unsigned i = 0; i < ws->num_tasks; ++i) {
        if (!ws->tasks[i].active) continue;
        uint32_t elapsed = (now_us >= ws->tasks[i].last_kick_us) ? (now_us - ws->tasks[i].last_kick_us) : 0;
        if (ws->tasks[i].token > 0 && elapsed > ws->tasks[i].max_interval_us) {
            ws->last_fault = FAULT_WDT_TIMEOUT;
            ws->faulting_task_id = ws->tasks[i].task_id;
            return false; /* Do not feed hardware WDT; allow timeout reset */
        }
    }

    /* All tasks healthy: feed hardware watchdog */
    ws->hardware_wdt_feed_count++;
    return true;
}

void crash_dump_save(CrashDump *dump, FaultReason reason, uint32_t pc, uint32_t lr,
                     uint32_t fault_addr, uint32_t status, uint32_t now_us) {
    if (!dump) return;
    dump->magic = CRASH_DUMP_MAGIC;
    dump->fault_reason = (uint32_t)reason;
    dump->faulting_pc = pc;
    dump->faulting_lr = lr;
    dump->faulting_address = fault_addr;
    dump->status_reg = status;
    dump->timestamp_us = now_us;
    dump->checksum = calc_checksum(dump);
}

bool crash_dump_validate(const CrashDump *dump) {
    if (!dump) return false;
    if (dump->magic != CRASH_DUMP_MAGIC) return false;
    return dump->checksum == calc_checksum(dump);
}

bool ftti_verify_budget(const FttiBudget *b) {
    if (!b) return false;
    uint32_t total = b->fault_detect_time_us + b->reaction_time_us + b->safe_state_transition_us;
    return total <= b->ftti_limit_us;
}

int fault_recovery_selftest(void) {
    /* 1. Supervisor normal operation */
    WatchdogSupervisor ws;
    wdt_supervisor_init(&ws);

    /* Task 1: Control (period 10ms: min 8ms, max 12ms)
       Task 2: DAQ (period 50ms: min 40ms, max 60ms) */
    if (!wdt_register_task(&ws, 1, 8000, 12000)) return 1;
    if (!wdt_register_task(&ws, 2, 40000, 60000)) return 2;

    /* Initial check-in at t=0 */
    if (!wdt_task_checkin(&ws, 1, 1, 0)) return 3;
    if (!wdt_task_checkin(&ws, 2, 1, 0)) return 4;
    if (!wdt_supervisor_poll(&ws, 5000)) return 5;
    if (ws.hardware_wdt_feed_count != 1) return 6;

    /* Next check-in at t=10,000 us (valid for Task 1) */
    if (!wdt_task_checkin(&ws, 1, 2, 10000)) return 7;
    if (!wdt_supervisor_poll(&ws, 10000)) return 8;

    /* 2. Early kick violation: Task 1 kicks again at t=12,000 us (only 2ms elapsed, min is 8ms!) */
    if (wdt_task_checkin(&ws, 1, 3, 12000)) return 9; /* Must fail! */
    if (ws.last_fault != FAULT_WDT_EARLY_KICK || ws.faulting_task_id != 1) return 10;

    /* 3. Late kick violation: Keep Task 1 healthy at t=65,000 us, but Task 2 misses its 60ms deadline at t=70,000 us */
    if (!wdt_task_checkin(&ws, 1, 3, 65000)) return 10;
    ws.last_fault = FAULT_NONE;
    if (wdt_supervisor_poll(&ws, 70000)) return 11; /* Must fail poll! */
    if (ws.last_fault != FAULT_WDT_TIMEOUT || ws.faulting_task_id != 2) return 12;

    /* 4. Crash dump test */
    CrashDump dump;
    crash_dump_save(&dump, FAULT_HARD_FAULT, 0x08001234, 0x08005678, 0x20001000, 0x00010000, 100000);
    if (!crash_dump_validate(&dump)) return 13;
    if (dump.fault_reason != FAULT_HARD_FAULT || dump.faulting_pc != 0x08001234) return 14;

    /* Corrupt magic or checksum */
    dump.magic = 0x12345678;
    if (crash_dump_validate(&dump)) return 15; /* Must fail */

    /* 5. FTTI budget verification:
       FTTI limit = 50 ms (50,000 us).
       Detect = 12 ms, Reaction = 1 ms, Transition = 5 ms -> Total = 18 ms <= 50 ms (PASS) */
    FttiBudget b_pass = {
        .ftti_limit_us = 50000,
        .fault_detect_time_us = 12000,
        .reaction_time_us = 1000,
        .safe_state_transition_us = 5000
    };
    if (!ftti_verify_budget(&b_pass)) return 16;

    FttiBudget b_fail = {
        .ftti_limit_us = 10000,
        .fault_detect_time_us = 8000,
        .reaction_time_us = 2000,
        .safe_state_transition_us = 1000 /* Total 11 ms > 10 ms */
    };
    if (ftti_verify_budget(&b_fail)) return 17;

    return 0;
}
