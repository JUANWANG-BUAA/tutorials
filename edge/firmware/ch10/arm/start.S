.syntax unified
.cpu cortex-m3
.thumb
.section .vectors,"a",%progbits
.balign 128
.word _estack, Reset_Handler
.word fault, hardfault_asm_entry    /* HardFault is exception 3 (offset 0x0C) */
.rept 12
.word fault
.endr
/* IRQ 0..17 */
.rept 18
.word fault
.endr
.word watchdog_irq_handler          /* IRQ 18 (offset 0x88): Watchdog Timer 0 */
.text
.global Reset_Handler
.type Reset_Handler,%function
.thumb_func
Reset_Handler:
 cpsid i
 ldr r0, =_sidata
 ldr r1, =_sdata
 ldr r2, =_edata
1: cmp r1, r2
 bhs 2f
 ldrb r3, [r0], #1
 strb r3, [r1], #1
 b 1b

2: ldr r1, =_sbss
 ldr r2, =_ebss
 movs r3, #0
3: cmp r1, r2
 bhs 4f
 strb r3, [r1], #1
 b 3b

4: bl main
 b fault

.global hardfault_asm_entry
.type hardfault_asm_entry,%function
.thumb_func
hardfault_asm_entry:
 tst lr, #4
 ite eq
 mrseq r0, msp
 mrsne r0, psp
 mov r1, lr
 b hardfault_c_decoder
