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

static void puts_host(const char *s) {
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}

__attribute__((noreturn)) static void finish(uint32_t code) {
    puts_host(code ? "ARM NN FAIL\n" : "ARM NN PASS: INT8 MLP inference, Q31 requantize, normal & anomaly classified\n");
    uint32_t block[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = block;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
    for (;;) {}
}

void fault(void) { finish(55); }

static void run_forward(const int8_t *in, int8_t *out) {
    int8_t hidden[HIDDEN_DIM];

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
    nn_fully_connected_int8(&l1_p, in, g_l1_weights, g_l1_bias, hidden);
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
}

int main(void) {
    if (nn_core_selftest() != 0) finish(1);

    int8_t normal_sample[IN_DIM] = {5, 8, -4, 6, 2, -3, 7, 4};
    int8_t out_norm[OUT_DIM];
    run_forward(normal_sample, out_norm);
    if (out_norm[0] <= out_norm[1]) finish(1); /* Class 0 must win for normal */

    int8_t anomaly_sample[IN_DIM] = {45, 62, 58, 70, 52, 65, 80, 75};
    int8_t out_anom[OUT_DIM];
    run_forward(anomaly_sample, out_anom);
    if (out_anom[1] <= out_anom[0]) finish(1); /* Class 1 must win for anomaly */

    finish(0);
}