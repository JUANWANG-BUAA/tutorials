#include "can_core.h"
#define CHECK(x) do { if (!(x)) return __LINE__; } while (0)

int can_core_selftest(void) {
    static const uint8_t text[] = "123456789";
    uint8_t text_bits[72];
    for (unsigned i = 0; i < 9; ++i)
        for (unsigned j = 0; j < 8; ++j)
            text_bits[8*i+j] = (text[i] >> (7-j)) & 1u;
    CHECK(can_crc15_bits(text_bits, 72) == 0x059e);
    CanFrame a = {.id=0x123, .extended=false, .rtr=false, .dlc=8,
                  .data={0,0,0xff,0xff,0x55,0xaa,0,0}};
    CanFrame b;
    CanBits wire;
    bool ack;
    CHECK(can_encode_standard(&a, true, &wire) == CAN_OK);
    CHECK(wire.count > 111 && wire.count <= 135);
    CHECK(can_decode_standard(&wire, &b, &ack) == CAN_OK && ack);
    CHECK(b.id == a.id && b.dlc == 8 && !b.extended && !b.rtr);
    for (unsigned i = 0; i < 8; ++i) CHECK(b.data[i] == a.data[i]);
    size_t dynamic_end = wire.count - 13;
    for (size_t i = 0; i < dynamic_end; ++i) {
        wire.bit[i] ^= 1u;
        CHECK(can_decode_standard(&wire, &b, &ack) != CAN_OK);
        wire.bit[i] ^= 1u;
    }
    wire.bit[dynamic_end] = 0;
    CHECK(can_decode_standard(&wire, &b, &ack) == CAN_FORM);
    wire.bit[dynamic_end] = 1;
    wire.bit[dynamic_end + 1] = 1;
    CHECK(can_decode_standard(&wire, &b, &ack) == CAN_OK && !ack);

    uint32_t seed = 0x20261022u;
    for (unsigned sample = 0; sample < 1000; ++sample) {
        seed = seed * 1664525u + 1013904223u;
        a.id = seed & 0x7ffu; a.dlc = sample % 9; a.rtr = sample % 7 == 0;
        for (unsigned i = 0; i < 8; ++i) {
            seed = seed * 1664525u + 1013904223u;
            a.data[i] = (uint8_t)(seed >> 24);
        }
        CHECK(can_encode_standard(&a, (sample & 1u) != 0, &wire) == CAN_OK);
        CHECK(can_decode_standard(&wire, &b, &ack) == CAN_OK);
        CHECK(ack == ((sample & 1u) != 0));
        CHECK(a.id == b.id && a.dlc == b.dlc && a.rtr == b.rtr);
        if (!a.rtr) for (unsigned i = 0; i < a.dlc; ++i) CHECK(a.data[i] == b.data[i]);
        uint8_t record[13]; size_t length;
        CHECK(can_pack_peli(&a, record, &length) == CAN_OK);
        CHECK(length == 3u + (a.rtr ? 0u : a.dlc));
        CHECK(can_unpack_peli(record, &b) == CAN_OK && b.id == a.id && b.dlc == a.dlc);
    }
    uint8_t record[13]; size_t length;
    a.id = 0x123; a.rtr = false; a.dlc = 0;
    CHECK(can_pack_peli(&a, record, &length) == CAN_OK);
    CHECK(length == 3 && record[1] == 0x24 && record[2] == 0x60);
    a.extended = true; a.id = 0x1fffffffu; a.dlc = 8;
    CHECK(can_pack_peli(&a, record, &length) == CAN_OK);
    CHECK(length == 13 && record[0] == 0x88 && record[1] == 0xff && record[4] == 0xf8);
    CHECK(can_unpack_peli(record, &b) == CAN_OK && b.id == a.id && b.extended);
    CHECK(can_encode_standard(&a, true, &wire) == CAN_ARGUMENT); /* not a fake extended encoder */
    a.extended = false; a.id = 0x800;
    CHECK(can_encode_standard(&a, true, &wire) == CAN_ARGUMENT);
    a.id = 0x123; a.dlc = 9;
    CHECK(can_pack_peli(&a, record, &length) == CAN_ARGUMENT);

    a = (CanFrame){.id=0x123}; b = (CanFrame){.id=0x124};
    CHECK(can_arbitrate(&a, &b) == -1 && can_arbitrate(&b, &a) == 1);
    b.id = a.id; b.rtr = true;
    CHECK(can_arbitrate(&a, &b) == -1); /* same ID data beats RTR */
    a.rtr = true; b.extended = true; b.id = (a.id << 18) | 1u;
    CHECK(can_arbitrate(&a, &b) == -1); /* IDE, not naive integer comparison */
    b = a; CHECK(can_arbitrate(&a, &b) == 0);
    static const unsigned fd[16] = {0,1,2,3,4,5,6,7,8,12,16,20,24,32,48,64};
    for (unsigned i = 0; i < 16; ++i) CHECK(can_fd_length(i) == fd[i]);
    CHECK(can_fd_length(16) == 0xff);

    CanFault fault = {0};
    for (unsigned i = 0; i < 64; ++i) can_fault_event(&fault, TX_ACK_MISSING, false);
    CHECK(fault.tec == 128 && can_fault_state(&fault) == ERROR_PASSIVE);
    fault = (CanFault){.rec=300};
    CHECK(can_fault_state(&fault) == ERROR_PASSIVE); /* REC alone does not cause Bus-Off */
    can_fault_event(&fault, RX_SUCCESS, false);
    CHECK(fault.rec == 127 && can_fault_state(&fault) == ERROR_ACTIVE);
    fault = (CanFault){.tec=127}; CHECK(can_fault_state(&fault) == ERROR_ACTIVE);
    fault.tec = 128; CHECK(can_fault_state(&fault) == ERROR_PASSIVE);
    fault.tec = 255; CHECK(can_fault_state(&fault) == ERROR_PASSIVE);
    fault = (CanFault){0};
    for (unsigned i = 0; i < 32; ++i) can_fault_event(&fault, TX_ERROR, true);
    CHECK(fault.tec == 256 && can_fault_state(&fault) == BUS_OFF);
    can_fault_event(&fault, TX_SUCCESS, false); CHECK(fault.tec == 256);
    for (unsigned i = 0; i < 1408; ++i) can_recovery_bit(&fault, 1);
    CHECK(can_fault_state(&fault) == BUS_OFF); /* software request still required by this API */
    fault.recovery_requested = true;
    for (unsigned i = 0; i < 127*11; ++i) can_recovery_bit(&fault, 1);
    CHECK(can_fault_state(&fault) == BUS_OFF && fault.recovery_groups == 127);
    for (unsigned i = 0; i < 10; ++i) can_recovery_bit(&fault, 1);
    can_recovery_bit(&fault, 0);
    CHECK(fault.recessive_run == 0);
    for (unsigned i = 0; i < 11; ++i) can_recovery_bit(&fault, 1);
    CHECK(can_fault_state(&fault) == ERROR_ACTIVE && fault.tec == 0 && fault.rec == 0);
    return 0;
}
