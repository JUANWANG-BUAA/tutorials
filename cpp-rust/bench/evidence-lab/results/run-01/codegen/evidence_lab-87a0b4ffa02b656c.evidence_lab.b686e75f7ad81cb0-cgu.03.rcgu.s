	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	.p2align	2
__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable" "quicksort.rs"
	.loc	1 16 0
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x28, x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	stp	x24, x23, [sp, #48]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
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
	.cfi_remember_state
	str	x6, [sp]
	mov	x20, x3
	mov	x21, x2
	mov	x23, x1
	mov	x24, x0
Ltmp0:
	.loc	1 26 12 prologue_end
	cmp	x1, #33
	b.hs	LBB0_2
	.loc	1 0 12 is_stmt 0
	mov	x0, x24
	mov	x26, x23
	.loc	1 26 12
	b	LBB0_50
LBB0_2:
	.loc	1 0 12
	mov	x25, x5
	mov	x22, x4
LBB0_3:
	.loc	1 31 12 is_stmt 1
	cbz	w22, LBB0_51
LBB0_4:
Ltmp1:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared" "pivot.rs"
	.loc	2 28 25
	lsr	x3, x23, #3
Ltmp2:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "const_ptr.rs"
	.loc	3 871 18
	add	x1, x24, x3, lsl #5
Ltmp3:
	.loc	3 871 18 is_stmt 0
	mov	w8, #56
	madd	x2, x3, x8, x24
Ltmp4:
	.loc	2 34 12 is_stmt 1
	cmp	x23, #64
	b.hs	LBB0_6
Ltmp5:
	.loc	2 82 13
	ldr	x8, [x24]
	ldr	x9, [x1]
Ltmp6:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "f64.rs"
	.loc	4 1547 19
	asr	x10, x8, #63
	.loc	4 1547 9 is_stmt 0
	eor	x8, x8, x10, lsr #1
	.loc	4 1548 20 is_stmt 1
	asr	x10, x9, #63
	.loc	4 1548 9 is_stmt 0
	eor	x9, x9, x10, lsr #1
Ltmp7:
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src" "cmp.rs"
	.loc	5 410 44 is_stmt 1
	cmp	x8, x9
	cset	w10, lt
Ltmp8:
	.loc	2 83 13
	ldr	x11, [x2]
Ltmp9:
	.loc	4 1548 20
	asr	x12, x11, #63
	.loc	4 1548 9 is_stmt 0
	eor	x11, x11, x12, lsr #1
Ltmp10:
	.loc	5 410 44 is_stmt 1
	cmp	x8, x11
	cset	w8, lt
Ltmp11:
	.loc	2 84 8
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lt
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x2, x1, ne
	cmp	w8, #0
	csel	x0, x24, x9, ne
	b	LBB0_7
Ltmp12:
LBB0_6:
	.loc	2 37 13
	mov	x0, x24
	ldr	x4, [sp]
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
Ltmp13:
LBB0_7:
	.loc	1 0 0 is_stmt 0
	sub	w22, w22, #1
Ltmp14:
	.loc	3 733 18 is_stmt 1
	sub	x28, x0, x24
	lsr	x19, x28, #3
Ltmp15:
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mod.rs"
	.loc	6 1755 9
	ldr	d0, [x0]
	str	d0, [sp, #8]
	add	x27, x21, x23, lsl #3
Ltmp16:
	.loc	1 59 16
	cbz	x25, LBB0_9
	fmov	x8, d0
	.loc	1 60 40
	ldr	x9, [x25]
Ltmp17:
	.loc	4 1547 19
	asr	x10, x9, #63
	.loc	4 1547 9 is_stmt 0
	eor	x9, x9, x10, lsr #1
	.loc	4 1548 20 is_stmt 1
	asr	x10, x8, #63
	.loc	4 1548 9 is_stmt 0
	eor	x8, x8, x10, lsr #1
Ltmp18:
	.loc	1 64 13 is_stmt 1
	cmp	x9, x8
	b.ge	LBB0_30
LBB0_9:
Ltmp19:
	.loc	1 98 29
	cmp	x20, x23
	b.lo	LBB0_55
	.loc	1 0 29 is_stmt 0
	mov	x26, #0
	mov	x8, x24
	mov	x9, x27
	mov	x10, x19
Ltmp20:
	.file	7 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "uint_macros.rs"
	.loc	7 2540 13 is_stmt 1
	subs	x11, x19, #3
	csel	x11, xzr, x11, lo
Ltmp21:
	.loc	3 871 18
	add	x11, x24, x11, lsl #3
Ltmp22:
	.loc	1 131 23
	cmp	x24, x11
	b.hs	LBB0_13
LBB0_11:
	.loc	1 0 23 is_stmt 0
	ldr	x12, [x24, x28]
	asr	x13, x12, #63
	eor	x12, x12, x13, lsr #1
LBB0_12:
	.loc	1 132 41 is_stmt 1
	ldp	x13, x14, [x8]
Ltmp23:
	.loc	4 1547 19
	asr	x15, x13, #63
	.loc	4 1547 9 is_stmt 0
	eor	x15, x13, x15, lsr #1
Ltmp24:
	.file	8 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mut_ptr.rs"
	.loc	8 1054 22 is_stmt 1
	sub	x16, x9, #8
Ltmp25:
	.loc	5 410 44
	cmp	x15, x12
Ltmp26:
	.loc	1 226 31
	csel	x15, x21, x16, lt
Ltmp27:
	.loc	6 573 14
	str	x13, [x15, x26, lsl #3]
Ltmp28:
	.loc	1 230 13
	cinc	x13, x26, lt
Ltmp29:
	.loc	4 1547 19
	asr	x15, x14, #63
	.loc	4 1547 9 is_stmt 0
	eor	x15, x14, x15, lsr #1
Ltmp30:
	.loc	8 1054 22 is_stmt 1
	sub	x16, x9, #16
Ltmp31:
	.loc	5 410 44
	cmp	x15, x12
Ltmp32:
	.loc	1 226 31
	csel	x15, x21, x16, lt
Ltmp33:
	.loc	6 573 14
	str	x14, [x15, x13, lsl #3]
Ltmp34:
	.loc	1 230 13
	cinc	x13, x13, lt
Ltmp35:
	.loc	1 134 41
	ldp	x14, x15, [x8, #16]
Ltmp36:
	.loc	4 1547 19
	asr	x16, x14, #63
	.loc	4 1547 9 is_stmt 0
	eor	x16, x14, x16, lsr #1
Ltmp37:
	.loc	8 1054 22 is_stmt 1
	sub	x17, x9, #24
Ltmp38:
	.loc	5 410 44
	cmp	x16, x12
Ltmp39:
	.loc	1 226 31
	csel	x16, x21, x17, lt
Ltmp40:
	.loc	6 573 14
	str	x14, [x16, x13, lsl #3]
Ltmp41:
	.loc	1 230 13
	cinc	x13, x13, lt
Ltmp42:
	.loc	4 1547 19
	asr	x14, x15, #63
	.loc	4 1547 9 is_stmt 0
	eor	x14, x15, x14, lsr #1
Ltmp43:
	.loc	8 1054 22 is_stmt 1
	sub	x9, x9, #32
Ltmp44:
	.loc	5 410 44
	cmp	x14, x12
Ltmp45:
	.loc	1 226 31
	csel	x14, x21, x9, lt
Ltmp46:
	.loc	6 573 14
	str	x15, [x14, x13, lsl #3]
Ltmp47:
	.loc	1 230 13
	cinc	x26, x13, lt
Ltmp48:
	.loc	3 871 18
	add	x8, x8, #32
Ltmp49:
	.loc	1 131 23
	cmp	x8, x11
	b.lo	LBB0_12
Ltmp50:
LBB0_13:
	.loc	3 871 18
	add	x11, x24, x10, lsl #3
Ltmp51:
	.loc	1 140 19
	cmp	x8, x11
	b.hs	LBB0_16
	.loc	1 0 19 is_stmt 0
	ldr	x12, [x24, x28]
	asr	x13, x12, #63
	eor	x12, x12, x13, lsr #1
LBB0_15:
	.loc	1 141 37 is_stmt 1
	ldr	x13, [x8], #8
Ltmp52:
	.loc	4 1547 19
	asr	x14, x13, #63
	.loc	4 1547 9 is_stmt 0
	eor	x14, x13, x14, lsr #1
Ltmp53:
	.loc	8 1054 22 is_stmt 1
	sub	x9, x9, #8
Ltmp54:
	.loc	5 410 44
	cmp	x14, x12
Ltmp55:
	.loc	1 226 31
	csel	x14, x21, x9, lt
Ltmp56:
	.loc	6 573 14
	str	x13, [x14, x26, lsl #3]
Ltmp57:
	.loc	1 230 13
	cinc	x26, x26, lt
Ltmp58:
	.loc	1 140 19
	cmp	x8, x11
	b.lo	LBB0_15
LBB0_16:
	.loc	1 144 16
	cmp	x10, x23
	b.eq	LBB0_18
Ltmp59:
	.loc	8 1054 22
	sub	x9, x9, #8
Ltmp60:
	.loc	6 573 14
	ldr	x10, [x8], #8
	str	x10, [x9, x26, lsl #3]
	mov	x10, x23
Ltmp61:
	.loc	7 2540 13
	subs	x11, x23, #3
	csel	x11, xzr, x11, lo
Ltmp62:
	.loc	3 871 18
	add	x11, x24, x11, lsl #3
Ltmp63:
	.loc	1 131 23
	cmp	x8, x11
	b.lo	LBB0_11
	b	LBB0_13
Ltmp64:
LBB0_18:
	.loc	6 573 14
	lsl	x2, x26, #3
	mov	x0, x24
	mov	x1, x21
	bl	_memcpy
Ltmp65:
	.file	9 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter" "range.rs"
	.loc	9 1100 12
	subs	x1, x23, x26
	b.eq	LBB0_26
	cmp	x1, #8
	b.hs	LBB0_21
	.loc	9 0 12 is_stmt 0
	mov	x8, #0
	.loc	9 1100 12
	b	LBB0_24
LBB0_21:
	.loc	9 0 12
	and	x8, x1, #0xfffffffffffffff8
	.loc	9 1100 12
	sub	x9, x21, #32
	add	x9, x9, x23, lsl #3
	and	x10, x1, #0xfffffffffffffff8
	add	x11, x24, #32
	add	x11, x11, x26, lsl #3
Ltmp66:
LBB0_22:
	.loc	6 573 14 is_stmt 1
	ldp	q1, q0, [x9]
	ldp	q3, q2, [x9, #-32]
	ext.16b	v0, v0, v0, #8
	ext.16b	v1, v1, v1, #8
	ext.16b	v2, v2, v2, #8
	ext.16b	v3, v3, v3, #8
	stp	q0, q1, [x11, #-32]
	stp	q2, q3, [x11], #64
Ltmp67:
	.loc	9 1100 12
	sub	x9, x9, #64
	sub	x10, x10, #8
	cbnz	x10, LBB0_22
	cmp	x1, x8
	b.eq	LBB0_26
LBB0_24:
	lsl	x10, x8, #3
	add	x9, x24, x10
	add	x9, x9, x26, lsl #3
	sub	x11, x21, #8
	sub	x10, x11, x10
	add	x10, x10, x23, lsl #3
	sub	x8, x8, x23
	add	x8, x8, x26
Ltmp68:
LBB0_25:
	.loc	6 573 14
	ldr	x11, [x10], #-8
	str	x11, [x9], #8
Ltmp69:
	.loc	5 2144 50
	adds	x8, x8, #1
Ltmp70:
	.loc	9 1100 12
	b.lo	LBB0_25
Ltmp71:
LBB0_26:
	.loc	1 69 12
	cbz	x26, LBB0_30
Ltmp72:
	.file	10 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice" "mod.rs"
	.loc	10 2202 12
	cmp	x23, x26
	b.lo	LBB0_56
Ltmp73:
	.loc	8 970 18
	add	x0, x24, x26, lsl #3
Ltmp74:
	.loc	1 78 9
	add	x5, sp, #8
	mov	x2, x21
	mov	x3, x20
	mov	x4, x22
	ldr	x6, [sp]
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
Ltmp75:
	.loc	1 26 12
	cmp	x26, #33
	b.lo	LBB0_49
	.loc	1 0 12 is_stmt 0
	mov	x23, x26
	.loc	1 31 12 is_stmt 1
	cbnz	w22, LBB0_4
	b	LBB0_52
LBB0_30:
Ltmp76:
	.loc	1 98 29
	cmp	x20, x23
	b.lo	LBB0_55
	.loc	1 0 29 is_stmt 0
	mov	x25, #0
	mov	x8, x24
Ltmp77:
	.loc	7 2540 13 is_stmt 1
	subs	x9, x19, #3
	csel	x9, xzr, x9, lo
Ltmp78:
	.loc	3 871 18
	add	x9, x24, x9, lsl #3
Ltmp79:
	.loc	1 131 23
	cmp	x24, x9
	b.hs	LBB0_34
LBB0_32:
	.loc	1 0 23 is_stmt 0
	ldr	x10, [x24, x28]
	asr	x11, x10, #63
	eor	x10, x10, x11, lsr #1
LBB0_33:
	.loc	1 132 41 is_stmt 1
	ldp	x11, x12, [x8]
Ltmp80:
	.loc	4 1548 20
	asr	x13, x11, #63
	.loc	4 1548 9 is_stmt 0
	eor	x13, x11, x13, lsr #1
Ltmp81:
	.loc	8 1054 22 is_stmt 1
	sub	x14, x27, #8
Ltmp82:
	.loc	5 410 44
	cmp	x10, x13
Ltmp83:
	.loc	1 226 31
	csel	x13, x21, x14, ge
Ltmp84:
	.loc	6 573 14
	str	x11, [x13, x25, lsl #3]
Ltmp85:
	.loc	1 230 13
	cinc	x11, x25, ge
Ltmp86:
	.loc	4 1548 20
	asr	x13, x12, #63
	.loc	4 1548 9 is_stmt 0
	eor	x13, x12, x13, lsr #1
Ltmp87:
	.loc	8 1054 22 is_stmt 1
	sub	x14, x27, #16
Ltmp88:
	.loc	5 410 44
	cmp	x10, x13
Ltmp89:
	.loc	1 226 31
	csel	x13, x21, x14, ge
Ltmp90:
	.loc	6 573 14
	str	x12, [x13, x11, lsl #3]
Ltmp91:
	.loc	1 230 13
	cinc	x11, x11, ge
Ltmp92:
	.loc	1 134 41
	ldp	x12, x13, [x8, #16]
Ltmp93:
	.loc	4 1548 20
	asr	x14, x12, #63
	.loc	4 1548 9 is_stmt 0
	eor	x14, x12, x14, lsr #1
Ltmp94:
	.loc	8 1054 22 is_stmt 1
	sub	x15, x27, #24
Ltmp95:
	.loc	5 410 44
	cmp	x10, x14
Ltmp96:
	.loc	1 226 31
	csel	x14, x21, x15, ge
Ltmp97:
	.loc	6 573 14
	str	x12, [x14, x11, lsl #3]
Ltmp98:
	.loc	1 230 13
	cinc	x11, x11, ge
Ltmp99:
	.loc	4 1548 20
	asr	x12, x13, #63
	.loc	4 1548 9 is_stmt 0
	eor	x12, x13, x12, lsr #1
Ltmp100:
	.loc	8 1054 22 is_stmt 1
	sub	x27, x27, #32
Ltmp101:
	.loc	5 410 44
	cmp	x10, x12
Ltmp102:
	.loc	1 226 31
	csel	x12, x21, x27, ge
Ltmp103:
	.loc	6 573 14
	str	x13, [x12, x11, lsl #3]
Ltmp104:
	.loc	1 230 13
	cinc	x25, x11, ge
Ltmp105:
	.loc	3 871 18
	add	x8, x8, #32
Ltmp106:
	.loc	1 131 23
	cmp	x8, x9
	b.lo	LBB0_33
Ltmp107:
LBB0_34:
	.loc	3 871 18
	add	x9, x24, x19, lsl #3
Ltmp108:
	.loc	1 140 19
	cmp	x8, x9
	b.hs	LBB0_37
	.loc	1 0 19 is_stmt 0
	ldr	x10, [x24, x28]
	asr	x11, x10, #63
	eor	x10, x10, x11, lsr #1
LBB0_36:
	.loc	1 141 37 is_stmt 1
	ldr	x11, [x8], #8
Ltmp109:
	.loc	4 1548 20
	asr	x12, x11, #63
	.loc	4 1548 9 is_stmt 0
	eor	x12, x11, x12, lsr #1
Ltmp110:
	.loc	8 1054 22 is_stmt 1
	sub	x27, x27, #8
Ltmp111:
	.loc	5 410 44
	cmp	x10, x12
Ltmp112:
	.loc	1 226 31
	csel	x12, x21, x27, ge
Ltmp113:
	.loc	6 573 14
	str	x11, [x12, x25, lsl #3]
Ltmp114:
	.loc	1 230 13
	cinc	x25, x25, ge
Ltmp115:
	.loc	1 140 19
	cmp	x8, x9
	b.lo	LBB0_36
LBB0_37:
	.loc	1 144 16
	cmp	x19, x23
	b.eq	LBB0_39
Ltmp116:
	.loc	8 1054 22
	sub	x27, x27, #8
Ltmp117:
	.loc	6 573 14
	ldr	x9, [x8], #8
	str	x9, [x21, x25, lsl #3]
Ltmp118:
	.loc	1 230 13
	add	x25, x25, #1
	mov	x19, x23
Ltmp119:
	.loc	7 2540 13
	subs	x9, x23, #3
	csel	x9, xzr, x9, lo
Ltmp120:
	.loc	3 871 18
	add	x9, x24, x9, lsl #3
Ltmp121:
	.loc	1 131 23
	cmp	x8, x9
	b.lo	LBB0_32
	b	LBB0_34
Ltmp122:
LBB0_39:
	.loc	6 573 14
	lsl	x2, x25, #3
	mov	x0, x24
	mov	x1, x21
	bl	_memcpy
Ltmp123:
	.loc	9 1100 12
	subs	x26, x23, x25
	b.eq	LBB0_54
	.loc	9 0 12 is_stmt 0
	add	x0, x24, x25, lsl #3
	.loc	9 1100 12
	cmp	x26, #8
	b.hs	LBB0_42
	.loc	9 0 12
	mov	x8, #0
	.loc	9 1100 12
	b	LBB0_45
LBB0_42:
	.loc	9 0 12
	and	x8, x26, #0xfffffffffffffff8
	.loc	9 1100 12
	add	x9, x0, #32
	and	x10, x26, #0xfffffffffffffff8
	sub	x11, x21, #32
	add	x11, x11, x23, lsl #3
Ltmp124:
LBB0_43:
	.loc	6 573 14 is_stmt 1
	ldp	q1, q0, [x11]
	ldp	q3, q2, [x11, #-32]
	ext.16b	v0, v0, v0, #8
	ext.16b	v1, v1, v1, #8
	ext.16b	v2, v2, v2, #8
	ext.16b	v3, v3, v3, #8
	stp	q0, q1, [x9, #-32]
	stp	q2, q3, [x9], #64
Ltmp125:
	.loc	9 1100 12
	sub	x11, x11, #64
	sub	x10, x10, #8
	cbnz	x10, LBB0_43
	cmp	x26, x8
	b.eq	LBB0_47
LBB0_45:
	lsl	x10, x8, #3
	add	x9, x24, x10
	add	x9, x9, x25, lsl #3
	sub	x11, x21, #8
	sub	x10, x11, x10
	add	x10, x10, x23, lsl #3
	sub	x8, x8, x23
	add	x8, x8, x25
Ltmp126:
LBB0_46:
	.loc	6 573 14
	ldr	x11, [x10], #-8
	str	x11, [x9], #8
Ltmp127:
	.loc	5 2144 50
	adds	x8, x8, #1
Ltmp128:
	.loc	9 1100 12
	b.lo	LBB0_46
Ltmp129:
LBB0_47:
	.file	11 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice" "index.rs"
	.loc	11 557 12
	cmp	x23, x25
	b.lo	LBB0_57
Ltmp130:
	.loc	11 0 12 is_stmt 0
	mov	x25, #0
	mov	x24, x0
	mov	x23, x26
	.loc	1 26 12 is_stmt 1
	cmp	x26, #33
	b.hs	LBB0_3
	b	LBB0_50
LBB0_49:
	.loc	1 0 12 is_stmt 0
	mov	x0, x24
LBB0_50:
Ltmp131:
	.file	12 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared" "smallsort.rs"
	.loc	12 61 9 is_stmt 1
	mov	x1, x26
	mov	x2, x21
	mov	x3, x20
	ldr	x4, [sp]
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort31small_sort_general_with_scratchdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
Ltmp132:
	.file	13 "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab" "src/lib.rs"
	.loc	13 0 0 is_stmt 0
	b	LBB0_53
LBB0_51:
	mov	x26, x23
LBB0_52:
	.loc	1 34 13 is_stmt 1
	mov	x0, x24
	mov	x1, x26
	mov	x2, x21
	mov	x3, x20
	mov	w4, #1
	ldr	x5, [sp]
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
Ltmp133:
LBB0_53:
	.cfi_def_cfa wsp, 112
	.loc	1 81 2 epilogue_begin
	ldp	x29, x30, [sp, #96]
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	add	sp, sp, #112
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
LBB0_54:
	.cfi_restore_state
Ltmp134:
	.loc	11 102 24
	add	x0, x24, x23, lsl #3
Ltmp135:
	.loc	1 26 12
	b	LBB0_50
LBB0_55:
Ltmp136:
	.loc	1 0 0 is_stmt 0
	brk	#0x1
LBB0_56:
Ltmp137:
	.loc	10 1998 21 is_stmt 1
Lloh0:
	adrp	x0, l_alloc_d1084648e479974e70c9329824bf76f9@PAGE
Lloh1:
	add	x0, x0, l_alloc_d1084648e479974e70c9329824bf76f9@PAGEOFF
Lloh2:
	adrp	x2, l_alloc_0224d112bf1fbef4412e85014b3237f9@PAGE
Lloh3:
	add	x2, x2, l_alloc_0224d112bf1fbef4412e85014b3237f9@PAGEOFF
	mov	w1, #19
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking9panic_fmt
Ltmp138:
LBB0_57:
	.loc	11 558 13
Lloh4:
	adrp	x3, l_alloc_60734244025279bd7e8eeb7b7113e987@PAGE
Lloh5:
	add	x3, x3, l_alloc_60734244025279bd7e8eeb7b7113e987@PAGEOFF
	mov	x0, x25
	mov	x1, x23
	mov	x2, x23
	bl	__RNvNtNtCsjIpoRzUjyHQ_4core5slice5index16slice_index_fail
Ltmp139:
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh4, Lloh5
Lfunc_end0:
	.cfi_endproc
	.file	14 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops" "function.rs"
	.file	15 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"

	.section	__TEXT,__cstring,cstring_literals
l_alloc_85e191b6a00af9bde53c56f853fc02a6:
	.asciz	"/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/quicksort.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_alloc_0224d112bf1fbef4412e85014b3237f9:
	.quad	l_alloc_85e191b6a00af9bde53c56f853fc02a6
	.asciz	"\203\000\000\000\000\000\000\000M\000\000\000\037\000\000"

	.p2align	3, 0x0
l_alloc_60734244025279bd7e8eeb7b7113e987:
	.quad	l_alloc_85e191b6a00af9bde53c56f853fc02a6
	.asciz	"\203\000\000\000\000\000\000\000G\000\000\000\027\000\000"

	.section	__TEXT,__const
l_alloc_d1084648e479974e70c9329824bf76f9:
	.ascii	"mid > len"

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
	.byte	11
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
	.byte	54
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
	.byte	9
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
	.byte	0
	.byte	0
	.byte	10
	.byte	29
	.byte	0
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
	.byte	11
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
	.ascii	"\266B"
	.byte	11
	.byte	0
	.byte	0
	.byte	12
	.byte	29
	.byte	1
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
	.byte	13
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
	.byte	14
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
	.byte	15
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
	.byte	16
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
	.long	180
	.byte	2
	.long	185
	.byte	2
	.long	192
	.byte	3
	.long	198
	.long	368
	.byte	2
	.byte	13

	.byte	1
	.byte	3
	.long	589
	.long	753
	.byte	2
	.byte	79

	.byte	1
	.byte	0
	.byte	2
	.long	4256
	.byte	2
	.long	4057
	.byte	3
	.long	4266
	.long	4471
	.byte	12
	.byte	56

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1663
	.byte	2
	.long	1670
	.byte	4
	.long	1680
	.long	1858
	.byte	1
	.byte	89
	.byte	3

	.byte	1
	.byte	2
	.long	2146
	.byte	3
	.long	2161
	.long	2289
	.byte	1
	.byte	215

	.byte	1
	.byte	0
	.byte	4
	.long	3222
	.long	3421
	.byte	1
	.byte	89
	.byte	3

	.byte	1
	.byte	2
	.long	1670
	.byte	4
	.long	3608
	.long	3781
	.byte	1
	.byte	70
	.byte	3

	.byte	1
	.byte	0
	.byte	5
	.quad	Lfunc_begin0
Lset4 = Lfunc_end0-Lfunc_begin0
	.long	Lset4
	.byte	1
	.byte	109
	.long	4825
	.long	4716
	.byte	1
	.byte	16

	.byte	6
	.long	67
Lset5 = Ldebug_ranges0-Ldebug_range
	.long	Lset5
	.byte	1
	.byte	39
	.byte	25
	.byte	7
	.long	2610
	.quad	Ltmp2
Lset6 = Ltmp3-Ltmp2
	.long	Lset6
	.byte	2
	.byte	31
	.byte	24
	.byte	7
	.long	2610
	.quad	Ltmp3
Lset7 = Ltmp4-Ltmp3
	.long	Lset7
	.byte	2
	.byte	32
	.byte	24
	.byte	8
	.long	79
	.quad	Ltmp5
Lset8 = Ltmp12-Ltmp5
	.long	Lset8
	.byte	2
	.byte	35
	.byte	13
	.byte	8
	.long	3023
	.quad	Ltmp6
Lset9 = Ltmp8-Ltmp6
	.long	Lset9
	.byte	2
	.byte	82
	.byte	13
	.byte	8
	.long	2809
	.quad	Ltmp6
Lset10 = Ltmp7-Ltmp6
	.long	Lset10
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp6
Lset11 = Ltmp7-Ltmp6
	.long	Lset11
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp7
Lset12 = Ltmp8-Ltmp7
	.long	Lset12
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	8
	.long	3023
	.quad	Ltmp9
Lset13 = Ltmp11-Ltmp9
	.long	Lset13
	.byte	2
	.byte	83
	.byte	13
	.byte	8
	.long	2809
	.quad	Ltmp9
Lset14 = Ltmp10-Ltmp9
	.long	Lset14
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp9
Lset15 = Ltmp10-Ltmp9
	.long	Lset15
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp10
Lset16 = Ltmp11-Ltmp10
	.long	Lset16
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	9
	.long	2623
	.quad	Ltmp14
Lset17 = Ltmp15-Ltmp14
	.long	Lset17
	.byte	2
	.byte	0
	.byte	0
	.byte	7
	.long	2677
	.quad	Ltmp15
Lset18 = Ltmp16-Ltmp15
	.long	Lset18
	.byte	1
	.byte	45
	.byte	35
	.byte	8
	.long	3023
	.quad	Ltmp17
Lset19 = Ltmp18-Ltmp17
	.long	Lset19
	.byte	1
	.byte	60
	.byte	40
	.byte	8
	.long	2809
	.quad	Ltmp17
Lset20 = Ltmp18-Ltmp17
	.long	Lset20
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp17
Lset21 = Ltmp18-Ltmp17
	.long	Lset21
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	0
	.byte	8
	.long	127
	.quad	Ltmp19
Lset22 = Ltmp71-Ltmp19
	.long	Lset22
	.byte	1
	.byte	65
	.byte	34
	.byte	10
	.long	2898
Lset23 = Ldebug_ranges1-Ldebug_range
	.long	Lset23
	.byte	1
	.byte	130
	.byte	58
	.byte	10
	.long	2636
Lset24 = Ldebug_ranges2-Ldebug_range
	.long	Lset24
	.byte	1
	.byte	130
	.byte	41
	.byte	6
	.long	3023
Lset25 = Ldebug_ranges3-Ldebug_range
	.long	Lset25
	.byte	1
	.byte	132
	.byte	41
	.byte	8
	.long	2809
	.quad	Ltmp23
Lset26 = Ltmp24-Ltmp23
	.long	Lset26
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp23
Lset27 = Ltmp24-Ltmp23
	.long	Lset27
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp25
Lset28 = Ltmp26-Ltmp25
	.long	Lset28
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	6
	.long	145
Lset29 = Ldebug_ranges4-Ldebug_range
	.long	Lset29
	.byte	1
	.byte	132
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp24
Lset30 = Ltmp25-Ltmp24
	.long	Lset30
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp27
Lset31 = Ltmp28-Ltmp27
	.long	Lset31
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	3023
Lset32 = Ldebug_ranges5-Ldebug_range
	.long	Lset32
	.byte	1
	.byte	133
	.byte	41
	.byte	8
	.long	2809
	.quad	Ltmp29
Lset33 = Ltmp30-Ltmp29
	.long	Lset33
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp29
Lset34 = Ltmp30-Ltmp29
	.long	Lset34
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp31
Lset35 = Ltmp32-Ltmp31
	.long	Lset35
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	6
	.long	145
Lset36 = Ldebug_ranges6-Ldebug_range
	.long	Lset36
	.byte	1
	.byte	133
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp30
Lset37 = Ltmp31-Ltmp30
	.long	Lset37
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp33
Lset38 = Ltmp34-Ltmp33
	.long	Lset38
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	3023
Lset39 = Ldebug_ranges7-Ldebug_range
	.long	Lset39
	.byte	1
	.byte	134
	.byte	41
	.byte	8
	.long	2809
	.quad	Ltmp36
Lset40 = Ltmp37-Ltmp36
	.long	Lset40
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp36
Lset41 = Ltmp37-Ltmp36
	.long	Lset41
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp38
Lset42 = Ltmp39-Ltmp38
	.long	Lset42
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	6
	.long	145
Lset43 = Ldebug_ranges8-Ldebug_range
	.long	Lset43
	.byte	1
	.byte	134
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp37
Lset44 = Ltmp38-Ltmp37
	.long	Lset44
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp40
Lset45 = Ltmp41-Ltmp40
	.long	Lset45
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	3023
Lset46 = Ldebug_ranges9-Ldebug_range
	.long	Lset46
	.byte	1
	.byte	135
	.byte	41
	.byte	8
	.long	2809
	.quad	Ltmp42
Lset47 = Ltmp43-Ltmp42
	.long	Lset47
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp42
Lset48 = Ltmp43-Ltmp42
	.long	Lset48
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp44
Lset49 = Ltmp45-Ltmp44
	.long	Lset49
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	6
	.long	145
Lset50 = Ldebug_ranges10-Ldebug_range
	.long	Lset50
	.byte	1
	.byte	135
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp43
Lset51 = Ltmp44-Ltmp43
	.long	Lset51
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp46
Lset52 = Ltmp47-Ltmp46
	.long	Lset52
	.byte	1
	.byte	228
	.byte	13
	.byte	7
	.long	2649
	.quad	Ltmp48
Lset53 = Ltmp49-Ltmp48
	.long	Lset53
	.byte	1
	.byte	231
	.byte	35
	.byte	0
	.byte	7
	.long	2636
	.quad	Ltmp50
Lset54 = Ltmp51-Ltmp50
	.long	Lset54
	.byte	1
	.byte	139
	.byte	35
	.byte	6
	.long	3023
Lset55 = Ldebug_ranges11-Ldebug_range
	.long	Lset55
	.byte	1
	.byte	141
	.byte	37
	.byte	8
	.long	2809
	.quad	Ltmp52
Lset56 = Ltmp53-Ltmp52
	.long	Lset56
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp52
Lset57 = Ltmp53-Ltmp52
	.long	Lset57
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp54
Lset58 = Ltmp55-Ltmp54
	.long	Lset58
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	6
	.long	145
Lset59 = Ldebug_ranges12-Ldebug_range
	.long	Lset59
	.byte	1
	.byte	141
	.byte	23
	.byte	7
	.long	2700
	.quad	Ltmp53
Lset60 = Ltmp54-Ltmp53
	.long	Lset60
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp56
Lset61 = Ltmp57-Ltmp56
	.long	Lset61
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	8
	.long	145
	.quad	Ltmp59
Lset62 = Ltmp61-Ltmp59
	.long	Lset62
	.byte	1
	.byte	150
	.byte	38
	.byte	7
	.long	2700
	.quad	Ltmp59
Lset63 = Ltmp60-Ltmp59
	.long	Lset63
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp60
Lset64 = Ltmp61-Ltmp60
	.long	Lset64
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	7
	.long	2741
	.quad	Ltmp64
Lset65 = Ltmp65-Ltmp64
	.long	Lset65
	.byte	1
	.byte	169
	.byte	9
	.byte	11
	.long	2973
Lset66 = Ldebug_ranges13-Ldebug_range
	.long	Lset66
	.byte	1
	.byte	172
	.byte	18
	.byte	2
	.byte	12
	.long	2941
Lset67 = Ldebug_ranges13-Ldebug_range
	.long	Lset67
	.byte	9
	.short	1185
	.byte	14
	.byte	13
	.long	2859
	.quad	Ltmp69
Lset68 = Ltmp70-Ltmp69
	.long	Lset68
	.byte	9
	.short	1100
	.byte	12
	.byte	0
	.byte	0
	.byte	10
	.long	2741
Lset69 = Ldebug_ranges14-Ldebug_range
	.long	Lset69
	.byte	1
	.byte	173
	.byte	13
	.byte	0
	.byte	6
	.long	2510
Lset70 = Ldebug_ranges15-Ldebug_range
	.long	Lset70
	.byte	1
	.byte	77
	.byte	31
	.byte	14
	.long	2497
	.quad	Ltmp72
Lset71 = Ltmp74-Ltmp72
	.long	Lset71
	.byte	10
	.short	1996
	.byte	20
	.byte	14
	.long	2524
	.quad	Ltmp73
Lset72 = Ltmp74-Ltmp73
	.long	Lset72
	.byte	10
	.short	2205
	.byte	32
	.byte	13
	.long	2713
	.quad	Ltmp73
Lset73 = Ltmp74-Ltmp73
	.long	Lset73
	.byte	10
	.short	2118
	.byte	40
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	158
	.quad	Ltmp76
Lset74 = Ltmp129-Ltmp76
	.long	Lset74
	.byte	1
	.byte	70
	.byte	26
	.byte	10
	.long	2911
Lset75 = Ldebug_ranges16-Ldebug_range
	.long	Lset75
	.byte	1
	.byte	130
	.byte	58
	.byte	10
	.long	2662
Lset76 = Ldebug_ranges17-Ldebug_range
	.long	Lset76
	.byte	1
	.byte	130
	.byte	41
	.byte	6
	.long	176
Lset77 = Ldebug_ranges18-Ldebug_range
	.long	Lset77
	.byte	1
	.byte	132
	.byte	41
	.byte	6
	.long	3023
Lset78 = Ldebug_ranges18-Ldebug_range
	.long	Lset78
	.byte	1
	.byte	70
	.byte	85
	.byte	8
	.long	2809
	.quad	Ltmp80
Lset79 = Ltmp81-Ltmp80
	.long	Lset79
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp80
Lset80 = Ltmp81-Ltmp80
	.long	Lset80
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp82
Lset81 = Ltmp83-Ltmp82
	.long	Lset81
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	6
	.long	145
Lset82 = Ldebug_ranges19-Ldebug_range
	.long	Lset82
	.byte	1
	.byte	132
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp81
Lset83 = Ltmp82-Ltmp81
	.long	Lset83
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp84
Lset84 = Ltmp85-Ltmp84
	.long	Lset84
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	176
Lset85 = Ldebug_ranges20-Ldebug_range
	.long	Lset85
	.byte	1
	.byte	133
	.byte	41
	.byte	6
	.long	3023
Lset86 = Ldebug_ranges20-Ldebug_range
	.long	Lset86
	.byte	1
	.byte	70
	.byte	85
	.byte	8
	.long	2809
	.quad	Ltmp86
Lset87 = Ltmp87-Ltmp86
	.long	Lset87
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp86
Lset88 = Ltmp87-Ltmp86
	.long	Lset88
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp88
Lset89 = Ltmp89-Ltmp88
	.long	Lset89
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	6
	.long	145
Lset90 = Ldebug_ranges21-Ldebug_range
	.long	Lset90
	.byte	1
	.byte	133
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp87
Lset91 = Ltmp88-Ltmp87
	.long	Lset91
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp90
Lset92 = Ltmp91-Ltmp90
	.long	Lset92
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	176
Lset93 = Ldebug_ranges22-Ldebug_range
	.long	Lset93
	.byte	1
	.byte	134
	.byte	41
	.byte	6
	.long	3023
Lset94 = Ldebug_ranges22-Ldebug_range
	.long	Lset94
	.byte	1
	.byte	70
	.byte	85
	.byte	8
	.long	2809
	.quad	Ltmp93
Lset95 = Ltmp94-Ltmp93
	.long	Lset95
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp93
Lset96 = Ltmp94-Ltmp93
	.long	Lset96
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp95
Lset97 = Ltmp96-Ltmp95
	.long	Lset97
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	6
	.long	145
Lset98 = Ldebug_ranges23-Ldebug_range
	.long	Lset98
	.byte	1
	.byte	134
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp94
Lset99 = Ltmp95-Ltmp94
	.long	Lset99
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp97
Lset100 = Ltmp98-Ltmp97
	.long	Lset100
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	6
	.long	176
Lset101 = Ldebug_ranges24-Ldebug_range
	.long	Lset101
	.byte	1
	.byte	135
	.byte	41
	.byte	6
	.long	3023
Lset102 = Ldebug_ranges24-Ldebug_range
	.long	Lset102
	.byte	1
	.byte	70
	.byte	85
	.byte	8
	.long	2809
	.quad	Ltmp99
Lset103 = Ltmp100-Ltmp99
	.long	Lset103
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp99
Lset104 = Ltmp100-Ltmp99
	.long	Lset104
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp101
Lset105 = Ltmp102-Ltmp101
	.long	Lset105
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	6
	.long	145
Lset106 = Ldebug_ranges25-Ldebug_range
	.long	Lset106
	.byte	1
	.byte	135
	.byte	27
	.byte	7
	.long	2700
	.quad	Ltmp100
Lset107 = Ltmp101-Ltmp100
	.long	Lset107
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp103
Lset108 = Ltmp104-Ltmp103
	.long	Lset108
	.byte	1
	.byte	228
	.byte	13
	.byte	7
	.long	2649
	.quad	Ltmp105
Lset109 = Ltmp106-Ltmp105
	.long	Lset109
	.byte	1
	.byte	231
	.byte	35
	.byte	0
	.byte	7
	.long	2662
	.quad	Ltmp107
Lset110 = Ltmp108-Ltmp107
	.long	Lset110
	.byte	1
	.byte	139
	.byte	35
	.byte	6
	.long	176
Lset111 = Ldebug_ranges26-Ldebug_range
	.long	Lset111
	.byte	1
	.byte	141
	.byte	37
	.byte	6
	.long	3023
Lset112 = Ldebug_ranges26-Ldebug_range
	.long	Lset112
	.byte	1
	.byte	70
	.byte	85
	.byte	8
	.long	2809
	.quad	Ltmp109
Lset113 = Ltmp110-Ltmp109
	.long	Lset113
	.byte	15
	.byte	196
	.byte	34
	.byte	7
	.long	2778
	.quad	Ltmp109
Lset114 = Ltmp110-Ltmp109
	.long	Lset114
	.byte	14
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	2835
	.quad	Ltmp111
Lset115 = Ltmp112-Ltmp111
	.long	Lset115
	.byte	15
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	6
	.long	145
Lset116 = Ldebug_ranges27-Ldebug_range
	.long	Lset116
	.byte	1
	.byte	141
	.byte	23
	.byte	7
	.long	2700
	.quad	Ltmp110
Lset117 = Ltmp111-Ltmp110
	.long	Lset117
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp113
Lset118 = Ltmp114-Ltmp113
	.long	Lset118
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	8
	.long	145
	.quad	Ltmp116
Lset119 = Ltmp119-Ltmp116
	.long	Lset119
	.byte	1
	.byte	150
	.byte	38
	.byte	7
	.long	2700
	.quad	Ltmp116
Lset120 = Ltmp117-Ltmp116
	.long	Lset120
	.byte	1
	.byte	222
	.byte	49
	.byte	7
	.long	2728
	.quad	Ltmp117
Lset121 = Ltmp118-Ltmp117
	.long	Lset121
	.byte	1
	.byte	228
	.byte	13
	.byte	0
	.byte	7
	.long	2754
	.quad	Ltmp122
Lset122 = Ltmp123-Ltmp122
	.long	Lset122
	.byte	1
	.byte	169
	.byte	9
	.byte	11
	.long	2986
Lset123 = Ldebug_ranges28-Ldebug_range
	.long	Lset123
	.byte	1
	.byte	172
	.byte	18
	.byte	2
	.byte	12
	.long	2954
Lset124 = Ldebug_ranges28-Ldebug_range
	.long	Lset124
	.byte	9
	.short	1185
	.byte	14
	.byte	13
	.long	2872
	.quad	Ltmp127
Lset125 = Ltmp128-Ltmp127
	.long	Lset125
	.byte	9
	.short	1100
	.byte	12
	.byte	0
	.byte	0
	.byte	10
	.long	2754
Lset126 = Ldebug_ranges29-Ldebug_range
	.long	Lset126
	.byte	1
	.byte	173
	.byte	13
	.byte	0
	.byte	6
	.long	2568
Lset127 = Ldebug_ranges30-Ldebug_range
	.long	Lset127
	.byte	1
	.byte	71
	.byte	23
	.byte	6
	.long	2549
Lset128 = Ldebug_ranges30-Ldebug_range
	.long	Lset128
	.byte	11
	.byte	32
	.byte	15
	.byte	13
	.long	2581
	.quad	Ltmp134
Lset129 = Ltmp135-Ltmp134
	.long	Lset129
	.byte	11
	.short	563
	.byte	19
	.byte	0
	.byte	0
	.byte	7
	.long	102
	.quad	Ltmp131
Lset130 = Ltmp132-Ltmp131
	.long	Lset130
	.byte	1
	.byte	27
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	494
	.byte	15
	.long	2826
	.long	2911
	.byte	10
	.short	2201

	.byte	1
	.byte	16
	.long	2937
	.long	3014
	.byte	10
	.short	1995
	.byte	3

	.byte	1
	.byte	16
	.long	3107
	.long	3194
	.byte	10
	.short	2101
	.byte	3

	.byte	1
	.byte	0
	.byte	2
	.long	3892
	.byte	2
	.long	3898
	.byte	15
	.long	3907
	.long	4042
	.byte	11
	.short	556

	.byte	1
	.byte	0
	.byte	2
	.long	4057
	.byte	3
	.long	4066
	.long	4205
	.byte	11
	.byte	31

	.byte	1
	.byte	0
	.byte	3
	.long	4581
	.long	4682
	.byte	11
	.byte	95

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	480
	.byte	2
	.long	484
	.byte	2
	.long	494
	.byte	15
	.long	503
	.long	580
	.byte	3
	.short	837

	.byte	1
	.byte	15
	.long	1386
	.long	1481
	.byte	3
	.short	705

	.byte	1
	.byte	15
	.long	503
	.long	580
	.byte	3
	.short	837

	.byte	1
	.byte	15
	.long	503
	.long	580
	.byte	3
	.short	837

	.byte	1
	.byte	15
	.long	503
	.long	580
	.byte	3
	.short	837

	.byte	1
	.byte	0
	.byte	0
	.byte	15
	.long	1507
	.long	1615
	.byte	6
	.short	1716

	.byte	1
	.byte	2
	.long	2054
	.byte	2
	.long	494
	.byte	15
	.long	2062
	.long	2137
	.byte	8
	.short	1015

	.byte	1
	.byte	15
	.long	3032
	.long	580
	.byte	8
	.short	936

	.byte	1
	.byte	0
	.byte	0
	.byte	15
	.long	2308
	.long	2390
	.byte	6
	.short	552

	.byte	1
	.byte	15
	.long	2308
	.long	2390
	.byte	6
	.short	552

	.byte	1
	.byte	15
	.long	2308
	.long	2390
	.byte	6
	.short	552

	.byte	1
	.byte	0
	.byte	2
	.long	860
	.byte	2
	.long	494
	.byte	16
	.long	864
	.long	906
	.byte	4
	.short	1521
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	916
	.byte	2
	.long	920
	.byte	2
	.long	929
	.byte	4
	.long	935
	.long	1055
	.byte	14
	.byte	166
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1303
	.byte	2
	.long	1307
	.byte	15
	.long	1317
	.long	1383
	.byte	5
	.short	410

	.byte	1
	.byte	0
	.byte	2
	.long	2744
	.byte	2
	.long	2750
	.byte	15
	.long	2760
	.long	2823
	.byte	5
	.short	2144

	.byte	1
	.byte	15
	.long	2760
	.long	2823
	.byte	5
	.short	2144

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1974
	.byte	2
	.long	1978
	.byte	15
	.long	1988
	.long	2039
	.byte	7
	.short	2539

	.byte	1
	.byte	15
	.long	1988
	.long	2039
	.byte	7
	.short	2539

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	2415
	.byte	2
	.long	2420
	.byte	2
	.long	2426
	.byte	15
	.long	2435
	.long	2568
	.byte	9
	.short	1099

	.byte	1
	.byte	15
	.long	2435
	.long	2568
	.byte	9
	.short	1099

	.byte	1
	.byte	0
	.byte	2
	.long	2585
	.byte	15
	.long	2594
	.long	2732
	.byte	9
	.short	1184

	.byte	1
	.byte	15
	.long	2594
	.long	2732
	.byte	9
	.short	1184

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1117
	.byte	2
	.long	174
	.byte	2
	.long	494
	.byte	2
	.long	1123
	.byte	4
	.long	1131
	.long	1247
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
	.section	__TEXT,__text,regular,pure_instructions
Lsec_end0:
	.section	__DWARF,__debug_aranges,regular,debug
	.long	44
	.short	2
Lset131 = Lcu_begin0-Lsection_info
	.long	Lset131
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset132 = Lsec_end0-Lfunc_begin0
	.quad	Lset132
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset133 = Ltmp1-Lfunc_begin0
	.quad	Lset133
Lset134 = Ltmp13-Lfunc_begin0
	.quad	Lset134
Lset135 = Ltmp14-Lfunc_begin0
	.quad	Lset135
Lset136 = Ltmp15-Lfunc_begin0
	.quad	Lset136
	.quad	0
	.quad	0
Ldebug_ranges1:
Lset137 = Ltmp20-Lfunc_begin0
	.quad	Lset137
Lset138 = Ltmp21-Lfunc_begin0
	.quad	Lset138
Lset139 = Ltmp61-Lfunc_begin0
	.quad	Lset139
Lset140 = Ltmp62-Lfunc_begin0
	.quad	Lset140
	.quad	0
	.quad	0
Ldebug_ranges2:
Lset141 = Ltmp21-Lfunc_begin0
	.quad	Lset141
Lset142 = Ltmp22-Lfunc_begin0
	.quad	Lset142
Lset143 = Ltmp62-Lfunc_begin0
	.quad	Lset143
Lset144 = Ltmp63-Lfunc_begin0
	.quad	Lset144
	.quad	0
	.quad	0
Ldebug_ranges3:
Lset145 = Ltmp23-Lfunc_begin0
	.quad	Lset145
Lset146 = Ltmp24-Lfunc_begin0
	.quad	Lset146
Lset147 = Ltmp25-Lfunc_begin0
	.quad	Lset147
Lset148 = Ltmp26-Lfunc_begin0
	.quad	Lset148
	.quad	0
	.quad	0
Ldebug_ranges4:
Lset149 = Ltmp24-Lfunc_begin0
	.quad	Lset149
Lset150 = Ltmp25-Lfunc_begin0
	.quad	Lset150
Lset151 = Ltmp26-Lfunc_begin0
	.quad	Lset151
Lset152 = Ltmp29-Lfunc_begin0
	.quad	Lset152
	.quad	0
	.quad	0
Ldebug_ranges5:
Lset153 = Ltmp29-Lfunc_begin0
	.quad	Lset153
Lset154 = Ltmp30-Lfunc_begin0
	.quad	Lset154
Lset155 = Ltmp31-Lfunc_begin0
	.quad	Lset155
Lset156 = Ltmp32-Lfunc_begin0
	.quad	Lset156
	.quad	0
	.quad	0
Ldebug_ranges6:
Lset157 = Ltmp30-Lfunc_begin0
	.quad	Lset157
Lset158 = Ltmp31-Lfunc_begin0
	.quad	Lset158
Lset159 = Ltmp32-Lfunc_begin0
	.quad	Lset159
Lset160 = Ltmp35-Lfunc_begin0
	.quad	Lset160
	.quad	0
	.quad	0
Ldebug_ranges7:
Lset161 = Ltmp36-Lfunc_begin0
	.quad	Lset161
Lset162 = Ltmp37-Lfunc_begin0
	.quad	Lset162
Lset163 = Ltmp38-Lfunc_begin0
	.quad	Lset163
Lset164 = Ltmp39-Lfunc_begin0
	.quad	Lset164
	.quad	0
	.quad	0
Ldebug_ranges8:
Lset165 = Ltmp37-Lfunc_begin0
	.quad	Lset165
Lset166 = Ltmp38-Lfunc_begin0
	.quad	Lset166
Lset167 = Ltmp39-Lfunc_begin0
	.quad	Lset167
Lset168 = Ltmp42-Lfunc_begin0
	.quad	Lset168
	.quad	0
	.quad	0
Ldebug_ranges9:
Lset169 = Ltmp42-Lfunc_begin0
	.quad	Lset169
Lset170 = Ltmp43-Lfunc_begin0
	.quad	Lset170
Lset171 = Ltmp44-Lfunc_begin0
	.quad	Lset171
Lset172 = Ltmp45-Lfunc_begin0
	.quad	Lset172
	.quad	0
	.quad	0
Ldebug_ranges10:
Lset173 = Ltmp43-Lfunc_begin0
	.quad	Lset173
Lset174 = Ltmp44-Lfunc_begin0
	.quad	Lset174
Lset175 = Ltmp45-Lfunc_begin0
	.quad	Lset175
Lset176 = Ltmp49-Lfunc_begin0
	.quad	Lset176
	.quad	0
	.quad	0
Ldebug_ranges11:
Lset177 = Ltmp52-Lfunc_begin0
	.quad	Lset177
Lset178 = Ltmp53-Lfunc_begin0
	.quad	Lset178
Lset179 = Ltmp54-Lfunc_begin0
	.quad	Lset179
Lset180 = Ltmp55-Lfunc_begin0
	.quad	Lset180
	.quad	0
	.quad	0
Ldebug_ranges12:
Lset181 = Ltmp53-Lfunc_begin0
	.quad	Lset181
Lset182 = Ltmp54-Lfunc_begin0
	.quad	Lset182
Lset183 = Ltmp55-Lfunc_begin0
	.quad	Lset183
Lset184 = Ltmp58-Lfunc_begin0
	.quad	Lset184
	.quad	0
	.quad	0
Ldebug_ranges13:
Lset185 = Ltmp65-Lfunc_begin0
	.quad	Lset185
Lset186 = Ltmp66-Lfunc_begin0
	.quad	Lset186
Lset187 = Ltmp67-Lfunc_begin0
	.quad	Lset187
Lset188 = Ltmp68-Lfunc_begin0
	.quad	Lset188
Lset189 = Ltmp69-Lfunc_begin0
	.quad	Lset189
Lset190 = Ltmp71-Lfunc_begin0
	.quad	Lset190
	.quad	0
	.quad	0
Ldebug_ranges14:
Lset191 = Ltmp66-Lfunc_begin0
	.quad	Lset191
Lset192 = Ltmp67-Lfunc_begin0
	.quad	Lset192
Lset193 = Ltmp68-Lfunc_begin0
	.quad	Lset193
Lset194 = Ltmp69-Lfunc_begin0
	.quad	Lset194
	.quad	0
	.quad	0
Ldebug_ranges15:
Lset195 = Ltmp72-Lfunc_begin0
	.quad	Lset195
Lset196 = Ltmp74-Lfunc_begin0
	.quad	Lset196
Lset197 = Ltmp137-Lfunc_begin0
	.quad	Lset197
Lset198 = Ltmp138-Lfunc_begin0
	.quad	Lset198
	.quad	0
	.quad	0
Ldebug_ranges16:
Lset199 = Ltmp77-Lfunc_begin0
	.quad	Lset199
Lset200 = Ltmp78-Lfunc_begin0
	.quad	Lset200
Lset201 = Ltmp119-Lfunc_begin0
	.quad	Lset201
Lset202 = Ltmp120-Lfunc_begin0
	.quad	Lset202
	.quad	0
	.quad	0
Ldebug_ranges17:
Lset203 = Ltmp78-Lfunc_begin0
	.quad	Lset203
Lset204 = Ltmp79-Lfunc_begin0
	.quad	Lset204
Lset205 = Ltmp120-Lfunc_begin0
	.quad	Lset205
Lset206 = Ltmp121-Lfunc_begin0
	.quad	Lset206
	.quad	0
	.quad	0
Ldebug_ranges18:
Lset207 = Ltmp80-Lfunc_begin0
	.quad	Lset207
Lset208 = Ltmp81-Lfunc_begin0
	.quad	Lset208
Lset209 = Ltmp82-Lfunc_begin0
	.quad	Lset209
Lset210 = Ltmp83-Lfunc_begin0
	.quad	Lset210
	.quad	0
	.quad	0
Ldebug_ranges19:
Lset211 = Ltmp81-Lfunc_begin0
	.quad	Lset211
Lset212 = Ltmp82-Lfunc_begin0
	.quad	Lset212
Lset213 = Ltmp83-Lfunc_begin0
	.quad	Lset213
Lset214 = Ltmp86-Lfunc_begin0
	.quad	Lset214
	.quad	0
	.quad	0
Ldebug_ranges20:
Lset215 = Ltmp86-Lfunc_begin0
	.quad	Lset215
Lset216 = Ltmp87-Lfunc_begin0
	.quad	Lset216
Lset217 = Ltmp88-Lfunc_begin0
	.quad	Lset217
Lset218 = Ltmp89-Lfunc_begin0
	.quad	Lset218
	.quad	0
	.quad	0
Ldebug_ranges21:
Lset219 = Ltmp87-Lfunc_begin0
	.quad	Lset219
Lset220 = Ltmp88-Lfunc_begin0
	.quad	Lset220
Lset221 = Ltmp89-Lfunc_begin0
	.quad	Lset221
Lset222 = Ltmp92-Lfunc_begin0
	.quad	Lset222
	.quad	0
	.quad	0
Ldebug_ranges22:
Lset223 = Ltmp93-Lfunc_begin0
	.quad	Lset223
Lset224 = Ltmp94-Lfunc_begin0
	.quad	Lset224
Lset225 = Ltmp95-Lfunc_begin0
	.quad	Lset225
Lset226 = Ltmp96-Lfunc_begin0
	.quad	Lset226
	.quad	0
	.quad	0
Ldebug_ranges23:
Lset227 = Ltmp94-Lfunc_begin0
	.quad	Lset227
Lset228 = Ltmp95-Lfunc_begin0
	.quad	Lset228
Lset229 = Ltmp96-Lfunc_begin0
	.quad	Lset229
Lset230 = Ltmp99-Lfunc_begin0
	.quad	Lset230
	.quad	0
	.quad	0
Ldebug_ranges24:
Lset231 = Ltmp99-Lfunc_begin0
	.quad	Lset231
Lset232 = Ltmp100-Lfunc_begin0
	.quad	Lset232
Lset233 = Ltmp101-Lfunc_begin0
	.quad	Lset233
Lset234 = Ltmp102-Lfunc_begin0
	.quad	Lset234
	.quad	0
	.quad	0
Ldebug_ranges25:
Lset235 = Ltmp100-Lfunc_begin0
	.quad	Lset235
Lset236 = Ltmp101-Lfunc_begin0
	.quad	Lset236
Lset237 = Ltmp102-Lfunc_begin0
	.quad	Lset237
Lset238 = Ltmp106-Lfunc_begin0
	.quad	Lset238
	.quad	0
	.quad	0
Ldebug_ranges26:
Lset239 = Ltmp109-Lfunc_begin0
	.quad	Lset239
Lset240 = Ltmp110-Lfunc_begin0
	.quad	Lset240
Lset241 = Ltmp111-Lfunc_begin0
	.quad	Lset241
Lset242 = Ltmp112-Lfunc_begin0
	.quad	Lset242
	.quad	0
	.quad	0
Ldebug_ranges27:
Lset243 = Ltmp110-Lfunc_begin0
	.quad	Lset243
Lset244 = Ltmp111-Lfunc_begin0
	.quad	Lset244
Lset245 = Ltmp112-Lfunc_begin0
	.quad	Lset245
Lset246 = Ltmp115-Lfunc_begin0
	.quad	Lset246
	.quad	0
	.quad	0
Ldebug_ranges28:
Lset247 = Ltmp123-Lfunc_begin0
	.quad	Lset247
Lset248 = Ltmp124-Lfunc_begin0
	.quad	Lset248
Lset249 = Ltmp125-Lfunc_begin0
	.quad	Lset249
Lset250 = Ltmp126-Lfunc_begin0
	.quad	Lset250
Lset251 = Ltmp127-Lfunc_begin0
	.quad	Lset251
Lset252 = Ltmp129-Lfunc_begin0
	.quad	Lset252
	.quad	0
	.quad	0
Ldebug_ranges29:
Lset253 = Ltmp124-Lfunc_begin0
	.quad	Lset253
Lset254 = Ltmp125-Lfunc_begin0
	.quad	Lset254
Lset255 = Ltmp126-Lfunc_begin0
	.quad	Lset255
Lset256 = Ltmp127-Lfunc_begin0
	.quad	Lset256
	.quad	0
	.quad	0
Ldebug_ranges30:
Lset257 = Ltmp129-Lfunc_begin0
	.quad	Lset257
Lset258 = Ltmp130-Lfunc_begin0
	.quad	Lset258
Lset259 = Ltmp134-Lfunc_begin0
	.quad	Lset259
Lset260 = Ltmp135-Lfunc_begin0
	.quad	Lset260
Lset261 = Ltmp138-Lfunc_begin0
	.quad	Lset261
Lset262 = Ltmp139-Lfunc_begin0
	.quad	Lset262
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.03"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"core"
	.asciz	"slice"
	.asciz	"sort"
	.asciz	"shared"
	.asciz	"pivot"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot12choose_pivotdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"choose_pivot<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"ptr"
	.asciz	"const_ptr"
	.asciz	"{impl#0}"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"add<f64>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot7median3dNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"median3<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
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
	.asciz	"cmp"
	.asciz	"{impl#13}"
	.asciz	"_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq"
	.asciz	"eq"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd20offset_from_unsignedCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"offset_from_unsigned<f64>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr4readINtNtNtB4_3mem12maybe_uninit11MaybeUninitdEECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"read<core::mem::maybe_uninit::MaybeUninit<f64>>"
	.asciz	"stable"
	.asciz	"quicksort"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort16stable_partitiondNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"stable_partition<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"num"
	.asciz	"{impl#11}"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj14saturating_sub"
	.asciz	"saturating_sub"
	.asciz	"mut_ptr"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3subCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"sub<f64>"
	.asciz	"PartitionState"
	.asciz	"_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksortINtB2_14PartitionStatedE13partition_oneCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"partition_one<f64>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"copy_nonoverlapping<f64>"
	.asciz	"iter"
	.asciz	"range"
	.asciz	"{impl#5}"
	.asciz	"_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"spec_next<usize>"
	.asciz	"{impl#6}"
	.asciz	"_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"next<usize>"
	.asciz	"impls"
	.asciz	"{impl#58}"
	.asciz	"_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt"
	.asciz	"lt"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd20split_at_mut_checkedCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"split_at_mut_checked<f64>"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd12split_at_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"split_at_mut<f64>"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd22split_at_mut_uncheckedCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"split_at_mut_unchecked<f64>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort16stable_partitiondNCINvB2_9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0E0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"stable_partition<f64, core::slice::sort::stable::quicksort::quicksort::{closure_env#0}<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>>"
	.asciz	"_RNCINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBc_3f64d9total_cmpE0E0CsfFAnx7WYh7o_12evidence_lab"
	.asciz	"{closure#0}<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"index"
	.asciz	"{impl#7}"
	.asciz	"_RNvXs5_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range9RangeFromjEINtB5_10SliceIndexSdE9index_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"index_mut<f64>"
	.asciz	"{impl#1}"
	.asciz	"_RNvXs_NtNtCsjIpoRzUjyHQ_4core5slice5indexSdINtNtNtB8_3ops5index8IndexMutINtNtBK_5range9RangeFromjEE9index_mutCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"index_mut<f64, core::ops::range::RangeFrom<usize>>"
	.asciz	"smallsort"
	.asciz	"_RINvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortdNtB5_23StableSmallSortTypeImpl10small_sortNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBd_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"small_sort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index28get_offset_len_mut_noubcheckdECsfFAnx7WYh7o_12evidence_lab"
	.asciz	"get_offset_len_mut_noubcheck<f64>"
	.asciz	"quicksort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	27
	.long	55
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	3
	.long	4
	.long	5
	.long	-1
	.long	6
	.long	7
	.long	11
	.long	12
	.long	14
	.long	15
	.long	17
	.long	18
	.long	20
	.long	22
	.long	26
	.long	27
	.long	31
	.long	33
	.long	34
	.long	35
	.long	39
	.long	40
	.long	43
	.long	46
	.long	48
	.long	51
	.long	239228802
	.long	2001719952
	.long	-694171966
	.long	-1754553576
	.long	2020982132
	.long	-167387869
	.long	-1623469949
	.long	-1710710458
	.long	-1472205121
	.long	-1332088270
	.long	-1275522973
	.long	358720306
	.long	5863355
	.long	-942777833
	.long	1409060592
	.long	1152739981
	.long	-15533895
	.long	-430092947
	.long	524621298
	.long	-1710870508
	.long	791849290
	.long	2095897963
	.long	209439230
	.long	-1765538810
	.long	-1306255931
	.long	-678578939
	.long	-133955269
	.long	2070688471
	.long	-1263282567
	.long	-1242731463
	.long	-473273745
	.long	1435269122
	.long	-158655704
	.long	634940550
	.long	2041624
	.long	304516982
	.long	1483294808
	.long	-2017384220
	.long	-1046578025
	.long	-1258739380
	.long	701239324
	.long	1535677672
	.long	-518045544
	.long	1116636971
	.long	-1368631592
	.long	-270958553
	.long	-559089349
	.long	-225265102
	.long	1945005289
	.long	-461902038
	.long	-263970789
	.long	5863589
	.long	1597742495
	.long	-2087322314
	.long	-1652370674
Lset263 = LNames15-Lnames_begin
	.long	Lset263
Lset264 = LNames22-Lnames_begin
	.long	Lset264
Lset265 = LNames3-Lnames_begin
	.long	Lset265
Lset266 = LNames32-Lnames_begin
	.long	Lset266
Lset267 = LNames35-Lnames_begin
	.long	Lset267
Lset268 = LNames0-Lnames_begin
	.long	Lset268
Lset269 = LNames33-Lnames_begin
	.long	Lset269
Lset270 = LNames1-Lnames_begin
	.long	Lset270
Lset271 = LNames6-Lnames_begin
	.long	Lset271
Lset272 = LNames23-Lnames_begin
	.long	Lset272
Lset273 = LNames21-Lnames_begin
	.long	Lset273
Lset274 = LNames20-Lnames_begin
	.long	Lset274
Lset275 = LNames14-Lnames_begin
	.long	Lset275
Lset276 = LNames25-Lnames_begin
	.long	Lset276
Lset277 = LNames2-Lnames_begin
	.long	Lset277
Lset278 = LNames13-Lnames_begin
	.long	Lset278
Lset279 = LNames51-Lnames_begin
	.long	Lset279
Lset280 = LNames40-Lnames_begin
	.long	Lset280
Lset281 = LNames48-Lnames_begin
	.long	Lset281
Lset282 = LNames39-Lnames_begin
	.long	Lset282
Lset283 = LNames24-Lnames_begin
	.long	Lset283
Lset284 = LNames44-Lnames_begin
	.long	Lset284
Lset285 = LNames53-Lnames_begin
	.long	Lset285
Lset286 = LNames50-Lnames_begin
	.long	Lset286
Lset287 = LNames7-Lnames_begin
	.long	Lset287
Lset288 = LNames16-Lnames_begin
	.long	Lset288
Lset289 = LNames54-Lnames_begin
	.long	Lset289
Lset290 = LNames47-Lnames_begin
	.long	Lset290
Lset291 = LNames26-Lnames_begin
	.long	Lset291
Lset292 = LNames41-Lnames_begin
	.long	Lset292
Lset293 = LNames37-Lnames_begin
	.long	Lset293
Lset294 = LNames19-Lnames_begin
	.long	Lset294
Lset295 = LNames12-Lnames_begin
	.long	Lset295
Lset296 = LNames45-Lnames_begin
	.long	Lset296
Lset297 = LNames4-Lnames_begin
	.long	Lset297
Lset298 = LNames43-Lnames_begin
	.long	Lset298
Lset299 = LNames9-Lnames_begin
	.long	Lset299
Lset300 = LNames36-Lnames_begin
	.long	Lset300
Lset301 = LNames42-Lnames_begin
	.long	Lset301
Lset302 = LNames11-Lnames_begin
	.long	Lset302
Lset303 = LNames49-Lnames_begin
	.long	Lset303
Lset304 = LNames52-Lnames_begin
	.long	Lset304
Lset305 = LNames10-Lnames_begin
	.long	Lset305
Lset306 = LNames5-Lnames_begin
	.long	Lset306
Lset307 = LNames27-Lnames_begin
	.long	Lset307
Lset308 = LNames17-Lnames_begin
	.long	Lset308
Lset309 = LNames28-Lnames_begin
	.long	Lset309
Lset310 = LNames18-Lnames_begin
	.long	Lset310
Lset311 = LNames46-Lnames_begin
	.long	Lset311
Lset312 = LNames38-Lnames_begin
	.long	Lset312
Lset313 = LNames31-Lnames_begin
	.long	Lset313
Lset314 = LNames34-Lnames_begin
	.long	Lset314
Lset315 = LNames29-Lnames_begin
	.long	Lset315
Lset316 = LNames8-Lnames_begin
	.long	Lset316
Lset317 = LNames30-Lnames_begin
	.long	Lset317
LNames15:
	.long	1317
	.long	12
	.long	348
	.long	430
	.long	651
	.long	778
	.long	905
	.long	1032
	.long	1199
	.long	1603
	.long	1743
	.long	1883
	.long	2023
	.long	2203
	.long	0
LNames22:
	.long	2039
	.long	2
	.long	574
	.long	1514
	.long	0
LNames3:
	.long	198
	.long	1
	.long	215
	.long	0
LNames32:
	.long	2568
	.long	2
	.long	1367
	.long	2372
	.long	0
LNames35:
	.long	2760
	.long	2
	.long	1380
	.long	2385
	.long	0
LNames0:
	.long	4716
	.long	1
	.long	190
	.long	0
LNames33:
	.long	2435
	.long	2
	.long	1367
	.long	2372
	.long	0
LNames1:
	.long	4825
	.long	1
	.long	190
	.long	0
LNames6:
	.long	753
	.long	1
	.long	267
	.long	0
LNames23:
	.long	1988
	.long	2
	.long	574
	.long	1514
	.long	0
LNames21:
	.long	1680
	.long	1
	.long	554
	.long	0
LNames20:
	.long	1858
	.long	1
	.long	554
	.long	0
LNames14:
	.long	1383
	.long	12
	.long	348
	.long	430
	.long	651
	.long	778
	.long	905
	.long	1032
	.long	1199
	.long	1603
	.long	1743
	.long	1883
	.long	2023
	.long	2203
	.long	0
LNames25:
	.long	2161
	.long	12
	.long	672
	.long	799
	.long	926
	.long	1053
	.long	1220
	.long	1273
	.long	1625
	.long	1765
	.long	1905
	.long	2045
	.long	2225
	.long	2278
	.long	0
LNames2:
	.long	368
	.long	1
	.long	215
	.long	0
LNames13:
	.long	864
	.long	13
	.long	327
	.long	409
	.long	532
	.long	630
	.long	757
	.long	884
	.long	1011
	.long	1178
	.long	1582
	.long	1722
	.long	1862
	.long	2002
	.long	2182
	.long	0
LNames51:
	.long	4682
	.long	1
	.long	2445
	.long	0
LNames40:
	.long	3194
	.long	1
	.long	1449
	.long	0
LNames48:
	.long	4066
	.long	1
	.long	2421
	.long	0
LNames39:
	.long	2826
	.long	1
	.long	1428
	.long	0
LNames24:
	.long	2289
	.long	12
	.long	672
	.long	799
	.long	926
	.long	1053
	.long	1220
	.long	1273
	.long	1625
	.long	1765
	.long	1905
	.long	2045
	.long	2225
	.long	2278
	.long	0
LNames44:
	.long	3222
	.long	1
	.long	1494
	.long	0
LNames53:
	.long	4471
	.long	1
	.long	2468
	.long	0
LNames50:
	.long	3907
	.long	1
	.long	2433
	.long	0
LNames7:
	.long	589
	.long	1
	.long	267
	.long	0
LNames16:
	.long	1481
	.long	1
	.long	452
	.long	0
LNames54:
	.long	4266
	.long	1
	.long	2468
	.long	0
LNames47:
	.long	4205
	.long	1
	.long	2421
	.long	0
LNames26:
	.long	2137
	.long	12
	.long	684
	.long	811
	.long	938
	.long	1065
	.long	1232
	.long	1293
	.long	1637
	.long	1777
	.long	1917
	.long	2057
	.long	2237
	.long	2298
	.long	0
LNames41:
	.long	3107
	.long	1
	.long	1449
	.long	0
LNames37:
	.long	2937
	.long	1
	.long	1416
	.long	0
LNames19:
	.long	1507
	.long	1
	.long	472
	.long	0
LNames12:
	.long	906
	.long	13
	.long	327
	.long	409
	.long	532
	.long	630
	.long	757
	.long	884
	.long	1011
	.long	1178
	.long	1582
	.long	1722
	.long	1862
	.long	2002
	.long	2182
	.long	0
LNames45:
	.long	3781
	.long	5
	.long	1538
	.long	1678
	.long	1818
	.long	1958
	.long	2138
	.long	0
LNames4:
	.long	580
	.long	9
	.long	227
	.long	247
	.long	586
	.long	1105
	.long	1126
	.long	1470
	.long	1526
	.long	2097
	.long	2118
	.long	0
LNames43:
	.long	3421
	.long	1
	.long	1494
	.long	0
LNames9:
	.long	1131
	.long	13
	.long	287
	.long	369
	.long	492
	.long	598
	.long	725
	.long	852
	.long	979
	.long	1146
	.long	1550
	.long	1690
	.long	1830
	.long	1970
	.long	2150
	.long	0
LNames36:
	.long	3014
	.long	1
	.long	1416
	.long	0
LNames42:
	.long	3032
	.long	1
	.long	1470
	.long	0
LNames11:
	.long	935
	.long	13
	.long	307
	.long	389
	.long	512
	.long	610
	.long	737
	.long	864
	.long	991
	.long	1158
	.long	1562
	.long	1702
	.long	1842
	.long	1982
	.long	2162
	.long	0
LNames49:
	.long	4042
	.long	1
	.long	2433
	.long	0
LNames52:
	.long	4581
	.long	1
	.long	2445
	.long	0
LNames10:
	.long	1055
	.long	13
	.long	307
	.long	389
	.long	512
	.long	610
	.long	737
	.long	864
	.long	991
	.long	1158
	.long	1562
	.long	1702
	.long	1842
	.long	1982
	.long	2162
	.long	0
LNames5:
	.long	503
	.long	8
	.long	227
	.long	247
	.long	586
	.long	1105
	.long	1126
	.long	1526
	.long	2097
	.long	2118
	.long	0
LNames27:
	.long	2062
	.long	12
	.long	684
	.long	811
	.long	938
	.long	1065
	.long	1232
	.long	1293
	.long	1637
	.long	1777
	.long	1917
	.long	2057
	.long	2237
	.long	2298
	.long	0
LNames17:
	.long	1386
	.long	1
	.long	452
	.long	0
LNames28:
	.long	2390
	.long	16
	.long	704
	.long	831
	.long	958
	.long	1085
	.long	1252
	.long	1313
	.long	1334
	.long	1403
	.long	1657
	.long	1797
	.long	1937
	.long	2077
	.long	2257
	.long	2318
	.long	2339
	.long	2408
	.long	0
LNames18:
	.long	1615
	.long	1
	.long	472
	.long	0
LNames46:
	.long	3608
	.long	5
	.long	1538
	.long	1678
	.long	1818
	.long	1958
	.long	2138
	.long	0
LNames38:
	.long	2911
	.long	1
	.long	1428
	.long	0
LNames31:
	.long	2594
	.long	2
	.long	1354
	.long	2359
	.long	0
LNames34:
	.long	2823
	.long	2
	.long	1380
	.long	2385
	.long	0
LNames29:
	.long	2308
	.long	16
	.long	704
	.long	831
	.long	958
	.long	1085
	.long	1252
	.long	1313
	.long	1334
	.long	1403
	.long	1657
	.long	1797
	.long	1937
	.long	2077
	.long	2257
	.long	2318
	.long	2339
	.long	2408
	.long	0
LNames8:
	.long	1247
	.long	13
	.long	287
	.long	369
	.long	492
	.long	598
	.long	725
	.long	852
	.long	979
	.long	1146
	.long	1550
	.long	1690
	.long	1830
	.long	1970
	.long	2150
	.long	0
LNames30:
	.long	2732
	.long	2
	.long	1354
	.long	2359
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
	.long	4
	.long	5
	.long	7
	.long	8
	.long	9
	.long	13
	.long	15
	.long	19
	.long	20
	.long	22
	.long	24
	.long	26
	.long	27
	.long	29
	.long	30
	.long	253189136
	.long	478822272
	.long	-1664328064
	.long	-476042384
	.long	-1762130655
	.long	272956402
	.long	-1738516798
	.long	-1738516765
	.long	-1536480780
	.long	193488517
	.long	193489909
	.long	193500757
	.long	274532053
	.long	212625478
	.long	-1536480714
	.long	193501687
	.long	270881047
	.long	-1738516633
	.long	-1553617785
	.long	-1738516600
	.long	2090376761
	.long	-1738516567
	.long	262716714
	.long	-662467286
	.long	193502907
	.long	-735823797
	.long	464608412
	.long	262739357
	.long	2090731117
	.long	2090156110
	.long	221207599
	.long	-1536476193
Lset318 = Lnamespac12-Lnamespac_begin
	.long	Lset318
Lset319 = Lnamespac16-Lnamespac_begin
	.long	Lset319
Lset320 = Lnamespac21-Lnamespac_begin
	.long	Lset320
Lset321 = Lnamespac20-Lnamespac_begin
	.long	Lset321
Lset322 = Lnamespac6-Lnamespac_begin
	.long	Lset322
Lset323 = Lnamespac23-Lnamespac_begin
	.long	Lset323
Lset324 = Lnamespac7-Lnamespac_begin
	.long	Lset324
Lset325 = Lnamespac30-Lnamespac_begin
	.long	Lset325
Lset326 = Lnamespac19-Lnamespac_begin
	.long	Lset326
Lset327 = Lnamespac14-Lnamespac_begin
	.long	Lset327
Lset328 = Lnamespac8-Lnamespac_begin
	.long	Lset328
Lset329 = Lnamespac18-Lnamespac_begin
	.long	Lset329
Lset330 = Lnamespac1-Lnamespac_begin
	.long	Lset330
Lset331 = Lnamespac31-Lnamespac_begin
	.long	Lset331
Lset332 = Lnamespac15-Lnamespac_begin
	.long	Lset332
Lset333 = Lnamespac9-Lnamespac_begin
	.long	Lset333
Lset334 = Lnamespac4-Lnamespac_begin
	.long	Lset334
Lset335 = Lnamespac24-Lnamespac_begin
	.long	Lset335
Lset336 = Lnamespac13-Lnamespac_begin
	.long	Lset336
Lset337 = Lnamespac25-Lnamespac_begin
	.long	Lset337
Lset338 = Lnamespac22-Lnamespac_begin
	.long	Lset338
Lset339 = Lnamespac29-Lnamespac_begin
	.long	Lset339
Lset340 = Lnamespac26-Lnamespac_begin
	.long	Lset340
Lset341 = Lnamespac17-Lnamespac_begin
	.long	Lset341
Lset342 = Lnamespac5-Lnamespac_begin
	.long	Lset342
Lset343 = Lnamespac10-Lnamespac_begin
	.long	Lset343
Lset344 = Lnamespac3-Lnamespac_begin
	.long	Lset344
Lset345 = Lnamespac28-Lnamespac_begin
	.long	Lset345
Lset346 = Lnamespac2-Lnamespac_begin
	.long	Lset346
Lset347 = Lnamespac0-Lnamespac_begin
	.long	Lset347
Lset348 = Lnamespac11-Lnamespac_begin
	.long	Lset348
Lset349 = Lnamespac27-Lnamespac_begin
	.long	Lset349
Lnamespac12:
	.long	1117
	.long	1
	.long	3003
	.long	0
Lnamespac16:
	.long	1663
	.long	1
	.long	117
	.long	0
Lnamespac21:
	.long	2146
	.long	1
	.long	140
	.long	0
Lnamespac20:
	.long	2054
	.long	1
	.long	2690
	.long	0
Lnamespac6:
	.long	484
	.long	1
	.long	2600
	.long	0
Lnamespac23:
	.long	2420
	.long	1
	.long	2931
	.long	0
Lnamespac7:
	.long	494
	.long	5
	.long	2492
	.long	2605
	.long	2695
	.long	2773
	.long	3013
	.long	0
Lnamespac30:
	.long	4057
	.long	2
	.long	97
	.long	2563
	.long	0
Lnamespac19:
	.long	1978
	.long	1
	.long	2893
	.long	0
Lnamespac14:
	.long	1303
	.long	1
	.long	2825
	.long	0
Lnamespac8:
	.long	860
	.long	1
	.long	2768
	.long	0
Lnamespac18:
	.long	1974
	.long	1
	.long	2888
	.long	0
Lnamespac1:
	.long	174
	.long	2
	.long	47
	.long	3008
	.long	0
Lnamespac31:
	.long	4256
	.long	1
	.long	92
	.long	0
Lnamespac15:
	.long	1307
	.long	1
	.long	2830
	.long	0
Lnamespac9:
	.long	916
	.long	1
	.long	2794
	.long	0
Lnamespac4:
	.long	192
	.long	1
	.long	62
	.long	0
Lnamespac24:
	.long	2426
	.long	1
	.long	2936
	.long	0
Lnamespac13:
	.long	1123
	.long	1
	.long	3018
	.long	0
Lnamespac25:
	.long	2585
	.long	1
	.long	2968
	.long	0
Lnamespac22:
	.long	2415
	.long	1
	.long	2926
	.long	0
Lnamespac29:
	.long	3898
	.long	1
	.long	2544
	.long	0
Lnamespac26:
	.long	2744
	.long	1
	.long	2849
	.long	0
Lnamespac17:
	.long	1670
	.long	2
	.long	122
	.long	171
	.long	0
Lnamespac5:
	.long	480
	.long	1
	.long	2595
	.long	0
Lnamespac10:
	.long	920
	.long	1
	.long	2799
	.long	0
Lnamespac3:
	.long	185
	.long	1
	.long	57
	.long	0
Lnamespac28:
	.long	3892
	.long	1
	.long	2539
	.long	0
Lnamespac2:
	.long	180
	.long	1
	.long	52
	.long	0
Lnamespac0:
	.long	169
	.long	1
	.long	42
	.long	0
Lnamespac11:
	.long	929
	.long	1
	.long	2804
	.long	0
Lnamespac27:
	.long	2750
	.long	1
	.long	2854
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
