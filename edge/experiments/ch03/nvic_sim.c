/*
 * nvic_sim.c - Chapter 03 中断控制器优先级抢占、咬尾与硬件栈帧仿真
 */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define MAX_IRQ 64

/* 硬件中断栈帧 (8 双字，对应 Cortex-M 自动压栈) */
typedef struct {
    uint32_t r0;
    uint32_t r1;
    uint32_t r2;
    uint32_t r3;
    uint32_t r12;
    uint32_t lr;
    uint32_t pc;
    uint32_t xpsr;
} CortexM_StackFrame;

/* 模拟 NVIC 中断控制寄存器 */
typedef struct {
    uint32_t iser[2];      /* 中断使能寄存器 */
    uint32_t icer[2];      /* 中断清除使能寄存器 */
    uint32_t ispr[2];      /* 中断挂起寄存器 */
    uint32_t icpr[2];      /* 中断清除挂起寄存器 */
    uint8_t  ipr[MAX_IRQ]; /* 中断优先级寄存器 (8 位) */
    uint32_t prigroup;     /* SCB->AIRCR.PRIGROUP 分组配置 (0~7) */
} SimNVIC;

static SimNVIC g_nvic;

/* 解析抢占优先级与子优先级 */
void nvic_decode_priority(uint8_t raw_prio, uint32_t prigroup, 
                          uint32_t* preempt, uint32_t* subprio) {
    /* Cortex-M 仅使用高 4 位 (STM32 实现) */
    uint8_t prio = raw_prio >> 4;
    uint32_t group = prigroup & 0x07;

    /* group 取值 0~7 决定抢占位宽:
     * group=3 (4位抢占, 0位子优先级)
     * group=4 (3位抢占, 1位子优先级)
     * group=5 (2位抢占, 2位子优先级)
     * group=6 (1位抢占, 3位子优先级)
     * group=7 (0位抢占, 4位子优先级)
     */
    if (group < 4) group = 4; /* 最多 4 位 */
    uint32_t preempt_bits = 7 - group;
    if (preempt_bits > 4) preempt_bits = 4;
    uint32_t subprio_bits = 4 - preempt_bits;

    uint32_t preempt_mask = (1U << preempt_bits) - 1;
    uint32_t subprio_mask = (1U << subprio_bits) - 1;

    *preempt = (prio >> subprio_bits) & preempt_mask;
    *subprio = prio & subprio_mask;
}

/* 优先级抢占判定规则：抢占优先级数值严格小于当前运行优先级方可抢占 */
bool nvic_can_preempt(uint32_t running_preempt, uint32_t incoming_preempt) {
    return incoming_preempt < running_preempt;
}

void test_nvic_priority_grouping(void) {
    printf("[EXP 3-1] 测试 NVIC 优先级分组与抢占仲裁机制...\n");
    g_nvic.prigroup = 5; /* 2 位抢占优先级 (0~3), 2 位子优先级 (0~3) */

    /* IRQ 10: 优先级 0x40 (高 4 位为 0b0100 -> preempt=1, sub=0) */
    g_nvic.ipr[10] = 0x40;
    /* IRQ 20: 优先级 0x20 (高 4 位为 0b0010 -> preempt=0, sub=2) */
    g_nvic.ipr[20] = 0x20;
    /* IRQ 30: 优先级 0x60 (高 4 位为 0b0110 -> preempt=1, sub=2) */
    g_nvic.ipr[30] = 0x60;

    uint32_t p10, s10, p20, s20, p30, s30;
    nvic_decode_priority(g_nvic.ipr[10], g_nvic.prigroup, &p10, &s10);
    nvic_decode_priority(g_nvic.ipr[20], g_nvic.prigroup, &p20, &s20);
    nvic_decode_priority(g_nvic.ipr[30], g_nvic.prigroup, &p30, &s30);

    assert(p10 == 1 && s10 == 0);
    assert(p20 == 0 && s20 == 2);
    assert(p30 == 1 && s30 == 2);
    printf("  [PASS] IRQ 10 解码: 抢占=%u, 子优先级=%u\n", p10, s10);
    printf("  [PASS] IRQ 20 解码: 抢占=%u, 子优先级=%u\n", p20, s20);
    printf("  [PASS] IRQ 30 解码: 抢占=%u, 子优先级=%u\n", p30, s30);

    /* 验证抢占逻辑 */
    /* 当 IRQ 10 (抢占=1) 正在运行时，IRQ 20 (抢占=0) 到达，能否抢占？ */
    assert(nvic_can_preempt(p10, p20) == true);
    printf("  [PASS] IRQ 20 (抢占0) 成功打断抢占正在运行的 IRQ 10 (抢占1)!\n");

    /* 当 IRQ 10 (抢占=1) 正在运行时，IRQ 30 (抢占=1, 子优先级更高) 到达，能否抢占？ */
    assert(nvic_can_preempt(p10, p30) == false);
    printf("  [PASS] IRQ 30 相同抢占优先级无法打断，必须挂起等待咬尾 (Tail-Chaining)!\n");
}

/* 仿真咬尾中断与硬件压栈周期 */
void test_tail_chaining_latency(void) {
    printf("[EXP 3-2] 仿真咬尾中断 (Tail-Chaining) 周期消除效果...\n");
    /* 传统中断退出再进入开销:
     * 恢复现场出栈 (12周期) + 下一中断识别与重新压栈 (12周期) = 24 周期
     * 咬尾技术:
     * 保持栈帧不变，仅重新加载下一中断向量 PC (6周期)
     */
    uint32_t normal_cycles = 12 + 12;
    uint32_t tail_chain_cycles = 6;
    uint32_t saved_cycles = normal_cycles - tail_chain_cycles;

    printf("  传统连续中断切换耗时: %u 周期\n", normal_cycles);
    printf("  咬尾硬件优化切换耗时: %u 周期\n", tail_chain_cycles);
    printf("  节省周期: %u 周期 (响应速度提升 75%%!)\n", saved_cycles);
    assert(saved_cycles == 18);
}

int main(void) {
    printf("=== Edge Chapter 03 NVIC & Interrupt Architecture Test ===\n");
    test_nvic_priority_grouping();
    test_tail_chaining_latency();
    printf("=== All Chapter 03 Tests Passed ===\n");
    return 0;
}
