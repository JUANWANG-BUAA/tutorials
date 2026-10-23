.text
.option push
.option norvc
.option norelax
.balign 4
.global exercise_traps
.type exercise_traps,@function
exercise_traps:
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
 li ra, 257
 li t0, 261
 li t1, 262
 li t2, 263
 li s0, 264
 li s1, 265
 li a0, 266
 li a1, 267
 li a2, 268
 li a3, 269
 li a4, 270
 li a5, 271
 li a6, 272
 li a7, 273
 li s2, 274
 li s3, 275
 li s4, 276
 li s5, 277
 li s6, 278
 li s7, 279
 li s8, 280
 li s9, 281
 li s10, 282
 li s11, 283
 li t3, 284
 li t4, 285
 li t5, 286
 li t6, 287
 ecall
 sw a0, 60(sp)
 li a0, 257
 bne ra, a0, .Lfail
 li a0, 261
 bne t0, a0, .Lfail
 li a0, 262
 bne t1, a0, .Lfail
 li a0, 263
 bne t2, a0, .Lfail
 li a0, 264
 bne s0, a0, .Lfail
 li a0, 265
 bne s1, a0, .Lfail
 li a0, 267
 bne a1, a0, .Lfail
 li a0, 268
 bne a2, a0, .Lfail
 li a0, 269
 bne a3, a0, .Lfail
 li a0, 270
 bne a4, a0, .Lfail
 li a0, 271
 bne a5, a0, .Lfail
 li a0, 272
 bne a6, a0, .Lfail
 li a0, 273
 bne a7, a0, .Lfail
 li a0, 274
 bne s2, a0, .Lfail
 li a0, 275
 bne s3, a0, .Lfail
 li a0, 276
 bne s4, a0, .Lfail
 li a0, 277
 bne s5, a0, .Lfail
 li a0, 278
 bne s6, a0, .Lfail
 li a0, 279
 bne s7, a0, .Lfail
 li a0, 280
 bne s8, a0, .Lfail
 li a0, 281
 bne s9, a0, .Lfail
 li a0, 282
 bne s10, a0, .Lfail
 li a0, 283
 bne s11, a0, .Lfail
 li a0, 284
 bne t3, a0, .Lfail
 li a0, 285
 bne t4, a0, .Lfail
 li a0, 286
 bne t5, a0, .Lfail
 li a0, 287
 bne t6, a0, .Lfail
 lw t0, 60(sp)
 li a0, 17
 bne t0, a0, .Lfail
 li ra, 257
 li t0, 261
 li t1, 262
 li t2, 263
 li s0, 264
 li s1, 265
 li a0, 266
 li a1, 267
 li a2, 268
 li a3, 269
 li a4, 270
 li a5, 271
 li a6, 272
 li a7, 273
 li s2, 274
 li s3, 275
 li s4, 276
 li s5, 277
 li s6, 278
 li s7, 279
 li s8, 280
 li s9, 281
 li s10, 282
 li s11, 283
 li t3, 284
 li t4, 285
 li t5, 286
 li t6, 287
 li a0, 128
 csrs mie, a0
 li a0, 0
.Lwait:
 wfi
 csrsi mstatus, 8
.global timer_resume_point
timer_resume_point:
 addi s0, s0, 1
 csrci mstatus, 8
 beqz a0, .Lundo
 sw a0, 60(sp)
 li a0, 257
 bne ra, a0, .Lfail
 li a0, 261
 bne t0, a0, .Lfail
 li a0, 262
 bne t1, a0, .Lfail
 li a0, 263
 bne t2, a0, .Lfail
 li a0, 265
 bne s0, a0, .Lfail
 li a0, 265
 bne s1, a0, .Lfail
 li a0, 267
 bne a1, a0, .Lfail
 li a0, 268
 bne a2, a0, .Lfail
 li a0, 269
 bne a3, a0, .Lfail
 li a0, 270
 bne a4, a0, .Lfail
 li a0, 271
 bne a5, a0, .Lfail
 li a0, 272
 bne a6, a0, .Lfail
 li a0, 273
 bne a7, a0, .Lfail
 li a0, 274
 bne s2, a0, .Lfail
 li a0, 275
 bne s3, a0, .Lfail
 li a0, 276
 bne s4, a0, .Lfail
 li a0, 277
 bne s5, a0, .Lfail
 li a0, 278
 bne s6, a0, .Lfail
 li a0, 279
 bne s7, a0, .Lfail
 li a0, 280
 bne s8, a0, .Lfail
 li a0, 281
 bne s9, a0, .Lfail
 li a0, 282
 bne s10, a0, .Lfail
 li a0, 283
 bne s11, a0, .Lfail
 li a0, 284
 bne t3, a0, .Lfail
 li a0, 285
 bne t4, a0, .Lfail
 li a0, 286
 bne t5, a0, .Lfail
 li a0, 287
 bne t6, a0, .Lfail
 lw t0, 60(sp)
 li a0, 42
 bne t0, a0, .Lfail
 li a0, 0
 j .Lrestore
.Lundo:
 addi s0, s0, -1
 j .Lwait
.Lfail:
 li a0, 1
.Lrestore:
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
.size exercise_traps, .-exercise_traps
.option pop
