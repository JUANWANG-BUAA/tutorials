#include <stdint.h>
#include <stdbool.h>
#include "daq_core.h"

__attribute__((noreturn)) void finish(unsigned code) {
    const char *s = code ? "RV32 DAQ FAIL\n" : "RV32 DAQ PASS: SPSC block queue, FENCE ordering, budget verification\n";
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
    for (;;) {}
}

static DaqBlockQueue g_queue;

int main(void) {
    if (daq_core_selftest() != 0) finish(1);

    daq_queue_init(&g_queue);

    /* Test 64 block stream with explicit FENCE ordering */
    for (uint32_t i = 0; i < 64; ++i) {
        DaqBlock blk = {
            .sequence = i,
            .timestamp_tick = i * 640u,
            .checksum = 0
        };
        for (unsigned s = 0; s < DAQ_BLOCK_SIZE; ++s) {
            blk.samples[s] = (int16_t)(i * 64u + s);
        }
        blk.checksum = daq_block_checksum(&blk);

        /* Push to queue */
        if (daq_queue_push(&g_queue, &blk) != DAQ_OK) finish(1);

        /* FENCE ensures queue memory write is globally visible before reading */
        __asm__ volatile("fence w,rw" ::: "memory");

        /* Pop and verify */
        DaqBlock popped;
        if (daq_queue_pop(&g_queue, &popped) != DAQ_OK) finish(1);

        if (popped.sequence != i || popped.checksum != daq_block_checksum(&popped)) {
            finish(1);
        }
    }

    /* Verify budget calculation */
    DaqPipelineBudget b = daq_calculate_budget(200000, 4000);
    /* 200kSPS * 4ms = 800 samples -> 800/64 = 12.5 -> 13 + 1 = 14 blocks */
    if (b.min_queue_depth_blocks != 14) finish(1);

    finish(0);
}
