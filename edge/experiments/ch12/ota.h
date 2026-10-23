#ifndef EDGE_OTA_H
#define EDGE_OTA_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Deliberately small NOR model, NOT the LM3S6965 flash geometry. */
enum { NOR_BYTES = 4096, NOR_PAGE = 256, OTA_SLOT_BYTES = 1024,
       OTA_HEADER_BYTES = 128, OTA_PAYLOAD_MAX = 896,
       OTA_META0 = 2560, OTA_META1 = 2816, OTA_NONE = 2 };
#define OTA_BOARD_ID UINT32_C(0x45444745)
#define OTA_FEATURE_ABI UINT32_C(7)
#define OTA_IMAGE_MAGIC UINT32_C(0x45494d47)
#define OTA_META_MAGIC UINT32_C(0x454d4554)

typedef enum { OTA_OK, OTA_CUT, OTA_RANGE, OTA_BITS, OTA_STATE,
               OTA_INVALID, OTA_NO_IMAGE, OTA_STALE } OtaStatus;
typedef struct {
    uint8_t bytes[NOR_BYTES];
    int32_t cut_after;  /* -1: disabled; 0: cut at next 4-byte mutation */
    uint32_t operations;
    uint8_t tear;       /* 0/1/2: apply 0/2/4 bytes, then lose power */
    bool powered;
} Nor;
typedef struct {
    uint32_t generation, confirmed, candidate, trial_used, floor;
    uint32_t page;
} OtaMeta;
typedef struct {
    uint32_t version, bytes, board, feature_abi, model_version, payload_crc;
} OtaImage;
typedef struct { uint32_t slot, receipt; bool trial; } OtaBoot;

void nor_init(Nor *n);
void nor_restart(Nor *n);
void nor_cut(Nor *n, int32_t after, uint8_t tear);
OtaStatus nor_program(Nor *n, uint32_t offset, const uint8_t word[4]);
OtaStatus nor_erase(Nor *n, uint32_t page);
uint32_t ota_crc32(const uint8_t *p, size_t size);
uint32_t ota_slot_offset(uint32_t slot);
bool ota_read_meta(const Nor *n, OtaMeta *m);
bool ota_validate(const Nor *n, uint32_t slot, OtaImage *image);
/* Factory provisioning is destructive; never call it as boot recovery. */
OtaStatus ota_factory(Nor *n, const uint8_t *payload, uint32_t size);
/* This model checks CRC/compatibility, NOT signatures or authorization. */
OtaStatus ota_stage(Nor *n, uint32_t slot, const uint8_t *payload,
                    uint32_t size, uint32_t version, uint32_t board,
                    uint32_t feature_abi, uint32_t model_version);
OtaStatus ota_request(Nor *n, uint32_t slot);
OtaStatus ota_boot(Nor *n, OtaBoot *boot);
OtaStatus ota_confirm(Nor *n, const OtaBoot *running);
OtaStatus ota_cancel(Nor *n);
int ota_selftest(void);
#endif
