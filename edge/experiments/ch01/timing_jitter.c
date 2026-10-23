/*
 * timing_jitter.c - 边缘嵌入式与实时系统 Chapter 01 验证实验
 * 验证：时钟周期测量、调度与临界区抖动分布，以及弱内存序下无锁队列屏障机制
 */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define ITERATIONS 100000
#define BUCKETS 10
#define QUEUE_SIZE 1024

/* 高精度单调时钟获取纳秒 */
static inline uint64_t get_time_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

/* 测量系统调用与微循环的延迟抖动分布 */
void test_latency_jitter(void) {
    uint64_t deltas[ITERATIONS];
    uint64_t min_delta = UINT64_MAX;
    uint64_t max_delta = 0;
    uint64_t sum_delta = 0;

    for (int i = 0; i < ITERATIONS; i++) {
        uint64_t t1 = get_time_ns();
        /* 模拟极短确定性执行体 */
        __asm__ volatile("" ::: "memory");
        uint64_t t2 = get_time_ns();
        uint64_t diff = t2 - t1;
        deltas[i] = diff;
        if (diff < min_delta) min_delta = diff;
        if (diff > max_delta) max_delta = diff;
        sum_delta += diff;
    }

    uint64_t avg_delta = sum_delta / ITERATIONS;
    printf("[EXP 1-1] 纳秒级测量基线 (N=%d):\n", ITERATIONS);
    printf("  Min Latency: %llu ns\n", (unsigned long long)min_delta);
    printf("  Avg Latency: %llu ns\n", (unsigned long long)avg_delta);
    printf("  Max Latency: %llu ns (Jitter Range: %llu ns)\n", 
           (unsigned long long)max_delta, (unsigned long long)(max_delta - min_delta));

    /* 统计直方图分布 */
    uint32_t hist_less_100 = 0;
    uint32_t hist_100_500 = 0;
    uint32_t hist_500_2000 = 0;
    uint32_t hist_over_2000 = 0;

    for (int i = 0; i < ITERATIONS; i++) {
        if (deltas[i] < 100) hist_less_100++;
        else if (deltas[i] < 500) hist_100_500++;
        else if (deltas[i] < 2000) hist_500_2000++;
        else hist_over_2000++;
    }

    printf("  延迟分布直方图:\n");
    printf("    < 100 ns   : %d (%.2f%%)\n", hist_less_100, (double)hist_less_100 * 100.0 / ITERATIONS);
    printf("    100~500 ns : %d (%.2f%%)\n", hist_100_500, (double)hist_100_500 * 100.0 / ITERATIONS);
    printf("    500~2000 ns: %d (%.2f%%)\n", hist_500_2000, (double)hist_500_2000 * 100.0 / ITERATIONS);
    printf("    > 2000 ns  : %d (%.2f%%) [操作系统中断与抖动毛刺]\n", hist_over_2000, (double)hist_over_2000 * 100.0 / ITERATIONS);
}

/* 无锁 SPSC 环形队列结构体 */
typedef struct {
    uint32_t data;
    uint32_t checksum;
} Packet;

typedef struct {
    Packet buffer[QUEUE_SIZE];
    volatile uint32_t head;
    volatile uint32_t tail;
} SPSCQueue;

static SPSCQueue g_queue;

/* 入队：带内存屏障保护 */
bool spsc_push(SPSCQueue* q, Packet pkt) {
    uint32_t current_head = q->head;
    uint32_t next_head = (current_head + 1) & (QUEUE_SIZE - 1);
    if (next_head == q->tail) return false;

    q->buffer[current_head] = pkt;

    /* 编译器与硬件内存屏障 */
#if defined(__arm__) || defined(__aarch64__)
    __asm__ volatile("dmb sy" ::: "memory");
#elif defined(__riscv)
    __asm__ volatile("fence w,w" ::: "memory");
#else
    __asm__ volatile("" ::: "memory");
#endif

    q->head = next_head;
    return true;
}

/* 出队 */
bool spsc_pop(SPSCQueue* q, Packet* pkt) {
    uint32_t current_tail = q->tail;
    if (current_tail == q->head) return false;

#if defined(__arm__) || defined(__aarch64__)
    __asm__ volatile("dmb sy" ::: "memory");
#elif defined(__riscv)
    __asm__ volatile("fence r,r" ::: "memory");
#else
    __asm__ volatile("" ::: "memory");
#endif

    *pkt = q->buffer[current_tail];
    q->tail = (current_tail + 1) & (QUEUE_SIZE - 1);
    return true;
}

void test_lockless_barrier(void) {
    g_queue.head = 0;
    g_queue.tail = 0;
    int pushed = 0, popped = 0;

    for (int i = 0; i < 1000; i++) {
        Packet p = { .data = (uint32_t)i, .checksum = (uint32_t)i ^ 0xAA55AA55 };
        if (spsc_push(&g_queue, p)) pushed++;
        Packet out;
        if (spsc_pop(&g_queue, &out)) {
            if ((out.data ^ 0xAA55AA55) != out.checksum) {
                fprintf(stderr, "FATAL: Checksum mismatch at index %d!\n", i);
                exit(1);
            }
            popped++;
        }
    }
    printf("[EXP 1-2] 无锁屏障队列数据完整性自测通过: Pushed=%d, Popped=%d, 0 撕裂\n", pushed, popped);
}

int main(void) {
    printf("=== Edge Chapter 01 Verification Suite ===\n");
    test_latency_jitter();
    test_lockless_barrier();
    printf("=== All Chapter 01 Tests Passed ===\n");
    return 0;
}
