#include "dsp.h"
#include "twiddle64.h"

int64_t dsp_round15(int64_t value) {
    /* No abs(INT64_MIN), signed negative shift, or overflowing rounding bias. */
    int64_t quotient = value / 32768;
    int64_t remainder = value % 32768;
    if (remainder >= 16384) ++quotient;
    if (remainder <= -16384) --quotient;
    return quotient;
}
int16_t dsp_sat16(int64_t value, unsigned *clipped) {
    if (value > INT16_MAX) { if (clipped) ++*clipped; return INT16_MAX; }
    if (value < INT16_MIN) { if (clipped) ++*clipped; return INT16_MIN; }
    return (int16_t)value;
}
int16_t dsp_q15_mul(int16_t a, int16_t b, unsigned *clipped) {
    return dsp_sat16(dsp_round15(dsp_mul_wide(a, b)), clipped);
}
bool dsp_adc_to_q15(unsigned code, unsigned bits, int16_t *out) {
    if (!out || bits < 1 || bits > 16 || code >= (1u << bits)) return false;
    int32_t centered = (int32_t)code - (int32_t)(1u << (bits - 1));
    int32_t factor = (int32_t)(1u << (16 - bits));
    *out = (int16_t)(centered * factor);
    return true;
}
bool dsp_fir_init(DspFir *fir, const int16_t *coefficients, unsigned taps) {
    if (!fir || !coefficients || !taps || taps > DSP_MAX_TAPS) return false;
    fir->taps = taps; fir->next = 0; fir->clipped = 0;
    for (unsigned i = 0; i < DSP_MAX_TAPS; ++i) {
        fir->history[i] = 0;
        fir->coefficient[i] = i < taps ? coefficients[i] : 0;
    }
    return true;
}
int16_t dsp_fir_step(DspFir *fir, int16_t sample) {
    /* Valid initialized state, single writer; not a thread-safe ISR/task queue. */
    fir->history[fir->next] = sample;
    unsigned at = fir->next;
    int64_t accumulator = 0;
    for (unsigned i = 0; i < fir->taps; ++i) {
        accumulator += dsp_mul_wide(fir->coefficient[i], fir->history[at]);
        at = at ? at - 1 : fir->taps - 1;
    }
    fir->next = (fir->next + 1 == fir->taps) ? 0 : fir->next + 1;
    return dsp_sat16(dsp_round15(accumulator), &fir->clipped);
}
int16_t dsp_iir_step(int16_t previous, int16_t sample, uint16_t alpha) {
    /* alpha is Q15 in [0,32768], including exactly 1.0. Clamp invalid larger values. */
    if (alpha > 32768) alpha = 32768;
    int32_t difference = (int32_t)sample - previous;
    int64_t correction = dsp_round15(dsp_mul_wide(difference, alpha));
    return dsp_sat16((int64_t)previous + correction, 0);
}
static int64_t half_round(int64_t value) {
    int64_t q = value / 2;
    if (value % 2) q += value > 0 ? 1 : -1;
    return q;
}
void dsp_fft64(DspComplex data[DSP_FFT_SIZE], unsigned *clipped) {
    for (unsigned i = 0, reverse = 0; i < DSP_FFT_SIZE; ++i) {
        if (i < reverse) { DspComplex tmp = data[i]; data[i] = data[reverse]; data[reverse] = tmp; }
        unsigned bit = DSP_FFT_SIZE / 2;
        while (bit && (reverse & bit)) { reverse ^= bit; bit >>= 1; }
        reverse ^= bit;
    }
    for (unsigned length = 2; length <= DSP_FFT_SIZE; length *= 2) {
        unsigned half = length / 2;
        unsigned stride = DSP_FFT_SIZE / length;
        for (unsigned base = 0; base < DSP_FFT_SIZE; base += length) {
            for (unsigned j = 0; j < half; ++j) {
                DspComplex a = data[base + j], b = data[base + j + half];
                DspComplex w = dsp_twiddle[j * stride];
                int64_t real = dsp_round15(dsp_mul_wide(b.re, w.re) - dsp_mul_wide(b.im, w.im));
                int64_t imag = dsp_round15(dsp_mul_wide(b.re, w.im) + dsp_mul_wide(b.im, w.re));
                data[base + j].re = dsp_sat16(half_round((int64_t)a.re + real), clipped);
                data[base + j].im = dsp_sat16(half_round((int64_t)a.im + imag), clipped);
                data[base + j + half].re = dsp_sat16(half_round((int64_t)a.re - real), clipped);
                data[base + j + half].im = dsp_sat16(half_round((int64_t)a.im - imag), clipped);
            }
        }
    }
}
