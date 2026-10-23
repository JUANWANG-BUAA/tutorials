.syntax unified
.cpu cortex-m3
.thumb
.section .vectors,"a",%progbits
.balign 128
.word _estack, Reset_Handler, fault, fault
.word fault, fault, fault, 0, 0, 0, 0, fault
.word fault, 0, fault, fault
.rept 5
.word fault
.endr
.word UART0_Handler
.text
.global Reset_Handler
.thumb_func
Reset_Handler:
 ldr r0, =_sdata
 ldr r1, =_edata
 ldr r2, =_sidata
3: cmp r0, r1
 bhs 4f
 ldr r3, [r2], #4
 str r3, [r0], #4
 b 3b
4: ldr r0, =_sbss
 ldr r1, =_ebss
 movs r2, #0
1: cmp r0, r1
 bhs 2f
 str r2, [r0], #4
 b 1b
2: bl main
 b fault
.global fault
.thumb_func
fault:
 movs r0, #1
 b finish
