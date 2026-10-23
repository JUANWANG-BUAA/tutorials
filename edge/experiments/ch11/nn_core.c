#include "nn_core.h"

void arena_init(TensorArena *arena, uint8_t *buf, size_t capacity) {
    if (!arena) return;
    arena->buffer = buf;
    arena->capacity = capacity;
    arena->current_offset = 0;
    arena->peak_offset = 0;
}

void *arena_alloc(TensorArena *arena, size_t bytes, size_t alignment) {
    if (!arena || !arena->buffer || bytes == 0) return NULL;
    if (alignment == 0) alignment = sizeof(void *);

    /* Align the absolute physical memory address */
    uintptr_t current_addr = (uintptr_t)(arena->buffer + arena->current_offset);
    uintptr_t aligned_addr = (current_addr + alignment - 1u) & ~(uintptr_t)(alignment - 1u);
    size_t new_offset = (size_t)(aligned_addr - (uintptr_t)arena->buffer) + bytes;

    if (new_offset > arena->capacity) {
        return NULL; /* Out of arena memory! */
    }

    arena->current_offset = new_offset;
    if (arena->current_offset > arena->peak_offset) {
        arena->peak_offset = arena->current_offset;
    }
    return (void *)aligned_addr;
}

void arena_reset(TensorArena *arena) {
    if (!arena) return;
    arena->current_offset = 0;
}

int32_t quant_rescale(int32_t val, int32_t multiplier_q31, int32_t shift) {
    if (multiplier_q31 == 0 || val == 0) return 0;
    int32_t total_shift = 31 + shift;
    if (total_shift <= 0) {
        return val;
    }
    if (total_shift > 62) {
        return 0;
    }

    int64_t prod = (int64_t)val * (int64_t)multiplier_q31;
    int64_t mask = (1LL << total_shift) - 1LL;
    int64_t half = 1LL << (total_shift - 1);
    int64_t quotient, remainder;

    if (prod >= 0) {
        quotient = prod >> total_shift;
        remainder = prod & mask;
        if (remainder >= half) {
            quotient++;
        }
    } else {
        uint64_t neg = (uint64_t)(-prod);
        quotient = -(int64_t)(neg >> total_shift);
        remainder = -(int64_t)(neg & (uint64_t)mask);
        if (remainder <= -half) {
            quotient--;
        }
    }
    return (int32_t)quotient;
}

int8_t quant_clamp_int8(int32_t val) {
    if (val > 127) return 127;
    if (val < -128) return -128;
    return (int8_t)val;
}

void nn_fully_connected_int8(const FullyConnectedParams *params,
                            const int8_t *input,
                            const int8_t *filter,
                            const int32_t *bias,
                            int8_t *output) {
    if (!params || !input || !filter || !output) return;

    uint32_t in_depth = params->input_depth;
    uint32_t out_depth = params->output_depth;

    for (uint32_t out_c = 0; out_c < out_depth; ++out_c) {
        int32_t acc = bias ? bias[out_c] : 0;
        const int8_t *filter_row = filter + (out_c * in_depth);

        /* Core MAC loop: 32-bit accumulation */
        for (uint32_t in_c = 0; in_c < in_depth; ++in_c) {
            int32_t in_val = (int32_t)input[in_c] - params->input_zero_point;
            int32_t filter_val = (int32_t)filter_row[in_c];
            acc += in_val * filter_val;
        }

        /* Fixed-point requantization: scale back to output INT8 domain */
        int32_t rescaled = quant_rescale(acc, params->multiplier_q31, params->shift);
        int32_t out_val = rescaled + params->output_zero_point;

        /* Activation clamp */
        if (out_val < params->activation_min) out_val = params->activation_min;
        if (out_val > params->activation_max) out_val = params->activation_max;

        output[out_c] = quant_clamp_int8(out_val);
    }
}

void nn_relu_int8(int8_t *data, uint32_t num_elements, int32_t zero_point) {
    if (!data) return;
    int8_t zp = quant_clamp_int8(zero_point);
    for (uint32_t i = 0; i < num_elements; ++i) {
        if (data[i] < zp) {
            data[i] = zp;
        }
    }
}

int nn_core_selftest(void) {
    /* 1. Test Arena Allocator */
    _Alignas(16) uint8_t arena_mem[256];
    TensorArena arena;
    arena_init(&arena, arena_mem, sizeof(arena_mem));

    void *p1 = arena_alloc(&arena, 64, 8);
    if (!p1 || ((uintptr_t)p1 & 7u) != 0) return 1;
    if (arena.current_offset != 64 || arena.peak_offset != 64) return 2;

    void *p2 = arena_alloc(&arena, 64, 16);
    if (!p2 || ((uintptr_t)p2 & 15u) != 0) return 3;

    /* Out of memory test */
    void *p3 = arena_alloc(&arena, 200, 8);
    if (p3 != NULL) return 4; /* Should fail */

    arena_reset(&arena);
    if (arena.current_offset != 0 || arena.peak_offset < 128) return 5;

    /* 2. Test Fixed-Point Requantization */
    /* Multiply by M0=0.5 (0x40000000 in Q31), shift=0 -> half */
    int32_t r1 = quant_rescale(100, 0x40000000, 0);
    if (r1 != 50) return 6;

    int32_t r2 = quant_rescale(-100, 0x40000000, 0);
    if (r2 != -50) return 7;

    /* Shift=1: multiplies by 0.5 * 2^-1 = 0.25 */
    int32_t r3 = quant_rescale(100, 0x40000000, 1);
    if (r3 != 25) return 8;

    /* Symmetric rounding ties */
    int32_t r4 = quant_rescale(3, 0x40000000, 0); /* 1.5 -> ties away from zero -> 2 */
    if (r4 != 2) return 9;
    int32_t r5 = quant_rescale(-3, 0x40000000, 0); /* -1.5 -> ties away from zero -> -2 */
    if (r5 != -2) return 10;

    /* 3. Test Fully Connected INT8 Layer */
    /* Input: 4 elements: [10, 20, -10, -20]
       Filter: 2 outputs x 4 inputs:
         row 0: [ 1,  2,  1,  2] -> dot = 10*1 + 20*2 + (-10)*1 + (-20)*2 = 10 + 40 - 10 - 40 = 0
         row 1: [ 2,  1, -2, -1] -> dot = 10*2 + 20*1 + (-10)*(-2) + (-20)*(-1) = 20 + 20 + 20 + 20 = 80
       Bias: [5, -10]
       Acc 0 = 0 + 5 = 5. Acc 1 = 80 - 10 = 70.
       Scale M0 = 0x40000000 (0.5), shift = 0.
       Output 0 = round(5 * 0.5) = round(2.5) = 3 + Z_out(0) = 3.
       Output 1 = round(70 * 0.5) = 35 + Z_out(0) = 35. */
    int8_t test_in[4] = {10, 20, -10, -20};
    int8_t test_w[8] = {
        1,  2,  1,  2,
        2,  1, -2, -1
    };
    int32_t test_bias[2] = {5, -10};
    int8_t test_out[2] = {0};

    FullyConnectedParams fc_params = {
        .input_depth = 4,
        .output_depth = 2,
        .input_zero_point = 0,
        .output_zero_point = 0,
        .multiplier_q31 = 0x40000000, /* 0.5 */
        .shift = 0,
        .activation_min = -128,
        .activation_max = 127
    };

    nn_fully_connected_int8(&fc_params, test_in, test_w, test_bias, test_out);
    if (test_out[0] != 3 || test_out[1] != 35) return 11;

    /* 4. Test ReLU */
    int8_t relu_data[4] = {-15, 0, 42, -100};
    nn_relu_int8(relu_data, 4, 0);
    if (relu_data[0] != 0 || relu_data[1] != 0 || relu_data[2] != 42 || relu_data[3] != 0) return 12;

    return 0;
}