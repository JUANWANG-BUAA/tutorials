/* Explicit discrete models, NOT an emulated DMA/cache controller. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

enum Owner { FREE, DMA, READY, CPU };
typedef struct { enum Owner owner; unsigned generation; uint8_t bytes[256]; } Slot;
static Slot slots[2];
static bool arm(unsigned index) {
    if (slots[index].owner != FREE) return false;
    slots[index].owner = DMA;
    return true;
}
static void complete(unsigned index, uint8_t value) {
    assert(slots[index].owner == DMA);
    memset(slots[index].bytes, value, sizeof slots[index].bytes);
    ++slots[index].generation;
    slots[index].owner = READY;
}
static unsigned acquire(unsigned index) {
    assert(slots[index].owner == READY);
    slots[index].owner = CPU;
    return slots[index].generation;
}
static bool release(unsigned index, unsigned generation) {
    if (slots[index].owner != CPU || slots[index].generation != generation) return false;
    slots[index].owner = FREE;
    return true;
}
static void test_ownership(void) {
    assert(arm(0)); complete(0, 0x55);
    unsigned token = acquire(0);
    assert(arm(1)); complete(1, 0xa3);
    assert(!arm(0)); /* cannot overwrite CPU-owned data */
    assert(slots[0].bytes[0] == 0x55);
    assert(release(0, token));
    assert(arm(0)); complete(0, 0x22);
    unsigned newer = acquire(0);
    assert(newer != token && !release(0, token));
    assert(release(0, newer));
    puts("MODEL PASS DMA ownership: overwrite blocked, stale token rejected");
}
static void test_cache_boundary(void) {
    /* Two explicit arrays represent noncoherent CPU cache and DMA-visible RAM. */
    uint8_t cache[32] = {0}, ram[32] = {0};
    cache[0] = 0x55; /* CPU stores to write-back cache */
    assert(ram[0] == 0); /* a memory barrier alone does not copy this line */
    memcpy(ram, cache, sizeof ram); /* model clean */
    assert(ram[0] == 0x55);
    ram[0] = 0xa3; /* DMA writes RAM */
    assert(cache[0] == 0x55); /* CPU would read stale data */
    memcpy(cache, ram, sizeof cache); /* model invalidate plus refill */
    assert(cache[0] == 0xa3);
    /* Shared line corruption: an unrelated CPU byte dirties the same line. */
    ram[1] = 0x99;
    cache[2] = 0x77;
    memcpy(ram, cache, sizeof ram);
    assert(ram[1] != 0x99);
    puts("MODEL PASS cache: barrier != clean; shared-line writeback destroys DMA byte");
}
static void test_serial_overrun(void) {
    /* 3 Mbaud, 8N1, one tick=1/3 us: byte=10 ticks. Mask=400us=1200 ticks. */
    enum { FIFO = 16, MASK_TICKS = 1200, BYTE_TICKS = 10 };
    unsigned incoming = 0, stored = 0, lost = 0;
    for (unsigned t = BYTE_TICKS; t <= MASK_TICKS; t += BYTE_TICKS) {
        ++incoming;
        if (stored < FIFO) ++stored;
        else ++lost;
    }
    assert(incoming == 120 && stored == 16 && lost == 104);
    puts("MODEL PASS UART: 3Mbaud 8N1, 400us masked, 120 arrived/16 stored/104 lost");
}
typedef struct { unsigned cpol, cpha, sck, bits, value; } SpiReceiver;
static void observe_spi(SpiReceiver *r, unsigned new_sck, unsigned mosi) {
    if (new_sck == r->sck) return;
    bool leading = r->sck == r->cpol;
    r->sck = new_sck;
    if (leading == (r->cpha == 0)) {
        r->value = (r->value << 1) | mosi;
        ++r->bits;
    }
}
static void test_spi_modes(void) {
    FILE *f = fopen(".build/ch05/spi.vcd", "w");
    assert(f);
    fputs("$timescale 1 ns $end\n$scope module spi $end\n$var wire 1 c sck $end\n$var wire 1 d mosi $end\n$upscope $end\n$enddefinitions $end\n", f);
    unsigned time = 0;
    for (unsigned mode = 0; mode < 4; ++mode) {
        unsigned cpol = mode >> 1, cpha = mode & 1;
        unsigned tx = 0x96, mosi = 0;
        SpiReceiver receiver = {.cpol=cpol, .cpha=cpha, .sck=cpol};
        fprintf(f, "#%u\n%uc\n", time, cpol);
        for (int bit = 7; bit >= 0; --bit) {
            unsigned data = (tx >> bit) & 1u;
            if (!cpha) {
                mosi = data;
                fprintf(f, "#%u\n%ud\n", time + 5, mosi);
            }
            if (cpha) mosi = data;
            fprintf(f, "#%u\n%uc\n%ud\n", time + 10, cpol ^ 1u, mosi);
            observe_spi(&receiver, cpol ^ 1u, mosi);
            fprintf(f, "#%u\n%uc\n", time + 20, cpol);
            observe_spi(&receiver, cpol, mosi);
            time += 20;
        }
        assert(receiver.bits == 8 && receiver.value == tx);
        time += 100;
    }
    assert(fclose(f) == 0);
    puts("MODEL PASS SPI: four CPOL/CPHA modes, 0x96 loopback, VCD generated");
}
static void test_i2c_arbitration(void) {
    unsigned a = 0xa0, b = 0xc0; /* addresses 0x50/0x60, write direction */
    bool b_active = true;
    int lost_bit = -1;
    for (int bit = 7; bit >= 0; --bit) {
        unsigned drive_a = (a >> bit) & 1u;
        unsigned drive_b = b_active ? ((b >> bit) & 1u) : 1u;
        unsigned sda = drive_a & drive_b; /* open-drain wired AND */
        if (b_active && drive_b && !sda) { b_active = false; lost_bit = bit; }
        assert(!drive_a || sda); /* A wins in this example */
    }
    assert(lost_bit == 6 && !b_active);
    unsigned pulses = 0;
    bool sda_stuck_low = true;
    while (sda_stuck_low && pulses < 9) ++pulses;
    assert(pulses == 9 && sda_stuck_low); /* recovery is bounded, not guaranteed */
    puts("MODEL PASS I2C: 0x60 loses at bit6; stuck-SDA recovery exits after 9 clocks");
}
int main(void) {
    test_ownership(); test_cache_boundary(); test_serial_overrun();
    test_spi_modes(); test_i2c_arbitration();
    return 0;
}
