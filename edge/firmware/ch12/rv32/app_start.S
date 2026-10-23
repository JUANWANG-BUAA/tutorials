.section .init,"ax"
.option norvc
.global _start
_start:
 mv s0, sp
.option push
.option norelax
 la gp, __global_pointer$
.option pop
 li tp, 0
 la t0, _sidata
 la t1, _sdata
 la t2, _edata
1: bgeu t1, t2, 2f
 lbu t3, 0(t0)
 sb t3, 0(t1)
 addi t0, t0, 1
 addi t1, t1, 1
 j 1b
2: la t0, _sbss
 la t1, _ebss
3: bgeu t0, t1, 4f
 sb zero, 0(t0)
 addi t0, t0, 1
 j 3b
4: la t0, entry_sp
 sw s0, 0(t0)
 call main
 j fault
.balign 256
.global app_trap
app_trap:
 addi sp, sp, -16
 sw t0, 0(sp)
 sw t1, 4(sp)
 csrr t0, mcause
 li t1, 0x80000007
 bne t0, t1, fault
 li t0, 0x02004000
 li t1, -1
 sw t1, 0(t0)
 sw t1, 4(t0)
 la t0, ticks
 lw t1, 0(t0)
 addi t1, t1, 1
 sw t1, 0(t0)
 lw t0, 0(sp)
 lw t1, 4(sp)
 addi sp, sp, 16
 mret
