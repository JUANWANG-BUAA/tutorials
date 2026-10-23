#ifndef EDGE_FAULT_RECOVERY_H
#define EDGE_FAULT_RECOVERY_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define MAX_WATCHDOG_TASKS  4u
#define CRASH_DUMP_MAGIC    0xDEADBEEFU

typedef enum {
    FAULT_NONE = 0,
    FAULT_WDT_TIMEOUT,
    FAULT_WDT_EARLY_KICK,
    FAULT_HARD_FAULT,
    FAULT_MEM_MANAGE,
    FAULT_BUS_ERROR,
    FAULT_USAGE_ERROR,
    FAULT_ILLEGAL_INSTRUCTION,
    FAULT_CORRUPT_STATE
} FaultReason;

/* Window Watchdog Task Registration */
typedef struct {
    uint32_t task_id;
    uint32_t min_interval_us;  /* Early kick limit */
    uint32_t max_interval_us;  /* Late kick limit (deadline) */
    uint32_t last_kick_us;
    uint32_t token;            /* Monotonically increasing check-in token */
    bool     active;
} WatchdogTaskEntry;

/* Multitask Centralized Watchdog Supervisor */
typedef struct {
    WatchdogTaskEntry tasks[MAX_WATCHDOG_TASKS];
    uint32_t num_tasks;
    uint32_t supervisor_now_us;
    uint32_t hardware_wdt_feed_count;
    FaultReason last_fault;
    uint32_t faulting_task_id;
} WatchdogSupervisor;

void wdt_supervisor_init(WatchdogSupervisor *ws);
bool wdt_register_task(WatchdogSupervisor *ws, uint32_t task_id, uint32_t min_us, uint32_t max_us);
/* Called by tasks to check in */
bool wdt_task_checkin(WatchdogSupervisor *ws, uint32_t task_id, uint32_t token, uint32_t now_us);
/* Called by high-priority timer / idle task to verify health and feed hardware WDT */
bool wdt_supervisor_poll(WatchdogSupervisor *ws, uint32_t now_us);

/* Persistent Crash Dump Structure */
typedef struct {
    uint32_t magic;
    uint32_t fault_reason;
    uint32_t faulting_pc;
    uint32_t faulting_lr;
    uint32_t faulting_address; /* MMFAR/BFAR on ARM, mtval on RV32, CR2 on x86 */
    uint32_t status_reg;       /* CFSR on ARM, mcause on RV32, ErrorCode on x86 */
    uint32_t timestamp_us;
    uint32_t checksum;
} CrashDump;

void crash_dump_save(CrashDump *dump, FaultReason reason, uint32_t pc, uint32_t lr,
                     uint32_t fault_addr, uint32_t status, uint32_t now_us);
bool crash_dump_validate(const CrashDump *dump);

/* FTTI (Fault Tolerant Time Interval) budget verification */
typedef struct {
    uint32_t ftti_limit_us;
    uint32_t fault_detect_time_us;
    uint32_t reaction_time_us;
    uint32_t safe_state_transition_us;
} FttiBudget;

bool ftti_verify_budget(const FttiBudget *budget);

int fault_recovery_selftest(void);

#endif /* EDGE_FAULT_RECOVERY_H */
