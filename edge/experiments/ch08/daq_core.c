#include "daq_core.h"

uint32_t daq_block_checksum(const DaqBlock *blk) {
    uint32_t sum = 0x5a5a5a5a ^ blk->sequence ^ (blk->timestamp_tick * 31u);
    for (unsigned i = 0; i < DAQ_BLOCK_SIZE; ++i) {
        sum = (sum << 1) ^ (uint16_t)blk->samples[i];
    }
    return sum;
}

void daq_pingpong_init(DaqPingPong *pp) {
    if (!pp) return;
    pp->active_buf = 0;
    pp->ready_mask = 0;
    pp->next_seq = 0;
    pp->overrun_count = 0;
    for (unsigned b = 0; b < 2; ++b) {
        pp->buffers[b].sequence = 0;
        pp->buffers[b].timestamp_tick = 0;
        pp->buffers[b].checksum = 0;
        for (unsigned i = 0; i < DAQ_BLOCK_SIZE; ++i) {
            pp->buffers[b].samples[i] = 0;
        }
    }
}

bool daq_pingpong_isr_step(DaqPingPong *pp, const int16_t *raw_input, uint32_t tick) {
    if (!pp || !raw_input) return false;
    uint32_t active = pp->active_buf;
    /* Check if the active buffer was not consumed by the consumer yet */
    if (pp->ready_mask & (1u << active)) {
        pp->overrun_count++;
        return false; /* Overrun: previous data not processed! */
    }

    DaqBlock *dst = &pp->buffers[active];
    dst->sequence = pp->next_seq++;
    dst->timestamp_tick = tick;
    for (unsigned i = 0; i < DAQ_BLOCK_SIZE; ++i) {
        dst->samples[i] = raw_input[i];
    }
    dst->checksum = daq_block_checksum(dst);

    /* Publish this buffer as ready */
    pp->ready_mask |= (1u << active);
    /* Toggle active buffer for next DMA transfer */
    pp->active_buf = active ^ 1u;
    return true;
}

DaqResult daq_pingpong_consume(DaqPingPong *pp, DaqBlock *out_block, unsigned *buf_idx) {
    if (!pp || !out_block) return DAQ_ERR_PARAM;
    
    /* Consumer looks for either buffer marked ready */
    unsigned target = 2;
    if (pp->ready_mask & 1u) target = 0;
    else if (pp->ready_mask & 2u) target = 1;
    else return DAQ_ERR_EMPTY;

    DaqBlock *src = &pp->buffers[target];
    uint32_t expected_csum = daq_block_checksum(src);
    if (src->checksum != expected_csum) {
        return DAQ_ERR_CORRUPT;
    }

    *out_block = *src;
    if (buf_idx) *buf_idx = target;

    /* Release buffer back to DMA */
    pp->ready_mask &= ~(1u << target);
    return DAQ_OK;
}

void daq_queue_init(DaqBlockQueue *q) {
    if (!q) return;
    q->head = 0;
    q->tail = 0;
    q->capacity = DAQ_RING_BLOCKS;
    q->dropped_blocks = 0;
}

uint32_t daq_queue_occupancy(const DaqBlockQueue *q) {
    if (!q) return 0;
    uint32_t cap = (q->capacity > 1 && q->capacity <= DAQ_RING_BLOCKS) ? q->capacity : DAQ_RING_BLOCKS;
    uint32_t h = q->head;
    uint32_t t = q->tail;
    return (h >= t) ? (h - t) : (cap - t + h);
}

DaqResult daq_queue_push(DaqBlockQueue *q, const DaqBlock *blk) {
    if (!q || !blk) return DAQ_ERR_PARAM;
    uint32_t cap = (q->capacity > 1 && q->capacity <= DAQ_RING_BLOCKS) ? q->capacity : DAQ_RING_BLOCKS;
    uint32_t next_head = (q->head + 1u) % cap;
    if (next_head == q->tail) {
        q->dropped_blocks++;
        return DAQ_ERR_FULL;
    }
    q->slots[q->head] = *blk;
    q->head = next_head;
    return DAQ_OK;
}

DaqResult daq_queue_pop(DaqBlockQueue *q, DaqBlock *blk) {
    if (!q || !blk) return DAQ_ERR_PARAM;
    if (q->head == q->tail) {
        return DAQ_ERR_EMPTY;
    }
    uint32_t cap = (q->capacity > 1 && q->capacity <= DAQ_RING_BLOCKS) ? q->capacity : DAQ_RING_BLOCKS;
    *blk = q->slots[q->tail];
    q->tail = (q->tail + 1u) % cap;
    return DAQ_OK;
}

DaqPipelineBudget daq_calculate_budget(uint32_t sample_rate_hz, uint32_t erase_stall_us) {
    DaqPipelineBudget b;
    b.sample_rate_hz = sample_rate_hz;
    b.erase_stall_us = erase_stall_us;
    b.bytes_per_sample = sizeof(int16_t);
    
    /* Pure 32-bit calculation: avoid 64-bit division runtime helper on 32-bit MCUs */
    uint32_t khz = sample_rate_hz / 1000u;
    uint32_t rem_hz = sample_rate_hz % 1000u;
    uint32_t samples_during_stall = (khz * erase_stall_us) / 1000u;
    if (rem_hz > 0) {
        samples_during_stall += (rem_hz * erase_stall_us + 999999u) / 1000000u;
    }
    /* Minimum blocks needed = ceil(samples_during_stall / DAQ_BLOCK_SIZE) + 1 (safety margin) */
    b.min_queue_depth_blocks = (samples_during_stall + DAQ_BLOCK_SIZE - 1u) / DAQ_BLOCK_SIZE + 1u;
    return b;
}

int daq_core_selftest(void) {
    DaqPingPong pp;
    daq_pingpong_init(&pp);

    int16_t input0[DAQ_BLOCK_SIZE], input1[DAQ_BLOCK_SIZE];
    for (unsigned i = 0; i < DAQ_BLOCK_SIZE; ++i) {
        input0[i] = (int16_t)(1000 + i);
        input1[i] = (int16_t)(2000 + i);
    }

    /* 1. Normal Ping-Pong alternation */
    if (!daq_pingpong_isr_step(&pp, input0, 100)) return 1;
    if (pp.active_buf != 1 || pp.ready_mask != 1) return 2;

    DaqBlock out;
    unsigned idx = 99;
    if (daq_pingpong_consume(&pp, &out, &idx) != DAQ_OK || idx != 0) return 3;
    if (out.sequence != 0 || out.timestamp_tick != 100 || out.samples[0] != 1000) return 4;
    if (pp.ready_mask != 0) return 5;

    /* Fill buffer 1 */
    if (!daq_pingpong_isr_step(&pp, input1, 200)) return 6;
    if (pp.active_buf != 0 || pp.ready_mask != 2) return 7;
    if (daq_pingpong_consume(&pp, &out, &idx) != DAQ_OK || idx != 1) return 8;
    if (out.sequence != 1 || out.timestamp_tick != 200 || out.samples[0] != 2000) return 9;

    /* 2. Overrun detection test */
    daq_pingpong_init(&pp);
    if (!daq_pingpong_isr_step(&pp, input0, 10)) return 10;
    if (!daq_pingpong_isr_step(&pp, input1, 20)) return 11;
    /* Both buffers are now full! Active is 0. Next step must OVERRUN */
    if (daq_pingpong_isr_step(&pp, input0, 30)) return 12; /* should fail! */
    if (pp.overrun_count != 1) return 13;

    /* 3. SPSC Queue test */
    DaqBlockQueue q;
    daq_queue_init(&q);
    if (daq_queue_occupancy(&q) != 0) return 14;

    for (unsigned i = 0; i < DAQ_RING_BLOCKS - 1; ++i) {
        DaqBlock b = {.sequence = i, .timestamp_tick = i * 10};
        if (daq_queue_push(&q, &b) != DAQ_OK) return 15;
    }
    if (daq_queue_occupancy(&q) != DAQ_RING_BLOCKS - 1) return 16;
    /* Queue should now be full */
    DaqBlock extra = {.sequence = 99};
    if (daq_queue_push(&q, &extra) != DAQ_ERR_FULL) return 17;
    if (q.dropped_blocks != 1) return 18;

    for (unsigned i = 0; i < DAQ_RING_BLOCKS - 1; ++i) {
        DaqBlock b;
        if (daq_queue_pop(&q, &b) != DAQ_OK) return 19;
        if (b.sequence != i) return 20;
    }
    if (daq_queue_pop(&q, &out) != DAQ_ERR_EMPTY) return 21;

    /* 4. Budget calculation test:
       100 kSPS, 5 ms erase stall (5000 us).
       Samples in 5 ms = 100000 * 0.005 = 500 samples.
       500 / 64 = 7.8125 -> 8 blocks + 1 margin = 9 blocks minimum queue depth */
    DaqPipelineBudget budget = daq_calculate_budget(100000, 5000);
    if (budget.min_queue_depth_blocks != 9) return 22;

    return 0;
}
