/* Deliberately limited register model, not a clocked CAN controller emulator. */
#include "sja_driver.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    uint8_t reg[32], filter[8], tx[13], rx[13];
    bool deny_reset, deny_exit;
    unsigned illegal, released, requested, data_reads, release_after_reads;
} Model;
static uint8_t read_reg(void *context, unsigned offset) {
    Model *m = context;
    assert(offset < 32);
    if (offset == SJA_CMR) return 0;
    if (offset == SJA_IR) { uint8_t v=m->reg[offset]; m->reg[offset] &= 1u; return v; }
    if (offset >= 16 && offset <= 28) {
        if (m->reg[SJA_MOD] & 1u) return offset < 24 ? m->filter[offset-16] : 0;
        ++m->data_reads;
        return m->rx[offset-16]; /* reads and writes address distinct FIFO/TX windows */
    }
    return m->reg[offset];
}
static void write_reg(void *context, unsigned offset, uint8_t value) {
    Model *m = context;
    assert(offset < 32);
    if (offset == SJA_MOD) {
        if (!m->deny_reset && !(m->deny_exit && !(value & 1u))) m->reg[offset] = value;
        return;
    }
    if ((offset == SJA_BTR0 || offset == SJA_BTR1) && !(m->reg[SJA_MOD] & 1u)) {
        ++m->illegal; return;
    }
    if (offset == SJA_CMR) {
        if (value & 1u) { ++m->requested; m->reg[SJA_SR] &= (uint8_t)~4u; }
        if (value & 4u) {
            ++m->released; m->release_after_reads = m->data_reads;
            m->reg[SJA_SR] &= (uint8_t)~1u;
            m->reg[SJA_IR] &= (uint8_t)~1u;
        }
        if (value & 8u) m->reg[SJA_SR] &= (uint8_t)~2u;
        return;
    }
    if (offset >= 16 && offset <= 28) {
        if (m->reg[SJA_MOD] & 1u) {
            if (offset < 24) m->filter[offset-16] = value;
            else ++m->illegal;
        } else if (m->reg[SJA_SR] & 4u) m->tx[offset-16] = value;
        else ++m->illegal;
        return;
    }
    m->reg[offset] = value;
}
static void inject(Model *m, const CanFrame *f) {
    size_t count;
    assert(can_pack_peli(f, m->rx, &count) == CAN_OK);
    m->reg[SJA_SR] |= 1u;
    m->reg[SJA_IR] |= 1u;
    m->data_reads = 0;
}
int main(void) {
    Model m = {0};
    m.reg[SJA_SR] = 4;
    SjaBus bus = {&m, read_reg, write_reg};
    assert(sja_initialize(bus, 0, 0x1c) == CAN_OK);
    assert(!m.illegal && m.reg[SJA_CDR] & 0x80u);
    assert(m.reg[SJA_BTR0] == 0 && m.reg[SJA_BTR1] == 0x1c);
    for (unsigned i = 4; i < 8; ++i) assert(m.filter[i] == 0xff);
    assert(!(m.reg[SJA_MOD] & 1u) && m.reg[SJA_IER] == 0);
    puts("MODEL PASS SJA init: reset-only BTR/filter writes and bounded exit");
    write_reg(&m, SJA_IER, 0xff); /* test harness now attaches/enables modeled IRQ sources */

    CanFrame f = {.id=0x123, .dlc=2, .data={0x55,0xa3}}, out;
    assert(sja_send(bus, &f) == CAN_OK);
    assert(m.tx[0] == 2 && m.tx[1] == 0x24 && m.tx[2] == 0x60);
    assert(m.tx[3] == 0x55 && m.tx[4] == 0xa3 && m.requested == 1);
    assert(sja_send(bus, &f) == CAN_BUSY);
    m.reg[SJA_SR] |= 4u | 0x80u;
    m.reg[SJA_MOD] |= 1u; /* hardware Bus-Off forces reset mode too */
    assert(sja_send(bus, &f) == CAN_BUS_OFF);
    m.reg[SJA_SR] &= (uint8_t)~0x80u;
    assert(sja_send(bus, &f) == CAN_MODE);
    m.reg[SJA_MOD] &= (uint8_t)~1u;
    puts("MODEL PASS SJA TX: ID packing, busy, Bus-Off and reset-mode rejection");

    inject(&m, &f);
    m.reg[SJA_IR] |= 0x82u;
    assert(read_reg(&m, SJA_IR) == 0x83);
    assert(read_reg(&m, SJA_IR) == 1); /* RI remains while FIFO nonempty */
    assert(sja_receive(bus, &out) == CAN_OK && out.id == f.id);
    assert(out.data[0] == 0x55 && out.data[1] == 0xa3);
    assert(m.released == 1 && m.release_after_reads == 5);
    assert(sja_receive(bus, &out) == CAN_BUSY);
    inject(&m, &f); m.rx[0] = 15;
    assert(sja_receive(bus, &out) == CAN_LENGTH && m.released == 2);
    assert(sja_receive(bus, &out) == CAN_BUSY);
    f.extended = true; f.id = 0x1abcdeff; f.rtr = true; f.dlc = 8;
    inject(&m, &f);
    assert(sja_receive(bus, &out) == CAN_OK && out.rtr && out.extended && out.id == f.id);
    assert(m.release_after_reads == 5); /* remote frame has NO data bytes */
    puts("MODEL PASS SJA RX: destructive IR snapshot, copy-before-release, bad-DLC drain");

    Model timeout = {.deny_reset=true};
    SjaBus broken = {&timeout, read_reg, write_reg};
    assert(sja_initialize(broken, 0, 0x1c) == CAN_TIMEOUT);
    Model stuck_reset = {.deny_exit=true};
    SjaBus stuck = {&stuck_reset, read_reg, write_reg};
    assert(sja_initialize(stuck, 0, 0x1c) == CAN_TIMEOUT);
    write_reg(&m, SJA_BTR0, 1);
    assert(m.illegal == 1);
    puts("MODEL PASS SJA fault injection: reset refusal times out, run-mode timing write rejected");
    return 0;
}
