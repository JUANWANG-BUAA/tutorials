#include "can_core.h"

static bool valid(const CanFrame *f) {
    return f && f->dlc <= 8 && f->id <= (f->extended ? 0x1fffffffu : 0x7ffu);
}
static void append(CanBits *b, unsigned value, unsigned width) {
    for (unsigned i = width; i > 0; --i)
        b->bit[b->count++] = (uint8_t)((value >> (i - 1)) & 1u);
}
static unsigned take(const uint8_t *bits, size_t *position, unsigned width) {
    unsigned value = 0;
    for (unsigned i = 0; i < width; ++i) value = (value << 1) | bits[(*position)++];
    return value;
}
uint16_t can_crc15_bits(const uint8_t *bits, size_t count) {
    uint16_t crc = 0;
    for (size_t i = 0; i < count; ++i) {
        unsigned feedback = ((crc >> 14) & 1u) ^ bits[i];
        crc = (uint16_t)((crc << 1) & 0x7fffu);
        if (feedback) crc ^= 0x4599u;
    }
    return crc;
}
CanResult can_encode_standard(const CanFrame *f, bool ack, CanBits *wire) {
    if (!wire || !valid(f) || f->extended) return CAN_ARGUMENT;
    CanBits raw = {{0}, 0};
    append(&raw, 0, 1); append(&raw, f->id, 11);
    append(&raw, f->rtr, 1); append(&raw, 0, 2); /* IDE, r0 */
    append(&raw, f->dlc, 4);
    if (!f->rtr) for (unsigned i = 0; i < f->dlc; ++i) append(&raw, f->data[i], 8);
    unsigned crc = can_crc15_bits(raw.bit, raw.count);
    append(&raw, crc, 15);
    wire->count = 0;
    unsigned run = 0, last = 2;
    for (size_t i = 0; i < raw.count; ++i) {
        unsigned bit = raw.bit[i];
        append(wire, bit, 1);
        run = bit == last ? run + 1 : 1;
        last = bit;
        if (run == 5) { last ^= 1u; append(wire, last, 1); run = 1; }
    }
    append(wire, 1, 1);         /* CRC delimiter */
    append(wire, ack ? 0 : 1, 1); /* resolved bus ACK slot, not a transmitter-only trace */
    append(wire, 0x7ffu, 11);   /* ACK delimiter + EOF 7 + intermission 3 */
    return CAN_OK;
}
CanResult can_decode_standard(const CanBits *wire, CanFrame *f, bool *ack) {
    if (!wire || !f || !ack || wire->count < 47 || wire->count > CAN_BIT_CAPACITY)
        return CAN_ARGUMENT;
    for (size_t i = 0; i < wire->count; ++i) if (wire->bit[i] > 1) return CAN_ARGUMENT;
    /* Caller supplies exactly one complete frame plus 3-bit intermission. */
    size_t dynamic_end = wire->count - 13;
    CanBits raw = {{0}, 0};
    unsigned last = 2, run = 0;
    for (size_t i = 0; i < dynamic_end; ++i) {
        unsigned bit = wire->bit[i];
        if (run == 5) {
            if (bit == last) return CAN_STUFF;
            last = bit; run = 1; /* stuffed bit participates in next run */
            continue;
        }
        append(&raw, bit, 1);
        run = bit == last ? run + 1 : 1;
        last = bit;
    }
    if (run == 5 || raw.count < 34) return CAN_STUFF;
    if (wire->bit[dynamic_end] != 1) return CAN_FORM;
    *ack = wire->bit[dynamic_end + 1] == 0;
    for (size_t i = dynamic_end + 2; i < wire->count; ++i)
        if (wire->bit[i] != 1) return CAN_FORM;
    size_t pos = 0;
    if (take(raw.bit, &pos, 1) != 0) return CAN_FORM;
    f->id = take(raw.bit, &pos, 11);
    f->rtr = take(raw.bit, &pos, 1) != 0;
    if (take(raw.bit, &pos, 2) != 0) return CAN_FORM; /* canonical IDE/r0 */
    f->extended = false;
    f->dlc = (uint8_t)take(raw.bit, &pos, 4);
    if (f->dlc > 8) return CAN_LENGTH; /* API deliberately accepts canonical DLC only */
    size_t expected = 34u + (f->rtr ? 0u : 8u * f->dlc);
    if (raw.count != expected) return CAN_LENGTH;
    for (unsigned i = 0; i < 8; ++i) f->data[i] = 0;
    if (!f->rtr) for (unsigned i = 0; i < f->dlc; ++i)
        f->data[i] = (uint8_t)take(raw.bit, &pos, 8);
    uint16_t calculated = can_crc15_bits(raw.bit, pos);
    if (take(raw.bit, &pos, 15) != calculated) return CAN_CRC;
    return CAN_OK;
}
static CanBits arbitration(const CanFrame *f) {
    CanBits b = {{0}, 0};
    if (f->extended) {
        append(&b, f->id >> 18, 11);
        append(&b, 3, 2); /* SRR=1 and IDE=1 */
        append(&b, f->id & 0x3ffffu, 18);
        append(&b, f->rtr, 1);
    } else {
        append(&b, f->id, 11);
        append(&b, f->rtr, 1);
        append(&b, 0, 1); /* IDE decides standard remote vs extended with same prefix */
    }
    return b;
}
int can_arbitrate(const CanFrame *a, const CanFrame *b) {
    CanBits aa = arbitration(a), bb = arbitration(b);
    size_t n = aa.count < bb.count ? aa.count : bb.count;
    for (size_t i = 0; i < n; ++i) {
        if (aa.bit[i] != bb.bit[i]) return aa.bit[i] ? 1 : -1;
    }
    return 0; /* identical arbitration field does not imply identical payload */
}
unsigned can_fd_length(unsigned dlc) {
    static const uint8_t lengths[16] = {0,1,2,3,4,5,6,7,8,12,16,20,24,32,48,64};
    return dlc < 16 ? lengths[dlc] : 0xffu;
}
CanResult can_pack_peli(const CanFrame *f, uint8_t record[13], size_t *length) {
    if (!record || !length || !valid(f)) return CAN_ARGUMENT;
    for (unsigned i = 0; i < 13; ++i) record[i] = 0;
    record[0] = (uint8_t)((f->extended ? 0x80u : 0) | (f->rtr ? 0x40u : 0) | f->dlc);
    unsigned start;
    if (f->extended) {
        record[1] = (uint8_t)(f->id >> 21);
        record[2] = (uint8_t)(f->id >> 13);
        record[3] = (uint8_t)(f->id >> 5);
        record[4] = (uint8_t)((f->id << 3) | (f->rtr ? 4u : 0));
        start = 5;
    } else {
        record[1] = (uint8_t)(f->id >> 3);
        record[2] = (uint8_t)((f->id << 5) | (f->rtr ? 0x10u : 0));
        start = 3;
    }
    if (!f->rtr) for (unsigned i = 0; i < f->dlc; ++i) record[start + i] = f->data[i];
    *length = start + (f->rtr ? 0u : f->dlc);
    return CAN_OK;
}
CanResult can_unpack_peli(const uint8_t record[13], CanFrame *f) {
    if (!record || !f) return CAN_ARGUMENT;
    f->extended = (record[0] & 0x80u) != 0;
    f->rtr = (record[0] & 0x40u) != 0;
    f->dlc = record[0] & 0x0fu;
    if (f->dlc > 8) return CAN_LENGTH;
    unsigned start;
    if (f->extended) {
        f->id = ((uint32_t)record[1] << 21) | ((uint32_t)record[2] << 13) |
                ((uint32_t)record[3] << 5) | (record[4] >> 3);
        start = 5;
    } else {
        f->id = ((uint32_t)record[1] << 3) | (record[2] >> 5);
        start = 3;
    }
    for (unsigned i = 0; i < 8; ++i) f->data[i] = 0;
    if (!f->rtr) for (unsigned i = 0; i < f->dlc; ++i) f->data[i] = record[start + i];
    return CAN_OK;
}
CanFaultState can_fault_state(const CanFault *f) {
    if (f->tec >= 256) return BUS_OFF;
    if (f->tec >= 128 || f->rec >= 128) return ERROR_PASSIVE;
    return ERROR_ACTIVE;
}
void can_fault_event(CanFault *f, CanFaultEvent e, bool flag_dominant) {
    if (can_fault_state(f) == BUS_OFF) return;
    switch (e) {
    case TX_ACK_MISSING:
        if (can_fault_state(f) == ERROR_PASSIVE && !flag_dominant) break;
        /* Otherwise the modeled transmitter error increments TEC by 8. */
        f->tec += 8; break;
    case TX_ERROR: f->tec += 8; break;
    case RX_ERROR: ++f->rec; break;
    case TX_SUCCESS: if (f->tec) --f->tec; break;
    case RX_SUCCESS:
        if (f->rec > 127) f->rec = 127; /* one permitted recovery value, not silicon's exact choice */
        else if (f->rec) --f->rec;
        break;
    }
}
void can_recovery_bit(CanFault *f, unsigned bit) {
    if (can_fault_state(f) != BUS_OFF || !f->recovery_requested) return;
    if (!bit) { f->recessive_run = 0; return; }
    if (++f->recessive_run == 11) {
        f->recessive_run = 0;
        if (++f->recovery_groups == 128) {
            f->tec = f->rec = f->recovery_groups = 0;
            f->recovery_requested = false;
        }
    }
}
