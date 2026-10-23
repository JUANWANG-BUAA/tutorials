#include <stdint.h>
#include <stddef.h>
typedef struct { uint32_t *sp; uint32_t id; } Task;
_Static_assert(offsetof(Task, sp) == 0, "assembly offset");
static _Alignas(8) uint32_t stacks[2][256];
static Task tasks[2];
Task *current;
static volatile uint32_t count[2], ticks, switches;
extern void task_entry(void);
extern void fault(void);
#define REG(a) (*(volatile uint32_t *)(a))
static void puts_host(const char *s) {
 register uint32_t r0 __asm__("r0") = 4;
 register const char *r1 __asm__("r1") = s;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}
__attribute__((noreturn)) void finish(uint32_t code) {
 uint32_t block[2] = {0x20026, code};
 puts_host(code ? "ARM FAIL\n" : "ARM PASS: integer registers, PSP, SysTick preemption\n");
 register uint32_t r0 __asm__("r0") = 0x20;
 register uint32_t *r1 __asm__("r1") = block;
 __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
 for (;;) {}
}
unsigned task_id(void) { return current->id; }
void select_next(void) { current = &tasks[current->id ^ 1u]; ++switches; }
void SysTick_Handler(void) {
 ++ticks;
 REG(0xe000ed04) = 1u << 28;
}
void task_step(void) {
 uint32_t id = current->id;
 ++count[id];
 for (volatile unsigned i = 0; i < 1000; ++i) { __asm__ volatile("nop"); }
 if (count[0] >= 128 && count[1] >= 128 && ticks >= 16 && switches >= 256) finish(0);
 REG(0xe000ed04) = 1u << 28;
 __asm__ volatile("dsb\nisb" ::: "memory");
}
int main(void) {
 for (unsigned t = 0; t < 2; ++t) {
  uint32_t *sp = &stacks[t][256];
  for (unsigned i = 0; i < 256; ++i) stacks[t][i] = 0xa5a5a5a5;
  sp -= 8;
  sp[0] = 0; sp[1] = 0; sp[2] = 0; sp[3] = 0; sp[4] = 0;
  sp[5] = (uint32_t)fault; sp[6] = (uint32_t)task_entry; sp[7] = 1u << 24;
  sp -= 9;
  for (unsigned i = 0; i < 8; ++i) sp[i] = 0;
  sp[8] = 0xfffffffd;
  tasks[t].sp = sp; tasks[t].id = t;
 }
 current = &tasks[0];
 REG(0xe000ed20) = (0xffu << 16) | (0x80u << 24);
 REG(0xe000e014) = 4095;
 REG(0xe000e018) = 0;
 REG(0xe000e010) = 7;
 __asm__ volatile("svc 0" ::: "memory");
 return 1;
}
