__RNvMNtCseHZXeO4ot7L_6tidekv5bloomNtB2_5Bloom8contains:
Lfunc_begin171:
	.loc	125 136 0
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	mov	x8, #8997
	movk	x8, #33826, lsl #16
	movk	x8, #40164, lsl #32
	movk	x8, #52210, lsl #48
Ltmp9222:
	.loc	2 180 28 prologue_end
	cbz	x2, LBB171_3
Ltmp9223:
	.loc	2 0 28 is_stmt 0
	mov	x9, #435
	movk	x9, #256, lsl #32
LBB171_2:
	.loc	125 23 10 is_stmt 1
	ldrb	w10, [x1], #1
Ltmp9224:
	.loc	125 24 9
	eor	x8, x8, x10
Ltmp9225:
	.loc	17 2728 13
	mul	x8, x8, x9
Ltmp9226:
	.loc	6 1663 9
	subs	x2, x2, #1
Ltmp9227:
	.loc	2 180 28
	b.ne	LBB171_2
Ltmp9228:
LBB171_3:
	.loc	125 83 22
	ldr	x9, [x0, #32]
	lsr	x9, x9, #4
Ltmp9229:
	.loc	125 84 9
	cbz	x9, LBB171_5
Ltmp9230:
	.loc	125 12 5
	eor	x8, x8, x8, lsr #30
Ltmp9231:
	.loc	17 2728 13
	mov	x10, #58809
	movk	x10, #7396, lsl #16
	movk	x10, #18285, lsl #32
	movk	x10, #48984, lsl #48
	mul	x8, x8, x10
Ltmp9232:
	.loc	125 14 5
	eor	x8, x8, x8, lsr #27
Ltmp9233:
	.loc	17 2728 13
	mov	x10, #4587
	movk	x10, #4913, lsl #16
	movk	x10, #18875, lsl #32
	movk	x10, #38096, lsl #48
	mul	x8, x8, x10
Ltmp9234:
	.loc	125 33 14
	lsr	x10, x8, #56
Ltmp9235:
	.loc	125 34 8
	cmp	x10, #0
	mov	w11, #127
	csel	w10, w11, w10, eq
Ltmp9236:
	.loc	125 16 5
	eor	x8, x8, x8, lsr #31
Ltmp9237:
	.loc	125 84 9
	udiv	x11, x8, x9
	msub	x8, x11, x9, x8
Ltmp9238:
	.loc	25 611 9
	ldr	x9, [x0, #8]
Ltmp9239:
	.loc	125 110 48
	ldr	x11, [x0, #24]
Ltmp9240:
	.loc	10 473 18
	add	x9, x9, x11
	add	x8, x9, x8, lsl #4
Ltmp9241:
	.loc	2 274 27
	add	x9, x8, #8
	ldr	d0, [x8]
	ld1.s	{ v0 }[2], [x9]
	add	x9, x8, #12
	ld1.h	{ v0 }[6], [x9]
Ltmp9242:
	.loc	125 140 36
	dup.16b	v1, w10
	mov.b	v1[14], w8
	mov.b	v1[15], w8
Ltmp9243:
	.loc	2 274 27
	ldrb	w9, [x8, #14]
Ltmp9244:
	.file	127 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits" "accum.rs"
	.loc	127 55 28
	cmeq.16b	v0, v0, v1
Lloh351:
	adrp	x11, lCPI171_0@PAGE
Lloh352:
	ldr	q1, [x11, lCPI171_0@PAGEOFF]
	and.16b	v0, v0, v1
	addv.16b	b0, v0
	smov.b	w11, v0[0]
	neg	w11, w11
	cmp	w9, w10
	cinc	x9, x11, eq
Ltmp9245:
	.loc	2 274 27
	ldrb	w8, [x8, #15]
Ltmp9246:
	.loc	125 140 36
	cmp	w8, w10
	cset	w8, eq
Ltmp9247:
	.loc	125 140 9 is_stmt 0
	orr	x8, x9, x8
	cmp	x8, #0
	cset	w0, ne
Ltmp9248:
	.cfi_def_cfa wsp, 16
	.loc	125 141 6 epilogue_begin is_stmt 1
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB171_5:
	.cfi_restore_state
Ltmp9249:
	.loc	125 84 9
Lloh353:
	adrp	x0, l_alloc_f2807348af7bae36ef4ea76a85a54442@PAGE
Lloh354:
	add	x0, x0, l_alloc_f2807348af7bae36ef4ea76a85a54442@PAGEOFF
	bl	__RNvNtNtCs3bJEMBXHbwl_4core9panicking11panic_const23panic_const_rem_by_zero
Ltmp9250:
	.loh AdrpLdr	Lloh351, Lloh352
	.loh AdrpAdd	Lloh353, Lloh354
Lfunc_end171:
	.cfi_endproc
	.file	128 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters" "map.rs"
	.file	129 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters" "filter.rs"

	.globl	__RNvMNtCseHZXeO4ot7L_6tidekv5statsNtB2_8Counters8snapshot
	.p2align	2
