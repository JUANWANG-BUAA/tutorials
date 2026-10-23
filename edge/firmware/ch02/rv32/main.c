#include <stdint.h>

typedef struct __attribute__((packed)) {
    char tag[19];
    uint32_t num32;
    uint16_t num16;
    uint8_t num8;
    uint8_t tail;
} OddData;
_Static_assert(sizeof(OddData) == 27, "OddData 27 bytes");

OddData g_odd_data = {
    .tag = "EdgeRTOS-RelocTest",
    .num32 = 0xA1B2C3D4,
    .num16 = 0x5E6F,
    .num8  = 0x77,
    .tail  = 0x99
};

typedef struct __attribute__((packed)) {
    uint8_t zero_buffer[31];
} OddBss;
_Static_assert(sizeof(OddBss) == 31, "OddBss 31 bytes");

OddBss g_odd_bss;

__attribute__((noreturn)) void finish(unsigned code) {
    const char *s = code ? "RV32 CRT0 FAIL\n" : "RV32 CRT0 PASS: gp/sp initialized, .data verified, .bss zeroed\n";
    while (*s) *(volatile unsigned char *)0x10000000 = (unsigned char)*s++;
    *(volatile uint32_t *)0x100000 = code ? 0x13333 : 0x5555;
    for (;;) {}
}

int main(void) {
    if (g_odd_data.num32 != 0xA1B2C3D4 || g_odd_data.num16 != 0x5E6F ||
        g_odd_data.num8 != 0x77 || g_odd_data.tail != 0x99) {
        finish(1);
    }
    for (unsigned i = 0; i < 19; ++i) {
        if (g_odd_data.tag[i] != "EdgeRTOS-RelocTest"[i]) finish(1);
    }

    for (unsigned i = 0; i < 31; ++i) {
        if (g_odd_bss.zero_buffer[i] != 0) finish(1);
    }

    finish(0);
}
