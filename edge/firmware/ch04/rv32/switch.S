.section .init,"ax"
.global _start
_start:
 .option push
 .option norelax
 la gp, __global_pointer$
 .option pop
 la sp, _estack
 la t0, _sbss
 la t1, _ebss
1: bgeu t0, t1, 2f
 sw zero, 0(t0)
 addi t0, t0, 4
 j 1b
2: call main
 li a0, 1
 tail finish
.section .text
.global rv_switch
rv_switch:
 addi sp, sp, -64
 sw ra, 0(sp)
 sw s0, 4(sp)
 sw s1, 8(sp)
 sw s2, 12(sp)
 sw s3, 16(sp)
 sw s4, 20(sp)
 sw s5, 24(sp)
 sw s6, 28(sp)
 sw s7, 32(sp)
 sw s8, 36(sp)
 sw s9, 40(sp)
 sw s10, 44(sp)
 sw s11, 48(sp)
 sw sp, 0(a0)
 mv sp, a1
 lw ra, 0(sp)
 lw s0, 4(sp)
 lw s1, 8(sp)
 lw s2, 12(sp)
 lw s3, 16(sp)
 lw s4, 20(sp)
 lw s5, 24(sp)
 lw s6, 28(sp)
 lw s7, 32(sp)
 lw s8, 36(sp)
 lw s9, 40(sp)
 lw s10, 44(sp)
 lw s11, 48(sp)
 addi sp, sp, 64
 ret
.global task_entry
task_entry:
 call task_id
 addi s0, a0, 0x40
 addi s1, s0, 1
 addi s2, s0, 2
 addi s3, s0, 3
 addi s4, s0, 4
 addi s5, s0, 5
 addi s6, s0, 6
 addi s7, s0, 7
 addi s8, s0, 8
 addi s9, s0, 9
 addi s10, s0, 10
 addi s11, s0, 11
3: call task_step
 call task_id
 addi t0, a0, 0x40
 bne s0, t0, fail
 addi t0, t0, 1
 bne s1, t0, fail
 addi t0, t0, 1
 bne s2, t0, fail
 addi t0, t0, 1
 bne s3, t0, fail
 addi t0, t0, 1
 bne s4, t0, fail
 addi t0, t0, 1
 bne s5, t0, fail
 addi t0, t0, 1
 bne s6, t0, fail
 addi t0, t0, 1
 bne s7, t0, fail
 addi t0, t0, 1
 bne s8, t0, fail
 addi t0, t0, 1
 bne s9, t0, fail
 addi t0, t0, 1
 bne s10, t0, fail
 addi t0, t0, 1
 bne s11, t0, fail
 j 3b
fail:
 li a0, 1
 tail finish
