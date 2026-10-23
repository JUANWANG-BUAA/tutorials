#ifndef EDGE_NN_CORE_H
#define EDGE_NN_CORE_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define MAX_TENSOR_DIMS 4u

/* Quantization parameters for affine mapping: r = S * (q - Z)
   Effective scale M = S_in * S_w / S_out is decomposed as M = (M0 * 2^-n)
   where M0 is represented as a signed 32-bit Q31 fixed-point integer. */
typedef struct {
    int32_t multiplier_q31; /* In range [0x40000000, 0x7FFFFFFF] representing [0.5, 1.0) */
    int32_t shift;          /* Right shift amount n (e.g. 0 to 31) */
    int32_t zero_point;     /* Quantized integer zero-point Z */
} QuantParams;

/* Tensor descriptor */
typedef struct {
    int8_t *data;
    uint32_t shape[MAX_TENSOR_DIMS];
    uint32_t num_dims;
    uint32_t total_elements;
    QuantParams qparams;
} Int8Tensor;

/* Simple Static Tensor Memory Arena */
typedef struct {
    uint8_t *buffer;
    size_t capacity;
    size_t current_offset;
    size_t peak_offset;
} TensorArena;

void arena_init(TensorArena *arena, uint8_t *buf, size_t capacity);
void *arena_alloc(TensorArena *arena, size_t bytes, size_t alignment);
void arena_reset(TensorArena *arena);

/*
 * Fixed-point requantization: (val * multiplier_q31) >> (31 + shift)
 * Implements symmetric rounding: round to nearest, ties away from zero.
 */
int32_t quant_rescale(int32_t val, int32_t multiplier_q31, int32_t shift);

/* Clamp integer to signed 8-bit range [-128, 127] */
int8_t quant_clamp_int8(int32_t val);

/*
 * Fully Connected (Dense / GEMM) INT8 Forward Kernel
 * input: [N, K]
 * weights: [M, K] (Symmetric: Z_w = 0)
 * bias: [M] (32-bit accumulator domain: S_bias = S_in * S_w)
 * output: [N, M]
 */
typedef struct {
    uint32_t input_depth;   /* K */
    uint32_t output_depth;  /* M */
    int32_t input_zero_point;
    int32_t output_zero_point;
    int32_t multiplier_q31;
    int32_t shift;
    int32_t activation_min; /* -128 */
    int32_t activation_max; /* 127 */
} FullyConnectedParams;

void nn_fully_connected_int8(const FullyConnectedParams *params,
                            const int8_t *input,
                            const int8_t *filter,
                            const int32_t *bias,
                            int8_t *output);

/* ReLU activation in INT8 */
void nn_relu_int8(int8_t *data, uint32_t num_elements, int32_t zero_point);

int nn_core_selftest(void);

#endif /* EDGE_NN_CORE_H */
