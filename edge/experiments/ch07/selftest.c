#include "dsp.h"
#include <limits.h>
#define REQUIRE(x) do { if (!(x)) return __LINE__; } while (0)

int dsp_selftest(void) {
    static const int32_t values[] = {INT32_MIN, -32768, -7, -1, 0, 1, 7, 32767, INT32_MAX};
    for (unsigned i = 0; i < sizeof(values)/sizeof(values[0]); ++i)
        for (unsigned j = 0; j < sizeof(values)/sizeof(values[0]); ++j)
            REQUIRE(dsp_mul_wide(values[i], values[j]) == (int64_t)values[i] * values[j]);
    REQUIRE(dsp_round15(16383) == 0 && dsp_round15(16384) == 1);
    REQUIRE(dsp_round15(-16383) == 0 && dsp_round15(-16384) == -1);
    REQUIRE(dsp_round15(INT64_MAX) == INT64_C(281474976710656));
    REQUIRE(dsp_round15(INT64_MIN) == -INT64_C(281474976710656));
    unsigned clipped = 0;
    REQUIRE(dsp_q15_mul(INT16_MIN, INT16_MIN, &clipped) == INT16_MAX && clipped == 1);
    REQUIRE(dsp_q15_mul(-1, 16384, &clipped) == -1 && clipped == 1);
    REQUIRE(dsp_q15_mul(1, 16384, &clipped) == 1);
    int16_t code;
    REQUIRE(dsp_adc_to_q15(0, 10, &code) && code == INT16_MIN);
    REQUIRE(dsp_adc_to_q15(512, 10, &code) && code == 0);
    REQUIRE(dsp_adc_to_q15(1023, 10, &code) && code == 32704);
    REQUIRE(dsp_adc_to_q15(4095, 12, &code) && code == 32752);
    REQUIRE(!dsp_adc_to_q15(1024, 10, &code));
    REQUIRE(!dsp_adc_to_q15(0, 0, &code) && !dsp_adc_to_q15(0, 17, &code));

    DspFir fir;
    static const int16_t average[] = {8192,8192,8192,8192};
    REQUIRE(!dsp_fir_init(&fir, average, 0));
    REQUIRE(!dsp_fir_init(&fir, average, 17));
    REQUIRE(dsp_fir_init(&fir, average, 4));
    for (unsigned i = 0; i < 8; ++i) {
        int16_t y = dsp_fir_step(&fir, i == 0 ? 32767 : 0);
        REQUIRE(y == (i < 4 ? 8192 : 0));
    }
    REQUIRE(!fir.clipped);
    REQUIRE(dsp_fir_init(&fir, average, 4));
    for (unsigned i = 0; i < 20; ++i)
        REQUIRE(dsp_fir_step(&fir, 16384) == (i < 4 ? (int16_t)(4096*(i+1)) : 16384));
    static const int16_t asymmetric[] = {16384,8192,4096,2048};
    static const int16_t impulse[] = {8192,4096,2048,1024,0,0};
    REQUIRE(dsp_fir_init(&fir, asymmetric, 4));
    for (unsigned i = 0; i < 6; ++i)
        REQUIRE(dsp_fir_step(&fir, i == 0 ? 16384 : 0) == impulse[i]);
    int16_t loud[DSP_MAX_TAPS];
    for (unsigned i = 0; i < DSP_MAX_TAPS; ++i) loud[i] = 32767;
    REQUIRE(dsp_fir_init(&fir, loud, DSP_MAX_TAPS));
    for (unsigned i = 0; i < DSP_MAX_TAPS; ++i) (void)dsp_fir_step(&fir, 32767);
    REQUIRE(fir.clipped == DSP_MAX_TAPS - 1);
    REQUIRE(dsp_fir_step(&fir, 32767) == 32767);
    REQUIRE(dsp_iir_step(1, 0, 16384) == 0);
    REQUIRE(dsp_iir_step(1234, -2345, 0) == 1234);
    REQUIRE(dsp_iir_step(1234, -2345, 32768) == -2345);
    int16_t state = 0;
    for (unsigned i = 0; i < 100; ++i) state = dsp_iir_step(state, 10000, 8192);
    REQUIRE(state >= 9998 && state <= 10000);

    DspComplex data[DSP_FFT_SIZE];
    for (unsigned i = 0; i < DSP_FFT_SIZE; ++i) data[i] = (DspComplex){8192,0};
    clipped = 0; dsp_fft64(data, &clipped);
    REQUIRE(!clipped && data[0].re >= 8180 && data[0].re <= 8204);
    for (unsigned i = 1; i < DSP_FFT_SIZE; ++i)
        REQUIRE(data[i].re >= -12 && data[i].re <= 12 && data[i].im >= -12 && data[i].im <= 12);
    static const DspComplex cycle[4] = {{16384,0},{0,16384},{-16384,0},{0,-16384}};
    for (unsigned i = 0; i < DSP_FFT_SIZE; ++i) data[i] = cycle[i % 4];
    clipped = 0; dsp_fft64(data, &clipped);
    REQUIRE(!clipped && data[16].re >= 16360 && data[16].re <= 16408);
    for (unsigned i = 0; i < DSP_FFT_SIZE; ++i) {
        if (i != 16) REQUIRE(data[i].re >= -24 && data[i].re <= 24);
        REQUIRE(data[i].im >= -24 && data[i].im <= 24);
    }
    return 0;
}
