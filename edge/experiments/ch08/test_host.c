#include "daq_core.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

/* Host Simulation of Storage Pipeline under Periodic Flash Erase Stalls */
static void run_pipeline_simulation(uint32_t queue_depth, bool expect_overrun) {
    DaqBlockQueue q;
    daq_queue_init(&q);
    q.capacity = queue_depth;

    /* Continuous stream: 100 kSPS, block size 64 -> 1 block every 640 us.
       Every 20 blocks, simulate a Flash Block Erase pause of 5000 us (5 ms).
       5 ms / 640 us = ~7.8 blocks arrive while storage is stalled! */
    uint32_t total_produced = 100;
    uint32_t total_consumed = 0;
    uint32_t stall_blocks_remaining = 0;

    for (uint32_t step = 0; step < total_produced; ++step) {
        DaqBlock blk = {
            .sequence = step,
            .timestamp_tick = step * 640u,
            .checksum = 0
        };
        blk.checksum = daq_block_checksum(&blk);

        /* Producer attempts to push to queue */
        daq_queue_push(&q, &blk);

        /* Storage consumer simulation */
        if (step == 30) {
            /* Flash Block Erase begins: stall consumer for 8 steps (approx 5.12 ms) */
            stall_blocks_remaining = 8;
        }

        if (stall_blocks_remaining > 0) {
            stall_blocks_remaining--;
            /* Consumer is blocked on Flash erase! No pop this step. */
        } else {
            /* Consumer drains queue if data is available */
            DaqBlock cblk;
            while (daq_queue_pop(&q, &cblk) == DAQ_OK) {
                total_consumed++;
            }
        }
    }

    /* Drain remaining */
    DaqBlock cblk;
    while (daq_queue_pop(&q, &cblk) == DAQ_OK) {
        total_consumed++;
    }

    if (expect_overrun) {
        assert(q.dropped_blocks > 0);
        assert(total_consumed < total_produced);
        printf("MODEL pipeline: undersized queue (depth=%u) dropped %u blocks during 5ms stall (OVERRUN DETECTED)\n",
               queue_depth, q.dropped_blocks);
    } else {
        assert(q.dropped_blocks == 0);
        assert(total_consumed == total_produced);
        printf("MODEL pipeline: adequately sized queue (depth=%u) sustained 5ms stall with 0 drops\n",
               queue_depth);
    }
}

/* Cache Incoherency Model: Non-invalidated cache reads stale data */
static void run_cache_coherence_model(void) {
    /* Memory line simulation: 64-byte line */
    typedef struct {
        uint8_t dram_bytes[64];
        uint8_t cache_bytes[64];
        bool    cache_valid;
        bool    cache_dirty;
    } CacheLine;

    CacheLine line;
    memset(&line, 0, sizeof(line));

    /* 1. CPU initially reads DRAM line -> cache filled */
    memset(line.dram_bytes, 0x11, 64);
    memcpy(line.cache_bytes, line.dram_bytes, 64);
    line.cache_valid = true;
    line.cache_dirty = false;

    /* 2. DMA directly writes fresh sensor payload to DRAM */
    memset(line.dram_bytes, 0x99, 64);

    /* 3. INCORRECT PATH: CPU reads without Invalidate -> gets stale 0x11 from cache! */
    uint8_t stale_read = line.cache_bytes[0];
    assert(stale_read == 0x11);

    /* 4. CORRECT PATH: CPU invalidates cache line before reading RX DMA buffer */
    line.cache_valid = false;
    /* After invalidate, read misses in cache, re-fetches from DRAM */
    memcpy(line.cache_bytes, line.dram_bytes, 64);
    line.cache_valid = true;
    uint8_t fresh_read = line.cache_bytes[0];
    assert(fresh_read == 0x99);

    puts("MODEL cache: missing Invalidate reads stale 0x11; Invalidate restores fresh DMA 0x99");
}

int main(void) {
    int res = daq_core_selftest();
    if (res != 0) {
        fprintf(stderr, "DAQ CORE FAIL at selftest line %d\n", res);
        return 1;
    }
    puts("MODEL PASS DAQ core: Ping-Pong toggle, overrun trap, SPSC queue, checksum");

    /* Test 1: Sized queue absorbs 5ms Flash erase stall */
    run_pipeline_simulation(16, false);

    /* Test 2: Undersized queue drops blocks during 5ms Flash erase stall */
    run_pipeline_simulation(4, true);

    /* Test 3: Cache coherence contract simulation */
    run_cache_coherence_model();

    /* Mathematical quantitative latency budget verification */
    /* 100 kSPS * 16-bit = 200 KB/s stream.
       At 100 kSPS, 64-sample block period = 640 us.
       A 10 ms (10,000 us) Flash erase stall generates:
       10000 / 640 = 15.625 blocks -> requires at least 17 blocks buffer! */
    DaqPipelineBudget b = daq_calculate_budget(100000, 10000);
    assert(b.min_queue_depth_blocks == 17);
    printf("MODEL budget: 100kSPS stream + 10ms erase stall requires min %u blocks queue buffer\n",
           b.min_queue_depth_blocks);

    return 0;
}
