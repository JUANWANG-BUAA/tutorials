#include "ota.h"
#include <string.h>

static uint32_t get32(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static void put32(uint8_t *p, uint32_t v) {
    for (unsigned i = 0; i < 4; ++i) p[i] = (uint8_t)(v >> (8 * i));
}
uint32_t ota_crc32(const uint8_t *p, size_t size) {
    uint32_t c = UINT32_MAX;
    for (size_t i = 0; i < size; ++i) {
        c ^= p[i];
        for (unsigned k = 0; k < 8; ++k)
            c = (c >> 1) ^ ((0u - (c & 1u)) & UINT32_C(0xedb88320));
    }
    return ~c;
}
void nor_init(Nor *n) {
    memset(n->bytes, 0xff, sizeof n->bytes);
    nor_restart(n);
}
void nor_restart(Nor *n) {
    n->powered = true; n->cut_after = -1; n->tear = 0; n->operations = 0;
}
void nor_cut(Nor *n, int32_t after, uint8_t tear) {
    n->cut_after = after; n->tear = tear; n->operations = 0;
}
static OtaStatus mutate(Nor *n, uint32_t off, const uint8_t *word, bool erase) {
    if (!n->powered) return OTA_CUT;
    bool cut = n->cut_after == 0;
    unsigned count = cut ? (n->tear == 0 ? 0 : n->tear == 1 ? 2 : 4) : 4;
    for (unsigned i = 0; i < count; ++i)
        n->bytes[off + i] = erase ? 0xff : (uint8_t)(n->bytes[off + i] & word[i]);
    ++n->operations;
    if (cut) { n->powered = false; return OTA_CUT; }
    if (n->cut_after > 0) --n->cut_after;
    return OTA_OK;
}
OtaStatus nor_program(Nor *n, uint32_t off, const uint8_t word[4]) {
    if (off % 4 || off > NOR_BYTES - 4u || !word) return OTA_RANGE;
    if (!n->powered) return OTA_CUT;
    for (unsigned i = 0; i < 4; ++i)
        if ((n->bytes[off + i] & word[i]) != word[i]) return OTA_BITS;
    return mutate(n, off, word, false);
}
OtaStatus nor_erase(Nor *n, uint32_t page) {
    if (page % NOR_PAGE || page > NOR_BYTES - NOR_PAGE) return OTA_RANGE;
    for (uint32_t k = 0; k < NOR_PAGE; k += 4) {
        OtaStatus s = mutate(n, page + k, NULL, true);
        if (s != OTA_OK) return s;
    }
    return OTA_OK;
}
uint32_t ota_slot_offset(uint32_t slot) {
    return slot < 2 ? 512u + slot * OTA_SLOT_BYTES : UINT32_MAX;
}
static bool decode_meta(const Nor *n, uint32_t page, OtaMeta *m) {
    const uint8_t *p = n->bytes + page;
    if (get32(p + 28) != 0) return false; /* COMMIT REQUIRED */
    if (get32(p) != OTA_META_MAGIC || get32(p + 24) != ota_crc32(p, 24))
        return false;
    m->generation = get32(p + 4); m->confirmed = get32(p + 8);
    m->candidate = get32(p + 12); m->trial_used = get32(p + 16);
    m->floor = get32(p + 20); m->page = page;
    return m->generation != 0 && m->confirmed < 2 && m->candidate <= OTA_NONE &&
           m->candidate != m->confirmed && m->trial_used <= 1 && m->floor != 0 &&
           (m->candidate != OTA_NONE || m->trial_used == 0);
}
bool ota_read_meta(const Nor *n, OtaMeta *m) {
    OtaMeta a, b;
    bool va = decode_meta(n, OTA_META0, &a), vb = decode_meta(n, OTA_META1, &b);
    if (!va && !vb) return false;
    if (va && vb && a.generation == b.generation &&
        memcmp(n->bytes + OTA_META0, n->bytes + OTA_META1, 32) != 0) return false;
    *m = !vb || (va && a.generation >= b.generation) ? a : b;
    return true;
}
static OtaStatus commit_meta(Nor *n, OtaMeta m, bool first) {
    uint8_t raw[32];
    if (m.generation == UINT32_MAX) return OTA_STATE; /* never wrap */
    uint32_t dst = first ? OTA_META0 : m.page == OTA_META0 ? OTA_META1 : OTA_META0;
    memset(raw, 0xff, sizeof raw);
    put32(raw, OTA_META_MAGIC); put32(raw + 4, m.generation + 1);
    put32(raw + 8, m.confirmed); put32(raw + 12, m.candidate);
    put32(raw + 16, m.trial_used); put32(raw + 20, m.floor);
    put32(raw + 24, ota_crc32(raw, 24));
    OtaStatus s = nor_erase(n, dst);
    if (s != OTA_OK) return s;
    for (unsigned k = 0; k < 28; k += 4) {
        s = nor_program(n, dst + k, raw + k);
        if (s != OTA_OK) return s;
    }
    if (memcmp(n->bytes + dst, raw, 28) != 0) return OTA_INVALID;
    put32(raw + 28, 0); /* publish only after body and CRC read back */
    return nor_program(n, dst + 28, raw + 28);
}
bool ota_validate(const Nor *n, uint32_t slot, OtaImage *image) {
    if (slot >= 2) return false;
    const uint8_t *p = n->bytes + ota_slot_offset(slot);
    OtaImage x = { get32(p + 4), get32(p + 8), get32(p + 12),
                   get32(p + 16), get32(p + 20), get32(p + 24) };
    if (get32(p) != OTA_IMAGE_MAGIC || x.bytes == 0 || x.bytes > OTA_PAYLOAD_MAX ||
        x.version == 0 || x.board != OTA_BOARD_ID || x.feature_abi != OTA_FEATURE_ABI ||
        x.model_version == 0 || get32(p + 28) != ota_crc32(p, 28) ||
        x.payload_crc != ota_crc32(p + OTA_HEADER_BYTES, x.bytes)) return false;
    if (image) *image = x;
    return true;
}
static OtaStatus write_image(Nor *n, uint32_t slot, const uint8_t *payload,
                             uint32_t size, uint32_t version, uint32_t model) {
    uint32_t base = ota_slot_offset(slot);
    for (uint32_t p = 0; p < OTA_SLOT_BYTES; p += NOR_PAGE) {
        OtaStatus s = nor_erase(n, base + p);
        if (s != OTA_OK) return s;
    }
    for (uint32_t k = 0; k < size; k += 4) {
        uint8_t word[4] = {255, 255, 255, 255};
        for (unsigned j = 0; j < 4 && k + j < size; ++j) word[j] = payload[k + j];
        OtaStatus s = nor_program(n, base + OTA_HEADER_BYTES + k, word);
        if (s != OTA_OK) return s;
    }
    uint8_t h[32];
    put32(h, OTA_IMAGE_MAGIC); put32(h + 4, version); put32(h + 8, size);
    put32(h + 12, OTA_BOARD_ID); put32(h + 16, OTA_FEATURE_ABI);
    put32(h + 20, model); put32(h + 24, ota_crc32(payload, size));
    put32(h + 28, ota_crc32(h, 28));
    for (unsigned k = 0; k < 32; k += 4) {
        OtaStatus s = nor_program(n, base + k, h + k);
        if (s != OTA_OK) return s;
    }
    return ota_validate(n, slot, NULL) ? OTA_OK : OTA_INVALID;
}
OtaStatus ota_factory(Nor *n, const uint8_t *payload, uint32_t size) {
    if (!payload || size == 0 || size > OTA_PAYLOAD_MAX) return OTA_RANGE;
    nor_init(n);
    OtaStatus s = write_image(n, 0, payload, size, 1, 1);
    if (s != OTA_OK) return s;
    OtaMeta m = {0, 0, OTA_NONE, 0, 1, OTA_META1};
    return commit_meta(n, m, true);
}
OtaStatus ota_stage(Nor *n, uint32_t slot, const uint8_t *payload,
                    uint32_t size, uint32_t version, uint32_t board,
                    uint32_t feature, uint32_t model) {
    OtaMeta m;
    if (slot >= 2 || !payload || size == 0 || size > OTA_PAYLOAD_MAX) return OTA_RANGE;
    if (!ota_read_meta(n, &m)) return OTA_STATE;
    if (slot == m.confirmed || m.candidate != OTA_NONE) return OTA_STATE;
    if (board != OTA_BOARD_ID || feature != OTA_FEATURE_ABI || !model || version < m.floor)
        return OTA_INVALID;
    return write_image(n, slot, payload, size, version, model);
}
OtaStatus ota_request(Nor *n, uint32_t slot) {
    OtaMeta m; OtaImage c, p;
    if (!ota_read_meta(n, &m) || m.candidate != OTA_NONE || slot == m.confirmed)
        return OTA_STATE;
    if (!ota_validate(n, m.confirmed, &c) || !ota_validate(n, slot, &p) ||
        p.version <= c.version || p.version < m.floor) return OTA_INVALID;
    m.candidate = slot; m.trial_used = 0;
    return commit_meta(n, m, false);
}
OtaStatus ota_boot(Nor *n, OtaBoot *boot) {
    OtaMeta m; OtaImage c, p;
    *boot = (OtaBoot){OTA_NONE, 0, false};
    if (!ota_read_meta(n, &m)) return OTA_STATE;
    if (!ota_validate(n, m.confirmed, &c) || c.version < m.floor) return OTA_NO_IMAGE;
    if (m.candidate < 2 && m.trial_used == 0 && ota_validate(n, m.candidate, &p) &&
        p.version > c.version && p.version >= m.floor) {
        m.trial_used = 1;
        OtaStatus s = commit_meta(n, m, false); /* PERSIST BEFORE JUMP */
        if (s != OTA_OK) return s;
        *boot = (OtaBoot){m.candidate, m.generation + 1, true};
    } else {
        *boot = (OtaBoot){m.confirmed, m.generation, false};
    }
    return OTA_OK;
}
OtaStatus ota_confirm(Nor *n, const OtaBoot *running) {
    OtaMeta m; OtaImage p;
    if (!ota_read_meta(n, &m)) return OTA_STATE;
    if (!running || !running->trial || running->slot != m.candidate ||
        m.candidate >= 2 || m.trial_used != 1 || running->receipt != m.generation)
        return OTA_STALE;
    if (!ota_validate(n, m.candidate, &p) || p.version < m.floor) return OTA_INVALID;
    m.confirmed = m.candidate; m.candidate = OTA_NONE; m.trial_used = 0;
    m.floor = p.version; /* confirmation and software floor in ONE record */
    return commit_meta(n, m, false);
}
OtaStatus ota_cancel(Nor *n) {
    OtaMeta m;
    if (!ota_read_meta(n, &m) || m.candidate == OTA_NONE) return OTA_STATE;
    m.candidate = OTA_NONE; m.trial_used = 0;
    return commit_meta(n, m, false);
}
