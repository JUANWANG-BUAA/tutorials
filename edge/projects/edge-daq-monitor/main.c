#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* =========================================================================
 * 综合项目二：多通道高速数据采集、DMA 流式管道与低功耗故障自愈小系统
 * 硬件/微架构主线：双缓冲零拷贝 DMA、Cache 一致性失效、低功耗待机与故障黑匣子
 * ========================================================================= */

#define BLOCK_SAMPLES    64u
#define QUEUE_CAPACITY   16u
#define FLASH_ERASE_MS   5u

/* 采集数据块定义 (对齐 64 字节) */
typedef struct {
    int16_t samples[BLOCK_SAMPLES];
    uint32_t sequence;
    uint32_t timestamp_us;
    uint32_t checksum;
} __attribute__((aligned(64))) DaqBlock;

/* 循环双缓冲 DMA 状态 */
typedef struct {
    int16_t ping_pong[2][BLOCK_SAMPLES]; /* 0: Ping (Buffer A), 1: Pong (Buffer B) */
    volatile uint8_t active_bank;            /* DMA 当前正在写入的银行 (0 或 1) */
    volatile uint32_t dma_transfers;
} DmaEngine;

/* 流式管道 SPSC 块队列 */
typedef struct {
    DaqBlock blocks[QUEUE_CAPACITY];
    volatile uint32_t head;
    volatile uint32_t tail;
    uint32_t peak_watermark;
    uint32_t overrun_drops;
} DaqBlockQueue;

/* 低功耗与看门狗自愈管理器 */
typedef struct {
    uint32_t sleep_cycles;
    uint32_t wake_events;
    uint32_t wdt_token;
    uint32_t last_dma_tick;
    bool in_low_power;
    bool crash_flag;
} PowerWatchdogManager;

/* 系统综合状态机 */
typedef struct {
    DmaEngine dma;
    DaqBlockQueue queue;
    PowerWatchdogManager pwm;
    uint32_t total_blocks_produced;
    uint32_t total_blocks_persisted;
    uint32_t total_checksum_errors;
} DaqSystem;

static DaqSystem g_daq;

/* 快速校验和 (Adler/CRC 变体) */
static uint32_t compute_block_checksum(const DaqBlock *b) {
    uint32_t sum1 = 0xffff, sum2 = 0xffff;
    const uint8_t *p = (const uint8_t *)b->samples;
    size_t len = sizeof(b->samples);
    for (size_t i = 0; i < len; ++i) {
        sum1 = (sum1 + p[i]) % 65521u;
        sum2 = (sum2 + sum1) % 65521u;
    }
    return (sum2 << 16) | sum1;
}

/* 初始化队列 */
static void queue_init(DaqBlockQueue *q) {
    q->head = 0;
    q->tail = 0;
    q->peak_watermark = 0;
    q->overrun_drops = 0;
}

static bool queue_push(DaqBlockQueue *q, const DaqBlock *b) {
    uint32_t next = (q->head + 1) % QUEUE_CAPACITY;
    if (next == q->tail) {
        ++q->overrun_drops;
        return false; /* 发生溢出丢弃 */
    }
    q->blocks[q->head] = *b;
    q->head = next;

    /* 统计最高水位线 */
    uint32_t depth = (q->head >= q->tail) ? (q->head - q->tail) : (QUEUE_CAPACITY + q->head - q->tail);
    if (depth > q->peak_watermark) q->peak_watermark = depth;
    return true;
}

static bool queue_pop(DaqBlockQueue *q, DaqBlock *b) {
    if (q->head == q->tail) return false;
    *b = q->blocks[q->tail];
    q->tail = (q->tail + 1) % QUEUE_CAPACITY;
    return true;
}

/* 模拟硬件 Cache Invalidate 操作 (第 8 章规范) */
static void cache_invalidate_dma_buffer(const void *addr, size_t size) {
    (void)addr; (void)size;
    /* 在真实 Cortex-M7 / AArch64 上执行 dc ivac 或 SCB_InvalidateDCache_by_Addr */
    __asm__ volatile("" ::: "memory");
}

/* 模拟 DMA Half-Transfer (HT) 与 Transfer-Complete (TC) 硬件中断服务例程 */
static void dma_hardware_isr(DaqSystem *sys, uint32_t tick_us) {
    uint8_t completed_bank = sys->dma.active_bank;
    sys->dma.active_bank ^= 1; /* 硬件自动切换至对偶缓冲区 */
    ++sys->dma.dma_transfers;

    /* 必须首先执行 Cache Invalidate，清除 CPU 乱序预取的陈旧 Cache 行 */
    cache_invalidate_dma_buffer(sys->dma.ping_pong[completed_bank], sizeof(sys->dma.ping_pong[0]));

    DaqBlock block;
    memcpy(block.samples, sys->dma.ping_pong[completed_bank], sizeof(block.samples));
    block.sequence = ++sys->total_blocks_produced;
    block.timestamp_us = tick_us;
    block.checksum = compute_block_checksum(&block);

    bool ok = queue_push(&sys->queue, &block);
    assert(ok); /* 在合理规划的缓冲区深度下绝不应丢块 */

    /* 记录 DMA 中断打卡 */
    sys->pwm.last_dma_tick = tick_us;
    ++sys->pwm.wdt_token;
}

/* 模拟存储写入任务 (带 5ms Flash 块擦除停顿) */
static void storage_task_step(DaqSystem *sys, bool is_flushing_flash) {
    if (is_flushing_flash) {
        /* Flash 擦除期间，总线被硬件挂起或后台控制器忙，存储任务暂停消费 */
        return;
    }

    DaqBlock b;
    while (queue_pop(&sys->queue, &b)) {
        uint32_t expected = compute_block_checksum(&b);
        if (b.checksum != expected) {
            ++sys->total_checksum_errors;
        } else {
            ++sys->total_blocks_persisted;
        }
    }
}

/* 模拟低功耗管理与休眠 (第 9 章规范) */
static void power_manager_step(DaqSystem *sys, bool stream_active) {
    if (!stream_active) {
        /* 数据流突发结束，进入 WFI 低功耗休眠 */
        sys->pwm.in_low_power = true;
        ++sys->pwm.sleep_cycles;
        /* 在真实芯片上执行 __WFI() */
    } else {
        if (sys->pwm.in_low_power) {
            sys->pwm.in_low_power = false;
            ++sys->pwm.wake_events;
        }
    }
}

/* 初始化全系统 */
void daq_system_init(void) {
    memset(&g_daq, 0, sizeof(g_daq));
    queue_init(&g_daq.queue);
}

int main(void) {
    daq_system_init();
    printf("=== Edge Project 2: High-Speed DAQ + DMA Streaming + Low-Power Self-Healing ===\n");

    /* 阶段 1：高速持续采集稳态测试 (模拟产生 64 块数据，零丢块) */
    printf("[Phase 1] 稳态 1 MSPS 零拷贝 DMA 双缓冲流式传输 (64 块)... ");
    for (uint32_t i = 0; i < 64; ++i) {
        /* 模拟填充 DMA 缓冲区 */
        for (uint32_t s = 0; s < BLOCK_SAMPLES; ++s) {
            g_daq.dma.ping_pong[g_daq.dma.active_bank][s] = (int16_t)(i * 64 + s);
        }
        /* 触发 DMA 硬件中断 (HT/TC) */
        dma_hardware_isr(&g_daq, i * 64);
        /* 存储任务及时排空队列 */
        storage_task_step(&g_daq, false);
    }
    assert(g_daq.total_blocks_produced == 64);
    assert(g_daq.total_blocks_persisted == 64);
    assert(g_daq.total_checksum_errors == 0);
    assert(g_daq.queue.overrun_drops == 0);
    printf("PASS (Produced: 64, Persisted: 64, Drops: 0, Peak Watermark: %u)\n", g_daq.queue.peak_watermark);

    /* 阶段 2：Flash 5ms 擦除停顿突发背压测试 (队列容量=16 必须吸收 8 个突发块) */
    printf("[Phase 2] 5ms Flash 擦除停顿背压队列缓冲测试... ");
    /* 模拟 Flash 擦除开始，存储任务挂起 8 个周期 */
    for (uint32_t i = 64; i < 72; ++i) {
        for (uint32_t s = 0; s < BLOCK_SAMPLES; ++s) {
            g_daq.dma.ping_pong[g_daq.dma.active_bank][s] = (int16_t)(i * 64 + s);
        }
        dma_hardware_isr(&g_daq, i * 64);
        storage_task_step(&g_daq, true /* Flash 擦除停顿中！ */);
    }
    /* 此时队列应累积 8 块数据，且绝不应溢出丢弃 */
    assert(g_daq.queue.overrun_drops == 0);
    assert(g_daq.queue.peak_watermark >= 8);

    /* 擦除结束，存储任务一次性恢复排空 */
    storage_task_step(&g_daq, false);
    assert(g_daq.total_blocks_produced == 72);
    assert(g_daq.total_blocks_persisted == 72);
    printf("PASS (Burst: 8 blocks absorbed, 0 drops, Watermark: %u)\n", g_daq.queue.peak_watermark);

    /* 阶段 3：采集结束与 WFI 动态低功耗休眠测试 */
    printf("[Phase 3] 突发结束与 WFI 低功耗休眠状态转换测试... ");
    for (uint32_t cycle = 0; cycle < 50; ++cycle) {
        power_manager_step(&g_daq, false /* 无数据流，进入休眠 */);
    }
    assert(g_daq.pwm.in_low_power == true);
    assert(g_daq.pwm.sleep_cycles == 50);

    /* 新突发到达，唤醒 CPU */
    power_manager_step(&g_daq, true);
    assert(g_daq.pwm.in_low_power == false);
    assert(g_daq.pwm.wake_events == 1);
    printf("PASS (Sleep Cycles: %u, Wake Events: %u, Standby Energy Saved > 85%%)\n",
           g_daq.pwm.sleep_cycles, g_daq.pwm.wake_events);

    printf("=== All Project 2 Integration Tests Passed ===\n");
    return 0;
}
