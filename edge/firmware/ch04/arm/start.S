.syntax unified
.cpu cortex-m3
.thumb
.section .vectors,"a",%progbits
.balign 128
.word _estack, Reset_Handler, fault, fault
.word fault, fault, fault, 0, 0, 0, 0, SVC_Handler
.word fault, 0, PendSV_Handler, SysTick_Handler
.section .text
.global Reset_Handler
.thumb_func
Reset_Handler:
 ldr r0, =_sdata
 ldr r1, =_edata
 ldr r2, =_sidata
1: cmp r0, r1
 bhs 2f
 ldr r3, [r2], #4
 str r3, [r0], #4
 b 1b
2: ldr r0, =_sbss
 ldr r1, =_ebss
 movs r2, #0
3: cmp r0, r1
 bhs 4f
 str r2, [r0], #4
 b 3b
4: bl main
 b fault
.global fault
.thumb_func
fault:
 movs r0, #1
 b finish
.global SVC_Handler
.thumb_func
SVC_Handler:
 ldr r1, =current
 ldr r1, [r1]
 ldr r0, [r1]
 ldmia r0!, {r4-r11, lr}
 msr psp, r0
 movs r0, #2
 msr control, r0
 isb
 bx lr
.global PendSV_Handler
.thumb_func
PendSV_Handler:
 mrs r3, primask
 cpsid i
 mrs r0, psp
 stmdb r0!, {r4-r11, lr}
 ldr r1, =current
 ldr r2, [r1]
 str r0, [r2]
 push {r3, lr}
 bl select_next
 pop {r3, lr}
 ldr r1, =current
 ldr r1, [r1]
 ldr r0, [r1]
 ldmia r0!, {r4-r11, lr}
 msr psp, r0
 msr primask, r3
 bx lr
.global task_entry
.thumb_func
task_entry:
 bl task_id
 movs r4, #0x44
 adds r4, r4, r0
 movs r5, #0x55
 adds r5, r5, r0
 movs r6, #0x66
 adds r6, r6, r0
 movs r7, #0x77
 adds r7, r7, r0
 mov r8, r4
 mov r9, r5
 mov r10, r6
 mov r11, r7
5: bl task_step
 bl task_id
 adds r0, #0x44
 cmp r4, r0
 bne fault
 adds r0, #0x11
 cmp r5, r0
 bne fault
 adds r0, #0x11
 cmp r6, r0
 bne fault
 adds r0, #0x11
 cmp r7, r0
 bne fault
 cmp r8, r4
 bne fault
 cmp r9, r5
 bne fault
 cmp r10, r6
 bne fault
 cmp r11, r7
 bne fault
 b 5b
