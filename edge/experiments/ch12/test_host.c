#include "ota.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

static uint8_t a[509], b[701];
static void init_data(void) {
    uint32_t x = 0x12345678;
    for (size_t i = 0; i < sizeof a; ++i) { x = x * 1664525u + 1013904223u; a[i] = (uint8_t)(x >> 24); }
    for (size_t i = 0; i < sizeof b; ++i) { x = x * 1664525u + 1013904223u; b[i] = (uint8_t)(x >> 24); }
}
static void stage_b(Nor *n) {
    assert(ota_stage(n, 1, b, sizeof b, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_OK);
}
static void put32(uint8_t *p, uint32_t v) {
    for (unsigned k = 0; k < 4; ++k) p[k] = (uint8_t)(v >> (8 * k));
}
static void boundaries(void) {
    Nor n, before; OtaBoot boot; OtaMeta m;
    assert(ota_factory(&n, a, sizeof a) == OTA_OK);
    const uint8_t zero[4] = {0}, ones[4] = {255,255,255,255};
    assert(nor_program(&n, 0, zero) == OTA_OK);
    assert(nor_program(&n, 0, ones) == OTA_BITS);
    assert(nor_program(&n, UINT32_MAX, zero) == OTA_RANGE);
    assert(nor_program(&n, 4094, zero) == OTA_RANGE);
    assert(nor_erase(&n, 1) == OTA_RANGE);
    assert(nor_erase(&n, UINT32_MAX) == OTA_RANGE);
    before = n;
    assert(ota_stage(&n, 1, b, UINT32_MAX, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_RANGE);
    assert(ota_stage(&n, 1, b, sizeof b, 2, 0, OTA_FEATURE_ABI, 2) == OTA_INVALID);
    assert(ota_stage(&n, 1, b, sizeof b, 2, OTA_BOARD_ID, 8, 2) == OTA_INVALID);
    assert(ota_stage(&n, 0, b, sizeof b, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_STATE);
    assert(memcmp(n.bytes, before.bytes, NOR_BYTES) == 0);
    stage_b(&n);
    uint32_t base = ota_slot_offset(1);
    for (size_t k = 0; k < sizeof b; ++k) {
        n.bytes[base + OTA_HEADER_BYTES + k] ^= 1;
        assert(!ota_validate(&n, 1, NULL));
        n.bytes[base + OTA_HEADER_BYTES + k] ^= 1;
    }
    /* A consistent CRC cannot excuse an out-of-range declared size. */
    put32(n.bytes + base + 8, UINT32_MAX);
    put32(n.bytes + base + 28, ota_crc32(n.bytes + base, 28));
    assert(!ota_validate(&n, 1, NULL));
    assert(ota_request(&n, 1) == OTA_INVALID);
    stage_b(&n);
    assert(ota_request(&n, 1) == OTA_OK);
    assert(ota_stage(&n, 1, b, sizeof b, 3, OTA_BOARD_ID, OTA_FEATURE_ABI, 3) == OTA_STATE);
    assert(ota_boot(&n, &boot) == OTA_OK && boot.slot == 1);
    OtaBoot stale = boot; --stale.receipt;
    assert(ota_confirm(&n, &stale) == OTA_STALE);
    assert(ota_confirm(&n, &boot) == OTA_OK);
    assert(ota_confirm(&n, &boot) == OTA_STALE);
    assert(ota_read_meta(&n, &m) && m.floor == 2);
    before = n;
    assert(ota_stage(&n, 0, a, sizeof a, 1, OTA_BOARD_ID, OTA_FEATURE_ABI, 1) == OTA_INVALID);
    assert(memcmp(n.bytes, before.bytes, NOR_BYTES) == 0);
    assert(ota_factory(&n, a, sizeof a) == OTA_OK);
    /* Body+CRC without a complete commit must NOT be accepted. */
    memset(n.bytes + OTA_META0 + 28, 0xff, 4);
    assert(!ota_read_meta(&n, &m));
    assert(ota_boot(&n, &boot) == OTA_STATE && boot.slot == OTA_NONE);
    assert(ota_factory(&n, a, sizeof a) == OTA_OK);
    put32(n.bytes + OTA_META0 + 4, UINT32_MAX);
    put32(n.bytes + OTA_META0 + 24, ota_crc32(n.bytes + OTA_META0, 24));
    stage_b(&n);
    assert(ota_request(&n, 1) == OTA_STATE); /* no generation rollover */
    puts("MODEL PASS boundaries: alignment, 1->0, lengths, compatibility, 701 single-byte corruptions, stale confirmation, generation limit");
}
enum Phase { STAGE, REQUEST, TRIAL, CONFIRM, CANCEL };
static Nor setup(enum Phase phase, OtaBoot *receipt) {
    Nor n;
    assert(ota_factory(&n, a, sizeof a) == OTA_OK);
    if (phase != STAGE) stage_b(&n);
    if (phase >= TRIAL) assert(ota_request(&n, 1) == OTA_OK);
    if (phase >= CONFIRM) assert(ota_boot(&n, receipt) == OTA_OK && receipt->slot == 1);
    nor_restart(&n);
    return n;
}
static OtaStatus action(Nor *n, enum Phase p, OtaBoot *receipt) {
    switch (p) {
    case STAGE: return ota_stage(n, 1, b, sizeof b, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2);
    case REQUEST: return ota_request(n, 1);
    case TRIAL: return ota_boot(n, receipt);
    case CONFIRM: return ota_confirm(n, receipt);
    case CANCEL: return ota_cancel(n);
    }
    return OTA_INVALID;
}
static unsigned cuts(enum Phase phase) {
    OtaBoot initial_receipt = {0};
    Nor base = setup(phase, &initial_receipt), complete = base;
    OtaBoot receipt = initial_receipt;
    assert(action(&complete, phase, &receipt) == OTA_OK);
    uint32_t count = complete.operations;
    unsigned cases = 0;
    for (uint32_t at = 0; at < count; ++at) {
        for (unsigned tear = 0; tear < 3; ++tear) {
            Nor n = base; receipt = initial_receipt;
            nor_cut(&n, (int32_t)at, (uint8_t)tear);
            assert(action(&n, phase, &receipt) == OTA_CUT);
            assert(!n.powered);
            /* No bootloader or confirmed-image byte was touched. */
            assert(memcmp(n.bytes, base.bytes, 512 + OTA_SLOT_BYTES) == 0);
            nor_restart(&n); /* reconstruct ALL policy from persistent bytes */
            OtaMeta m;
            assert(ota_read_meta(&n, &m));
            assert(m.floor == 1 || (phase == CONFIRM && m.floor == 2));
            if (phase == CONFIRM)
                assert((m.confirmed == 1) == (m.floor == 2));
            OtaBoot first, second;
            assert(ota_boot(&n, &first) == OTA_OK);
            assert(first.slot < 2 && ota_validate(&n, first.slot, NULL));
            if (phase == STAGE || phase == CONFIRM || phase == CANCEL)
                assert(!first.trial);
            if (first.slot == 1) assert(memcmp(n.bytes + ota_slot_offset(1) + OTA_HEADER_BYTES, b, sizeof b) == 0);
            nor_restart(&n);
            assert(ota_boot(&n, &second) == OTA_OK);
            /* If it was trial B, the NEXT reset must revert without confirm. */
            assert(second.slot == m.confirmed && !second.trial);
            ++cases;
        }
    }
    const char *names[] = {"stage", "request", "trial-before-jump", "confirm+floor", "cancel"};
    printf("POWER-CUT PASS %-17s: %u mutation points x 3 tear modes = %u cases\n", names[phase], count, cases);
    return cases;
}
int main(void) {
    init_data();
    int self = ota_selftest();
    if (self) { fprintf(stderr, "OTA SELFTEST FAIL line=%d\n", self); return 1; }
    boundaries();
    unsigned total = 0;
    for (enum Phase p = STAGE; p <= CANCEL; p = (enum Phase)(p + 1)) total += cuts(p);
    printf("MODEL PASS total power-cut cases=%u; CRC != authentication; no physical flash exercised\n", total);
    return 0;
}
