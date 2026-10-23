#include "power_model.h"

/* Restoring 64-bit unsigned division without compiler runtime library dependencies */
static uint64_t udiv64(uint64_t n, uint64_t d) {
    if (d == 0) return 0;
    uint64_t q = 0;
    uint64_t r = 0;
    for (int i = 63; i >= 0; --i) {
        r = (r << 1) | ((n >> i) & 1ULL);
        if (r >= d) {
            r -= d;
            q |= (1ULL << i);
        }
    }
    return q;
}

uint64_t power_calc_dyn_uw(const PowerOperatingPoint *pop) {
    if (!pop || pop->freq_khz == 0) return 0;
    uint64_t v = pop->voltage_mv;
    uint64_t v2 = v * v;
    uint64_t num = (uint64_t)pop->alpha_c_pf * v2 * pop->freq_khz;
    return udiv64(num, 1000000000ULL);
}

uint64_t power_calc_leak_uw(const PowerOperatingPoint *pop) {
    if (!pop) return 0;
    uint64_t num = (uint64_t)pop->voltage_mv * pop->ileak_ua;
    return udiv64(num, 1000ULL);
}

uint64_t power_calc_total_uw(const PowerOperatingPoint *pop) {
    return power_calc_dyn_uw(pop) + power_calc_leak_uw(pop);
}

uint64_t power_calc_task_energy_nj(const PowerOperatingPoint *pop, uint64_t num_cycles) {
    if (!pop || pop->freq_khz == 0) return 0;
    uint64_t p_total = power_calc_total_uw(pop);
    /* E(nJ) = P_total(uW) * num_cycles / freq_khz */
    return udiv64(p_total * num_cycles, pop->freq_khz);
}

uint32_t power_calc_breakeven_us(uint64_t p_run_uw, uint64_t p_sleep_uw,
                                uint32_t t_wake_us, uint64_t p_wake_uw) {
    if (p_run_uw <= p_sleep_uw) return 0;
    uint64_t p_delta = p_run_uw - p_sleep_uw;
    uint64_t overhead_energy_uj = (uint64_t)t_wake_us * (p_wake_uw > p_sleep_uw ? p_wake_uw - p_sleep_uw : 0);
    return (uint32_t)udiv64(overhead_energy_uj + p_delta - 1ULL, p_delta);
}

TicklessComparison power_simulate_tickless(const PowerOperatingPoint *pop_run,
                                           uint64_t p_sleep_uw,
                                           uint32_t t_wake_us,
                                           uint64_t p_wake_uw,
                                           uint32_t event_interval_ms,
                                           uint32_t total_time_ms,
                                           uint64_t task_cycles) {
    TicklessComparison cmp = {0};
    if (!pop_run || pop_run->freq_khz == 0 || total_time_ms == 0) return cmp;

    uint64_t p_run_uw = power_calc_total_uw(pop_run);
    uint32_t task_time_us = (uint32_t)udiv64(task_cycles * 1000ULL, pop_run->freq_khz);

    /* 1. Periodic Tick Simulation: Wakes every 1 ms */
    uint64_t periodic_total_nj = 0;
    uint32_t periodic_wakes = total_time_ms;
    uint32_t event_count = total_time_ms / event_interval_ms;

    for (uint32_t ms = 0; ms < total_time_ms; ++ms) {
        bool has_event = (ms % event_interval_ms) == 0;
        uint64_t wake_e_nj = udiv64((uint64_t)t_wake_us * p_wake_uw, 1000000ULL);
        periodic_total_nj += wake_e_nj;

        uint32_t run_us = has_event ? task_time_us : 10u;
        uint64_t run_e_nj = udiv64((uint64_t)run_us * p_run_uw, 1000000ULL);
        periodic_total_nj += run_e_nj;

        uint32_t sleep_us = 1000u > (t_wake_us + run_us) ? 1000u - (t_wake_us + run_us) : 0;
        uint64_t sleep_e_nj = udiv64((uint64_t)sleep_us * p_sleep_uw, 1000000ULL);
        periodic_total_nj += sleep_e_nj;
    }

    /* 2. Tickless Simulation: Wakes only when real event is due */
    uint64_t tickless_total_nj = 0;
    uint32_t tickless_wakes = event_count;

    for (uint32_t ev = 0; ev < event_count; ++ev) {
        uint64_t wake_e_nj = udiv64((uint64_t)t_wake_us * p_wake_uw, 1000000ULL);
        tickless_total_nj += wake_e_nj;

        uint64_t run_e_nj = udiv64((uint64_t)task_time_us * p_run_uw, 1000000ULL);
        tickless_total_nj += run_e_nj;

        uint32_t interval_us = event_interval_ms * 1000u;
        uint32_t sleep_us = interval_us > (t_wake_us + task_time_us) ? interval_us - (t_wake_us + task_time_us) : 0;
        uint64_t sleep_e_nj = udiv64((uint64_t)sleep_us * p_sleep_uw, 1000000ULL);
        tickless_total_nj += sleep_e_nj;
    }

    cmp.periodic_energy_nj = periodic_total_nj;
    cmp.tickless_energy_nj = tickless_total_nj;
    cmp.periodic_wakeups = periodic_wakes;
    cmp.tickless_wakeups = tickless_wakes;
    return cmp;
}

int power_model_selftest(void) {
    /* Test 1: 3.3V, 100MHz, 200pF, 500uA */
    PowerOperatingPoint pop1 = {
        .voltage_mv = 3300,
        .freq_khz = 100000,
        .alpha_c_pf = 200,
        .ileak_ua = 500
    };
    uint64_t p_dyn1 = power_calc_dyn_uw(&pop1);
    uint64_t p_leak1 = power_calc_leak_uw(&pop1);
    /* P_dyn = 200 * 3300^2 * 100000 / 10^9 = 217800 uW = 217.8 mW */
    if (p_dyn1 != 217800) return 1;
    /* P_leak = 3300 * 500 / 1000 = 1650 uW = 1.65 mW */
    if (p_leak1 != 1650) return 2;
    if (power_calc_total_uw(&pop1) != 219450) return 3;

    /* Task energy for 100,000 cycles (1ms at 100MHz) */
    uint64_t e1 = power_calc_task_energy_nj(&pop1, 100000);
    if (e1 != 219450) return 4;

    /* Test 2: Frequency Scaling ONLY (drop to 50MHz, voltage unchanged 3.3V) */
    PowerOperatingPoint pop_half_f = {
        .voltage_mv = 3300,
        .freq_khz = 50000,
        .alpha_c_pf = 200,
        .ileak_ua = 500
    };
    uint64_t p_dyn_half = power_calc_dyn_uw(&pop_half_f);
    if (p_dyn_half != 108900) return 5; /* Power halved! */
    /* But energy for same 100,000 cycles: time doubled to 2ms! */
    uint64_t e_half_f = power_calc_task_energy_nj(&pop_half_f, 100000);
    /* Dynamic energy per task = P_dyn * 2ms = 108900 * 2 = 217800 nJ (UNCHANGED!)
       Plus leakage doubles: 1650 uW * 2ms = 3300 nJ. Total = 221100 nJ!
       So dropping frequency alone WITHOUT voltage actually INCREASES total energy! */
    if (e_half_f <= e1) return 6;

    /* Test 3: DVFS (Voltage scaled to 1.8V with 50MHz) */
    PowerOperatingPoint pop_dvfs = {
        .voltage_mv = 1800,
        .freq_khz = 50000,
        .alpha_c_pf = 200,
        .ileak_ua = 200
    };
    uint64_t e_dvfs = power_calc_task_energy_nj(&pop_dvfs, 100000);
    /* P_dyn = 200 * 1800^2 * 50000 / 10^9 = 32400 uW.
       P_leak = 1800 * 200 / 1000 = 360 uW.
       Total = 32760 uW.
       Energy for 100,000 cycles (2ms at 50MHz) = 32760 * 100000 / 50000 = 65520 nJ!
       Energy reduced by > 70%! Quadratic savings confirmed! */
    if (e_dvfs != 65520) return 7;

    /* Test 4: Break-even time calculation */
    /* P_run = 200,000 uW, P_sleep = 100 uW, t_wake = 50 us, P_wake = 250,000 uW */
    uint32_t t_be = power_calc_breakeven_us(200000, 100, 50, 250000);
    /* Overhead = 50 * (250000 - 100) = 12495000 uJ.
       P_delta = 200000 - 100 = 199900 uW.
       t_be = 12495000 / 199900 = 62.5 -> 63 us */
    if (t_be != 63) return 8;

    return 0;
}
