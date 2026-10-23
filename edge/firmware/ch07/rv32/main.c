#include <stdint.h>
#include "dsp.h"
int main(void) {
 int result = dsp_selftest();
 const char *s = result ? "RV32 DSP FAIL\n" : "RV32 DSP PASS: MULH/MUL, Q15, FIR/IIR, FFT64\n";
 while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
 *(volatile uint32_t *)0x100000 = result ? 0x13333 : 0x5555;
 for (;;) {}
}
