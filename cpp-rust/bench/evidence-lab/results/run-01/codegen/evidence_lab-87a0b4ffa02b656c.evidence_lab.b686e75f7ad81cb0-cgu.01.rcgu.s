	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	.globl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	.p2align	2
__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable" "drift.rs"
	.loc	1 20 0
	.cfi_startproc
	stp	x28, x27, [sp, #-96]!
	.cfi_def_cfa_offset 96
	stp	x26, x25, [sp, #16]
	stp	x24, x23, [sp, #32]
	stp	x22, x21, [sp, #48]
	stp	x20, x19, [sp, #64]
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	sub	sp, sp, #736
	str	w4, [sp, #28]
Ltmp0:
	.loc	1 27 8 prologue_end
	cmp	x1, #2
	b.lo	LBB0_60
	.loc	1 0 8 is_stmt 0
	mov	x26, x5
	mov	x19, x1
	mov	x23, x0
	mov	x8, #4611686018427387904
Ltmp1:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "uint_macros.rs"
	.loc	2 3788 21 is_stmt 1
	udiv	x9, x8, x1
Ltmp2:
	.loc	2 3789 21
	mul	x10, x9, x1
Ltmp3:
	.loc	2 3790 16
	cmp	x10, x8
	cinc	x8, x9, ne
	str	x8, [sp, #32]
Ltmp4:
	.loc	1 37 31
	cmp	x1, #1, lsl #12
	str	x3, [sp, #120]
	str	x2, [sp, #104]
	b.hi	LBB0_3
	.loc	1 40 18
	sub	x8, x19, x19, lsr #1
Ltmp5:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src" "cmp.rs"
	.loc	3 1090 5
	mov	w9, #64
	cmp	x8, #64
	csel	x8, x8, x9, lo
	str	x8, [sp, #56]
	b	LBB0_4
Ltmp6:
LBB0_3:
	.loc	1 42 9
	mov	x0, x19
	bl	__RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift11sqrt_approx
	ldr	x3, [sp, #120]
	str	x0, [sp, #56]
LBB0_4:
	.loc	1 0 9 is_stmt 0
	mov	x21, #0
	mov	x25, #0
Ltmp7:
	.loc	1 57 5 is_stmt 1
	add	x9, x23, #16
	sub	x8, x23, #16
	stp	x8, x9, [sp, #8]
	sub	x8, x23, #8
	stp	x19, x8, [sp, #40]
	mov	w24, #1
	stp	x23, x26, [sp, #80]
Ltmp8:
	.loc	1 62 12
	subs	x9, x19, x21
	b.ls	LBB0_8
LBB0_5:
Ltmp9:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice" "index.rs"
	.loc	4 102 24
	add	x0, x23, x21, lsl #3
	ldr	x8, [sp, #56]
Ltmp10:
	.loc	1 234 8
	cmp	x9, x8
	b.hs	LBB0_9
LBB0_6:
	.loc	1 0 8 is_stmt 0
	ldr	w8, [sp, #28]
	.loc	1 249 8 is_stmt 1
	tbz	w8, #0, LBB0_12
Ltmp11:
	.loc	3 1090 5
	cmp	x9, #32
	mov	w8, #32
	csel	x26, x9, x8, lo
Ltmp12:
	.loc	1 255 9
	mov	x1, x26
	ldr	x2, [sp, #104]
	ldr	x3, [sp, #120]
	mov	w4, #0
	mov	x5, #0
	ldr	x6, [sp, #88]
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	ldr	x3, [sp, #120]
Ltmp13:
	.loc	1 281 14
	mov	w8, #1
	orr	x11, x8, x26, lsl #1
	ldr	x26, [sp, #88]
	b	LBB0_13
Ltmp14:
LBB0_8:
	.loc	1 0 14 is_stmt 0
	mov	w10, #0
	mov	w11, #1
	.loc	1 87 19 is_stmt 1
	cmp	x25, #2
	b.hs	LBB0_14
	b	LBB0_36
LBB0_9:
Ltmp15:
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared" "mod.rs"
	.loc	5 25 8
	cmp	x9, #2
	b.hs	LBB0_38
Ltmp16:
	.loc	5 0 8 is_stmt 0
	mov	x8, x9
LBB0_11:
Ltmp17:
	.loc	1 281 14 is_stmt 1
	mov	w9, #1
	orr	x11, x9, x8, lsl #1
Ltmp18:
	.loc	1 260 2
	b	LBB0_13
LBB0_12:
	.loc	1 0 2 is_stmt 0
	ldr	x8, [sp, #56]
Ltmp19:
	.loc	3 1090 5 is_stmt 1
	cmp	x9, x8
	csel	x8, x9, x8, lo
Ltmp20:
	.loc	1 286 14
	lsl	x11, x8, #1
Ltmp21:
LBB0_13:
	.loc	1 168 13
	lsl	x8, x21, #1
	sub	x9, x8, x24, lsr #1
Ltmp22:
	.loc	1 169 13
	add	x8, x8, x11, lsr #1
	ldr	x10, [sp, #32]
Ltmp23:
	.loc	1 170 6
	mul	x9, x9, x10
	.loc	1 170 27 is_stmt 0
	mul	x8, x8, x10
	.loc	1 170 5
	eor	x8, x8, x9
Ltmp24:
	.loc	2 154 20 is_stmt 1
	clz	x10, x8
Ltmp25:
	.loc	1 87 19
	cmp	x25, #2
	b.lo	LBB0_36
LBB0_14:
	.loc	1 0 19 is_stmt 0
	lsl	x8, x21, #3
	add	x19, x23, x8
	ldr	x9, [sp, #48]
	.loc	1 87 36
	add	x8, x9, x8
	stp	x8, x11, [sp, #64]
	str	x10, [sp, #112]
	str	x21, [sp, #96]
	b	LBB0_17
LBB0_15:
	.loc	1 0 36
	ldr	x23, [sp, #80]
Ltmp26:
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "const_ptr.rs"
	.loc	6 733 18 is_stmt 1
	sub	x2, x8, x1
Ltmp27:
	.file	7 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mod.rs"
	.loc	7 573 14
	mov	x0, x21
	bl	_memcpy
	ldr	x26, [sp, #88]
	ldp	x10, x3, [sp, #112]
Ltmp28:
LBB0_16:
	.loc	1 281 14
	mov	w8, #1
	orr	x24, x8, x20, lsl #1
	ldr	x21, [sp, #96]
Ltmp29:
	.loc	1 87 19
	cmp	x22, #1
	b.ls	LBB0_34
LBB0_17:
	.loc	1 87 56 is_stmt 0
	sub	x22, x25, #1
	.loc	1 87 36
	sub	x8, x29, #154
	ldrb	w8, [x8, x22]
	cmp	w8, w10
	b.lo	LBB0_35
	.loc	1 0 0
	mov	x25, x22
	.loc	1 90 28 is_stmt 1
	add	x8, sp, #128
	ldr	x8, [x8, x22, lsl #3]
Ltmp30:
	.loc	1 296 9
	lsr	x27, x8, #1
Ltmp31:
	.loc	1 296 9 is_stmt 0
	lsr	x28, x24, #1
Ltmp32:
	.loc	1 91 34 is_stmt 1
	add	x20, x27, x28
Ltmp33:
	.loc	1 204 9
	cmp	x20, x3
	b.hi	LBB0_21
	orr	w9, w8, w24
	tbnz	w9, #0, LBB0_21
Ltmp34:
	.loc	1 286 14
	lsl	x24, x20, #1
Ltmp35:
	.loc	1 87 19
	cmp	x22, #1
	b.hi	LBB0_17
	b	LBB0_34
LBB0_21:
Ltmp36:
	.loc	1 0 0 is_stmt 0
	sub	x9, x21, x20
Ltmp37:
	add	x21, x23, x9, lsl #3
Ltmp38:
	.loc	1 205 13 is_stmt 1
	tbz	w8, #0, LBB0_24
	.loc	1 208 13
	tbz	w24, #0, LBB0_25
LBB0_23:
Ltmp39:
	.file	8 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable" "merge.rs"
	.loc	8 16 8
	cbnz	x28, LBB0_26
	b	LBB0_16
Ltmp40:
LBB0_24:
	.loc	1 269 21
	orr	x8, x27, #0x1
Ltmp41:
	.file	9 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "nonzero.rs"
	.loc	9 598 21
	clz	x8, x8
Ltmp42:
	.loc	1 269 17
	lsl	w8, w8, #1
	eor	w4, w8, #0x7e
Ltmp43:
	.loc	1 270 5
	mov	x0, x21
	mov	x1, x27
	ldr	x2, [sp, #104]
	ldr	x3, [sp, #120]
	mov	x5, #0
	mov	x6, x26
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	ldp	x10, x3, [sp, #112]
Ltmp44:
	.loc	1 208 13
	tbnz	w24, #0, LBB0_23
LBB0_25:
Ltmp45:
	.loc	4 102 24
	add	x0, x21, x27, lsl #3
Ltmp46:
	.loc	1 269 21
	orr	x8, x28, #0x1
Ltmp47:
	.loc	9 598 21
	clz	x8, x8
Ltmp48:
	.loc	1 269 17
	lsl	w8, w8, #1
	eor	w4, w8, #0x7e
Ltmp49:
	.loc	1 270 5
	mov	x1, x28
	ldr	x2, [sp, #104]
	ldr	x3, [sp, #120]
	mov	x5, #0
	mov	x6, x26
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	ldp	x10, x3, [sp, #112]
Ltmp50:
	.loc	8 16 8
	cbz	x28, LBB0_16
LBB0_26:
	cbz	x27, LBB0_16
Ltmp51:
	.loc	3 1090 5
	cmp	x28, x27
	csel	x8, x28, x27, lo
Ltmp52:
	.loc	8 16 34
	cmp	x3, x8
	b.lo	LBB0_16
Ltmp53:
	.file	10 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mut_ptr.rs"
	.loc	10 970 18
	add	x26, x21, x27, lsl #3
Ltmp54:
	.loc	8 48 28
	cmp	x27, x28
	csel	x1, x26, x21, hi
Ltmp55:
	.loc	7 573 14
	lsl	x24, x8, #3
	ldr	x23, [sp, #104]
	mov	x0, x23
	mov	x2, x24
	bl	_memcpy
Ltmp56:
	.loc	10 970 18
	add	x8, x23, x24
Ltmp57:
	.loc	8 48 28
	cmp	x27, x28
Ltmp58:
	.loc	8 55 12
	b.ls	LBB0_32
	.loc	8 0 12 is_stmt 0
	ldr	x9, [sp, #64]
LBB0_30:
Ltmp59:
	.loc	8 122 36 is_stmt 1
	ldr	x10, [x8, #-8]!
	ldr	x11, [x26, #-8]!
Ltmp60:
	.file	11 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "f64.rs"
	.loc	11 1547 19
	asr	x12, x10, #63
	.loc	11 1547 9 is_stmt 0
	eor	x12, x10, x12, lsr #1
	.loc	11 1548 20 is_stmt 1
	asr	x13, x11, #63
	.loc	11 1548 9 is_stmt 0
	eor	x13, x11, x13, lsr #1
Ltmp61:
	.loc	3 410 44 is_stmt 1
	cmp	x12, x13
Ltmp62:
	.loc	8 124 27
	csel	x10, x11, x10, lt
Ltmp63:
	.loc	3 410 44
	cset	w11, lt
	cset	w12, ge
Ltmp64:
	.loc	7 573 14
	str	x10, [x9], #-8
Ltmp65:
	.loc	10 970 18
	add	x26, x26, w12, uxtw #3
Ltmp66:
	.loc	10 970 18 is_stmt 0
	add	x8, x8, w11, uxtw #3
Ltmp67:
	.loc	8 130 20 is_stmt 1
	cmp	x26, x21
	ccmp	x8, x23, #4, ne
	b.ne	LBB0_30
Ltmp68:
	.loc	8 0 20 is_stmt 0
	mov	x21, x26
	mov	x1, x23
	b	LBB0_15
LBB0_32:
	mov	x1, x23
LBB0_33:
Ltmp69:
	.loc	8 90 37 is_stmt 1
	ldr	x9, [x26]
	ldr	x10, [x1]
Ltmp70:
	.loc	11 1547 19
	asr	x11, x9, #63
	.loc	11 1547 9 is_stmt 0
	eor	x11, x9, x11, lsr #1
	.loc	11 1548 20 is_stmt 1
	asr	x12, x10, #63
	.loc	11 1548 9 is_stmt 0
	eor	x12, x10, x12, lsr #1
Ltmp71:
	.loc	3 410 44 is_stmt 1
	cmp	x11, x12
Ltmp72:
	.loc	8 92 30
	csel	x9, x9, x10, lt
Ltmp73:
	.loc	3 410 44
	cset	w10, lt
	cset	w11, ge
Ltmp74:
	.loc	7 573 14
	str	x9, [x21], #8
Ltmp75:
	.loc	10 970 18
	add	x1, x1, w11, uxtw #3
Ltmp76:
	.loc	6 871 18
	add	x26, x26, w10, uxtw #3
Ltmp77:
	.loc	8 89 19
	cmp	x1, x8
	ccmp	x26, x19, #4, ne
	b.ne	LBB0_33
	b	LBB0_15
Ltmp78:
LBB0_34:
	.loc	8 0 19 is_stmt 0
	mov	w25, #1
LBB0_35:
	ldr	x19, [sp, #40]
	ldr	x11, [sp, #72]
LBB0_36:
	.loc	1 103 13 is_stmt 1
	add	x8, sp, #128
	str	x24, [x8, x25, lsl #3]
	.loc	1 104 13
	sub	x8, x29, #154
	strb	w10, [x8, x25]
	.loc	1 109 12
	cmp	x19, x21
	b.ls	LBB0_58
	.loc	1 105 13
	add	x25, x25, #1
	.loc	1 113 9
	add	x21, x21, x11, lsr #1
	mov	x24, x11
	.loc	1 62 12
	subs	x9, x19, x21
	b.ls	LBB0_8
	b	LBB0_5
LBB0_38:
Ltmp79:
	.loc	5 34 35
	ldp	x8, x12, [x0]
Ltmp80:
	.loc	11 1547 19
	asr	x10, x12, #63
	.loc	11 1547 9 is_stmt 0
	eor	x10, x12, x10, lsr #1
	.loc	11 1548 20 is_stmt 1
	asr	x11, x8, #63
	.loc	11 1548 9 is_stmt 0
	eor	x11, x8, x11, lsr #1
Ltmp81:
	.loc	5 35 12 is_stmt 1
	cmp	x10, x11
	b.ge	LBB0_41
	.loc	5 36 19
	cmp	x9, #2
	b.ne	LBB0_44
	.loc	5 0 19 is_stmt 0
	mov	w9, #1
	mov	w8, #2
	.loc	5 36 19
	b	LBB0_51
LBB0_41:
	.loc	5 0 19
	mov	w8, #2
	.loc	5 40 19 is_stmt 1
	cmp	x9, #2
	b.eq	LBB0_11
LBB0_42:
	.loc	5 40 37 is_stmt 0
	ldr	x13, [x0, x8, lsl #3]
Ltmp82:
	.loc	11 1547 19 is_stmt 1
	asr	x14, x13, #63
	.loc	11 1547 9 is_stmt 0
	eor	x14, x13, x14, lsr #1
	.loc	11 1548 20 is_stmt 1
	asr	x15, x12, #63
	.loc	11 1548 9 is_stmt 0
	eor	x12, x12, x15, lsr #1
Ltmp83:
	.loc	5 40 37 is_stmt 1
	cmp	x14, x12
	b.lt	LBB0_48
	.loc	5 42 17
	add	x8, x8, #1
	mov	x12, x13
	.loc	5 40 19
	cmp	x9, x8
	b.ne	LBB0_42
	b	LBB0_47
LBB0_44:
	.loc	5 0 19 is_stmt 0
	mov	w8, #2
LBB0_45:
	.loc	5 36 36 is_stmt 1
	ldr	x13, [x0, x8, lsl #3]
Ltmp84:
	.loc	11 1547 19
	asr	x14, x13, #63
	.loc	11 1547 9 is_stmt 0
	eor	x14, x13, x14, lsr #1
	.loc	11 1548 20 is_stmt 1
	asr	x15, x12, #63
	.loc	11 1548 9 is_stmt 0
	eor	x12, x12, x15, lsr #1
Ltmp85:
	.loc	5 36 36 is_stmt 1
	cmp	x14, x12
	b.ge	LBB0_48
	.loc	5 37 17
	add	x8, x8, #1
	mov	x12, x13
	.loc	5 36 19
	cmp	x9, x8
	b.ne	LBB0_45
Ltmp86:
LBB0_47:
	.loc	5 0 19 is_stmt 0
	mov	x8, x9
LBB0_48:
	ldr	x12, [sp, #56]
Ltmp87:
	.loc	1 240 12 is_stmt 1
	cmp	x8, x12
	b.lo	LBB0_6
	.loc	1 241 16
	cmp	x10, x11
	b.ge	LBB0_11
Ltmp88:
	.file	12 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice" "mod.rs"
	.loc	12 978 24
	lsr	x9, x8, #1
Ltmp89:
	.loc	12 1013 19
	cbz	x9, LBB0_11
LBB0_51:
	.loc	12 1014 43
	cmp	x9, #4
	b.hs	LBB0_53
	.loc	12 0 43 is_stmt 0
	mov	x10, #0
	.loc	12 1014 43
	b	LBB0_56
LBB0_53:
	.loc	12 0 43
	and	x10, x9, #0x7ffffffffffffffc
	.loc	12 1014 43
	lsl	x12, x21, #3
	ldp	x13, x11, [sp, #8]
	add	x11, x11, x12
	add	x12, x12, x8, lsl #3
	add	x12, x13, x12
	and	x13, x9, #0x7ffffffffffffffc
LBB0_54:
Ltmp90:
	.file	13 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem" "mod.rs"
	.loc	13 833 14 is_stmt 1
	ldp	q0, q1, [x11, #-16]
	ldp	q3, q2, [x12, #-16]
	ext.16b	v2, v2, v2, #8
	ext.16b	v3, v3, v3, #8
	stp	q2, q3, [x11, #-16]
	ext.16b	v0, v0, v0, #8
	ext.16b	v1, v1, v1, #8
	stp	q1, q0, [x12, #-16]
Ltmp91:
	.loc	12 1013 19
	add	x11, x11, #32
	sub	x12, x12, #32
	sub	x13, x13, #4
	cbnz	x13, LBB0_54
	cmp	x9, x10
	b.eq	LBB0_11
LBB0_56:
	.loc	12 1013 19
	sub	x9, x9, x10
	lsl	x11, x21, #3
	lsl	x12, x10, #3
	add	x10, x11, x12
	add	x10, x23, x10
	add	x11, x11, x8, lsl #3
	sub	x11, x11, x12
	ldr	x12, [sp, #48]
	add	x11, x12, x11
LBB0_57:
Ltmp92:
	.loc	13 833 14
	ldr	d0, [x10]
	ldr	x12, [x11]
	str	x12, [x10], #8
	str	d0, [x11], #-8
Ltmp93:
	.loc	12 1013 19
	subs	x9, x9, #1
	b.ne	LBB0_57
	b	LBB0_11
Ltmp94:
LBB0_58:
	.loc	1 117 9
	tbnz	w24, #0, LBB0_60
Ltmp95:
	.loc	1 269 21
	orr	x8, x19, #0x1
Ltmp96:
	.loc	9 598 21
	clz	x8, x8
Ltmp97:
	.loc	1 269 17
	lsl	w8, w8, #1
	eor	w4, w8, #0x7e
Ltmp98:
	.loc	1 270 5
	mov	x0, x23
	mov	x1, x19
	ldr	x2, [sp, #104]
	mov	x5, #0
	mov	x6, x26
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
Ltmp99:
LBB0_60:
	.loc	1 120 2 epilogue_begin
	add	sp, sp, #736
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
Ltmp100:
Lfunc_end0:
	.cfi_endproc
	.file	14 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops" "function.rs"
	.file	15 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"

	.section	__DWARF,__debug_abbrev,regular,debug
Lsection_abbrev:
	.byte	1
	.byte	17
	.byte	1
	.byte	37
	.byte	14
	.byte	19
	.byte	5
	.byte	3
	.byte	14
	.byte	16
	.byte	23
	.byte	27
	.byte	14
	.ascii	"\341\177"
	.byte	25
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	0
	.byte	0
	.byte	2
	.byte	57
	.byte	1
	.byte	3
	.byte	14
	.byte	0
	.byte	0
	.byte	3
	.byte	46
	.byte	0
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.ascii	"\341\177"
	.byte	25
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	4
	.byte	46
	.byte	0
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.ascii	"\341\177"
	.byte	25
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	5
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.ascii	"\341\177"
	.byte	25
	.byte	0
	.byte	0
	.byte	6
	.byte	29
	.byte	1
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	7
	.byte	29
	.byte	0
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	8
	.byte	29
	.byte	0
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	9
	.byte	29
	.byte	1
	.byte	49
	.byte	19
	.byte	85
	.byte	23
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	10
	.byte	29
	.byte	1
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	11
	.byte	29
	.byte	0
	.byte	49
	.byte	19
	.byte	85
	.byte	23
	.byte	88
	.byte	11
	.byte	89
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	12
	.byte	29
	.byte	1
	.byte	49
	.byte	16
	.byte	85
	.byte	23
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	13
	.byte	29
	.byte	1
	.byte	49
	.byte	16
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	14
	.byte	29
	.byte	1
	.byte	49
	.byte	16
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	15
	.byte	29
	.byte	0
	.byte	49
	.byte	16
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	16
	.byte	29
	.byte	0
	.byte	49
	.byte	16
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	17
	.byte	29
	.byte	0
	.byte	49
	.byte	16
	.byte	85
	.byte	23
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	18
	.byte	29
	.byte	1
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.ascii	"\266B"
	.byte	11
	.byte	0
	.byte	0
	.byte	19
	.byte	46
	.byte	0
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.byte	54
	.byte	11
	.ascii	"\341\177"
	.byte	25
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	20
	.byte	46
	.byte	0
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	54
	.byte	11
	.ascii	"\341\177"
	.byte	25
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	21
	.byte	17
	.byte	1
	.byte	37
	.byte	14
	.byte	19
	.byte	5
	.byte	3
	.byte	14
	.byte	16
	.byte	23
	.byte	27
	.byte	14
	.ascii	"\341\177"
	.byte	25
	.byte	0
	.byte	0
	.byte	0
	.section	__DWARF,__debug_info,regular,debug
Lsection_info:
Lcu_begin0:
Lset0 = Ldebug_info_end0-Ldebug_info_start0
	.long	Lset0
Ldebug_info_start0:
	.short	4
Lset1 = Lsection_abbrev-Lsection_abbrev
	.long	Lset1
	.byte	8
	.byte	1
	.long	0
	.short	28
	.long	57
Lset2 = Lline_table_start0-Lsection_line
	.long	Lset2
	.long	107

	.quad	Lfunc_begin0
Lset3 = Lfunc_end0-Lfunc_begin0
	.long	Lset3
	.byte	2
	.long	169
	.byte	2
	.long	174
	.byte	2
	.long	178
	.byte	3
	.long	187
	.long	231
	.byte	2
	.short	3787

	.byte	1
	.byte	4
	.long	1897
	.long	1947
	.byte	2
	.byte	153

	.byte	1
	.byte	0
	.byte	2
	.long	3622
	.byte	2
	.long	3630
	.byte	3
	.long	3638
	.long	1947
	.byte	9
	.short	595

	.byte	1
	.byte	3
	.long	3714
	.long	3781
	.byte	9
	.short	1801

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	3787
	.byte	3
	.long	3797
	.long	3847
	.byte	2
	.short	1931

	.byte	1
	.byte	3
	.long	3861
	.long	3781
	.byte	2
	.short	1808

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	240
	.byte	2
	.long	246
	.byte	2
	.long	251
	.byte	2
	.long	258
	.byte	4
	.long	264
	.long	345
	.byte	1
	.byte	156

	.byte	1
	.byte	4
	.long	1022
	.long	1190
	.byte	1
	.byte	226

	.byte	1
	.byte	2
	.long	1300
	.byte	3
	.long	1313
	.long	1401
	.byte	1
	.short	280

	.byte	1
	.byte	3
	.long	1703
	.long	1793
	.byte	1
	.short	285

	.byte	1
	.byte	3
	.long	1313
	.long	1401
	.byte	1
	.short	280

	.byte	1
	.byte	3
	.long	3248
	.long	3328
	.byte	1
	.short	295

	.byte	1
	.byte	3
	.long	1703
	.long	1793
	.byte	1
	.short	285

	.byte	1
	.byte	0
	.byte	4
	.long	1806
	.long	1880
	.byte	1
	.byte	167

	.byte	1
	.byte	4
	.long	2857
	.long	3028
	.byte	1
	.byte	191

	.byte	1
	.byte	3
	.long	3332
	.long	3506
	.byte	1
	.short	262

	.byte	1
	.byte	5
	.quad	Lfunc_begin0
Lset4 = Lfunc_end0-Lfunc_begin0
	.long	Lset4
	.byte	1
	.byte	109
	.long	5560
	.long	5456
	.byte	1
	.byte	20

	.byte	6
	.long	174
	.quad	Ltmp1
Lset5 = Ltmp4-Ltmp1
	.long	Lset5
	.byte	1
	.byte	30
	.byte	24
	.byte	7
	.long	57
	.quad	Ltmp1
Lset6 = Ltmp4-Ltmp1
	.long	Lset6
	.byte	1
	.byte	161
	.byte	18
	.byte	0
	.byte	6
	.long	2105
	.quad	Ltmp5
Lset7 = Ltmp6-Ltmp5
	.long	Lset7
	.byte	1
	.byte	40
	.byte	9
	.byte	8
	.long	2091
	.quad	Ltmp5
Lset8 = Ltmp6-Ltmp5
	.long	Lset8
	.byte	3
	.short	1587
	.byte	8
	.byte	0
	.byte	6
	.long	2004
	.quad	Ltmp9
Lset9 = Ltmp10-Ltmp9
	.long	Lset9
	.byte	1
	.byte	64
	.byte	34
	.byte	6
	.long	1972
	.quad	Ltmp9
Lset10 = Ltmp10-Ltmp9
	.long	Lset10
	.byte	4
	.byte	32
	.byte	15
	.byte	8
	.long	1955
	.quad	Ltmp9
Lset11 = Ltmp10-Ltmp9
	.long	Lset11
	.byte	4
	.short	563
	.byte	19
	.byte	0
	.byte	0
	.byte	9
	.long	186
Lset12 = Ldebug_ranges0-Ldebug_range
	.long	Lset12
	.byte	1
	.byte	64
	.byte	17
	.byte	6
	.long	2118
	.quad	Ltmp11
Lset13 = Ltmp12-Ltmp11
	.long	Lset13
	.byte	1
	.byte	254
	.byte	29
	.byte	8
	.long	2091
	.quad	Ltmp11
Lset14 = Ltmp12-Ltmp11
	.long	Lset14
	.byte	3
	.short	1587
	.byte	8
	.byte	0
	.byte	8
	.long	203
	.quad	Ltmp13
Lset15 = Ltmp14-Ltmp13
	.long	Lset15
	.byte	1
	.short	256
	.byte	9
	.byte	9
	.long	1936
Lset16 = Ldebug_ranges1-Ldebug_range
	.long	Lset16
	.byte	1
	.byte	235
	.byte	39
	.byte	6
	.long	2229
	.quad	Ltmp80
Lset17 = Ltmp81-Ltmp80
	.long	Lset17
	.byte	5
	.byte	34
	.byte	35
	.byte	6
	.long	2173
	.quad	Ltmp80
Lset18 = Ltmp81-Ltmp80
	.long	Lset18
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2142
	.quad	Ltmp80
Lset19 = Ltmp81-Ltmp80
	.long	Lset19
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	0
	.byte	6
	.long	2229
	.quad	Ltmp82
Lset20 = Ltmp83-Ltmp82
	.long	Lset20
	.byte	5
	.byte	40
	.byte	37
	.byte	6
	.long	2173
	.quad	Ltmp82
Lset21 = Ltmp83-Ltmp82
	.long	Lset21
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2142
	.quad	Ltmp82
Lset22 = Ltmp83-Ltmp82
	.long	Lset22
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	0
	.byte	6
	.long	2229
	.quad	Ltmp84
Lset23 = Ltmp85-Ltmp84
	.long	Lset23
	.byte	5
	.byte	36
	.byte	36
	.byte	6
	.long	2173
	.quad	Ltmp84
Lset24 = Ltmp85-Ltmp84
	.long	Lset24
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2142
	.quad	Ltmp84
Lset25 = Ltmp85-Ltmp84
	.long	Lset25
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.long	203
	.quad	Ltmp17
Lset26 = Ltmp18-Ltmp17
	.long	Lset26
	.byte	1
	.byte	245
	.byte	20
	.byte	6
	.long	2047
	.quad	Ltmp88
Lset27 = Ltmp94-Ltmp88
	.long	Lset27
	.byte	1
	.byte	242
	.byte	30
	.byte	10
	.long	2065
	.quad	Ltmp89
Lset28 = Ltmp94-Ltmp89
	.long	Lset28
	.byte	12
	.short	997
	.byte	9
	.byte	11
	.long	2194
Lset29 = Ldebug_ranges2-Ldebug_range
	.long	Lset29
	.byte	12
	.short	1014
	.byte	17
	.byte	0
	.byte	0
	.byte	10
	.long	2118
	.quad	Ltmp19
Lset30 = Ltmp20-Ltmp19
	.long	Lset30
	.byte	1
	.short	258
	.byte	36
	.byte	8
	.long	2091
	.quad	Ltmp19
Lset31 = Ltmp20-Ltmp19
	.long	Lset31
	.byte	3
	.short	1587
	.byte	8
	.byte	0
	.byte	8
	.long	216
	.quad	Ltmp20
Lset32 = Ltmp21-Ltmp20
	.long	Lset32
	.byte	1
	.short	258
	.byte	9
	.byte	0
	.byte	6
	.long	269
	.quad	Ltmp21
Lset33 = Ltmp25-Ltmp21
	.long	Lset33
	.byte	1
	.byte	65
	.byte	29
	.byte	7
	.long	70
	.quad	Ltmp24
Lset34 = Ltmp25-Ltmp24
	.long	Lset34
	.byte	1
	.byte	170
	.byte	47
	.byte	0
	.byte	9
	.long	281
Lset35 = Ldebug_ranges3-Ldebug_range
	.long	Lset35
	.byte	1
	.byte	94
	.byte	28
	.byte	12
	.long	2493
Lset36 = Ldebug_ranges4-Ldebug_range
	.long	Lset36
	.byte	1
	.byte	211
	.byte	9
	.byte	13
	.long	2389
	.quad	Ltmp26
Lset37 = Ltmp28-Ltmp26
	.long	Lset37
	.byte	8
	.byte	62
	.byte	5
	.byte	14
	.long	2480
	.quad	Ltmp26
Lset38 = Ltmp28-Ltmp26
	.long	Lset38
	.byte	7
	.short	847
	.byte	1
	.byte	13
	.long	2335
	.quad	Ltmp26
Lset39 = Ltmp27-Ltmp26
	.long	Lset39
	.byte	8
	.byte	146
	.byte	32
	.byte	15
	.long	2297
	.quad	Ltmp26
Lset40 = Ltmp27-Ltmp26
	.long	Lset40
	.byte	10
	.short	892
	.byte	37
	.byte	0
	.byte	16
	.long	2402
	.quad	Ltmp27
Lset41 = Ltmp28-Ltmp27
	.long	Lset41
	.byte	8
	.byte	147
	.byte	13
	.byte	0
	.byte	0
	.byte	16
	.long	2415
	.quad	Ltmp55
Lset42 = Ltmp56-Ltmp55
	.long	Lset42
	.byte	8
	.byte	51
	.byte	9
	.byte	16
	.long	2348
	.quad	Ltmp56
Lset43 = Ltmp57-Ltmp56
	.long	Lset43
	.byte	8
	.byte	53
	.byte	65
	.byte	13
	.long	2510
	.quad	Ltmp59
Lset44 = Ltmp68-Ltmp59
	.long	Lset44
	.byte	8
	.byte	58
	.byte	25
	.byte	12
	.long	2676
Lset45 = Ldebug_ranges5-Ldebug_range
	.long	Lset45
	.byte	8
	.byte	122
	.byte	36
	.byte	13
	.long	2639
	.quad	Ltmp60
Lset46 = Ltmp61-Ltmp60
	.long	Lset46
	.byte	15
	.byte	196
	.byte	34
	.byte	16
	.long	2608
	.quad	Ltmp60
Lset47 = Ltmp61-Ltmp60
	.long	Lset47
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	17
	.long	2583
Lset48 = Ldebug_ranges6-Ldebug_range
	.long	Lset48
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	16
	.long	2428
	.quad	Ltmp64
Lset49 = Ltmp65-Ltmp64
	.long	Lset49
	.byte	8
	.byte	125
	.byte	17
	.byte	16
	.long	2361
	.quad	Ltmp65
Lset50 = Ltmp66-Ltmp65
	.long	Lset50
	.byte	8
	.byte	127
	.byte	33
	.byte	16
	.long	2361
	.quad	Ltmp66
Lset51 = Ltmp67-Ltmp66
	.long	Lset51
	.byte	8
	.byte	128
	.byte	34
	.byte	0
	.byte	13
	.long	2523
	.quad	Ltmp69
Lset52 = Ltmp78-Ltmp69
	.long	Lset52
	.byte	8
	.byte	56
	.byte	25
	.byte	12
	.long	2676
Lset53 = Ldebug_ranges7-Ldebug_range
	.long	Lset53
	.byte	8
	.byte	90
	.byte	37
	.byte	13
	.long	2639
	.quad	Ltmp70
Lset54 = Ltmp71-Ltmp70
	.long	Lset54
	.byte	15
	.byte	196
	.byte	34
	.byte	16
	.long	2608
	.quad	Ltmp70
Lset55 = Ltmp71-Ltmp70
	.long	Lset55
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	17
	.long	2583
Lset56 = Ldebug_ranges8-Ldebug_range
	.long	Lset56
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	16
	.long	2441
	.quad	Ltmp74
Lset57 = Ltmp75-Ltmp74
	.long	Lset57
	.byte	8
	.byte	93
	.byte	17
	.byte	16
	.long	2374
	.quad	Ltmp75
Lset58 = Ltmp76-Ltmp75
	.long	Lset58
	.byte	8
	.byte	95
	.byte	30
	.byte	16
	.long	2310
	.quad	Ltmp76
Lset59 = Ltmp77-Ltmp76
	.long	Lset59
	.byte	8
	.byte	96
	.byte	31
	.byte	0
	.byte	16
	.long	2348
	.quad	Ltmp53
Lset60 = Ltmp54-Ltmp53
	.long	Lset60
	.byte	8
	.byte	41
	.byte	28
	.byte	13
	.long	2565
	.quad	Ltmp51
Lset61 = Ltmp52-Ltmp51
	.long	Lset61
	.byte	8
	.byte	16
	.byte	50
	.byte	15
	.long	2551
	.quad	Ltmp51
Lset62 = Ltmp52-Ltmp51
	.long	Lset62
	.byte	3
	.short	1587
	.byte	8
	.byte	0
	.byte	0
	.byte	7
	.long	229
	.quad	Ltmp28
Lset63 = Ltmp29-Ltmp28
	.long	Lset63
	.byte	1
	.byte	213
	.byte	9
	.byte	7
	.long	255
	.quad	Ltmp34
Lset64 = Ltmp35-Ltmp34
	.long	Lset64
	.byte	1
	.byte	215
	.byte	9
	.byte	6
	.long	293
	.quad	Ltmp40
Lset65 = Ltmp44-Ltmp40
	.long	Lset65
	.byte	1
	.byte	206
	.byte	13
	.byte	10
	.long	139
	.quad	Ltmp41
Lset66 = Ltmp42-Ltmp41
	.long	Lset66
	.byte	1
	.short	269
	.byte	35
	.byte	10
	.long	126
	.quad	Ltmp41
Lset67 = Ltmp42-Ltmp41
	.long	Lset67
	.byte	2
	.short	1809
	.byte	37
	.byte	10
	.long	106
	.quad	Ltmp41
Lset68 = Ltmp42-Ltmp41
	.long	Lset68
	.byte	2
	.short	1933
	.byte	35
	.byte	8
	.long	93
	.quad	Ltmp41
Lset69 = Ltmp42-Ltmp41
	.long	Lset69
	.byte	9
	.short	1802
	.byte	35
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.long	2016
	.quad	Ltmp45
Lset70 = Ltmp46-Ltmp45
	.long	Lset70
	.byte	1
	.byte	209
	.byte	36
	.byte	18
	.long	1985
	.quad	Ltmp45
Lset71 = Ltmp46-Ltmp45
	.long	Lset71
	.byte	4
	.byte	32
	.byte	15
	.byte	2
	.byte	8
	.long	2029
	.quad	Ltmp45
Lset72 = Ltmp46-Ltmp45
	.long	Lset72
	.byte	4
	.short	563
	.byte	19
	.byte	0
	.byte	0
	.byte	6
	.long	293
	.quad	Ltmp46
Lset73 = Ltmp50-Ltmp46
	.long	Lset73
	.byte	1
	.byte	209
	.byte	13
	.byte	10
	.long	139
	.quad	Ltmp47
Lset74 = Ltmp48-Ltmp47
	.long	Lset74
	.byte	1
	.short	269
	.byte	35
	.byte	10
	.long	126
	.quad	Ltmp47
Lset75 = Ltmp48-Ltmp47
	.long	Lset75
	.byte	2
	.short	1809
	.byte	37
	.byte	10
	.long	106
	.quad	Ltmp47
Lset76 = Ltmp48-Ltmp47
	.long	Lset76
	.byte	2
	.short	1933
	.byte	35
	.byte	8
	.long	93
	.quad	Ltmp47
Lset77 = Ltmp48-Ltmp47
	.long	Lset77
	.byte	9
	.short	1802
	.byte	35
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.long	242
	.quad	Ltmp30
Lset78 = Ltmp31-Ltmp30
	.long	Lset78
	.byte	1
	.byte	91
	.byte	39
	.byte	7
	.long	242
	.quad	Ltmp31
Lset79 = Ltmp32-Ltmp31
	.long	Lset79
	.byte	1
	.byte	91
	.byte	56
	.byte	6
	.long	293
	.quad	Ltmp95
Lset80 = Ltmp99-Ltmp95
	.long	Lset80
	.byte	1
	.byte	118
	.byte	9
	.byte	10
	.long	139
	.quad	Ltmp96
Lset81 = Ltmp97-Ltmp96
	.long	Lset81
	.byte	1
	.short	269
	.byte	35
	.byte	10
	.long	126
	.quad	Ltmp96
Lset82 = Ltmp97-Ltmp96
	.long	Lset82
	.byte	2
	.short	1809
	.byte	37
	.byte	10
	.long	106
	.quad	Ltmp96
Lset83 = Ltmp97-Ltmp96
	.long	Lset83
	.byte	2
	.short	1933
	.byte	35
	.byte	8
	.long	93
	.quad	Ltmp96
Lset84 = Ltmp97-Ltmp96
	.long	Lset84
	.byte	9
	.short	1802
	.byte	35
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1412
	.byte	4
	.long	1419
	.long	1586
	.byte	5
	.byte	20

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	523
	.byte	4
	.long	529
	.long	630
	.byte	4
	.byte	95

	.byte	1
	.byte	2
	.long	664
	.byte	3
	.long	673
	.long	808
	.byte	4
	.short	556

	.byte	1
	.byte	3
	.long	673
	.long	808
	.byte	4
	.short	556

	.byte	1
	.byte	0
	.byte	2
	.long	823
	.byte	4
	.long	832
	.long	971
	.byte	4
	.byte	31

	.byte	1
	.byte	4
	.long	832
	.long	971
	.byte	4
	.byte	31

	.byte	1
	.byte	0
	.byte	4
	.long	529
	.long	630
	.byte	4
	.byte	95

	.byte	1
	.byte	0
	.byte	2
	.long	2025
	.byte	3
	.long	5187
	.long	5258
	.byte	12
	.short	977

	.byte	1
	.byte	2
	.long	5271
	.byte	3
	.long	5279
	.long	5363
	.byte	12
	.short	1000

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	369
	.byte	2
	.long	373
	.byte	3
	.long	377
	.long	447
	.byte	3
	.short	1085

	.byte	1
	.byte	0
	.byte	3
	.long	458
	.long	447
	.byte	3
	.short	1586

	.byte	1
	.byte	3
	.long	458
	.long	447
	.byte	3
	.short	1586

	.byte	1
	.byte	0
	.byte	2
	.long	4295
	.byte	2
	.long	2025
	.byte	19
	.long	4299
	.long	4341
	.byte	11
	.short	1521
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	4351
	.byte	2
	.long	4355
	.byte	2
	.long	4364
	.byte	20
	.long	4370
	.long	4490
	.byte	14
	.byte	166
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	5376
	.byte	3
	.long	5380
	.long	5446
	.byte	13
	.short	830

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	4552
	.byte	2
	.long	240
	.byte	2
	.long	2025
	.byte	2
	.long	4558
	.byte	20
	.long	4566
	.long	4682
	.byte	15
	.byte	196
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end0:
Lcu_begin1:
Lset85 = Ldebug_info_end1-Ldebug_info_start1
	.long	Lset85
Ldebug_info_start1:
	.short	4
Lset86 = Lsection_abbrev-Lsection_abbrev
	.long	Lset86
	.byte	8
	.byte	21
	.long	0
	.short	28
	.long	1961
Lset87 = Lline_table_start0-Lsection_line
	.long	Lset87
	.long	107

	.byte	2
	.long	169
	.byte	2
	.long	2011
	.byte	2
	.long	2015
	.byte	2
	.long	2025
	.byte	3
	.long	2034
	.long	2129
	.byte	6
	.short	705

	.byte	1
	.byte	3
	.long	5110
	.long	3977
	.byte	6
	.short	837

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	2155
	.byte	2
	.long	2025
	.byte	3
	.long	2163
	.long	2129
	.byte	10
	.short	887

	.byte	1
	.byte	3
	.long	3902
	.long	3977
	.byte	10
	.short	936

	.byte	1
	.byte	3
	.long	3902
	.long	3977
	.byte	10
	.short	936

	.byte	1
	.byte	3
	.long	3902
	.long	3977
	.byte	10
	.short	936

	.byte	1
	.byte	0
	.byte	0
	.byte	3
	.long	2407
	.long	2529
	.byte	7
	.short	847

	.byte	1
	.byte	3
	.long	3141
	.long	3223
	.byte	7
	.short	552

	.byte	1
	.byte	3
	.long	3141
	.long	3223
	.byte	7
	.short	552

	.byte	1
	.byte	3
	.long	3141
	.long	3223
	.byte	7
	.short	552

	.byte	1
	.byte	3
	.long	3141
	.long	3223
	.byte	7
	.short	552

	.byte	1
	.byte	0
	.byte	2
	.long	240
	.byte	2
	.long	246
	.byte	2
	.long	251
	.byte	2
	.long	2256
	.byte	2
	.long	823
	.byte	4
	.long	2262
	.long	2397
	.byte	8
	.byte	139

	.byte	1
	.byte	0
	.byte	4
	.long	2590
	.long	2752
	.byte	8
	.byte	8

	.byte	1
	.byte	2
	.long	3986
	.byte	20
	.long	3997
	.long	4185
	.byte	8
	.byte	108
	.byte	3

	.byte	1
	.byte	20
	.long	4817
	.long	5002
	.byte	8
	.byte	78
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	369
	.byte	2
	.long	373
	.byte	3
	.long	377
	.long	447
	.byte	3
	.short	1085

	.byte	1
	.byte	0
	.byte	3
	.long	458
	.long	447
	.byte	3
	.short	1586

	.byte	1
	.byte	2
	.long	4738
	.byte	3
	.long	4748
	.long	4814
	.byte	3
	.short	410

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	4295
	.byte	2
	.long	2025
	.byte	19
	.long	4299
	.long	4341
	.byte	11
	.short	1521
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	4351
	.byte	2
	.long	4355
	.byte	2
	.long	4364
	.byte	20
	.long	4370
	.long	4490
	.byte	14
	.byte	166
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	4552
	.byte	2
	.long	240
	.byte	2
	.long	2025
	.byte	2
	.long	4558
	.byte	20
	.long	4566
	.long	4682
	.byte	15
	.byte	196
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end1:
	.section	__TEXT,__text,regular,pure_instructions
Lsec_end0:
	.section	__DWARF,__debug_aranges,regular,debug
	.long	44
	.short	2
Lset88 = Lcu_begin0-Lsection_info
	.long	Lset88
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset89 = Lsec_end0-Lfunc_begin0
	.quad	Lset89
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset90 = Ltmp10-Lfunc_begin0
	.quad	Lset90
Lset91 = Ltmp14-Lfunc_begin0
	.quad	Lset91
Lset92 = Ltmp15-Lfunc_begin0
	.quad	Lset92
Lset93 = Ltmp21-Lfunc_begin0
	.quad	Lset93
Lset94 = Ltmp79-Lfunc_begin0
	.quad	Lset94
Lset95 = Ltmp94-Lfunc_begin0
	.quad	Lset95
	.quad	0
	.quad	0
Ldebug_ranges1:
Lset96 = Ltmp15-Lfunc_begin0
	.quad	Lset96
Lset97 = Ltmp16-Lfunc_begin0
	.quad	Lset97
Lset98 = Ltmp79-Lfunc_begin0
	.quad	Lset98
Lset99 = Ltmp86-Lfunc_begin0
	.quad	Lset99
	.quad	0
	.quad	0
Ldebug_ranges2:
Lset100 = Ltmp90-Lfunc_begin0
	.quad	Lset100
Lset101 = Ltmp91-Lfunc_begin0
	.quad	Lset101
Lset102 = Ltmp92-Lfunc_begin0
	.quad	Lset102
Lset103 = Ltmp93-Lfunc_begin0
	.quad	Lset103
	.quad	0
	.quad	0
Ldebug_ranges3:
Lset104 = Ltmp26-Lfunc_begin0
	.quad	Lset104
Lset105 = Ltmp29-Lfunc_begin0
	.quad	Lset105
Lset106 = Ltmp33-Lfunc_begin0
	.quad	Lset106
Lset107 = Ltmp35-Lfunc_begin0
	.quad	Lset107
Lset108 = Ltmp38-Lfunc_begin0
	.quad	Lset108
Lset109 = Ltmp78-Lfunc_begin0
	.quad	Lset109
	.quad	0
	.quad	0
Ldebug_ranges4:
Lset110 = Ltmp26-Lfunc_begin0
	.quad	Lset110
Lset111 = Ltmp28-Lfunc_begin0
	.quad	Lset111
Lset112 = Ltmp39-Lfunc_begin0
	.quad	Lset112
Lset113 = Ltmp40-Lfunc_begin0
	.quad	Lset113
Lset114 = Ltmp50-Lfunc_begin0
	.quad	Lset114
Lset115 = Ltmp78-Lfunc_begin0
	.quad	Lset115
	.quad	0
	.quad	0
Ldebug_ranges5:
Lset116 = Ltmp60-Lfunc_begin0
	.quad	Lset116
Lset117 = Ltmp62-Lfunc_begin0
	.quad	Lset117
Lset118 = Ltmp63-Lfunc_begin0
	.quad	Lset118
Lset119 = Ltmp64-Lfunc_begin0
	.quad	Lset119
	.quad	0
	.quad	0
Ldebug_ranges6:
Lset120 = Ltmp61-Lfunc_begin0
	.quad	Lset120
Lset121 = Ltmp62-Lfunc_begin0
	.quad	Lset121
Lset122 = Ltmp63-Lfunc_begin0
	.quad	Lset122
Lset123 = Ltmp64-Lfunc_begin0
	.quad	Lset123
	.quad	0
	.quad	0
Ldebug_ranges7:
Lset124 = Ltmp70-Lfunc_begin0
	.quad	Lset124
Lset125 = Ltmp72-Lfunc_begin0
	.quad	Lset125
Lset126 = Ltmp73-Lfunc_begin0
	.quad	Lset126
Lset127 = Ltmp74-Lfunc_begin0
	.quad	Lset127
	.quad	0
	.quad	0
Ldebug_ranges8:
Lset128 = Ltmp71-Lfunc_begin0
	.quad	Lset128
Lset129 = Ltmp72-Lfunc_begin0
	.quad	Lset129
Lset130 = Ltmp73-Lfunc_begin0
	.quad	Lset130
Lset131 = Ltmp74-Lfunc_begin0
	.quad	Lset131
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.01"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"core"
	.asciz	"num"
	.asciz	"{impl#9}"
	.asciz	"_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy8div_ceil"
	.asciz	"div_ceil"
	.asciz	"slice"
	.asciz	"sort"
	.asciz	"stable"
	.asciz	"drift"
	.asciz	"_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift23merge_tree_scale_factor"
	.asciz	"merge_tree_scale_factor"
	.asciz	"cmp"
	.asciz	"Ord"
	.asciz	"_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"min<usize>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"index"
	.asciz	"_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index28get_offset_len_mut_noubcheckdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"get_offset_len_mut_noubcheck<f64>"
	.asciz	"{impl#7}"
	.asciz	"_RNvXs5_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range9RangeFromjEINtB5_10SliceIndexSdE9index_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"index_mut<f64>"
	.asciz	"{impl#1}"
	.asciz	"_RNvXs_NtNtCsjIpoRzUjyHQ_4core5slice5indexSdINtNtNtB8_3ops5index8IndexMutINtNtBK_5range9RangeFromjEE9index_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"index_mut<f64, core::ops::range::RangeFrom<usize>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"create_run<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"DriftsortRun"
	.asciz	"_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun10new_sorted"
	.asciz	"new_sorted"
	.asciz	"shared"
	.asciz	"_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"find_existing_run<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun12new_unsorted"
	.asciz	"new_unsorted"
	.asciz	"_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift16merge_tree_depth"
	.asciz	"merge_tree_depth"
	.asciz	"_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy13leading_zeros"
	.asciz	"leading_zeros"
	.asciz	"src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.04"
	.asciz	"ptr"
	.asciz	"const_ptr"
	.asciz	"{impl#0}"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd20offset_from_unsignedCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"offset_from_unsigned<f64>"
	.asciz	"mut_ptr"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd20offset_from_unsignedCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"merge"
	.asciz	"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"drop<f64>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"drop_glue<core::slice::sort::stable::merge::MergeState<f64>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"logical_merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"copy_nonoverlapping<f64>"
	.asciz	"_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun3len"
	.asciz	"len"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift16stable_quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"stable_quicksort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"nonzero"
	.asciz	"NonZero"
	.asciz	"_RNvMs1f_NtNtCsjIpoRzUjyHQ_4core3num7nonzeroINtB6_7NonZerojE13leading_zeros"
	.asciz	"_RNvMs1f_NtNtCsjIpoRzUjyHQ_4core3num7nonzeroINtB6_7NonZerojE5ilog2"
	.asciz	"ilog2"
	.asciz	"{impl#11}"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13checked_ilog2"
	.asciz	"checked_ilog2"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj5ilog2"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"add<f64>"
	.asciz	"MergeState"
	.asciz	"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"merge_down<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"f64"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp"
	.asciz	"total_cmp"
	.asciz	"ops"
	.asciz	"function"
	.asciz	"FnMut"
	.asciz	"_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>"
	.asciz	"alloc"
	.asciz	"sort_by"
	.asciz	"_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0CsfFAnx7WYh7o_12evidence_lab"
	.asciz	"{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>"
	.asciz	"{impl#13}"
	.asciz	"_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq"
	.asciz	"eq"
	.asciz	"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"merge_up<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd7reverseCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"reverse<f64>"
	.asciz	"reverse"
	.asciz	"_RINvNvMNtCsjIpoRzUjyHQ_4core5sliceSp7reverse7revswapdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"revswap<f64>"
	.asciz	"mem"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3mem4swapdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"swap<f64>"
	.asciz	"sort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	35
	.long	71
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	1
	.long	4
	.long	-1
	.long	6
	.long	-1
	.long	10
	.long	12
	.long	-1
	.long	15
	.long	18
	.long	20
	.long	21
	.long	22
	.long	24
	.long	28
	.long	30
	.long	-1
	.long	31
	.long	32
	.long	35
	.long	-1
	.long	37
	.long	40
	.long	41
	.long	47
	.long	48
	.long	52
	.long	53
	.long	55
	.long	58
	.long	59
	.long	62
	.long	67
	.long	69
	.long	-1714173031
	.long	1152739981
	.long	-1258739380
	.long	-1046578025
	.long	-518045544
	.long	-501360624
	.long	2041624
	.long	1314328299
	.long	1842170859
	.long	-1004800867
	.long	-1975601570
	.long	-699684935
	.long	383088517
	.long	2126014842
	.long	-158655704
	.long	701239324
	.long	1019075689
	.long	-861415277
	.long	802570345
	.long	1827115265
	.long	-1765538810
	.long	1806087197
	.long	262679458
	.long	-270958553
	.long	1003917474
	.long	2144200779
	.long	-1857834892
	.long	-57759797
	.long	5863355
	.long	1916613700
	.long	1116636971
	.long	1596043103
	.long	205702824
	.long	-1758850827
	.long	-668322542
	.long	1597742495
	.long	-2012061826
	.long	239228802
	.long	-678578939
	.long	-151974049
	.long	1483294808
	.long	1072964539
	.long	-1616918787
	.long	-1356277882
	.long	-1267175162
	.long	-424342892
	.long	-51757882
	.long	-1198720446
	.long	1316798796
	.long	2070688471
	.long	-92348745
	.long	-15533895
	.long	193498052
	.long	1018032183
	.long	-1659755143
	.long	781274964
	.long	1294378954
	.long	-816418872
	.long	1567618355
	.long	-1973294975
	.long	-1465351560
	.long	-270857665
	.long	306328292
	.long	1535677672
	.long	1736053232
	.long	-2087322314
	.long	-559089349
	.long	524621298
	.long	-815279478
	.long	-1740281842
	.long	-708216122
Lset132 = LNames18-Lnames_begin
	.long	Lset132
Lset133 = LNames26-Lnames_begin
	.long	Lset133
Lset134 = LNames24-Lnames_begin
	.long	Lset134
Lset135 = LNames53-Lnames_begin
	.long	Lset135
Lset136 = LNames23-Lnames_begin
	.long	Lset136
Lset137 = LNames7-Lnames_begin
	.long	Lset137
Lset138 = LNames52-Lnames_begin
	.long	Lset138
Lset139 = LNames27-Lnames_begin
	.long	Lset139
Lset140 = LNames43-Lnames_begin
	.long	Lset140
Lset141 = LNames36-Lnames_begin
	.long	Lset141
Lset142 = LNames34-Lnames_begin
	.long	Lset142
Lset143 = LNames38-Lnames_begin
	.long	Lset143
Lset144 = LNames54-Lnames_begin
	.long	Lset144
Lset145 = LNames46-Lnames_begin
	.long	Lset145
Lset146 = LNames25-Lnames_begin
	.long	Lset146
Lset147 = LNames11-Lnames_begin
	.long	Lset147
Lset148 = LNames2-Lnames_begin
	.long	Lset148
Lset149 = LNames48-Lnames_begin
	.long	Lset149
Lset150 = LNames66-Lnames_begin
	.long	Lset150
Lset151 = LNames16-Lnames_begin
	.long	Lset151
Lset152 = LNames12-Lnames_begin
	.long	Lset152
Lset153 = LNames19-Lnames_begin
	.long	Lset153
Lset154 = LNames63-Lnames_begin
	.long	Lset154
Lset155 = LNames49-Lnames_begin
	.long	Lset155
Lset156 = LNames33-Lnames_begin
	.long	Lset156
Lset157 = LNames37-Lnames_begin
	.long	Lset157
Lset158 = LNames64-Lnames_begin
	.long	Lset158
Lset159 = LNames30-Lnames_begin
	.long	Lset159
Lset160 = LNames56-Lnames_begin
	.long	Lset160
Lset161 = LNames4-Lnames_begin
	.long	Lset161
Lset162 = LNames60-Lnames_begin
	.long	Lset162
Lset163 = LNames17-Lnames_begin
	.long	Lset163
Lset164 = LNames65-Lnames_begin
	.long	Lset164
Lset165 = LNames8-Lnames_begin
	.long	Lset165
Lset166 = LNames58-Lnames_begin
	.long	Lset166
Lset167 = LNames51-Lnames_begin
	.long	Lset167
Lset168 = LNames62-Lnames_begin
	.long	Lset168
Lset169 = LNames57-Lnames_begin
	.long	Lset169
Lset170 = LNames47-Lnames_begin
	.long	Lset170
Lset171 = LNames59-Lnames_begin
	.long	Lset171
Lset172 = LNames22-Lnames_begin
	.long	Lset172
Lset173 = LNames55-Lnames_begin
	.long	Lset173
Lset174 = LNames61-Lnames_begin
	.long	Lset174
Lset175 = LNames0-Lnames_begin
	.long	Lset175
Lset176 = LNames40-Lnames_begin
	.long	Lset176
Lset177 = LNames1-Lnames_begin
	.long	Lset177
Lset178 = LNames15-Lnames_begin
	.long	Lset178
Lset179 = LNames20-Lnames_begin
	.long	Lset179
Lset180 = LNames3-Lnames_begin
	.long	Lset180
Lset181 = LNames9-Lnames_begin
	.long	Lset181
Lset182 = LNames29-Lnames_begin
	.long	Lset182
Lset183 = LNames13-Lnames_begin
	.long	Lset183
Lset184 = LNames69-Lnames_begin
	.long	Lset184
Lset185 = LNames68-Lnames_begin
	.long	Lset185
Lset186 = LNames44-Lnames_begin
	.long	Lset186
Lset187 = LNames42-Lnames_begin
	.long	Lset187
Lset188 = LNames31-Lnames_begin
	.long	Lset188
Lset189 = LNames39-Lnames_begin
	.long	Lset189
Lset190 = LNames6-Lnames_begin
	.long	Lset190
Lset191 = LNames32-Lnames_begin
	.long	Lset191
Lset192 = LNames35-Lnames_begin
	.long	Lset192
Lset193 = LNames67-Lnames_begin
	.long	Lset193
Lset194 = LNames45-Lnames_begin
	.long	Lset194
Lset195 = LNames14-Lnames_begin
	.long	Lset195
Lset196 = LNames70-Lnames_begin
	.long	Lset196
Lset197 = LNames21-Lnames_begin
	.long	Lset197
Lset198 = LNames50-Lnames_begin
	.long	Lset198
Lset199 = LNames10-Lnames_begin
	.long	Lset199
Lset200 = LNames28-Lnames_begin
	.long	Lset200
Lset201 = LNames41-Lnames_begin
	.long	Lset201
Lset202 = LNames5-Lnames_begin
	.long	Lset202
LNames18:
	.long	1313
	.long	3
	.long	531
	.long	751
	.long	1459
	.long	0
LNames26:
	.long	4299
	.long	5
	.long	604
	.long	666
	.long	728
	.long	1154
	.long	1301
	.long	0
LNames24:
	.long	4370
	.long	5
	.long	584
	.long	646
	.long	708
	.long	1134
	.long	1281
	.long	0
LNames53:
	.long	3902
	.long	5
	.long	1082
	.long	1208
	.long	1228
	.long	1355
	.long	1396
	.long	0
LNames23:
	.long	4490
	.long	5
	.long	584
	.long	646
	.long	708
	.long	1134
	.long	1281
	.long	0
LNames7:
	.long	458
	.long	4
	.long	372
	.long	489
	.long	827
	.long	1416
	.long	0
LNames52:
	.long	3977
	.long	6
	.long	1082
	.long	1208
	.long	1228
	.long	1355
	.long	1375
	.long	1396
	.long	0
LNames27:
	.long	5258
	.long	1
	.long	771
	.long	0
LNames43:
	.long	2529
	.long	1
	.long	957
	.long	0
LNames36:
	.long	1806
	.long	1
	.long	892
	.long	0
LNames34:
	.long	1703
	.long	2
	.long	870
	.long	1479
	.long	0
LNames38:
	.long	1897
	.long	1
	.long	912
	.long	0
LNames54:
	.long	4185
	.long	1
	.long	1102
	.long	0
LNames46:
	.long	2262
	.long	1
	.long	977
	.long	0
LNames25:
	.long	4341
	.long	5
	.long	604
	.long	666
	.long	728
	.long	1154
	.long	1301
	.long	0
LNames11:
	.long	808
	.long	2
	.long	434
	.long	1627
	.long	0
LNames2:
	.long	345
	.long	1
	.long	331
	.long	0
LNames48:
	.long	2163
	.long	1
	.long	998
	.long	0
LNames66:
	.long	3797
	.long	3
	.long	1540
	.long	1712
	.long	1861
	.long	0
LNames16:
	.long	1022
	.long	1
	.long	477
	.long	0
LNames12:
	.long	673
	.long	2
	.long	434
	.long	1627
	.long	0
LNames19:
	.long	1586
	.long	1
	.long	552
	.long	0
LNames63:
	.long	3781
	.long	6
	.long	1519
	.long	1561
	.long	1691
	.long	1733
	.long	1840
	.long	1882
	.long	0
LNames49:
	.long	2034
	.long	1
	.long	1018
	.long	0
LNames33:
	.long	1793
	.long	2
	.long	870
	.long	1479
	.long	0
LNames37:
	.long	1947
	.long	4
	.long	912
	.long	1582
	.long	1754
	.long	1903
	.long	0
LNames64:
	.long	3861
	.long	3
	.long	1519
	.long	1691
	.long	1840
	.long	0
LNames30:
	.long	5279
	.long	1
	.long	791
	.long	0
LNames56:
	.long	4814
	.long	2
	.long	1175
	.long	1322
	.long	0
LNames4:
	.long	231
	.long	1
	.long	351
	.long	0
LNames60:
	.long	5110
	.long	1
	.long	1375
	.long	0
LNames17:
	.long	1401
	.long	3
	.long	531
	.long	751
	.long	1459
	.long	0
LNames65:
	.long	3847
	.long	3
	.long	1540
	.long	1712
	.long	1861
	.long	0
LNames8:
	.long	377
	.long	4
	.long	392
	.long	509
	.long	848
	.long	1436
	.long	0
LNames58:
	.long	5002
	.long	1
	.long	1249
	.long	0
LNames51:
	.long	3141
	.long	4
	.long	1040
	.long	1062
	.long	1188
	.long	1335
	.long	0
LNames62:
	.long	3332
	.long	3
	.long	1499
	.long	1671
	.long	1820
	.long	0
LNames57:
	.long	4748
	.long	2
	.long	1175
	.long	1322
	.long	0
LNames47:
	.long	2129
	.long	2
	.long	998
	.long	1018
	.long	0
LNames59:
	.long	4817
	.long	1
	.long	1249
	.long	0
LNames22:
	.long	4566
	.long	5
	.long	564
	.long	626
	.long	688
	.long	1122
	.long	1269
	.long	0
LNames55:
	.long	3997
	.long	1
	.long	1102
	.long	0
LNames61:
	.long	3506
	.long	3
	.long	1499
	.long	1671
	.long	1820
	.long	0
LNames0:
	.long	5456
	.long	1
	.long	306
	.long	0
LNames40:
	.long	2857
	.long	1
	.long	933
	.long	0
LNames1:
	.long	5560
	.long	1
	.long	306
	.long	0
LNames15:
	.long	1190
	.long	1
	.long	477
	.long	0
LNames20:
	.long	1419
	.long	1
	.long	552
	.long	0
LNames3:
	.long	264
	.long	1
	.long	331
	.long	0
LNames9:
	.long	971
	.long	2
	.long	414
	.long	1607
	.long	0
LNames29:
	.long	5363
	.long	1
	.long	791
	.long	0
LNames13:
	.long	630
	.long	2
	.long	454
	.long	1648
	.long	0
LNames69:
	.long	3328
	.long	2
	.long	1780
	.long	1800
	.long	0
LNames68:
	.long	3638
	.long	3
	.long	1582
	.long	1754
	.long	1903
	.long	0
LNames44:
	.long	2407
	.long	1
	.long	957
	.long	0
LNames42:
	.long	2590
	.long	1
	.long	945
	.long	0
LNames31:
	.long	5446
	.long	1
	.long	812
	.long	0
LNames39:
	.long	3028
	.long	1
	.long	933
	.long	0
LNames6:
	.long	447
	.long	8
	.long	372
	.long	392
	.long	489
	.long	509
	.long	827
	.long	848
	.long	1416
	.long	1436
	.long	0
LNames32:
	.long	5380
	.long	1
	.long	812
	.long	0
LNames35:
	.long	1880
	.long	1
	.long	892
	.long	0
LNames67:
	.long	3714
	.long	3
	.long	1561
	.long	1733
	.long	1882
	.long	0
LNames45:
	.long	2397
	.long	1
	.long	977
	.long	0
LNames14:
	.long	529
	.long	2
	.long	454
	.long	1648
	.long	0
LNames70:
	.long	3248
	.long	2
	.long	1780
	.long	1800
	.long	0
LNames21:
	.long	4682
	.long	5
	.long	564
	.long	626
	.long	688
	.long	1122
	.long	1269
	.long	0
LNames50:
	.long	3223
	.long	4
	.long	1040
	.long	1062
	.long	1188
	.long	1335
	.long	0
LNames10:
	.long	832
	.long	2
	.long	414
	.long	1607
	.long	0
LNames28:
	.long	5187
	.long	1
	.long	771
	.long	0
LNames41:
	.long	2752
	.long	1
	.long	945
	.long	0
LNames5:
	.long	187
	.long	1
	.long	351
	.long	0
	.section	__DWARF,__apple_objc,regular,debug
Lobjc_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	1
	.long	0
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	-1
	.section	__DWARF,__apple_namespac,regular,debug
Lnamespac_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	16
	.long	32
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	5
	.long	7
	.long	8
	.long	9
	.long	11
	.long	16
	.long	18
	.long	-1
	.long	20
	.long	21
	.long	22
	.long	26
	.long	27
	.long	29
	.long	31
	.long	253189136
	.long	478822272
	.long	574455952
	.long	-2098963376
	.long	-476042384
	.long	1062753473
	.long	-1762130655
	.long	-1738516798
	.long	-1738516765
	.long	193499140
	.long	-1536480780
	.long	193488517
	.long	193489909
	.long	193500757
	.long	267174901
	.long	274532053
	.long	-2119460170
	.long	-1536480714
	.long	193501687
	.long	-1553617785
	.long	-1738516567
	.long	193466890
	.long	193502907
	.long	2079663707
	.long	-1738516501
	.long	-735823797
	.long	464608412
	.long	262739357
	.long	2090731117
	.long	256958974
	.long	2090156110
	.long	221207599
Lset203 = Lnamespac27-Lnamespac_begin
	.long	Lset203
Lset204 = Lnamespac5-Lnamespac_begin
	.long	Lset204
Lset205 = Lnamespac19-Lnamespac_begin
	.long	Lset205
Lset206 = Lnamespac20-Lnamespac_begin
	.long	Lset206
Lset207 = Lnamespac17-Lnamespac_begin
	.long	Lset207
Lset208 = Lnamespac30-Lnamespac_begin
	.long	Lset208
Lset209 = Lnamespac15-Lnamespac_begin
	.long	Lset209
Lset210 = Lnamespac16-Lnamespac_begin
	.long	Lset210
Lset211 = Lnamespac11-Lnamespac_begin
	.long	Lset211
Lset212 = Lnamespac31-Lnamespac_begin
	.long	Lset212
Lset213 = Lnamespac21-Lnamespac_begin
	.long	Lset213
Lset214 = Lnamespac7-Lnamespac_begin
	.long	Lset214
Lset215 = Lnamespac23-Lnamespac_begin
	.long	Lset215
Lset216 = Lnamespac1-Lnamespac_begin
	.long	Lset216
Lset217 = Lnamespac18-Lnamespac_begin
	.long	Lset217
Lset218 = Lnamespac3-Lnamespac_begin
	.long	Lset218
Lset219 = Lnamespac22-Lnamespac_begin
	.long	Lset219
Lset220 = Lnamespac29-Lnamespac_begin
	.long	Lset220
Lset221 = Lnamespac24-Lnamespac_begin
	.long	Lset221
Lset222 = Lnamespac28-Lnamespac_begin
	.long	Lset222
Lset223 = Lnamespac10-Lnamespac_begin
	.long	Lset223
Lset224 = Lnamespac8-Lnamespac_begin
	.long	Lset224
Lset225 = Lnamespac14-Lnamespac_begin
	.long	Lset225
Lset226 = Lnamespac12-Lnamespac_begin
	.long	Lset226
Lset227 = Lnamespac2-Lnamespac_begin
	.long	Lset227
Lset228 = Lnamespac25-Lnamespac_begin
	.long	Lset228
Lset229 = Lnamespac13-Lnamespac_begin
	.long	Lset229
Lset230 = Lnamespac9-Lnamespac_begin
	.long	Lset230
Lset231 = Lnamespac4-Lnamespac_begin
	.long	Lset231
Lset232 = Lnamespac6-Lnamespac_begin
	.long	Lset232
Lset233 = Lnamespac0-Lnamespac_begin
	.long	Lset233
Lset234 = Lnamespac26-Lnamespac_begin
	.long	Lset234
Lnamespac27:
	.long	4552
	.long	2
	.long	2656
	.long	2209
	.long	0
Lnamespac5:
	.long	251
	.long	2
	.long	164
	.long	2465
	.long	0
Lnamespac19:
	.long	3622
	.long	1
	.long	83
	.long	0
Lnamespac20:
	.long	3630
	.long	1
	.long	88
	.long	0
Lnamespac17:
	.long	2155
	.long	1
	.long	2325
	.long	0
Lnamespac30:
	.long	5271
	.long	1
	.long	2060
	.long	0
Lnamespac15:
	.long	2015
	.long	1
	.long	2287
	.long	0
Lnamespac16:
	.long	2025
	.long	7
	.long	2292
	.long	2330
	.long	2603
	.long	2666
	.long	2042
	.long	2137
	.long	2219
	.long	0
Lnamespac11:
	.long	823
	.long	2
	.long	2475
	.long	1999
	.long	0
Lnamespac31:
	.long	5376
	.long	1
	.long	2189
	.long	0
Lnamespac21:
	.long	3787
	.long	1
	.long	121
	.long	0
Lnamespac7:
	.long	369
	.long	2
	.long	2541
	.long	2081
	.long	0
Lnamespac23:
	.long	4295
	.long	2
	.long	2598
	.long	2132
	.long	0
Lnamespac1:
	.long	174
	.long	1
	.long	47
	.long	0
Lnamespac18:
	.long	2256
	.long	1
	.long	2470
	.long	0
Lnamespac3:
	.long	240
	.long	4
	.long	154
	.long	2455
	.long	2661
	.long	2214
	.long	0
Lnamespac22:
	.long	3986
	.long	1
	.long	2505
	.long	0
Lnamespac29:
	.long	4738
	.long	1
	.long	2578
	.long	0
Lnamespac24:
	.long	4351
	.long	2
	.long	2624
	.long	2158
	.long	0
Lnamespac28:
	.long	4558
	.long	2
	.long	2671
	.long	2224
	.long	0
Lnamespac10:
	.long	664
	.long	1
	.long	1967
	.long	0
Lnamespac8:
	.long	373
	.long	2
	.long	2546
	.long	2086
	.long	0
Lnamespac14:
	.long	2011
	.long	1
	.long	2282
	.long	0
Lnamespac12:
	.long	1300
	.long	1
	.long	198
	.long	0
Lnamespac2:
	.long	178
	.long	1
	.long	52
	.long	0
Lnamespac25:
	.long	4355
	.long	2
	.long	2629
	.long	2163
	.long	0
Lnamespac13:
	.long	1412
	.long	1
	.long	1931
	.long	0
Lnamespac9:
	.long	523
	.long	1
	.long	1950
	.long	0
Lnamespac4:
	.long	246
	.long	2
	.long	159
	.long	2460
	.long	0
Lnamespac6:
	.long	258
	.long	1
	.long	169
	.long	0
Lnamespac0:
	.long	169
	.long	2
	.long	2277
	.long	42
	.long	0
Lnamespac26:
	.long	4364
	.long	2
	.long	2634
	.long	2168
	.long	0
	.section	__DWARF,__apple_types,regular,debug
Ltypes_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	1
	.long	0
	.long	20
	.long	0
	.long	3
	.short	1
	.short	6
	.short	3
	.short	5
	.short	4
	.short	11
	.long	-1
.subsections_via_symbols
	.section	__DWARF,__debug_line,regular,debug
Lsection_line:
Lline_table_start0:
