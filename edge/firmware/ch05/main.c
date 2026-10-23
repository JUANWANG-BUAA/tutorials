#include <stdint.h>
#define MMIO(a) (*(volatile uint32_t *)(a))
#define UART 0x4000c000u
#define DR MMIO(UART + 0x00)
#define FR MMIO(UART + 0x18)
#define CR MMIO(UART + 0x30)
#define IMSC MMIO(UART + 0x38)
#define ICR MMIO(UART + 0x44)
static volatile uint32_t received, error;
static void output(const char *s) {
 while (*s) { while (FR & (1u << 5)) {} DR = (unsigned char)*s++; }
}
__attribute__((noreturn)) void finish(uint32_t code) {
 uint32_t block[2] = {0x20026, code};
 output(code ? "UART FAIL\n" : "UART PASS: IRQ5 received 0x55 and 0xa3\n");
 register uint32_t r0 __asm__("r0") = 0x20;
 register uint32_t *r1 __asm__("r1") = block;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
 for (;;) {}
}
void UART0_Handler(void) {
 while (!(FR & (1u << 4))) {
  uint32_t data = DR;
  uint32_t expected = received == 0 ? 0x55 : 0xa3;
  if ((data & 0xfffu) != expected || received >= 2) error = 1;
  ++received;
 }
 ICR = (1u << 4) | (1u << 6);
 __asm__ volatile("dsb" ::: "memory");
}
int main(void) {
 MMIO(0x400fe104) |= 1u; /* LM3S RCGC1 UART0 gate */
 CR = 0;
 MMIO(UART + 0x24) = 6;
 MMIO(UART + 0x28) = 33;
 MMIO(UART + 0x2c) = 3u << 5; /* 8N1, FIFO disabled */
 ICR = 0x7ff;
 IMSC = (1u << 4) | (1u << 6);
 MMIO(0xe000e100) = 1u << 5;
 CR = (1u << 0) | (1u << 8) | (1u << 9);
 output("UART READY\n");
 /* Busy-poll only the IRQ-owned count, never DR: verifies real IRQ delivery.
  * A production sleep loop would need a race-safe check-and-WFI protocol. */
 while (received < 2 && !error) __asm__ volatile("nop");
 finish(error);
}
