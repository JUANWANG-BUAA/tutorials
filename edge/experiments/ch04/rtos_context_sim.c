/* Teaching model: single CPU, all calls serialized as if under an IRQ lock.
 * No recursion, dynamic allocation, SMP support, or floating point context.
 * Selection is O(1) for 32 priorities; donation recomputation is deliberately bounded O(N^3).
 */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#define NT 4
#define NL 3
#define NP 32
#define NONE (-1)
typedef enum { READY, BLOCKED } State;
typedef struct {
    unsigned base, effective;
    State state;
    int wait_lock, next, prev;
} Task;
typedef struct { int owner; } Mutex;
static Task tasks[NT];
static Mutex locks[NL];
static int heads[NP], tails[NP];
static uint32_t bitmap;

static void enqueue(int id) {
    Task *t = &tasks[id];
    unsigned p = t->effective;
    assert(t->state == READY && t->next == NONE && t->prev == NONE);
    t->prev = tails[p];
    if (tails[p] != NONE) tasks[tails[p]].next = id;
    else heads[p] = id;
    tails[p] = id;
    bitmap |= UINT32_C(1) << p;
}
static void remove_ready(int id) {
    Task *t = &tasks[id];
    unsigned p = t->effective;
    assert(t->state == READY);
    if (t->prev != NONE) tasks[t->prev].next = t->next;
    else heads[p] = t->next;
    if (t->next != NONE) tasks[t->next].prev = t->prev;
    else tails[p] = t->prev;
    t->next = t->prev = NONE;
    if (heads[p] == NONE) bitmap &= ~(UINT32_C(1) << p);
}
static int select_ready(void) {
    if (!bitmap) return NONE; /* never evaluate ctz(0) */
    return heads[(unsigned)__builtin_ctz(bitmap)];
}
static void check_invariants(void) {
    bool seen[NT] = {false};
    for (unsigned p = 0; p < NP; ++p) {
        assert(((bitmap >> p) & 1u) == (heads[p] != NONE));
        int previous = NONE;
        for (int id = heads[p]; id != NONE; id = tasks[id].next) {
            assert(id >= 0 && id < NT && !seen[id]);
            seen[id] = true;
            assert(tasks[id].state == READY && tasks[id].effective == p);
            assert(tasks[id].prev == previous);
            previous = id;
        }
        assert(tails[p] == previous);
    }
    for (int i = 0; i < NT; ++i) {
        assert(seen[i] == (tasks[i].state == READY));
        assert(tasks[i].effective <= tasks[i].base);
        assert((tasks[i].wait_lock == NONE) == (tasks[i].state == READY));
    }
}
static void reset(const unsigned base[NT]) {
    bitmap = 0;
    for (unsigned p = 0; p < NP; ++p) heads[p] = tails[p] = NONE;
    for (int l = 0; l < NL; ++l) locks[l].owner = NONE;
    for (int i = 0; i < NT; ++i) {
        tasks[i] = (Task){.base=base[i], .effective=base[i], .state=READY,
                          .wait_lock=NONE, .next=NONE, .prev=NONE};
        enqueue(i);
    }
    check_invariants();
}
static void recompute_donation(void) {
    unsigned effective[NT];
    for (int i = 0; i < NT; ++i) effective[i] = tasks[i].base;
    for (int pass = 0; pass < NT; ++pass) {
        bool changed = false;
        for (int i = 0; i < NT; ++i) {
            int l = tasks[i].wait_lock;
            if (l != NONE) {
                int owner = locks[l].owner;
                assert(owner != NONE);
                if (effective[owner] > effective[i]) {
                    effective[owner] = effective[i]; changed = true;
                }
            }
        }
        if (!changed) break;
    }
    for (int i = 0; i < NT; ++i) {
        if (tasks[i].effective != effective[i]) {
            if (tasks[i].state == READY) remove_ready(i);
            tasks[i].effective = effective[i];
            if (tasks[i].state == READY) enqueue(i);
        }
    }
    check_invariants();
}
/* Return 1=owned, 0=blocked, -1=cycle/invalid. No busy waiting. */
static int lock_take(int id, int l) {
    if (tasks[id].state != READY) return -1;
    if (locks[l].owner == NONE) { locks[l].owner = id; return 1; }
    int owner = locks[l].owner;
    for (int n = 0; n < NT; ++n) {
        if (owner == id) return -1;
        int wait = tasks[owner].wait_lock;
        if (wait == NONE) break;
        owner = locks[wait].owner;
    }
    remove_ready(id);
    tasks[id].state = BLOCKED;
    tasks[id].wait_lock = l;
    recompute_donation();
    return 0;
}
static bool lock_give(int id, int l) {
    if (locks[l].owner != id) return false;
    int best = NONE;
    for (int i = 0; i < NT; ++i) {
        if (tasks[i].wait_lock == l &&
            (best == NONE || tasks[i].effective < tasks[best].effective)) best = i;
    }
    locks[l].owner = best; /* direct ownership handover, no steal window */
    if (best != NONE) {
        tasks[best].wait_lock = NONE;
        tasks[best].state = READY;
        enqueue(best);
    }
    recompute_donation();
    return true;
}
static void test_same_priority_fifo(void) {
    const unsigned base[NT] = {2, 2, 5, 9}; reset(base);
    assert(select_ready() == 0);
    remove_ready(0); enqueue(0); /* time-slice rotation */
    assert(select_ready() == 1);
    assert(lock_take(1, 0) == 1);
    assert(lock_take(0, 0) == 0);
    assert(select_ready() == 1); /* blocked waiter must NOT be selected */
    assert(lock_give(1, 0));
    check_invariants();
    puts("PASS same-priority FIFO: removing one task retains its peer");
}
static void test_donation_handover(void) {
    const unsigned base[NT] = {20, 10, 2, 30}; reset(base);
    assert(lock_take(0, 0) == 1);
    assert(lock_take(2, 0) == 0);
    assert(tasks[0].effective == 2 && tasks[2].state == BLOCKED);
    assert(select_ready() == 0);
    assert(!lock_give(1, 0)); /* non-owner rejected */
    assert(lock_give(0, 0));
    assert(locks[0].owner == 2 && tasks[2].state == READY);
    assert(tasks[0].effective == 20 && select_ready() == 2);
    puts("PASS priority inheritance: blocked waiter, owner boost, direct handover");
}
static void test_transitive_and_multi_lock(void) {
    const unsigned base[NT] = {20, 10, 2, 5}; reset(base);
    assert(lock_take(0, 0) == 1);
    assert(lock_take(1, 1) == 1);
    assert(lock_take(1, 0) == 0);
    assert(lock_take(2, 1) == 0);
    assert(tasks[0].effective == 2 && tasks[1].effective == 2);
    assert(lock_take(0, 1) == -1); /* cycle 0->1->0 */
    assert(select_ready() == 0);
    assert(lock_give(0, 0));
    assert(tasks[1].effective == 2 && tasks[0].effective == 20);
    assert(lock_give(1, 1));
    assert(select_ready() == 2);
    reset(base);
    assert(lock_take(0, 0) == 1 && lock_take(0, 1) == 1);
    assert(lock_take(2, 0) == 0 && lock_take(3, 1) == 0);
    assert(tasks[0].effective == 2);
    assert(lock_give(0, 0));
    assert(tasks[0].effective == 5); /* another lock still has a donor */
    puts("PASS transitive donation, cycle rejection, remaining-lock donation");
}
static void test_deadline_counterexample(void) {
    /* Synthetic schedule: H blocks at t=1, L needs 3 CPU ms, M runs 8ms.
     * H has C=1ms and deadline t=6. PIP bounds L's interference by M. */
    unsigned finish_without_pip = 1 + 8 + 3 + 1;
    unsigned finish_with_pip = 1 + 3 + 1;
    assert(finish_without_pip > 6 && finish_with_pip <= 6);
    printf("MODEL deadline: no-PIP finish=%ums MISS; PIP finish=%ums MEET (not hardware timing)\n",
           finish_without_pip, finish_with_pip);
}
int main(void) {
    test_same_priority_fifo(); test_donation_handover();
    test_transitive_and_multi_lock(); test_deadline_counterexample();
    puts("PASS scheduler invariants (single-core serialized teaching model)");
    return 0;
}
