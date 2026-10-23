#include "sja_driver.h"

CanResult sja_initialize(SjaBus bus, uint8_t btr0, uint8_t btr1) {
    if (!bus.read || !bus.write) return CAN_ARGUMENT;
    bus.write(bus.context, SJA_MOD, 1); /* reset request */
    unsigned tries;
    for (tries = 0; tries < 64; ++tries)
        if (bus.read(bus.context, SJA_MOD) & 1u) break;
    if (tries == 64) return CAN_TIMEOUT; /* transaction budget, not 64 us */
    bus.write(bus.context, SJA_CDR, bus.read(bus.context, SJA_CDR) | 0x80u);
    bus.write(bus.context, SJA_IER, 0); /* board layer enables sources only after attaching its ISR */
    bus.write(bus.context, SJA_MOD, 9); /* RM + single acceptance filter AFM */
    bus.write(bus.context, SJA_BTR0, btr0);
    bus.write(bus.context, SJA_BTR1, btr1);
    for (unsigned i = 0; i < 4; ++i) {
        bus.write(bus.context, 16 + i, 0); /* ACR, reset mode only */
        bus.write(bus.context, 20 + i, 0xff); /* AMR=1 means don't care */
    }
    /* OCR/transceiver board configuration belongs to the board layer. */
    (void)bus.read(bus.context, SJA_IR);
    bus.write(bus.context, SJA_CMR, 8); /* clear data overrun */
    bus.write(bus.context, SJA_MOD, 8); /* AFM, exit reset */
    for (tries = 0; tries < 64; ++tries)
        if (!(bus.read(bus.context, SJA_MOD) & 1u)) return CAN_OK;
    return CAN_TIMEOUT;
}
CanResult sja_send(SjaBus bus, const CanFrame *frame) {
    if (!bus.read || !bus.write) return CAN_ARGUMENT;
    uint8_t status = bus.read(bus.context, SJA_SR);
    if (status & 0x80u) return CAN_BUS_OFF; /* real Bus-Off also sets RM */
    if (bus.read(bus.context, SJA_MOD) & 1u) return CAN_MODE;
    if (!(status & 4u)) return CAN_BUSY;
    uint8_t record[13]; size_t length;
    CanResult result = can_pack_peli(frame, record, &length);
    if (result != CAN_OK) return result;
    for (size_t i = 0; i < length; ++i)
        bus.write(bus.context, SJA_BUFFER + (unsigned)i, record[i]);
    bus.write(bus.context, SJA_CMR, 1); /* TR, not read-modify-write */
    return CAN_OK; /* queued, NOT ACKed */
}
CanResult sja_receive(SjaBus bus, CanFrame *frame) {
    if (!bus.read || !bus.write || !frame) return CAN_ARGUMENT;
    if (bus.read(bus.context, SJA_MOD) & 1u) return CAN_MODE;
    if (!(bus.read(bus.context, SJA_SR) & 1u)) return CAN_BUSY;
    uint8_t record[13] = {0};
    record[0] = bus.read(bus.context, 16);
    unsigned dlc = record[0] & 0x0fu;
    CanResult result = CAN_LENGTH;
    if (dlc <= 8) {
        unsigned header = (record[0] & 0x80u) ? 5u : 3u;
        unsigned size = header + ((record[0] & 0x40u) ? 0u : dlc);
        for (unsigned i = 1; i < size; ++i) record[i] = bus.read(bus.context, 16 + i);
        result = can_unpack_peli(record, frame);
    }
    /* Even an invalid canonical record must be released, or it blocks the FIFO. */
    bus.write(bus.context, SJA_CMR, 4);
    return result;
}
