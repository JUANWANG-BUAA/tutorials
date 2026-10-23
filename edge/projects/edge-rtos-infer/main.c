#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* =========================================================================
 * 综合项目一：工业级 CAN 节点 + RTOS 实时调度 + 边缘 INT8 故障诊断系统
 * 硬件/微架构主线：ARM Cortex-M / RISC-V 任务抢占、CAN 总线协议、定点 FIR 滤波与 INT8 张量推理
 * ========================================================================= */

#define CAN_ID_ALARM   0x050u /* 突发最高优先级异步告警帧 */
#define CAN_ID_COMMAND 0x100u /* 总线控制与配置帧 */
#define CAN_ID_STATUS  0x200u /* 周期性健康状态上报帧 */

#define FEATURE_DIM 8u
#define HIDDEN_DIM  16u
#define OUTPUT_DIM  2u
#define SPSC_CAP    8u

/* --- 1. CAN 报文结构体 --- */
typedef struct {
    uint32_t id;
    uint8_t dlc;
    uint8_t data[8];
} CanMsg;

/* --- 2. SPSC 无锁单生产者单消费者队列 (第 4、8 章模型) --- */
typedef struct {
    int8_t features[FEATURE_DIM];
    uint32_t sequence;
    uint32_t timestamp_us;
} SensorPacket;

typedef struct {
    SensorPacket buffer[SPSC_CAP];
    volatile uint32_t head;
    volatile uint32_t tail;
} SpscQueue;

static void spsc_init(SpscQueue *q) {
    q->head = 0;
    q->tail = 0;
}

static bool spsc_push(SpscQueue *q, const SensorPacket *pkt) {
    uint32_t next = (q->head + 1) % SPSC_CAP;
    if (next == q->tail) return false; /* 队列已满 */
    q->buffer[q->head] = *pkt;
    q->head = next;
    return true;
}

static bool spsc_pop(SpscQueue *q, SensorPacket *pkt) {
    if (q->head == q->tail) return false; /* 队列为空 */
    *pkt = q->buffer[q->tail];
    q->tail = (q->tail + 1) % SPSC_CAP;
    return true;
}

/* --- 3. 定点 Q15 滤波算法 (第 7 章模型) --- */
#define FIR_TAPS 8u
static const int16_t g_fir_coeffs[FIR_TAPS] = {
    1024, 2048, 4096, 8192, 8192, 4096, 2048, 1024 /* 低通滤波器系数，和为 30720 <= 32767 */
};

typedef struct {
    int16_t history[FIR_TAPS];
    uint8_t ptr;
} Q15Fir;

static void fir_init(Q15Fir *fir) {
    memset(fir->history, 0, sizeof(fir->history));
    fir->ptr = 0;
}

static int16_t fir_step(Q15Fir *fir, int16_t raw_sample) {
    fir->history[fir->ptr] = raw_sample;
    fir->ptr = (fir->ptr + 1) % FIR_TAPS;

    int32_t acc = 0;
    for (uint32_t i = 0; i < FIR_TAPS; ++i) {
        uint32_t idx = (fir->ptr + FIR_TAPS - 1 - i) % FIR_TAPS;
        acc += ((int32_t)fir->history[idx] * (int32_t)g_fir_coeffs[i]) >> 15;
    }
    /* 饱和钳位至 Q15 范围 [-32768, 32767] */
    if (acc > 32767) acc = 32767;
    if (acc < -32768) acc = -32768;
    return (int16_t)acc;
}

/* --- 4. INT8 量化张量推理内核 (第 11 章模型) --- */
static const int8_t g_l1_weights[HIDDEN_DIM * FEATURE_DIM] = {
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

static const int8_t g_l2_weights[OUTPUT_DIM * HIDDEN_DIM] = {
    2, -1,  3, -2,  1,  3, -2,  1,  0,  2, -1,  3,  1, -2,  2,  0,
   -2,  3, -1,  4, -2,  1,  3, -1,  3, -1,  4, -2,  2,  3, -1,  4
};

static const int32_t g_l2_bias[OUTPUT_DIM] = {20, -20};

static int8_t quant_rescale_q31(int32_t acc, int32_t mult_q31, int shift) {
    int64_t total = (int64_t)acc * (int64_t)mult_q31;
    int total_shift = 31 + shift;
    int64_t rounded;
    if (total >= 0) {
        rounded = (total + ((int64_t)1 << (total_shift - 1))) >> total_shift;
    } else {
        int64_t mag = -total;
        rounded = -((mag + ((int64_t)1 << (total_shift - 1))) >> total_shift);
    }
    if (rounded > 127) rounded = 127;
    if (rounded < -128) rounded = -128;
    return (int8_t)rounded;
}

static void nn_infer(const int8_t *in, int8_t *out) {
    int8_t hidden[HIDDEN_DIM];

    /* Layer 1: Dense 8 -> 16 */
    for (uint32_t o = 0; o < HIDDEN_DIM; ++o) {
        int32_t acc = g_l1_bias[o];
        for (uint32_t i = 0; i < FEATURE_DIM; ++i) {
            acc += (int32_t)in[i] * (int32_t)g_l1_weights[o * FEATURE_DIM + i];
        }
        int8_t h = quant_rescale_q31(acc, 0x40000000, 1); /* M0=0.5, shift=1 => *0.25 */
        if (h < 0) h = 0; /* 原位 ReLU 激活 */
        hidden[o] = h;
    }

    /* Layer 2: Dense 16 -> 2 */
    for (uint32_t o = 0; o < OUTPUT_DIM; ++o) {
        int32_t acc = g_l2_bias[o];
        for (uint32_t i = 0; i < HIDDEN_DIM; ++i) {
            acc += (int32_t)hidden[i] * (int32_t)g_l2_weights[o * HIDDEN_DIM + i];
        }
        out[o] = quant_rescale_q31(acc, 0x40000000, 1);
    }
}

/* --- 5. 功能安全看门狗监管 (第 10 章模型) --- */
#define TASK_COMM_ID    1u
#define TASK_SAMPLE_ID  2u
#define TASK_INFER_ID   3u

typedef struct {
    uint32_t token[4];
    uint32_t last_checkin[4];
    uint32_t total_feeds;
} WatchdogSupervisor;

static void wdt_init(WatchdogSupervisor *wdt) {
    memset(wdt, 0, sizeof(*wdt));
}

static bool wdt_checkin(WatchdogSupervisor *wdt, uint32_t task_id, uint32_t token, uint32_t tick) {
    if (task_id < 1 || task_id > 3) return false;
    if (token != wdt->token[task_id] + 1) return false; /* 严格检测代际 Token 递增 */
    wdt->token[task_id] = token;
    wdt->last_checkin[task_id] = tick;
    return true;
}

static bool wdt_poll_supervisor(WatchdogSupervisor *wdt, uint32_t tick, uint32_t timeout_ticks) {
    for (uint32_t id = 1; id <= 3; ++id) {
        if (wdt->token[id] == 0) return false; /* 从未打卡违约 */
        if (tick - wdt->last_checkin[id] > timeout_ticks) return false; /* 超时违约 */
    }
    ++wdt->total_feeds;
    return true;
}

/* --- 6. 综合系统运行上下文与统计指标 --- */
typedef struct {
    SpscQueue queue;
    Q15Fir fir;
    WatchdogSupervisor wdt;
    uint32_t ticks;
    uint32_t frames_sent_status;
    uint32_t frames_sent_alarm;
    uint32_t inferences_count;
    uint32_t normal_count;
    uint32_t anomaly_count;
    uint8_t system_status; /* 0: Normal, 1: Anomaly Warning, 2: Fault Tripped */
} EdgeSystem;

static EdgeSystem g_sys;

/* 模拟总线输出回调 */
static void bus_transmit(const CanMsg *msg) {
    if (msg->id == CAN_ID_STATUS) {
        ++g_sys.frames_sent_status;
    } else if (msg->id == CAN_ID_ALARM) {
        ++g_sys.frames_sent_alarm;
    }
}

/* 任务 1：传感器采样与定点滤波 (Priority 2) */
static void task_sensor_sampling(uint32_t tick, bool inject_anomaly) {
    static uint32_t s_seq = 0;
    static uint32_t s_token = 0;

    SensorPacket pkt;
    pkt.sequence = ++s_seq;
    pkt.timestamp_us = tick * 1000u;

    for (uint32_t i = 0; i < FEATURE_DIM; ++i) {
        int16_t raw;
        if (!inject_anomaly) {
            /* 正常工况：基准平稳振动信号 (-5 ~ +7) */
            raw = (int16_t)(((int32_t)(tick * 7 + i * 3) % 13) - 5);
        } else {
            /* 轴承损伤异常：高频大幅度冲击振动 (+55 ~ +79) */
            raw = (int16_t)(55 + ((int32_t)(tick * 11 + i * 7) % 25));
        }
        int16_t filtered = fir_step(&g_sys.fir, raw);
        /* 压缩至 int8 范围 [-128, 127] */
        int32_t compressed = filtered / 2;
        if (compressed > 127) compressed = 127;
        if (compressed < -128) compressed = -128;
        pkt.features[i] = (int8_t)compressed;
    }

    bool pushed = spsc_push(&g_sys.queue, &pkt);
    assert(pushed); /* 队列在正常调度下绝不应溢出丢包 */

    /* 报告看门狗心跳 */
    bool checked = wdt_checkin(&g_sys.wdt, TASK_SAMPLE_ID, ++s_token, tick);
    assert(checked);
}

/* 任务 2：边缘诊断张量推理 (Priority 3) */
static void task_edge_inference(uint32_t tick) {
    static uint32_t s_token = 0;
    SensorPacket pkt;

    while (spsc_pop(&g_sys.queue, &pkt)) {
        int8_t logits[OUTPUT_DIM];
        nn_infer(pkt.features, logits);
        ++g_sys.inferences_count;

        if (logits[0] > logits[1]) {
            /* Class 0 胜出：健康正常 */
            ++g_sys.normal_count;
            g_sys.system_status = 0;
        } else {
            /* Class 1 胜出：检测到轴承磨损异常！ */
            ++g_sys.anomaly_count;
            g_sys.system_status = 1;

            /* 立即触发异步最高优先级 CAN 告警帧 (CAN ID 0x050) */
            CanMsg alarm_msg;
            alarm_msg.id = CAN_ID_ALARM;
            alarm_msg.dlc = 8;
            alarm_msg.data[0] = 0xAA; /* Alarm Sync */
            alarm_msg.data[1] = 0x01; /* Reason: Bearing Vibration Anomaly */
            alarm_msg.data[2] = (uint8_t)logits[0];
            alarm_msg.data[3] = (uint8_t)logits[1];
            alarm_msg.data[4] = (uint8_t)(pkt.sequence >> 24);
            alarm_msg.data[5] = (uint8_t)(pkt.sequence >> 16);
            alarm_msg.data[6] = (uint8_t)(pkt.sequence >> 8);
            alarm_msg.data[7] = (uint8_t)pkt.sequence;
            bus_transmit(&alarm_msg);
        }
    }

    bool checked = wdt_checkin(&g_sys.wdt, TASK_INFER_ID, ++s_token, tick);
    assert(checked);
}

/* 任务 3：CAN 通信与状态发布调度 (Priority 1) */
static void task_can_comm(uint32_t tick) {
    static uint32_t s_token = 0;

    /* 周期性 10ms (每 10 个 tick) 发送健康遥测状态帧 */
    if (tick % 10 == 0) {
        CanMsg status_msg;
        status_msg.id = CAN_ID_STATUS;
        status_msg.dlc = 8;
        status_msg.data[0] = g_sys.system_status;
        status_msg.data[1] = (uint8_t)(g_sys.inferences_count & 0xFF);
        status_msg.data[2] = (uint8_t)(g_sys.normal_count & 0xFF);
        status_msg.data[3] = (uint8_t)(g_sys.anomaly_count & 0xFF);
        status_msg.data[4] = (uint8_t)(g_sys.frames_sent_alarm & 0xFF);
        status_msg.data[5] = 0;
        status_msg.data[6] = 0;
        status_msg.data[7] = (uint8_t)(tick & 0xFF);
        bus_transmit(&status_msg);
    }

    bool checked = wdt_checkin(&g_sys.wdt, TASK_COMM_ID, ++s_token, tick);
    assert(checked);
}

/* --- 7. 系统初始化与全流程集成自测 --- */
void project_system_init(void) {
    memset(&g_sys, 0, sizeof(g_sys));
    spsc_init(&g_sys.queue);
    fir_init(&g_sys.fir);
    wdt_init(&g_sys.wdt);
}

int main(void) {
    project_system_init();
    printf("=== Edge Project 1: Industrial CAN Node + RTOS + INT8 Fault Diagnosis ===\n");

    /* 阶段 1：模拟正常工况运行 (Tick 1 ~ 100) */
    printf("[Phase 1] 正常工况模拟 (100 ms)... ");
    for (uint32_t tick = 1; tick <= 100; ++tick) {
        /* 优先级抢占调度执行顺序：P1(CAN) -> P2(Sample) -> P3(Infer) */
        task_can_comm(tick);
        task_sensor_sampling(tick, false /* 无异常 */);
        task_edge_inference(tick);

        /* 看门狗每 5 个 tick 巡检一次 */
        if (tick % 5 == 0) {
            bool ok = wdt_poll_supervisor(&g_sys.wdt, tick, 10 /* 超时上限 10ms */);
            assert(ok);
        }
    }
    assert(g_sys.normal_count == 100);
    assert(g_sys.anomaly_count == 0);
    assert(g_sys.frames_sent_alarm == 0);
    assert(g_sys.frames_sent_status == 10); /* 100ms / 10ms = 10 帧 */
    printf("PASS (Inferred: 100, Normal: 100, Alarms: 0, Status Frames: 10)\n");

    /* 阶段 2：注入轴承振动突发损伤异常 (Tick 101 ~ 150) */
    printf("[Phase 2] 轴承振动故障注入与告警测试 (50 ms)... ");
    for (uint32_t tick = 101; tick <= 150; ++tick) {
        task_can_comm(tick);
        task_sensor_sampling(tick, true /* 注入异常 */);
        task_edge_inference(tick);

        if (tick % 5 == 0) {
            bool ok = wdt_poll_supervisor(&g_sys.wdt, tick, 10);
            assert(ok);
        }
    }
    assert(g_sys.anomaly_count == 50);
    assert(g_sys.frames_sent_alarm == 50); /* 每一帧异常均触发异步 CAN 0x050 告警 */
    assert(g_sys.system_status == 1);     /* 系统进入警报状态 */
    printf("PASS (Inferred: 50, Anomaly: 50, Alarms: 50, System Status: FAULT)\n");

    /* 阶段 3：故障自愈与恢复正常 (Tick 151 ~ 200) */
    printf("[Phase 3] 故障清除与平稳工况自愈测试 (50 ms)... ");
    for (uint32_t tick = 151; tick <= 200; ++tick) {
        task_can_comm(tick);
        task_sensor_sampling(tick, false /* 恢复正常 */);
        task_edge_inference(tick);

        if (tick % 5 == 0) {
            bool ok = wdt_poll_supervisor(&g_sys.wdt, tick, 10);
            assert(ok);
        }
    }
    assert(g_sys.normal_count == 150);
    assert(g_sys.anomaly_count == 50);
    assert(g_sys.system_status == 0); /* 恢复为健康态 */
    printf("PASS (Total Inferences: 200, Total Feeds: %u)\n", g_sys.wdt.total_feeds);

    printf("=== All Project 1 Integration Tests Passed ===\n");
    return 0;
}
