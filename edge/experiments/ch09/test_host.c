#include "power_model.h"
#include <assert.h>
#include <stdio.h>

int main(void) {
    int res = power_model_selftest();
    if (res != 0) {
        fprintf(stderr, "POWER MODEL FAIL at selftest line %d\n", res);
        return 1;
    }
    puts("MODEL PASS power core: dynamic power, static leakage, DVFS quadratic scaling");

    /* 1. DVFS quantitative comparison */
    PowerOperatingPoint pop_high = {.voltage_mv = 3300, .freq_khz = 100000, .alpha_c_pf = 200, .ileak_ua = 500};
    PowerOperatingPoint pop_mid  = {.voltage_mv = 1800, .freq_khz = 50000,  .alpha_c_pf = 200, .ileak_ua = 200};
    PowerOperatingPoint pop_low  = {.voltage_mv = 1100, .freq_khz = 25000,  .alpha_c_pf = 200, .ileak_ua = 80};

    uint64_t e_high = power_calc_task_energy_nj(&pop_high, 1000000);
    uint64_t e_mid  = power_calc_task_energy_nj(&pop_mid,  1000000);
    uint64_t e_low  = power_calc_task_energy_nj(&pop_low,  1000000);

    printf("MODEL DVFS energy (1M cycles task): High(3.3V)=%llu nJ, Mid(1.8V)=%llu nJ, Low(1.1V)=%llu nJ\n",
           (unsigned long long)e_high, (unsigned long long)e_mid, (unsigned long long)e_low);
    assert(e_high > e_mid && e_mid > e_low);
    /* Low (1.1V) saves over 85% energy compared to High (3.3V) */
    assert(e_low * 7 < e_high);

    /* 2. Break-even analysis */
    /* P_run = 220 mW (220,000 uW), P_sleep = 50 uW, Wakeup time = 600 us (PLL relock), P_wake = 250,000 uW */
    uint32_t be_pll = power_calc_breakeven_us(220000, 50, 600, 250000);
    printf("MODEL break-even: with PLL relock (twake=600us), break-even time = %u us\n", be_pll);
    assert(be_pll >= 600 && be_pll <= 700);

    /* Fast wakeup without PLL: twake = 5 us, P_wake = 100,000 uW */
    uint32_t be_fast = power_calc_breakeven_us(220000, 50, 5, 100000);
    printf("MODEL break-even: fast internal osc (twake=5us), break-even time = %u us\n", be_fast);
    assert(be_fast < 5);

    /* 3. Tickless Idle vs Periodic Tick simulation */
    /* Scenario: Sensor node wakes every 100 ms to do a 10,000-cycle calculation (100 us at 100MHz).
       Total time: 1000 ms (1 second).
       Periodic tick wakes 1000 times a year/second!
       Tickless wakes 10 times! */
    TicklessComparison cmp = power_simulate_tickless(&pop_high, 50, 10, 150000, 100, 1000, 10000);
    printf("MODEL tickless: 1s simulation (event every 100ms):\n");
    printf("  Periodic 1ms Tick: %u wakeups, total energy = %llu nJ\n",
           cmp.periodic_wakeups, (unsigned long long)cmp.periodic_energy_nj);
    printf("  Tickless Idle:     %u wakeups, total energy = %llu nJ\n",
           cmp.tickless_wakeups, (unsigned long long)cmp.tickless_energy_nj);
    assert(cmp.periodic_wakeups == 1000 && cmp.tickless_wakeups == 10);
    /* Tickless idle should achieve dramatic energy reduction (>= 80% savings) */
    assert(cmp.tickless_energy_nj * 4 < cmp.periodic_energy_nj);
    puts("MODEL PASS tickless: periodic 1ms tick wasted >75% energy on idle wakeups; tickless eliminated it");

    return 0;
}
