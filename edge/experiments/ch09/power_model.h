#ifndef EDGE_POWER_MODEL_H
#define EDGE_POWER_MODEL_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/*
 * Dynamic power: P_dyn = alpha * C * V^2 * f
 * Static leakage: P_leak = V * I_leak
 * Units:
 *   Voltage: millivolts (mV), e.g. 3300 mV, 1800 mV, 1100 mV
 *   Frequency: kHz (e.g. 100000 kHz = 100 MHz)
 *   Capacitance factor alpha*C: picofarads (pF), e.g. 200 pF
 *   Leakage current: microamperes (uA), e.g. 50 uA, 500 uA
 * Output power: microwatts (uW)
 * Output energy: picojoules (pJ) or nanojoules (nJ)
 */

typedef struct {
    uint32_t voltage_mv;
    uint32_t freq_khz;
    uint32_t alpha_c_pf;
    uint32_t ileak_ua;
} PowerOperatingPoint;

/* Calculate total power in microwatts (uW) */
uint64_t power_calc_total_uw(const PowerOperatingPoint *pop);

/* Calculate dynamic power in microwatts (uW) */
uint64_t power_calc_dyn_uw(const PowerOperatingPoint *pop);

/* Calculate static leakage power in microwatts (uW) */
uint64_t power_calc_leak_uw(const PowerOperatingPoint *pop);

/* Calculate energy for a task of N cycles in nanojoules (nJ) */
uint64_t power_calc_task_energy_nj(const PowerOperatingPoint *pop, uint64_t num_cycles);

/*
 * Sleep break-even calculation:
 * P_run_uw: Run mode power (uW)
 * P_sleep_uw: Sleep mode power (uW)
 * T_wake_us: Wakeup time duration (us)
 * P_wake_uw: Power during wakeup transition (uW)
 * Returns break-even time in microseconds (us).
 * If sleep duration is shorter than break-even, sleeping consumes MORE energy!
 */
uint32_t power_calc_breakeven_us(uint64_t p_run_uw, uint64_t p_sleep_uw,
                                uint32_t t_wake_us, uint64_t p_wake_uw);

/*
 * Tickless Idle vs Periodic Tick simulation
 * Total period: total_time_ms (e.g. 1000 ms)
 * Active task: task_cycles per interval, executed at each wake
 * Periodic tick: wakes every 1 ms regardless of work
 * Tickless: sleeps until actual next event
 * Returns energy consumed in nanojoules (nJ).
 */
typedef struct {
    uint64_t periodic_energy_nj;
    uint64_t tickless_energy_nj;
    uint32_t periodic_wakeups;
    uint32_t tickless_wakeups;
} TicklessComparison;

TicklessComparison power_simulate_tickless(const PowerOperatingPoint *pop_run,
                                           uint64_t p_sleep_uw,
                                           uint32_t t_wake_us,
                                           uint64_t p_wake_uw,
                                           uint32_t event_interval_ms,
                                           uint32_t total_time_ms,
                                           uint64_t task_cycles);

int power_model_selftest(void);

#endif /* EDGE_POWER_MODEL_H */
