/*
 * crt0_sim.c - Chapter 02 裸机 C 运行时初始化 (CRT0) 仿真与内存段重定位验证
 */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

/* 模拟链接脚本导出的符号边界 */
#define FLASH_SIZE 4096
#define SRAM_SIZE  4096

static uint8_t g_sim_flash[FLASH_SIZE];
static uint8_t g_sim_sram[SRAM_SIZE];

/* 模拟链接器符号 */
uint32_t _etext;      /* Flash 中代码段结束地址，亦即 .data 段的 LMA 起始 */
uint32_t _sdata;      /* SRAM 中 .data 段的 VMA 起始 */
uint32_t _edata;      /* SRAM 中 .data 段的 VMA 结束 */
uint32_t _sbss;       /* SRAM 中 .bss 段的 VMA 起始 */
uint32_t _ebss;       /* SRAM 中 .bss 段的 VMA 结束 */

/* 汇编 CRT0 的 C 语言等效实现 */
void crt0_memory_init(const uint8_t* lma_src, uint8_t* vma_data_start, 
                      uint8_t* vma_data_end, uint8_t* vma_bss_start, 
                      uint8_t* vma_bss_end) {
    /* 1. 搬运已初始化全局变量 (.data 段: LMA -> VMA) */
    uint32_t* src = (uint32_t*)lma_src;
    uint32_t* dst = (uint32_t*)vma_data_start;
    uint32_t* dst_end = (uint32_t*)vma_data_end;

    while (dst < dst_end) {
        *dst++ = *src++;
    }

    /* 2. 清零未初始化全局变量 (.bss 段: 全部写入 0) */
    uint32_t* bss = (uint32_t*)vma_bss_start;
    uint32_t* bss_end = (uint32_t*)vma_bss_end;

    while (bss < bss_end) {
        *bss++ = 0U;
    }
}

/* 测试数据结构 */
typedef struct {
    uint32_t counter;
    char name[16];
    uint32_t status;
} AppState;

void test_crt0_relocation(void) {
    /* 预设 Flash 中的 LMA 原始数据 */
    AppState initial_state = {
        .counter = 0x12345678,
        .name = "EdgeNode",
        .status = 0xAA55AA55
    };
    memcpy(&g_sim_flash[256], &initial_state, sizeof(AppState));

    /* 预设 SRAM 中充满未初始化的脏数据 0xFF */
    memset(g_sim_sram, 0xFF, SRAM_SIZE);

    /* 配置 VMA 布局：
     * .data: [0..sizeof(AppState)]
     * .bss:  [sizeof(AppState)..sizeof(AppState)+64]
     */
    uint8_t* vma_data = &g_sim_sram[0];
    uint8_t* vma_data_end = &g_sim_sram[sizeof(AppState)];
    uint8_t* vma_bss = vma_data_end;
    uint8_t* vma_bss_end = vma_bss + 64;

    printf("[EXP 2-1] 执行 CRT0 重定位与 BSS 清零...\n");
    crt0_memory_init(&g_sim_flash[256], vma_data, vma_data_end, vma_bss, vma_bss_end);

    /* 验证 .data 拷贝正确 */
    AppState* runtime_state = (AppState*)vma_data;
    assert(runtime_state->counter == 0x12345678);
    assert(strcmp(runtime_state->name, "EdgeNode") == 0);
    assert(runtime_state->status == 0xAA55AA55);
    printf("  [PASS] .data 变量从 LMA 完美拷贝至 VMA (0x%X, '%s')\n", 
           runtime_state->counter, runtime_state->name);

    /* 验证 .bss 全部清零 */
    for (int i = 0; i < 64; i++) {
        assert(vma_bss[i] == 0);
    }
    printf("  [PASS] .bss 区域 (64 字节) 全部完成 0 初始化\n");
}

int main(void) {
    printf("=== Edge Chapter 02 CRT0 & Linker Relocation Test ===\n");
    test_crt0_relocation();
    printf("=== All Chapter 02 Tests Passed ===\n");
    return 0;
}
