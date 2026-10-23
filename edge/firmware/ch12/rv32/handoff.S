.text
.global handoff
.type handoff,@function
/* a0=validated entry, a1=new aligned stack; single-hart M-mode only. */
handoff:
 csrci mstatus, 8
 csrw mie, zero
 addi t0, a0, 256
 csrw mtvec, t0      /* application has a trap vector at entry+0x100 */
 fence rw, rw
 fence.i            /* local instruction-fetch synchronization, NOT flash completion */
 mv t0, a0
 mv sp, a1
 li a0, 0
 li a1, 0
 jr t0
