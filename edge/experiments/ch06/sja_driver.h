#ifndef EDGE_SJA_DRIVER_H
#define EDGE_SJA_DRIVER_H
#include "can_core.h"
enum { SJA_MOD=0, SJA_CMR=1, SJA_SR=2, SJA_IR=3, SJA_IER=4,
       SJA_BTR0=6, SJA_BTR1=7, SJA_OCR=8, SJA_ALC=11, SJA_ECC=12,
       SJA_RXERR=14, SJA_TXERR=15, SJA_BUFFER=16, SJA_CDR=31 };
typedef struct {
    void *context;
    uint8_t (*read)(void *, unsigned);
    void (*write)(void *, unsigned, uint8_t);
} SjaBus;
CanResult sja_initialize(SjaBus bus, uint8_t btr0, uint8_t btr1);
CanResult sja_send(SjaBus bus, const CanFrame *frame);
CanResult sja_receive(SjaBus bus, CanFrame *frame);
#endif
