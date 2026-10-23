#include <stdint.h>
static _Alignas(16) uint32_t stacks[2][256];
static uint32_t *saved[2], *boot_sp;
static unsigned current, progress[2];
extern void rv_switch(uint32_t **old_sp, uint32_t *new_sp);
extern void task_entry(void);
__attribute__((noreturn)) void finish(unsigned code) {
 const char *s = code ? "RV32 FAIL\n" : "RV32 PASS: cooperative ABI, 12 saved registers, 512 switches\n";
 while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
 *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
 for (;;) {}
}
unsigned task_id(void) { return current; }
void task_step(void) {
 unsigned old = current;
 if (++progress[old] >= 257 && progress[old ^ 1u] >= 257) finish(0);
 current ^= 1u;
 rv_switch(&saved[old], saved[current]);
}
int main(void) {
 for (unsigned t = 0; t < 2; ++t) {
  uint32_t *sp = &stacks[t][256 - 16];
  for (unsigned i = 0; i < 16; ++i) sp[i] = 0;
  sp[0] = (uint32_t)task_entry;
  saved[t] = sp;
 }
 current = 0;
 rv_switch(&boot_sp, saved[0]);
 return 1;
}
