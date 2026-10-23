#ifndef EDGE_CAN_CORE_H
#define EDGE_CAN_CORE_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

typedef enum {
    CAN_OK = 0, CAN_ARGUMENT, CAN_CAPACITY, CAN_STUFF, CAN_FORM,
    CAN_CRC, CAN_LENGTH, CAN_BUSY, CAN_BUS_OFF, CAN_TIMEOUT, CAN_MODE
} CanResult;
/* Canonical Classical CAN frame: DLC 0..8, 11/29 bit ID, RTR supported. */
typedef struct {
    uint32_t id;
    bool extended, rtr;
    uint8_t dlc, data[8];
} CanFrame;
#define CAN_BIT_CAPACITY 256u
typedef struct { uint8_t bit[CAN_BIT_CAPACITY]; size_t count; } CanBits;

uint16_t can_crc15_bits(const uint8_t *bits, size_t count);
CanResult can_encode_standard(const CanFrame *frame, bool ack, CanBits *wire);
CanResult can_decode_standard(const CanBits *wire, CanFrame *frame, bool *ack);
/* Arbitration projection only, without dynamic stuffing: -1=A wins, +1=B wins. */
int can_arbitrate(const CanFrame *a, const CanFrame *b);
unsigned can_fd_length(unsigned dlc); /* returns 0xff for invalid DLC */
CanResult can_pack_peli(const CanFrame *frame, uint8_t record[13], size_t *length);
CanResult can_unpack_peli(const uint8_t record[13], CanFrame *frame);

typedef enum { ERROR_ACTIVE, ERROR_PASSIVE, BUS_OFF } CanFaultState;
typedef enum { TX_ERROR, TX_ACK_MISSING, RX_ERROR, TX_SUCCESS, RX_SUCCESS } CanFaultEvent;
typedef struct {
    unsigned tec, rec, recessive_run, recovery_groups;
    bool recovery_requested;
} CanFault;
CanFaultState can_fault_state(const CanFault *fault);
/* Selected normal counter rules, not the complete ISO error-confinement FSM. */
void can_fault_event(CanFault *fault, CanFaultEvent event, bool passive_flag_saw_dominant);
void can_recovery_bit(CanFault *fault, unsigned bit);
int can_core_selftest(void);
#endif
