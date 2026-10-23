.section .init,"ax"
.global _start
_start:
 csrw mie, zero
 csrci mstatus, 8
.option push
.option norelax
 la gp, __global_pointer$
.option pop
 li tp, 0
 la sp, _estack
 la t0, _sbss
 la t1, _ebss
1: bgeu t0, t1, 2f
 sb zero, 0(t0)
 addi t0, t0, 1
 j 1b
2: call main
1: j 1b
