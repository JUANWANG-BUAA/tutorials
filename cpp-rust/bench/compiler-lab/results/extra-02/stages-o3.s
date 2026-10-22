	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages
	.globl	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages
	.p2align	2
__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages:
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
	adrp	x1, l_vtable.0@PAGE
Lloh1:
	add	x1, x1, l_vtable.0@PAGEOFF
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
__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages:
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
__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.private_extern	__RNvCs9CzmnnBYieY_6stages4main
	.globl	__RNvCs9CzmnnBYieY_6stages4main
	.p2align	2
__RNvCs9CzmnnBYieY_6stages4main:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	str	xzr, [sp]
	mov	w8, #1
	strb	w8, [sp, #15]
	add	x8, sp, #15
	; InlineAsm Start
	; InlineAsm End
	ldrb	w8, [sp, #15]
	mov	x9, sp
	str	x9, [sp, #16]
	tbz	w8, #0, LBB4_2
	ldr	x8, [sp]
	add	x8, x8, #1
	str	x8, [sp]
	add	x8, sp, #16
	stur	x8, [x29, #-8]
	sub	x8, x29, #8
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [sp, #16]
	ldr	x9, [x8]
	add	x9, x9, #1
	str	x9, [x8]
	ldr	x8, [sp]
	b	LBB4_3
LBB4_2:
	add	x8, sp, #16
	stur	x8, [x29, #-8]
	sub	x8, x29, #8
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [sp, #16]
	ldr	x9, [x8]
	add	x9, x9, #1
	str	x9, [x8]
	ldr	x8, [sp]
	add	x8, x8, #1
	str	x8, [sp]
LBB4_3:
	stur	x8, [x29, #-8]
	cmp	x8, #2
	b.ne	LBB4_5
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB4_5:
	.cfi_restore_state
Lloh2:
	adrp	x2, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGE
Lloh3:
	add	x2, x2, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGEOFF
Lloh4:
	adrp	x5, l_alloc_770cfff3e7ea7887b74e74f003c9be9a@PAGE
Lloh5:
	add	x5, x5, l_alloc_770cfff3e7ea7887b74e74f003c9be9a@PAGEOFF
	sub	x1, x29, #8
	mov	w0, #0
	mov	x3, #0
	bl	__RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
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
Lloh6:
	adrp	x8, __RNvCs9CzmnnBYieY_6stages4main@PAGE
Lloh7:
	add	x8, x8, __RNvCs9CzmnnBYieY_6stages4main@PAGEOFF
	str	x8, [sp, #8]
Lloh8:
	adrp	x1, l_vtable.0@PAGE
Lloh9:
	add	x1, x1, l_vtable.0@PAGEOFF
	add	x0, sp, #8
	mov	w4, #0
	bl	__RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh6, Lloh7
	.cfi_endproc

	.section	__DATA,__const
	.p2align	3, 0x0
l_vtable.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages
	.quad	__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages
	.quad	__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages

	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
l_alloc_f85406d658e94b9c37cd2112f10307ee:
	.asciz	"\002\000\000\000\000\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_alloc_2ff739fb30955571335d6ded878dde47:
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/compiler-lab/probes/stages.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_alloc_770cfff3e7ea7887b74e74f003c9be9a:
	.quad	l_alloc_2ff739fb30955571335d6ded878dde47
	.asciz	"N\000\000\000\000\000\000\000\024\000\000\000\005\000\000"

.subsections_via_symbols
