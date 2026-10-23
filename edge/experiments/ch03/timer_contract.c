/* Contract models, not SysTick peripheral or hardware timing measurements. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
typedef struct { uint32_t start, delay; } Deadline;
static bool deadline_start(Deadline *timer, uint32_t now, uint32_t delay) {
    if (!timer || delay >= UINT32_C(0x80000000)) return false;
    timer->start=now; timer->delay=delay; return true;
}
static bool expired(const Deadline *timer, uint32_t now) {
    /* Monotonic modulo-2^32 counter; caller must not miss a whole wrap. */
    return (uint32_t)(now-timer->start) >= timer->delay;
}
static uint32_t down_elapsed(uint32_t before, uint32_t after, uint32_t load) {
    assert(before<=load && after<=load && load<UINT32_MAX);
    return before>=after ? before-after : before+(load+1)-after;
}
typedef struct Delta { unsigned ticks, id; struct Delta *next; } Delta;
static unsigned drain_due(Delta **head, unsigned budget, unsigned *callbacks) {
    unsigned done=0;
    while (*head && !(*head)->ticks && done<budget) {
        Delta *expired=*head;
        *head=expired->next;
        assert(expired->id==*callbacks);
        ++*callbacks; ++done;
    }
    return done;
}
int main(void) {
    Deadline timer;
    assert(deadline_start(&timer,UINT32_C(0xfffffff0),32));
    assert(!expired(&timer,UINT32_C(0x0000000f)));
    assert(expired(&timer,UINT32_C(0x00000010)));
    assert(!deadline_start(&timer,0,UINT32_C(0x80000000)));
    assert(deadline_start(&timer,42,0) && expired(&timer,42));
    assert(down_elapsed(1,10,10)==2); /* 1 -> 0 -> reload 10 */
    assert(1+(10-10)==1); /* old missing +1 would lose one tick */
    puts("MODEL PASS deadline: modulo rollover, interval bounds, LOAD+1 correction");
    uint32_t high_before=7, high_after=7, load=9;
    uint64_t previous=(uint64_t)high_before*(load+1)+(load-1);
    uint64_t broken=(uint64_t)high_after*(load+1)+(load-9);
    assert(high_before==high_after && broken<previous);
    puts("MODEL PASS timestamp counterexample: equal high reads still regress if hardware wraps before ISR");
    Delta nodes[4096];
    for (unsigned i=0; i<4096; ++i) {
        nodes[i].ticks=0; nodes[i].id=i;
        nodes[i].next=i+1<4096 ? &nodes[i+1] : 0;
    }
    Delta *head=nodes;
    unsigned callbacks=0;
    assert(drain_due(&head,32,&callbacks)==32 && head==&nodes[32]);
    assert(callbacks==32 && head->ticks==0);
    assert(drain_due(&head,4096,&callbacks)==4064 && !head && callbacks==4096);
    puts("MODEL PASS delta drain: 4096 simultaneous expirations, budget=32 leaves pending work; total service is O(k)");
    /* Ordered little-endian mtimecmp low-sentinel sequence. */
    uint64_t now=UINT64_C(0x0000000180000000);
    uint64_t old=UINT64_C(0x0000000190000000);
    uint64_t target=UINT64_C(0x0000000200000005);
    uint64_t bad=(old&UINT64_C(0xffffffff00000000))|(uint32_t)target;
    assert(old>now && target>now && bad<now);
    uint64_t first=(old&UINT64_C(0xffffffff00000000))|UINT32_MAX;
    uint64_t second=(target&UINT64_C(0xffffffff00000000))|UINT32_MAX;
    assert(first>=old && second>=target);
    puts("MODEL PASS mtimecmp: bad low-first intermediate fires; ordered low=UINT32_MAX/high/low avoids it");
    return 0;
}
