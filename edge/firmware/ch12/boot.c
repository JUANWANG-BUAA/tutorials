#include "ota.h"
#include "platform.h"
#ifndef OTA_BOOT_MODE
#define OTA_BOOT_MODE 1
#endif
static Nor model;
#ifdef __arm__
#define BASE_A 0x10000u
#define BASE_B 0x20000u
#define APP_STACK 0x2000e000u
#else
#define BASE_A 0x80200000u
#define BASE_B 0x80300000u
#define APP_STACK 0x80410000u
#endif
#define REG(a) (*(volatile uint32_t *)(uintptr_t)(a))
#define REQUIRE(c) do { if (!(c)) platform_exit(1); } while (0)
int main(void) {
    REQUIRE(ota_selftest() == 0);
    REQUIRE(ota_factory(&model, (const uint8_t *)BASE_A, OTA_PAYLOAD_MAX) == OTA_OK);
    REQUIRE(ota_stage(&model, 1, (const uint8_t *)BASE_B, OTA_PAYLOAD_MAX, 2,
                      OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_OK);
    if (OTA_BOOT_MODE != 0) REQUIRE(ota_request(&model, 1) == OTA_OK);
    OtaBoot boot;
    if (OTA_BOOT_MODE == 2) {
        REQUIRE(ota_boot(&model, &boot) == OTA_OK && boot.slot == 1 && boot.trial);
        nor_restart(&model); /* SOFTWARE reset of policy; not a machine reset */
    }
    REQUIRE(ota_boot(&model, &boot) == OTA_OK);
    REQUIRE(boot.slot == (OTA_BOOT_MODE == 1 ? 1u : 0u));
    uint32_t base = boot.slot == 0 ? BASE_A : BASE_B;
    OtaImage image;
    REQUIRE(ota_validate(&model, boot.slot, &image));
    REQUIRE(ota_crc32((const uint8_t *)(uintptr_t)base, image.bytes) == image.payload_crc);
#ifdef __arm__
    uint32_t ipsr, control;
    __asm__ volatile("mrs %0, ipsr" : "=r"(ipsr));
    __asm__ volatile("mrs %0, control" : "=r"(control));
    REQUIRE(ipsr == 0 && control == 0); /* privileged Thread/MSP only */
    REQUIRE((base & 127u) == 0 && REG(base) == APP_STACK);
    uint32_t reset = REG(base + 4);
    REQUIRE((reset & 1) && (reset & ~1u) >= base && (reset & ~1u) < base + image.bytes);
    /* Seed stale producer state; the app checks that handoff cleared it. */
    REG(0xe000e100) = 1; REG(0xe000e200) = 1;
    REG(0xe000e014) = 0x00ffffff; REG(0xe000e010) = 3;
    platform_puts("ARM OTA SELECT: policy ready; real vector/MSP handoff follows\n");
    handoff(base, APP_STACK);
#else
    /* Deassert this platform's local timer/software interrupt sources. */
    REG(0x02004000) = UINT32_MAX; REG(0x02004004) = UINT32_MAX;
    REG(0x02000000) = 0;
    platform_puts("RV32 OTA SELECT: policy ready; real gp/sp/mtvec handoff follows\n");
    handoff(base, APP_STACK);
#endif
}
