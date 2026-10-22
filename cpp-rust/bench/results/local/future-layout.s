	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECsjV46J4n7g6N_13future_layout
	.globl	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECsjV46J4n7g6N_13future_layout
	.p2align	2
__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECsjV46J4n7g6N_13future_layout:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x4, x3
	mov	x3, x2
	mov	x2, x1
	str	x0, [sp, #8]
Lloh0:
	adrp	x1, l_anon.10152ef17e257522430061fa358411d7.0@PAGE
Lloh1:
	add	x1, x1, l_anon.10152ef17e257522430061fa358411d7.0@PAGEOFF
	add	x0, sp, #8
	bl	__RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.p2align	2
__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECsjV46J4n7g6N_13future_layout:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	blr	x0
	; InlineAsm Start
	; InlineAsm End
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0CsjV46J4n7g6N_13future_layout:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECsjV46J4n7g6N_13future_layout
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCsjV46J4n7g6N_13future_layout:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECsjV46J4n7g6N_13future_layout
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.private_extern	__RNvCsjV46J4n7g6N_13future_layout4main
	.globl	__RNvCsjV46J4n7g6N_13future_layout4main
	.p2align	2
__RNvCsjV46J4n7g6N_13future_layout4main:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
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
	.cfi_remember_state
	mov	w8, #4097
	str	x8, [sp]
	mov	w19, #1
	str	x19, [sp, #40]
Lloh2:
	adrp	x20, __RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGE
Lloh3:
	ldr	x20, [x20, __RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGEOFF]
	mov	x21, sp
	stp	x21, x20, [sp, #8]
	add	x22, sp, #40
	stp	x22, x20, [sp, #24]
Lloh4:
	adrp	x0, l_anon.10152ef17e257522430061fa358411d7.2@PAGE
Lloh5:
	add	x0, x0, l_anon.10152ef17e257522430061fa358411d7.2@PAGEOFF
	add	x1, sp, #8
	bl	__RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print
	mov	w8, #2
	stp	x8, x21, [sp]
	stp	x20, x19, [sp, #32]
	stp	x20, x22, [sp, #16]
Lloh6:
	adrp	x0, l_anon.10152ef17e257522430061fa358411d7.3@PAGE
Lloh7:
	add	x0, x0, l_anon.10152ef17e257522430061fa358411d7.3@PAGEOFF
	add	x1, sp, #8
	bl	__RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #24
	mov	w1, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
	cbz	x0, LBB4_13
	mov	x19, x0
	mov	w8, #1
	dup.2d	v0, x8
	str	q0, [x0]
	str	xzr, [x0, #16]
	str	x0, [sp, #40]
	ldadd	x8, x8, [x0]
	tbnz	x8, #63, LBB4_17
	str	x19, [sp, #8]
	strb	wzr, [sp, #24]
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB4_4
	dmb	ishld
	add	x0, sp, #8
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtCsjIpoRzUjyHQ_4core4sync6atomic6AtomicjEE9drop_slowCsjV46J4n7g6N_13future_layout
LBB4_4:
	ldr	x8, [x19, #16]
	str	x8, [sp, #8]
	cbnz	x8, LBB4_14
	mov	w8, #1
	ldadd	x8, x8, [x19]
	tbnz	x8, #63, LBB4_17
	stp	x19, x19, [sp, #8]
	mov	w8, #3
	strb	w8, [sp, #24]
	add	x8, x19, #16
	mov	w9, #1
	ldadd	x9, x8, [x8]
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB4_8
	add	x8, sp, #8
	dmb	ishld
	add	x0, x8, #8
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtCsjIpoRzUjyHQ_4core4sync6atomic6AtomicjEE9drop_slowCsjV46J4n7g6N_13future_layout
LBB4_8:
	ldr	x8, [x19, #16]
	str	x8, [sp, #8]
	cmp	x8, #1
	b.ne	LBB4_15
Ltmp2:
Lloh8:
	adrp	x0, l_anon.10152ef17e257522430061fa358411d7.6@PAGE
Lloh9:
	add	x0, x0, l_anon.10152ef17e257522430061fa358411d7.6@PAGEOFF
	mov	w1, #125
	bl	__RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print
Ltmp3:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB4_12
	dmb	ishld
	add	x0, sp, #40
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtCsjIpoRzUjyHQ_4core4sync6atomic6AtomicjEE9drop_slowCsjV46J4n7g6N_13future_layout
LBB4_12:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	add	sp, sp, #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB4_13:
	.cfi_restore_state
	mov	w0, #8
	mov	w1, #24
	bl	__RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error
LBB4_14:
Lloh10:
	adrp	x5, l_anon.10152ef17e257522430061fa358411d7.8@PAGE
Lloh11:
	add	x5, x5, l_anon.10152ef17e257522430061fa358411d7.8@PAGEOFF
	add	x1, sp, #8
Lloh12:
	adrp	x2, l_anon.10152ef17e257522430061fa358411d7.4@PAGE
Lloh13:
	add	x2, x2, l_anon.10152ef17e257522430061fa358411d7.4@PAGEOFF
	b	LBB4_16
LBB4_15:
Lloh14:
	adrp	x5, l_anon.10152ef17e257522430061fa358411d7.7@PAGE
Lloh15:
	add	x5, x5, l_anon.10152ef17e257522430061fa358411d7.7@PAGEOFF
	add	x1, sp, #8
Lloh16:
	adrp	x2, l_anon.10152ef17e257522430061fa358411d7.5@PAGE
Lloh17:
	add	x2, x2, l_anon.10152ef17e257522430061fa358411d7.5@PAGEOFF
LBB4_16:
Ltmp0:
	mov	w0, #0
	mov	x3, #0
	bl	__RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedjjEB4_
Ltmp1:
LBB4_17:
	brk	#0x1
LBB4_18:
Ltmp4:
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB4_20
	dmb	ishld
	mov	x19, x0
	add	x0, sp, #40
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtCsjIpoRzUjyHQ_4core4sync6atomic6AtomicjEE9drop_slowCsjV46J4n7g6N_13future_layout
	mov	x0, x19
LBB4_20:
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp2-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp2-Lfunc_begin0
	.uleb128 Ltmp3-Ltmp2
	.uleb128 Ltmp4-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp3-Lfunc_begin0
	.uleb128 Ltmp0-Ltmp3
	.byte	0
	.byte	0
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp0
	.uleb128 Ltmp4-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp1-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp1
	.byte	0
	.byte	0
Lcst_end0:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtCsjIpoRzUjyHQ_4core4sync6atomic6AtomicjEE9drop_slowCsjV46J4n7g6N_13future_layout:
	.cfi_startproc
	ldr	x0, [x0]
	cmn	x0, #1
	b.eq	LBB5_3
	add	x8, x0, #8
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB5_3
	dmb	ishld
	mov	w1, #24
	mov	w2, #8
	b	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
LBB5_3:
	ret
	.cfi_endproc

	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x1
	sxtw	x2, w0
Lloh18:
	adrp	x8, __RNvCsjV46J4n7g6N_13future_layout4main@PAGE
Lloh19:
	add	x8, x8, __RNvCsjV46J4n7g6N_13future_layout4main@PAGEOFF
	str	x8, [sp, #8]
Lloh20:
	adrp	x1, l_anon.10152ef17e257522430061fa358411d7.0@PAGE
Lloh21:
	add	x1, x1, l_anon.10152ef17e257522430061fa358411d7.0@PAGEOFF
	add	x0, sp, #8
	mov	w4, #0
	bl	__RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh18, Lloh19
	.cfi_endproc

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.10152ef17e257522430061fa358411d7.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCsjV46J4n7g6N_13future_layout
	.quad	__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0CsjV46J4n7g6N_13future_layout
	.quad	__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0CsjV46J4n7g6N_13future_layout

	.section	__TEXT,__cstring,cstring_literals
l_anon.10152ef17e257522430061fa358411d7.1:
	.asciz	"examples/future_layout.rs"

l_anon.10152ef17e257522430061fa358411d7.2:
	.asciz	"\022across_await size=\300\007 align=\300\001\n"

l_anon.10152ef17e257522430061fa358411d7.3:
	.asciz	"\022before_await size=\300\007 align=\300\001\n"

	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
l_anon.10152ef17e257522430061fa358411d7.4:
	.space	8

	.p2align	3, 0x0
l_anon.10152ef17e257522430061fa358411d7.5:
	.asciz	"\001\000\000\000\000\000\000"

	.section	__TEXT,__const
l_anon.10152ef17e257522430061fa358411d7.6:
	.ascii	"drop before first poll: 0 guards; drop after Pending: 1 guard\n"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.10152ef17e257522430061fa358411d7.7:
	.quad	l_anon.10152ef17e257522430061fa358411d7.1
	.asciz	"\031\000\000\000\000\000\000\0009\000\000\000\005\000\000"

	.p2align	3, 0x0
l_anon.10152ef17e257522430061fa358411d7.8:
	.quad	l_anon.10152ef17e257522430061fa358411d7.1
	.asciz	"\031\000\000\000\000\000\000\0003\000\000\000\005\000\000"

.subsections_via_symbols
