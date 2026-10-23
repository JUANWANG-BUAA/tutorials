#ifndef EDGE_DSP_H
#define EDGE_DSP_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#define DSP_MAX_TAPS 16u
#define DSP_FFT_SIZE 64u
/* Full signed 32x32->64 result. Architecture implementations obey the target ABI. */
int64_t dsp_mul_wide(int32_t a, int32_t b);
int64_t dsp_round15(int64_t value); /* nearest, ties away from zero; all int64 inputs */
int16_t dsp_sat16(int64_t value, unsigned *clipped);
int16_t dsp_q15_mul(int16_t a, int16_t b, unsigned *clipped);
bool dsp_adc_to_q15(unsigned code, unsigned bits, int16_t *out);
typedef struct {
    int16_t coefficient[DSP_MAX_TAPS], history[DSP_MAX_TAPS];
    unsigned taps, next, clipped;
} DspFir;
bool dsp_fir_init(DspFir *fir, const int16_t *coefficients, unsigned taps);
int16_t dsp_fir_step(DspFir *fir, int16_t sample);
int16_t dsp_iir_step(int16_t previous, int16_t sample, uint16_t alpha);
typedef struct { int16_t re, im; } DspComplex;
/* In-place radix-2 DIT, natural-order output; divide by two at EACH of six stages.
 * Output approximates DFT(input)/64. Does NOT apply a window or infer sample rate. */
void dsp_fft64(DspComplex data[DSP_FFT_SIZE], unsigned *clipped);
int dsp_selftest(void);
#endif
