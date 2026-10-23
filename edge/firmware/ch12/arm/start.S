.syntax unified
.cpu cortex-m3
.thumb
.section .vectors,"a",%progbits
.balign 128
.word _estack, Reset_Handler
.rept 14
.word fault
.endr
.section .text.Reset_Handler,"ax",%progbits
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
