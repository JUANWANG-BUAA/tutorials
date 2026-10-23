#include <stdint.h>
#include <stdbool.h>
#include "nn_core.h"

#define IN_DIM     8u
#define HIDDEN_DIM 16u
#define OUT_DIM    2u

static const int8_t g_l1_weights[HIDDEN_DIM * IN_DIM] = {
    2, -1,  3,  0, -2,  1,  2, -1,
   -1,  2, -1,  3,  1, -2,  0,  2,
    3,  1, -2, -1,  2,  0, -3,  1,
    0, -2,  1,  2, -1,  3,  2, -2,
    1,  3,  0, -2,  2, -1,  1,  3,
   -2,  0,  3,  1, -1,  2, -2,  1,
    2, -1, -2,  3,  0,  1,  3, -1,
    1,  2,  1, -2,  3, -1,  0,  2,
   -1,  3,  2,  0, -2,  1, -1,  3,
    2,  0, -1,  3,  1, -2,  2, -1,
    3, -2,  1,  1,  0,  3, -2,  2,
    0,  1,  3, -2,  2, -1,  1,  0,
   -2,  2,  0,  1, -1,  3,  2, -2,
    1, -1,  2,  3,  0, -2,  1,  3,
    3,  0, -1,  2,  2, -1, -2,  1,
   -1,  2,  3, -1,  1,  0,  3, -2
};

static const int32_t g_l1_bias[HIDDEN_DIM] = {
    10, -5, 8, 12, -4, 6, 15, -8,
     7, 11, -3, 9,  4, -6, 13, -2
};

static const int8_t g_l2_weights[OUT_DIM * HIDDEN_DIM] = {
    2, -1,  3, -2,  1,  3, -2,  1,  0,  2, -1,  3,  1, -2,  2,  0,
   -2,  3, -1,  4, -2,  1,  3, -1,  3, -1,  4, -2,  2,  3, -1,  4
};

static const int32_t g_l2_bias[OUT_DIM] = {20, -20};

__attribute__((noreturn)) void finish(unsigned code) {
    const char *s = code ? "RV32 NN FAIL\n" : "RV32 NN PASS: INT8 GEMM, ReLU activation, Q31 scaling\n";
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
    for (;;) {}
}

int main(void) {
    if (nn_core_selftest() != 0) finish(1);

    int8_t normal_sample[IN_DIM] = {5, 8, -4, 6, 2, -3, 7, 4};
    int8_t hidden[HIDDEN_DIM];
    int8_t out[OUT_DIM];

    FullyConnectedParams l1_p = {
        .input_depth = IN_DIM,
        .output_depth = HIDDEN_DIM,
        .input_zero_point = 0,
        .output_zero_point = 0,
        .multiplier_q31 = 0x40000000,
        .shift = 1,
        .activation_min = -128,
        .activation_max = 127
    };
    nn_fully_connected_int8(&l1_p, normal_sample, g_l1_weights, g_l1_bias, hidden);
    nn_relu_int8(hidden, HIDDEN_DIM, 0);

    FullyConnectedParams l2_p = {
        .input_depth = HIDDEN_DIM,
        .output_depth = OUT_DIM,
        .input_zero_point = 0,
        .output_zero_point = 0,
        .multiplier_q31 = 0x40000000,
        .shift = 1,
        .activation_min = -128,
        .activation_max = 127
    };
    nn_fully_connected_int8(&l2_p, hidden, g_l2_weights, g_l2_bias, out);

    if (out[0] <= out[1]) finish(1); /* Class 0 must win for normal sample */

    finish(0);
}
