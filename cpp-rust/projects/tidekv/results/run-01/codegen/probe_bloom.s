__RNvCs3JOnBuUxc1f_10tide_probe11probe_bloom:
Lfunc_begin15:
	.file	24 "/Users/juanwang/Desktop/tutorials/cpp-rust/projects/tidekv" "src/bin/tide-probe.rs"
	.loc	24 13 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
Ltmp340:
	.file	25 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/iter" "macros.rs"
	.loc	25 180 28 prologue_end
	cbz	x2, LBB15_7
Ltmp341:
	.loc	25 0 28 is_stmt 0
	mov	x8, x0
	ldr	x9, [x0, #32]
	lsr	x9, x9, #4
	cbz	x9, LBB15_9
	mov	x0, #0
	mov	w10, #24
	madd	x10, x2, x10, x1
	ldr	x11, [x8, #8]
	ldr	x8, [x8, #24]
	add	x8, x11, x8
	mov	x11, #8997
	movk	x11, #33826, lsl #16
	movk	x11, #40164, lsl #32
	movk	x11, #52210, lsl #48
	mov	x12, #58809
	movk	x12, #7396, lsl #16
	movk	x12, #18285, lsl #32
	movk	x12, #48984, lsl #48
	mov	x13, #4587
	movk	x13, #4913, lsl #16
	movk	x13, #18875, lsl #32
	movk	x13, #38096, lsl #48
	mov	w14, #127
Lloh2:
	adrp	x15, lCPI15_0@PAGE
Lloh3:
	ldr	q0, [x15, lCPI15_0@PAGEOFF]
	mov	x15, #435
	movk	x15, #256, lsl #32
	b	LBB15_4
LBB15_3:
	add	x1, x1, #24
Ltmp342:
	.file	26 "/Users/juanwang/Desktop/tutorials/cpp-rust/projects/tidekv" "src/bloom.rs"
	.loc	26 12 5 is_stmt 1
	eor	x16, x17, x17, lsr #30
Ltmp343:
	.loc	7 2728 13
	mul	x16, x16, x12
Ltmp344:
	.loc	26 14 5
	eor	x16, x16, x16, lsr #27
Ltmp345:
	.loc	7 2728 13
	mul	x16, x16, x13
Ltmp346:
	.loc	26 33 14
	lsr	x17, x16, #56
Ltmp347:
	.loc	26 34 8
	cmp	x17, #0
	csel	w17, w14, w17, eq
Ltmp348:
	.loc	26 16 5
	eor	x16, x16, x16, lsr #31
Ltmp349:
	.loc	26 84 9
	udiv	x2, x16, x9
	msub	x16, x2, x9, x16
Ltmp350:
	.file	27 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "const_ptr.rs"
	.loc	27 473 18
	add	x16, x8, x16, lsl #4
Ltmp351:
	.loc	25 274 27
	add	x2, x16, #8
	ldr	d1, [x16]
	ld1.s	{ v1 }[2], [x2]
	add	x2, x16, #12
	ld1.h	{ v1 }[6], [x2]
Ltmp352:
	.loc	26 140 36
	dup.16b	v2, w17
	mov.b	v2[14], w8
	mov.b	v2[15], w8
Ltmp353:
	.loc	25 274 27
	ldrb	w2, [x16, #14]
Ltmp354:
	.file	28 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits" "accum.rs"
	.loc	28 55 28
	cmeq.16b	v1, v1, v2
	and.16b	v1, v1, v0
	addv.16b	b1, v1
	smov.b	w3, v1[0]
	neg	w3, w3
	cmp	w2, w17
	cinc	x2, x3, eq
Ltmp355:
	.loc	25 274 27
	ldrb	w16, [x16, #15]
Ltmp356:
	.loc	26 140 36
	cmp	w16, w17
	cset	w16, eq
Ltmp357:
	.loc	26 140 9 is_stmt 0
	orr	x16, x2, x16
Ltmp358:
	.loc	24 16 9 is_stmt 1
	cmp	x16, #0
	cinc	x0, x0, ne
Ltmp359:
	.loc	25 180 28
	cmp	x1, x10
	b.eq	LBB15_8
Ltmp360:
LBB15_4:
	.loc	9 1865 86
	ldr	x16, [x1, #16]
	mov	x17, x11
Ltmp361:
	.loc	25 180 28
	cbz	x16, LBB15_3
Ltmp362:
	.loc	25 0 28 is_stmt 0
	ldr	x2, [x1, #8]
	mov	x17, x11
LBB15_6:
	.loc	26 23 10 is_stmt 1
	ldrb	w3, [x2], #1
Ltmp363:
	.loc	26 24 9
	eor	x17, x17, x3
Ltmp364:
	.loc	7 2728 13
	mul	x17, x17, x15
Ltmp365:
	.loc	2 1663 9
	subs	x16, x16, #1
Ltmp366:
	.loc	25 180 28
	b.ne	LBB15_6
	b	LBB15_3
Ltmp367:
LBB15_7:
	.loc	25 0 28 is_stmt 0
	mov	x0, #0
LBB15_8:
	.cfi_def_cfa wsp, 16
	.loc	24 19 2 epilogue_begin is_stmt 1
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB15_9:
	.cfi_restore_state
Ltmp368:
	.loc	26 84 9
Lloh4:
	adrp	x0, l_alloc_f2807348af7bae36ef4ea76a85a54442@PAGE
Lloh5:
	add	x0, x0, l_alloc_f2807348af7bae36ef4ea76a85a54442@PAGEOFF
	bl	__RNvNtNtCs3bJEMBXHbwl_4core9panicking11panic_const23panic_const_rem_by_zero
Ltmp369:
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpAdd	Lloh4, Lloh5
Lfunc_end15:
	.cfi_endproc
	.file	29 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters" "map.rs"
	.file	30 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits" "iterator.rs"
	.file	31 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters" "filter.rs"

	.p2align	2
