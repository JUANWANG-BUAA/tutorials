/* C11 SPSC queue: exactly one producer and one consumer; host concurrency test.
 * Not a DMA protocol: cache maintenance and MMIO ordering are separate contracts.
 */
#include <assert.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#define CAP 64u
#define TOTAL 200000u
_Static_assert((CAP & (CAP - 1u)) == 0, "power of two capacity");
typedef struct { uint32_t sequence, inverse; } Packet;
typedef struct {
    Packet data[CAP];
    _Atomic unsigned head, tail;
} Queue;
static Queue q;
static bool push(Packet value) {
    unsigned h = atomic_load_explicit(&q.head, memory_order_relaxed);
    unsigned next = (h + 1u) & (CAP - 1u);
    if (next == atomic_load_explicit(&q.tail, memory_order_acquire)) return false;
    q.data[h] = value;
    atomic_store_explicit(&q.head, next, memory_order_release);
    return true;
}
static bool pop(Packet *value) {
    unsigned t = atomic_load_explicit(&q.tail, memory_order_relaxed);
    if (t == atomic_load_explicit(&q.head, memory_order_acquire)) return false;
    *value = q.data[t];
    atomic_store_explicit(&q.tail, (t + 1u) & (CAP - 1u), memory_order_release);
    return true;
}
static void *producer(void *arg) {
    (void)arg;
    for (unsigned i = 0; i < TOTAL; ++i) {
        Packet value = {i, ~i};
        while (!push(value)) {} /* host stress harness only; not an ISR API */
    }
    return NULL;
}
static void *consumer(void *arg) {
    (void)arg;
    for (unsigned i = 0; i < TOTAL; ++i) {
        Packet value;
        while (!pop(&value)) {}
        assert(value.sequence == i && value.inverse == ~i);
    }
    return NULL;
}
int main(void) {
    Packet p;
    assert(atomic_is_lock_free(&q.head) && atomic_is_lock_free(&q.tail));
    assert(!pop(&p));
    for (unsigned i = 0; i < CAP - 1; ++i) assert(push((Packet){i, ~i}));
    assert(!push((Packet){0, 0}));
    for (unsigned i = 0; i < CAP - 1; ++i) { assert(pop(&p)); assert(p.sequence == i); }
    assert(!pop(&p));
    pthread_t a, b;
    assert(pthread_create(&a, NULL, producer, NULL) == 0);
    assert(pthread_create(&b, NULL, consumer, NULL) == 0);
    assert(pthread_join(a, NULL) == 0 && pthread_join(b, NULL) == 0);
    assert(!pop(&p));
    puts("PASS C11 SPSC: 200000 ordered packets, full/empty/wrap tests");
    return 0;
}
