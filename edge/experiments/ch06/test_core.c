#include "can_core.h"
#include <assert.h>
#include <stdio.h>
int main(int argc, char **argv) {
    (void)argv;
    int result = can_core_selftest();
    if (result) { fprintf(stderr, "CAN CORE FAIL at selftest line %d\n", result); return 1; }
    CanFrame frame = {.id=0x123, .dlc=8, .data={0,0,0xff,0xff,0x55,0xaa,0,0}};
    CanBits wire;
    assert(can_encode_standard(&frame, true, &wire) == CAN_OK);
    if (argc > 1) {
        for (size_t i = 0; i < wire.count; ++i) putchar('0' + wire.bit[i]);
        putchar('\n'); return 0;
    }
    puts("MODEL PASS CAN CRC-15: check(123456789)=0x059e");
    puts("MODEL PASS classic wire: 1000 seeded roundtrips and every single-bit dynamic-region mutation rejected");
    puts("MODEL PASS arbitration: ID order, data/RTR, standard-remote/extended IDE tie-break");
    puts("MODEL PASS FD DLC: 16 entries; FD wire encoder intentionally not part of this API");
    puts("MODEL PASS confinement: 127/128/255/256, passive ACK exception, REC-only no Bus-Off");
    puts("MODEL PASS recovery: software request plus 128 groups of 11 recessive bits");
    unsigned bitrate = 16000000u / (2u * (0u + 1u) * (1u + 13u + 2u));
    assert(bitrate == 500000);
    printf("MODEL timing: SJA 16MHz BTR0=0x00 BTR1=0x1c -> %u bit/s, sample=87.5%%\n", bitrate);
    printf("MODEL frame: %zu bits including stuffing/intermission, at 500k -> %zu us\n", wire.count, 2*wire.count);
    /* Waiting-time recurrence for nonpreemptive CAN arbitration; all units us.
     * One lower-priority blocker B=270, one higher-priority frame C=270/T=500.
     * Include one bit time (2us) at the arbitration boundary. */
    unsigned wait = 270;
    for (unsigned i = 0; i < 10; ++i) {
        unsigned next = 270 + ((wait + 2 + 499) / 500) * 270;
        if (next == wait) break;
        wait = next;
    }
    assert(wait == 810 && wait + 270 > 1000);
    puts("MODEL deadline: nonpreemptive wait=810us + frame=270us -> 1080us, misses 1000us");
    FILE *f = fopen(".build/ch06/can-wire.vcd", "w");
    assert(f);
    fputs("$timescale 1 ns $end\n$scope module can $end\n$var wire 1 b bus $end\n$upscope $end\n$enddefinitions $end\n", f);
    for (size_t i = 0; i < wire.count; ++i) fprintf(f, "#%zu\n%ub\n", i*2000u, wire.bit[i]);
    fprintf(f, "#%zu\n", wire.count*2000u);
    assert(fclose(f) == 0);
    return 0;
}
