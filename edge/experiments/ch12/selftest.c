#include "ota.h"
#define CHECK(c) do { if (!(c)) return __LINE__; } while (0)
int ota_selftest(void) {
    Nor n; OtaBoot b; OtaMeta m;
    const uint8_t old[] = {1, 2, 3, 4, 5};
    const uint8_t newer[] = {9, 8, 7, 6, 5, 4, 3};
    CHECK(ota_crc32((const uint8_t *)"123456789", 9) == UINT32_C(0xcbf43926));
    CHECK(ota_factory(&n, old, sizeof old) == OTA_OK);
    CHECK(ota_stage(&n, 0, newer, sizeof newer, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_STATE);
    CHECK(ota_stage(&n, 1, newer, sizeof newer, 2, OTA_BOARD_ID, OTA_FEATURE_ABI, 2) == OTA_OK);
    CHECK(ota_request(&n, 1) == OTA_OK);
    CHECK(ota_boot(&n, &b) == OTA_OK && b.slot == 1 && b.trial);
    OtaBoot trial = b;
    nor_restart(&n);
    CHECK(ota_boot(&n, &b) == OTA_OK && b.slot == 0 && !b.trial);
    CHECK(ota_cancel(&n) == OTA_OK);
    CHECK(ota_confirm(&n, &trial) == OTA_STALE);
    CHECK(ota_request(&n, 1) == OTA_OK);
    CHECK(ota_boot(&n, &b) == OTA_OK && b.slot == 1);
    CHECK(ota_confirm(&n, &b) == OTA_OK);
    nor_restart(&n);
    CHECK(ota_boot(&n, &b) == OTA_OK && b.slot == 1 && !b.trial);
    CHECK(ota_read_meta(&n, &m) && m.floor == 2);
    CHECK(ota_stage(&n, 0, old, sizeof old, 1, OTA_BOARD_ID, OTA_FEATURE_ABI, 1) == OTA_INVALID);
    return 0;
}
