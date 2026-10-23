#include "dsp.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdint.h>

static double check_fft(void) {
    const double pi = acos(-1.0);
    uint32_t seed = 0x71b5u;
    double worst = 0;
    for (unsigned trial = 0; trial < 32; ++trial) {
        DspComplex input[DSP_FFT_SIZE], output[DSP_FFT_SIZE];
        for (unsigned n = 0; n < DSP_FFT_SIZE; ++n) {
            seed = seed*1664525u + 1013904223u;
            input[n].re = (int16_t)((int32_t)((seed >> 16) & 8191u) - 4096);
            seed = seed*1664525u + 1013904223u;
            input[n].im = (int16_t)((int32_t)((seed >> 16) & 8191u) - 4096);
            output[n] = input[n];
        }
        unsigned clipped = 0;
        dsp_fft64(output, &clipped);
        assert(clipped == 0);
        for (unsigned k = 0; k < DSP_FFT_SIZE; ++k) {
            double re = 0, im = 0;
            for (unsigned n = 0; n < DSP_FFT_SIZE; ++n) {
                double phase = -2*pi*k*n/DSP_FFT_SIZE;
                re += input[n].re*cos(phase) - input[n].im*sin(phase);
                im += input[n].re*sin(phase) + input[n].im*cos(phase);
            }
            re /= DSP_FFT_SIZE; im /= DSP_FFT_SIZE;
            double error = fmax(fabs(output[k].re-re), fabs(output[k].im-im));
            if (error > worst) worst = error;
            assert(error <= 12.0);
        }
    }
    return worst;
}
int main(void) {
    int result = dsp_selftest();
    if (result) { fprintf(stderr, "DSP FAIL at selftest line %d\n", result); return 1; }
    puts("PASS Q15: signed widening, symmetric ties, INT64 extremes, saturation and ADC code bounds");
    puts("PASS FIR/IIR: asymmetric impulse, DC, wraparound history, wide accumulation, feedback endpoints");
    printf("REFERENCE PASS FFT64: 32 complex blocks vs independent double DFT, max component error=%.6f LSB\n", check_fft());
    int64_t exact = 16 * (int64_t)32767 * 32767;
    uint32_t modular = (uint32_t)exact;
    int64_t interpreted = modular >= UINT32_C(0x80000000) ? (int64_t)modular - INT64_C(4294967296) : modular;
    assert(dsp_round15(interpreted) == -32);
    printf("MODEL overflow: exact sum=%lld, deliberately modular 32-bit path -> -32, wide+saturate -> 32767\n", (long long)exact);
    uint64_t oldest_ns = (DSP_FFT_SIZE - 1u) * UINT64_C(1000000000) / 16000;
    assert(oldest_ns == 3937500 && oldest_ns > 1000000);
    puts("MODEL deadline: 64 samples at 16kS/s -> oldest waits 3937.5us before compute, misses 1000us");
    const double pi = acos(-1.0);
    for (unsigned n = 0; n < 1000; ++n) {
        double low = cos(2*pi*100*n/1000);
        double high = cos(2*pi*900*n/1000);
        assert(fabs(low-high) < 1e-10);
    }
    puts("MODEL alias: sampled cos(100Hz) and cos(900Hz) agree at 1kS/s (1000 samples)");
    return 0;
}
