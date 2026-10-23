#include <stdint.h>
#include <stdbool.h>
#include "daq_core.h"

static void puts_host(const char *s) {
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}

__attribute__((noreturn)) static void finish(uint32_t code) {
    puts_host(code ? "ARM DAQ FAIL\n" : "ARM DAQ PASS: Ping-Pong DMA buffers, SPSC queue, checksum, 128 blocks\n");
    uint32_t block[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = block;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
    for (;;) {}
}

void fault(void) { finish(1); }

static DaqPingPong g_pp;
static DaqBlockQueue g_queue;

int main(void) {
    if (daq_core_selftest() != 0) finish(1);

    daq_pingpong_init(&g_pp);
    daq_queue_init(&g_queue);

    /* Stream 128 blocks through Ping-Pong -> Queue -> Consumer */
    int16_t synthetic_input[DAQ_BLOCK_SIZE];
    uint32_t consumed_count = 0;

    for (uint32_t blk_idx = 0; blk_idx < 128; ++blk_idx) {
        for (unsigned i = 0; i < DAQ_BLOCK_SIZE; ++i) {
            synthetic_input[i] = (int16_t)(blk_idx * 100u + i);
        }

        /* Step 1: Simulate DMA filling active ping-pong buffer */
        if (!daq_pingpong_isr_step(&g_pp, synthetic_input, blk_idx * 640u)) {
            finish(1); /* Overrun! */
        }

        /* Step 2: Consumer extracts from ping-pong */
        DaqBlock blk;
        unsigned buf_id;
        if (daq_pingpong_consume(&g_pp, &blk, &buf_id) != DAQ_OK) {
            finish(1);
        }

        /* Step 3: Enqueue to storage queue */
        if (daq_queue_push(&g_queue, &blk) != DAQ_OK) {
            finish(1);
        }

        /* Step 4: Dequeue from storage queue and verify */
        DaqBlock popped;
        if (daq_queue_pop(&g_queue, &popped) != DAQ_OK) {
            finish(1);
        }

        if (popped.sequence != blk_idx ||
            popped.checksum != daq_block_checksum(&popped)) {
            finish(1);
        }
        consumed_count++;
    }

    if (consumed_count != 128 || g_pp.overrun_count != 0 || g_queue.dropped_blocks != 0) {
        finish(1);
    }

    finish(0);
}
