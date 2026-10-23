#include "nn_core.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Simulated 2-layer Vibration Anomaly Classifier:
   Input 8 -> Hidden 16 (ReLU) -> Output 2 (Class 0: Normal, Class 1: Anomaly) */
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
    /* Class 0 (Normal): expects low activation on anomaly filters */
    2, -1,  3, -2,  1,  3, -2,  1,  0,  2, -1,  3,  1, -2,  2,  0,
    /* Class 1 (Anomaly): strongly weights high vibration energy */
   -2,  3, -1,  4, -2,  1,  3, -1,  3, -1,  4, -2,  2,  3, -1,  4
};

static const int32_t g_l2_bias[OUT_DIM] = {20, -20};

static void run_mlp_inference(const int8_t *in_features, int8_t *out_logits, bool corrupt_scale) {
    uint8_t arena_buffer[1024];
    TensorArena arena;
    arena_init(&arena, arena_buffer, sizeof(arena_buffer));

    /* Ping-Pong Activation Buffers:
       Buffer 1 for Hidden Layer (16 bytes)
       Buffer 2 for Output Layer (2 bytes) */
    int8_t *hidden_act = (int8_t *)arena_alloc(&arena, HIDDEN_DIM, 8);
    assert(hidden_act != NULL);

    FullyConnectedParams l1_params = {
        .input_depth = IN_DIM,
        .output_depth = HIDDEN_DIM,
        .input_zero_point = 0,
        .output_zero_point = 0,
        .multiplier_q31 = corrupt_scale ? 0x7FFFFFFF : 0x40000000, /* 0.5 vs saturated */
        .shift = corrupt_scale ? 0 : 1,                            /* 0.25 effective scale */
        .activation_min = -128,
        .activation_max = 127
    };

    /* Layer 1: Dense */
    nn_fully_connected_int8(&l1_params, in_features, g_l1_weights, g_l1_bias, hidden_act);

    /* Layer 1 Activation: ReLU */
    nn_relu_int8(hidden_act, HIDDEN_DIM, 0);

    /* Layer 2: Dense -> Output logits */
    FullyConnectedParams l2_params = {
        .input_depth = HIDDEN_DIM,
        .output_depth = OUT_DIM,
        .input_zero_point = 0,
        .output_zero_point = 0,
        .multiplier_q31 = 0x40000000,
        .shift = 1,
        .activation_min = -128,
        .activation_max = 127
    };

    nn_fully_connected_int8(&l2_params, hidden_act, g_l2_weights, g_l2_bias, out_logits);

    /* Verify arena memory efficiency */
    assert(arena.peak_offset <= 64); /* Only 64 bytes needed! */
}

int main(void) {
    int res = nn_core_selftest();
    if (res != 0) {
        fprintf(stderr, "NN CORE FAIL at selftest line %d\n", res);
        return 1;
    }
    puts("MODEL PASS NN core: arena allocator, fixed-point requantize, dense gemm, relu");

    /* Test Case A: Normal Vibration Sample (low amplitudes across all bands) */
    int8_t normal_sample[IN_DIM] = {5, 8, -4, 6, 2, -3, 7, 4};
    int8_t logits_normal[OUT_DIM];
    run_mlp_inference(normal_sample, logits_normal, false);
    printf("MODEL inference Normal: Logit0(Normal)=%d, Logit1(Anomaly)=%d -> Predicted: %s\n",
           logits_normal[0], logits_normal[1],
           logits_normal[0] > logits_normal[1] ? "NORMAL" : "ANOMALY");
    assert(logits_normal[0] > logits_normal[1]);

    /* Test Case B: Bearing Fault Anomaly Sample (high high-frequency vibration) */
    int8_t anomaly_sample[IN_DIM] = {45, 62, 58, 70, 52, 65, 80, 75};
    int8_t logits_anomaly[OUT_DIM];
    run_mlp_inference(anomaly_sample, logits_anomaly, false);
    printf("MODEL inference Anomaly: Logit0(Normal)=%d, Logit1(Anomaly)=%d -> Predicted: %s\n",
           logits_anomaly[0], logits_anomaly[1],
           logits_anomaly[0] < logits_anomaly[1] ? "ANOMALY" : "NORMAL");
    assert(logits_anomaly[1] > logits_anomaly[0]);

    /* Test Case C: Failure Case - Scale Factor Miscalibration / Saturation Collapse */
    int8_t logits_corrupt[OUT_DIM];
    run_mlp_inference(normal_sample, logits_corrupt, true);
    printf("MODEL failure case: scale miscalibration caused hidden layer saturation (Logit0=%d, Logit1=%d)\n",
           logits_corrupt[0], logits_corrupt[1]);
    /* With corrupt scaling, hidden units hit 127 saturation limit, causing misclassification of normal sample! */
    assert(logits_corrupt[1] >= logits_corrupt[0]); /* Classification inverted! */
    puts("MODEL PASS failure case: scale factor corruption inverted prediction from NORMAL to ANOMALY");

    return 0;
}
