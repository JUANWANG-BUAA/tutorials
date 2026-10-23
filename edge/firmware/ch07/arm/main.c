#include <stdint.h>
#include "dsp.h"
#define REG(address) (*(volatile uint32_t *)(address))
#define ADC_BASE 0x40038000u
#define TIMER_BASE 0x40030000u
static DspFir filter;
static unsigned samples, minimum=1023, maximum;
static void output(const char *s) {
 register uint32_t r0 __asm__("r0")=4;
 register const char *r1 __asm__("r1")=s;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}
__attribute__((noreturn)) static void finish(unsigned code) {
 uint32_t block[2]={0x20026,code};
 output(code ? "ARM ADC/DSP FAIL\n" : "ARM ADC PASS: IRQ17, 64 synthetic samples, FIFO read and ISC clear\n");
 register uint32_t r0 __asm__("r0")=0x20;
 register uint32_t *r1 __asm__("r1")=block;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
 for (;;) {}
}
void fault(void) { finish(1); }
void ADC3_Handler(void) {
 if (!(REG(ADC_BASE+0x004)&8u) || (REG(ADC_BASE+0x0ac)&0x100u)) finish(1);
 unsigned raw=REG(ADC_BASE+0x0a8)&0x3ffu;
 REG(ADC_BASE+0x00c)=8; /* acknowledge */
 if (REG(ADC_BASE+0x004)&8u) finish(1); /* controlled slow-trigger test, not a production race rule */
 int16_t normalized;
 if (!dsp_adc_to_q15(raw,10,&normalized)) finish(1);
 (void)dsp_fir_step(&filter,normalized);
 if (raw<minimum) minimum=raw;
 if (raw>maximum) maximum=raw;
 if (++samples==64) {
  REG(TIMER_BASE+0x00c)=0;
  REG(ADC_BASE+0x008)=0;
  finish(minimum==maximum || filter.clipped);
 }
}
int main(void) {
 if (dsp_selftest()) finish(1);
 output("ARM DSP PASS: SMULL, Q15, FIR/IIR, FFT64\n");
 static const int16_t average[4]={8192,8192,8192,8192};
 if (!dsp_fir_init(&filter,average,4)) finish(1);
 REG(0x400fe100)|=1u<<16; /* ADC clock */
 REG(0x400fe104)|=1u<<16; /* Timer0 clock */
 (void)REG(0x400fe104);
 REG(TIMER_BASE+0x00c)=0;
 REG(ADC_BASE+0x000)=0;
 REG(ADC_BASE+0x008)=0;
 REG(ADC_BASE+0x014)=5u<<12; /* SS3: hardware timer trigger, PSSI not implemented by QEMU */
 REG(ADC_BASE+0x0a0)=0;
 REG(ADC_BASE+0x0a4)=6; /* END0 | IE0 */
 REG(ADC_BASE+0x00c)=8;
 REG(ADC_BASE+0x000)=8;
 REG(ADC_BASE+0x008)=8;
 REG(0xe000e100)=1u<<17;
 REG(TIMER_BASE+0x000)=0;
 REG(TIMER_BASE+0x004)=2; /* periodic, 32-bit */
 REG(TIMER_BASE+0x028)=49999;
 REG(TIMER_BASE+0x00c)=0x21; /* TAOTE | TAEN */
 __asm__ volatile("cpsie i" ::: "memory");
 for (;;) __asm__ volatile("wfi");
}
