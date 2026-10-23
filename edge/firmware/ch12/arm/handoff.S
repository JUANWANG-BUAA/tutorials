.syntax unified
.cpu cortex-m3
.thumb
.text
.global handoff
.type handoff,%function
.thumb_func
/* Entry: r0=validated vector base, r1=validated new MSP.
 * Privileged Thread mode with CONTROL=0, no active exception. Never returns. */
handoff:
 cpsid i
 ldr r2, =0xe000e010
 movs r3, #0
 str r3, [r2]       /* SysTick CTRL */
 str r3, [r2, #4]   /* LOAD */
 str r3, [r2, #8]   /* VAL */
 ldr r2, =0xe000ed04
 ldr r3, =0x0a000000 /* PENDSVCLR | PENDSTCLR */
 str r3, [r2]
 ldr r2, =0xe000e004 /* ICTR.INTLINESNUM */
 ldr r2, [r2]
 and r2, r2, #15
 adds r2, r2, #1
 ldr r3, =0xe000e180 /* ICER[] */
 ldr r4, =0xe000e280 /* ICPR[] */
 mvn r5, #0
1: str r5, [r3], #4
 str r5, [r4], #4   /* CLEAR STALE PENDING */
 subs r2, r2, #1
 bne 1b
 movs r2, #0
 msr basepri, r2
 msr faultmask, r2
 ldr r3, =0xe000ed08
 str r0, [r3]       /* INSTALL APPLICATION VTOR */
 dsb sy
 isb sy
 ldr r2, [r0, #4]
 movs r3, #0
 msr control, r3
 isb sy
 msr msp, r1
 bx r2              /* no C epilogue or stack access after new MSP */
