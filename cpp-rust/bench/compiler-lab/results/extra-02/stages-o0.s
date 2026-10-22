	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages
	.globl	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages
	.p2align	2
__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	str	x1, [sp, #8]
	mov	x0, x2
	ldr	x2, [sp, #8]
	str	x0, [sp, #16]
	mov	x4, x3
	ldr	x3, [sp, #16]
	sub	x0, x29, #8
	stur	x8, [x29, #-8]
	adrp	x1, l_vtable.0@PAGE
	add	x1, x1, l_vtable.0@PAGEOFF
	bl	__RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core3mem4dropNtCs9CzmnnBYieY_6stages5GuardEBy_:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	add	x0, sp, #8
	str	x8, [sp, #8]
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvXCs9CzmnnBYieY_6stagesNtB2_5GuardNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRNtCs9CzmnnBYieY_6stages5GuardEBF_:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	add	x8, sp, #8
	str	x0, [sp, #8]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxbECs9CzmnnBYieY_6stages:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	add	x8, sp, #15
	strb	w0, [sp, #15]
	; InlineAsm Start
	; InlineAsm End
	ldrb	w8, [sp, #15]
	and	w0, w8, #0x1
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvYFEuINtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages
	; InlineAsm Start
	; InlineAsm End
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
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
	bl	__RNvXsU_NtCs1SSuMAdGM58_3std7processuNtB5_11Termination6reportCs9CzmnnBYieY_6stages
	and	w0, w0, #0xff
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
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__RNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNvCs9CzmnnBYieY_6stages11conditional:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	sturb	wzr, [x29, #-17]
	mov	w8, #1
	sturb	w8, [x29, #-17]
	mov	x8, x1
	str	x8, [sp, #8]
	str	x1, [sp, #16]
	tbnz	w0, #0, LBB8_2
	b	LBB8_1
LBB8_1:
Ltmp4:
	add	x0, sp, #16
	bl	__RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRNtCs9CzmnnBYieY_6stages5GuardEBF_
Ltmp5:
	b	LBB8_6
LBB8_2:
	sturb	wzr, [x29, #-17]
	ldr	x0, [sp, #8]
Ltmp2:
	bl	__RINvNtCsjIpoRzUjyHQ_4core3mem4dropNtCs9CzmnnBYieY_6stages5GuardEBy_
Ltmp3:
	b	LBB8_5
LBB8_3:
Ltmp7:
	add	x0, sp, #16
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_
Ltmp8:
	b	LBB8_7
LBB8_4:
Ltmp6:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB8_3
LBB8_5:
	b	LBB8_1
LBB8_6:
Ltmp9:
	add	x0, sp, #16
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_
Ltmp10:
	b	LBB8_9
LBB8_7:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB8_14
	b	LBB8_13
LBB8_8:
Ltmp11:
	stur	x0, [x29, #-16]
	mov	x8, x1
	stur	w8, [x29, #-8]
	b	LBB8_7
LBB8_9:
	ldurb	w8, [x29, #-17]
	tbnz	w8, #0, LBB8_11
	b	LBB8_10
LBB8_10:
	sturb	wzr, [x29, #-17]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB8_11:
	.cfi_restore_state
	add	x0, sp, #8
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_
	b	LBB8_10
LBB8_12:
Ltmp14:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup
LBB8_13:
	ldur	x0, [x29, #-16]
	bl	__Unwind_Resume
LBB8_14:
Ltmp12:
	add	x0, sp, #8
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_
Ltmp13:
	b	LBB8_13
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception0:
	.byte	255
	.byte	155
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp4-Lfunc_begin0
	.uleb128 Ltmp3-Ltmp4
	.uleb128 Ltmp6-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp7-Lfunc_begin0
	.uleb128 Ltmp8-Ltmp7
	.uleb128 Ltmp14-Lfunc_begin0
	.byte	1
	.uleb128 Ltmp9-Lfunc_begin0
	.uleb128 Ltmp10-Ltmp9
	.uleb128 Ltmp11-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp10-Lfunc_begin0
	.uleb128 Ltmp12-Ltmp10
	.byte	0
	.byte	0
	.uleb128 Ltmp12-Lfunc_begin0
	.uleb128 Ltmp13-Ltmp12
	.uleb128 Ltmp14-Lfunc_begin0
	.byte	1
Lcst_end0:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase0:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
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
	mov	x0, #0
	bl	__RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3newCs9CzmnnBYieY_6stages
	add	x8, sp, #16
	str	x8, [sp, #8]
	str	x0, [sp, #16]
	mov	w8, #1
	and	w0, w8, #0x1
	bl	__RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxbECs9CzmnnBYieY_6stages
	ldr	x1, [sp, #8]
	bl	__RNvCs9CzmnnBYieY_6stages11conditional
	ldr	x0, [sp, #8]
	bl	__RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages
	stur	x0, [x29, #-8]
	ldur	x8, [x29, #-8]
	adrp	x9, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGE
	ldr	x9, [x9, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGEOFF]
	subs	x8, x8, x9
	b.eq	LBB9_2
	b	LBB9_1
LBB9_1:
	ldr	x4, [sp]
	mov	w0, #0
	sub	x1, x29, #8
	adrp	x2, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGE
	add	x2, x2, l_alloc_f85406d658e94b9c37cd2112f10307ee@PAGEOFF
	mov	x3, #0
	adrp	x5, l_alloc_770cfff3e7ea7887b74e74f003c9be9a@PAGE
	add	x5, x5, l_alloc_770cfff3e7ea7887b74e74f003c9be9a@PAGEOFF
	bl	__RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_
LBB9_2:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3newCs9CzmnnBYieY_6stages:
	.cfi_startproc
	ret
	.cfi_endproc

	.p2align	2
__RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3setCs9CzmnnBYieY_6stages:
	.cfi_startproc
	str	x1, [x0]
	ret
	.cfi_endproc

	.p2align	2
__RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages:
	.cfi_startproc
	ldr	x0, [x0]
	ret
	.cfi_endproc

	.p2align	2
__RNvXCs9CzmnnBYieY_6stagesNtB2_5GuardNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	ldr	x8, [x0]
	str	x8, [sp]
	ldr	x0, [x0]
	bl	__RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages
	add	x8, x0, #1
	str	x8, [sp, #8]
	subs	x8, x8, x0
	b.lo	LBB13_2
	b	LBB13_1
LBB13_1:
	ldr	x1, [sp, #8]
	ldr	x0, [sp]
	bl	__RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3setCs9CzmnnBYieY_6stages
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB13_2:
	.cfi_restore_state
	adrp	x0, l_alloc_eb3cb0362d4df237f01f3e1e96ae83a3@PAGE
	add	x0, x0, l_alloc_eb3cb0362d4df237f01f3e1e96ae83a3@PAGEOFF
	bl	__RNvNtNtCsjIpoRzUjyHQ_4core9panicking11panic_const24panic_const_add_overflow
	.cfi_endproc

	.p2align	2
__RNvXsU_NtCs1SSuMAdGM58_3std7processuNtB5_11Termination6reportCs9CzmnnBYieY_6stages:
	.cfi_startproc
	mov	w0, #0
	ret
	.cfi_endproc

	.p2align	2
__RNvYFEuINtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	blr	x0
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__RNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	add	x0, sp, #16
	str	x8, [sp, #16]
	bl	__RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages
	str	w0, [sp, #12]
	b	LBB16_1
LBB16_1:
	ldr	w0, [sp, #12]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x2, x1
	mov	x8, x0
	sxtw	x1, w8
	adrp	x0, __RNvCs9CzmnnBYieY_6stages4main@PAGE
	add	x0, x0, __RNvCs9CzmnnBYieY_6stages4main@PAGEOFF
	mov	w3, #0
	bl	__RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages
	ldp	x29, x30, [sp], #16
	ret
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

	.p2align	3, 0x0
l_alloc_eb3cb0362d4df237f01f3e1e96ae83a3:
	.quad	l_alloc_2ff739fb30955571335d6ded878dde47
	.asciz	"N\000\000\000\000\000\000\000\006\000\000\000\024\000\000"

.subsections_via_symbols
