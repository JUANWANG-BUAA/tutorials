#include <stdint.h>
#include <stddef.h>
typedef struct {
    uint32_t gpr[32], mepc, mstatus, mcause, pad;
} TrapFrame;
_Static_assert(sizeof(TrapFrame)==144, "trap frame size");
_Static_assert(offsetof(TrapFrame,mepc)==128, "mepc offset");
_Static_assert(offsetof(TrapFrame,mstatus)==132, "mstatus offset");
_Static_assert(offsetof(TrapFrame,mcause)==136, "mcause offset");
static volatile unsigned ecall_seen, timer_seen;
extern void trap_entry(void);
extern int exercise_traps(void);
extern void timer_resume_point(void);
#define REG(a) (*(volatile uint32_t *)(a))
__attribute__((noreturn)) static void finish(unsigned code) {
    const char *s=code ? "RV32 TRAP FAIL\n" : "RV32 TRAP PASS: complete integer frame, M-ecall, asynchronous MTIP, unchanged IRQ PC\n";
    while (*s) *(volatile unsigned char *)0x10000000=(unsigned char)*s++;
    REG(0x100000)=code ? 0x13333 : 0x5555;
    for (;;) {}
}
static uint64_t read_time(void) {
    uint32_t hi,lo,again;
    do { hi=REG(0x0200bffc); lo=REG(0x0200bff8); again=REG(0x0200bffc); } while (hi!=again);
    return ((uint64_t)hi<<32)|lo;
}
static void set_compare(uint64_t value) {
    REG(0x02004000)=UINT32_MAX;
    __asm__ volatile("fence io,io" ::: "memory");
    REG(0x02004004)=(uint32_t)(value>>32);
    __asm__ volatile("fence io,io" ::: "memory");
    REG(0x02004000)=(uint32_t)value;
    __asm__ volatile("fence io,io" ::: "memory");
}
void trap_dispatch(TrapFrame *frame) {
    if ((frame->gpr[2]&15u) || ((frame->mstatus>>11)&3u)!=3u || (frame->mstatus&8u)) finish(1);
    for (unsigned r=1; r<32; ++r) {
        if (r==2 || r==3 || r==4 || r==10) continue;
        if (frame->gpr[r]!=0x100u+r) finish(1);
    }
    if (frame->gpr[0] || frame->gpr[4]) finish(1);
    if (frame->mcause==11) {
        if (ecall_seen || frame->gpr[10]!=0x10a || *(const uint32_t *)(uintptr_t)frame->mepc!=0x73) finish(1);
        ++ecall_seen;
        frame->gpr[10]=17;
        frame->mepc+=4; /* only a verified 32-bit M-mode ECALL */
    } else if (frame->mcause==UINT32_C(0x80000007)) {
        if (!ecall_seen || timer_seen || frame->gpr[10]!=0 || frame->mepc!=(uintptr_t)timer_resume_point) finish(1);
        ++timer_seen;
        set_compare(UINT64_MAX);
        __asm__ volatile("csrw mie, zero" ::: "memory");
        frame->gpr[10]=42;
        /* IRQ returns to the unchanged mepc, not mepc+4. */
    } else finish(1);
}
int main(void) {
    __asm__ volatile("csrw mtvec, %0" : : "r"((uintptr_t)trap_entry) : "memory");
    set_compare(read_time()+10000u);
    int failed=exercise_traps();
    finish(failed || ecall_seen!=1 || timer_seen!=1);
}
