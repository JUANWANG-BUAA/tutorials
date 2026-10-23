#ifndef EDGE_DAQ_CORE_H
#define EDGE_DAQ_CORE_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define DAQ_BLOCK_SIZE    64u
#define DAQ_RING_BLOCKS   32u
#define DAQ_FIFO_CAPACITY 32u

typedef enum {
    DAQ_OK = 0,
    DAQ_ERR_PARAM,
    DAQ_ERR_FULL,
    DAQ_ERR_EMPTY,
    DAQ_ERR_OVERRUN,
    DAQ_ERR_CORRUPT,
    DAQ_ERR_STALL
} DaqResult;

/* Block of samples exchanged between DMA/ISR and processing task */
typedef struct {
    uint32_t sequence;
    uint32_t timestamp_tick;
    int16_t  samples[DAQ_BLOCK_SIZE];
    uint32_t checksum;
} DaqBlock;

/* Ping-Pong / Double Buffer Controller */
typedef struct {
    DaqBlock buffers[2];
    volatile uint32_t active_buf;     /* 0 or 1: currently filled by DMA/ISR */
    volatile uint32_t ready_mask;     /* bit 0: buf0 ready, bit 1: buf1 ready */
    uint32_t next_seq;
    unsigned overrun_count;
} DaqPingPong;

void daq_pingpong_init(DaqPingPong *pp);
/* Called by DMA Half-Transfer / Transfer-Complete ISR */
bool daq_pingpong_isr_step(DaqPingPong *pp, const int16_t *raw_input, uint32_t tick);
/* Called by worker thread to retrieve next ready block */
DaqResult daq_pingpong_consume(DaqPingPong *pp, DaqBlock *out_block, unsigned *buf_idx);

/* SPSC Lockless Ring Buffer of Blocks */
typedef struct {
    DaqBlock slots[DAQ_RING_BLOCKS];
    volatile uint32_t head;           /* written by producer */
    volatile uint32_t tail;           /* written by consumer */
    uint32_t capacity;
    unsigned dropped_blocks;
} DaqBlockQueue;

void daq_queue_init(DaqBlockQueue *q);
DaqResult daq_queue_push(DaqBlockQueue *q, const DaqBlock *blk);
DaqResult daq_queue_pop(DaqBlockQueue *q, DaqBlock *blk);
uint32_t daq_queue_occupancy(const DaqBlockQueue *q);

/* Storage Pipeline Model with Flash Block Erase Stalls */
typedef struct {
    uint32_t sample_rate_hz;
    uint32_t erase_stall_us;
    uint32_t bytes_per_sample;
    uint32_t min_queue_depth_blocks;
} DaqPipelineBudget;

DaqPipelineBudget daq_calculate_budget(uint32_t sample_rate_hz, uint32_t erase_stall_us);

/* Checksum helper for data integrity validation */
uint32_t daq_block_checksum(const DaqBlock *blk);

int daq_core_selftest(void);

#endif /* EDGE_DAQ_CORE_H */
