#include <stdint.h>
#include <stdbool.h>

/* Exact 27 bytes of initialized data (odd length, tests non-word-multiple LMA copy) */
typedef struct __attribute__((packed)) {
    char tag[19];
    uint32_t num32;
    uint16_t num16;
    uint8_t num8;
    uint8_t tail;
} OddData;
_Static_assert(sizeof(OddData) == 27, "OddData must be 27 bytes");

OddData g_odd_data = {
    .tag = "EdgeRTOS-RelocTest",
    .num32 = 0xA1B2C3D4,
    .num16 = 0x5E6F,
    .num8  = 0x77,
    .tail  = 0x99
};

/* Exact 31 bytes of uninitialized BSS */
typedef struct __attribute__((packed)) {
    uint8_t zero_buffer[31];
} OddBss;
_Static_assert(sizeof(OddBss) == 31, "OddBss must be 31 bytes");

OddBss g_odd_bss;

static void puts_host(const char *s) {
    register uint32_t r0 __asm__("r0") = 4;
    register const char *r1 __asm__("r1") = s;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
}

__attribute__((noreturn)) void finish(uint32_t code) {
    puts_host(code ? "ARM CRT0 FAIL\n" : "ARM CRT0 PASS: .data LMA->VMA copy, odd tail bytes, .bss zeroed\n");
    uint32_t block[2] = {0x20026, code};
    register uint32_t r0 __asm__("r0") = 0x20;
    register uint32_t *r1 __asm__("r1") = block;
    __asm__ volatile("bkpt 0xab" : "+r"(r0) : "r"(r1) : "memory");
    for (;;) {}
}

void fault(void) { finish(1); }

int main(void) {
    /* 1. Verify .data relocation */
    if (g_odd_data.num32 != 0xA1B2C3D4 || g_odd_data.num16 != 0x5E6F ||
        g_odd_data.num8 != 0x77 || g_odd_data.tail != 0x99) {
        finish(1);
    }
    for (unsigned i = 0; i < 19; ++i) {
        if (g_odd_data.tag[i] != "EdgeRTOS-RelocTest"[i]) finish(1);
    }

    /* 2. Verify .bss was zeroed */
    for (unsigned i = 0; i < 31; ++i) {
        if (g_odd_bss.zero_buffer[i] != 0) finish(1);
    }

    finish(0);
}
