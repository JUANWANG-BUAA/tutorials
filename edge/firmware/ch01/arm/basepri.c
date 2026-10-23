#include <stdint.h>
#define REG(a) (*(volatile uint32_t *)(a))
static volatile unsigned high_count, low_count;
static uint32_t read_mask(void) {
 uint32_t value; __asm__ volatile("mrs %0, basepri" : "=r"(value)); return value;
}
static void write_mask(uint32_t value) {
 __asm__ volatile("msr basepri, %0\ndsb\nisb" : : "r"(value) : "memory");
}
static void raise_mask(uint32_t value) {
 __asm__ volatile("msr basepri_max, %0\ndsb\nisb" : : "r"(value) : "memory");
}
__attribute__((noreturn)) static void finish(unsigned code) {
 const char *s=code ? "ARM BASEPRI FAIL\n" : "ARM BASEPRI PASS: raw priorities, pending mask, BASEPRI_MAX nesting\n";
 register uint32_t r0 __asm__("r0")=4;
 register const char *r1 __asm__("r1")=s;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
 uint32_t block[2]={0x20026,code};
 r0=0x20; r1=(const char *)block;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
 for (;;) {}
}
void fault(void) { finish(1); }
void high_handler(void) { ++high_count; }
void low_handler(void) { ++low_count; }
int main(void) {
 volatile uint8_t *priority=(volatile uint8_t *)0xe000e400;
 priority[0]=0x20; priority[1]=0x80; /* LM3S NVIC implements three priority bits */
 REG(0xe000e280)=3; /* clear pending before enabling */
 REG(0xe000e100)=3;
 write_mask(0x80);
 __asm__ volatile("cpsie i" ::: "memory");
 REG(0xe000e200)=3; /* pend IRQ0 and IRQ1 without external GPIO hardware */
 __asm__ volatile("dsb\nisb" ::: "memory");
 for (volatile unsigned i=0; i<10000 && !high_count; ++i) {}
 if (high_count!=1 || low_count || !(REG(0xe000e200)&2u)) finish(1);
 write_mask(0);
 for (volatile unsigned i=0; i<10000 && !low_count; ++i) {}
 if (high_count!=1 || low_count!=1) finish(1);
 write_mask(0x40);
 uint32_t saved=read_mask();
 raise_mask(0x80); /* must NOT weaken the existing 0x40 threshold */
 if (read_mask()!=0x40) finish(1);
 raise_mask(0x20);
 if (read_mask()!=0x20) finish(1);
 write_mask(saved);
 if (read_mask()!=0x40) finish(1);
 write_mask(0);
 finish(read_mask()!=0);
}
