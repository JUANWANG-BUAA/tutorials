	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_13rb_test_panic0EB2_:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
Ltmp0:
Lloh0:
	adrp	x0, l_alloc_af2cc7126a897d51cc4d6d82b99ccb9c@PAGE
Lloh1:
	add	x0, x0, l_alloc_af2cc7126a897d51cc4d6d82b99ccb9c@PAGEOFF
Lloh2:
	adrp	x2, l_alloc_d0a2bb76699ee4f32e1dd71bfe0e2112@PAGE
Lloh3:
	add	x2, x2, l_alloc_d0a2bb76699ee4f32e1dd71bfe0e2112@PAGEOFF
	mov	w1, #61
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking9panic_fmt
Ltmp1:
	brk	#0x1
LBB0_2:
Ltmp2:
Ltmp3:
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp4:
	mov	w0, #5
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB0_4:
	.cfi_restore_state
Ltmp5:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table0:
Lexception0:
	.byte	255
	.byte	155
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp0
	.uleb128 Ltmp2-Lfunc_begin0
	.byte	3
	.uleb128 Ltmp3-Lfunc_begin0
	.uleb128 Ltmp4-Ltmp3
	.uleb128 Ltmp5-Lfunc_begin0
	.byte	1
Lcst_end0:
	.byte	127
	.byte	0
	.byte	1
	.byte	0
	.p2align	2, 0x0
	.long	0
Lttbase0:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_:
	.cfi_startproc
Lloh4:
	adrp	x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE
Lloh5:
	add	x0, x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF
	ldapr	x8, [x0]
	cbnz	x8, LBB1_2
	ret
LBB1_2:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	add	x8, x0, #8
	sub	x9, x29, #1
	stp	x8, x9, [sp]
	mov	x8, sp
	str	x8, [sp, #16]
Lloh6:
	adrp	x3, l_vtable.0@PAGE
Lloh7:
	add	x3, x3, l_vtable.0@PAGEOFF
Lloh8:
	adrp	x4, l_alloc_14b41ca4a8bee6f2e6e20a17309d9f1e@PAGE
Lloh9:
	add	x4, x4, l_alloc_14b41ca4a8bee6f2e6e20a17309d9f1e@PAGEOFF
	add	x2, sp, #16
	mov	w1, #1
	bl	__RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once4call
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh6, Lloh7
	.cfi_endproc

	.p2align	2
__RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x20, x19, [sp, #128]
	stp	x29, x30, [sp, #144]
	add	x29, sp, #144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
Lloh10:
	adrp	x8, l_anon.b10e0b3f9217cb4544b1a69b463540be.0@PAGE
Lloh11:
	add	x8, x8, l_anon.b10e0b3f9217cb4544b1a69b463540be.0@PAGEOFF
	ldp	q0, q2, [x8]
	stp	q0, q0, [sp, #48]
	str	q2, [sp, #32]
	ldp	q0, q1, [x8, #32]
	stp	q1, q0, [sp]
	stp	q2, q0, [sp, #80]
	str	q1, [sp, #112]
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #64
	mov	w1, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
	cbz	x0, LBB2_6
	mov	x19, x0
	ldp	q0, q1, [sp, #32]
	stp	q1, q0, [x0]
	ldp	q0, q1, [sp]
	stp	q1, q0, [x0, #32]
Ltmp6:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init
Ltmp7:
	mov	x20, #0
Lloh12:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh13:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	casal	x20, x19, [x8]
	cmp	x20, #0
	b.eq	LBB2_5
Ltmp12:
	mov	x0, x19
	bl	__RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop
Ltmp13:
	mov	x0, x19
	mov	w1, #64
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	mov	x19, x20
LBB2_5:
	mov	x0, x19
	.cfi_def_cfa wsp, 160
	ldp	x29, x30, [sp, #144]
	ldp	x20, x19, [sp, #128]
	add	sp, sp, #160
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB2_6:
	.cfi_restore_state
Ltmp15:
	mov	w0, #8
	mov	w1, #64
	bl	__RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error
Ltmp16:
	brk	#0x1
LBB2_8:
Ltmp14:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	mov	w1, #64
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_9:
Ltmp8:
	str	x0, [sp, #48]
Ltmp9:
	mov	x0, x19
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECsiU7OkGI6hgA_10ffi_bridge
Ltmp10:
	ldr	x0, [sp, #48]
	bl	__Unwind_Resume
LBB2_11:
Ltmp11:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup
LBB2_12:
Ltmp17:
	mov	x19, x0
Ltmp18:
	add	x0, sp, #64
	bl	__RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop
Ltmp19:
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_14:
Ltmp20:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
Lexception1:
	.byte	255
	.byte	155
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp6-Lfunc_begin1
	.uleb128 Ltmp7-Ltmp6
	.uleb128 Ltmp8-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp12-Lfunc_begin1
	.uleb128 Ltmp13-Ltmp12
	.uleb128 Ltmp14-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp15-Lfunc_begin1
	.uleb128 Ltmp16-Ltmp15
	.uleb128 Ltmp17-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp16-Lfunc_begin1
	.uleb128 Ltmp9-Ltmp16
	.byte	0
	.byte	0
	.uleb128 Ltmp9-Lfunc_begin1
	.uleb128 Ltmp10-Ltmp9
	.uleb128 Ltmp11-Lfunc_begin1
	.byte	1
	.uleb128 Ltmp10-Lfunc_begin1
	.uleb128 Ltmp18-Ltmp10
	.byte	0
	.byte	0
	.uleb128 Ltmp18-Lfunc_begin1
	.uleb128 Ltmp19-Ltmp18
	.uleb128 Ltmp20-Lfunc_begin1
	.byte	1
	.uleb128 Ltmp19-Lfunc_begin1
	.uleb128 Lfunc_end1-Ltmp19
	.byte	0
	.byte	0
Lcst_end1:
	.byte	127
	.byte	0
	.p2align	2, 0x0
Lttbase1:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECsiU7OkGI6hgA_10ffi_bridge:
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception2
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x0
Ltmp21:
	bl	__RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop
Ltmp22:
	mov	x0, x19
	mov	w1, #64
	mov	w2, #8
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	b	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
LBB3_2:
	.cfi_restore_state
Ltmp23:
	mov	x20, x0
	mov	x0, x19
	mov	w1, #64
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	mov	x0, x20
	bl	__Unwind_Resume
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp21-Lfunc_begin2
	.uleb128 Ltmp22-Ltmp21
	.uleb128 Ltmp23-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp22-Lfunc_begin2
	.uleb128 Lfunc_end2-Ltmp22
	.byte	0
	.byte	0
Lcst_end2:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_:
	.cfi_startproc
	tbnz	w1, #0, LBB4_2
Lloh14:
	adrp	x8, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh15:
	ldr	x8, [x8, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
Lloh16:
	ldr	x8, [x8]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB4_3
LBB4_2:
	ldr	x0, [x0]
	b	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
LBB4_3:
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
	mov	x8, x0
	mov	x0, x19
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	tbnz	w8, #0, LBB4_2
	mov	w8, #1
	strb	w8, [x0, #8]
	ldr	x0, [x0]
	b	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
	.loh AdrpLdrGotLdr	Lloh14, Lloh15, Lloh16
	.cfi_endproc

	.p2align	2
__RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	adds	x8, x2, x1
	b.hs	LBB5_3
	mov	x19, x0
	ldp	x1, x2, [x0]
	lsl	x9, x1, #1
	cmp	x8, x9
	csel	x8, x8, x9, hi
	mov	w9, #4
	cmp	x8, #4
	csel	x20, x8, x9, hi
	add	x0, sp, #8
	mov	x3, x20
	mov	w4, #8
	bl	__RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge
	ldr	x8, [sp, #8]
	cbnz	x8, LBB5_4
	ldr	x8, [sp, #16]
	stp	x20, x8, [x19]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB5_3:
	.cfi_restore_state
	mov	x0, #0
	bl	__RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error
LBB5_4:
	ldp	x0, x1, [sp, #16]
	bl	__RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error
	.cfi_endproc

	.p2align	2
__RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_:
	.cfi_startproc
	ldr	x9, [x0]
	ldr	x8, [x9]
	str	xzr, [x9]
	cbz	x8, LBB6_2
	str	xzr, [x8]
	strb	wzr, [x8, #8]
	mov	w9, #8
	stp	xzr, x9, [x8, #16]
	str	xzr, [x8, #32]
	ret
LBB6_2:
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh17:
	adrp	x0, l_alloc_696290a743386ff4d3c84dceb79925aa@PAGE
Lloh18:
	add	x0, x0, l_alloc_696290a743386ff4d3c84dceb79925aa@PAGEOFF
	bl	__RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed
	.loh AdrpAdd	Lloh17, Lloh18
	.cfi_endproc

	.p2align	2
__RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtNtBf_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1f_11get_or_initNCNvB2g_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB2g_:
	.cfi_startproc
	ldr	x9, [x0]
	ldr	x8, [x9]
	str	xzr, [x9]
	cbz	x8, LBB7_2
	str	xzr, [x8]
	strb	wzr, [x8, #8]
	mov	w9, #8
	stp	xzr, x9, [x8, #16]
	str	xzr, [x8, #32]
	ret
LBB7_2:
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh19:
	adrp	x0, l_alloc_696290a743386ff4d3c84dceb79925aa@PAGE
Lloh20:
	add	x0, x0, l_alloc_696290a743386ff4d3c84dceb79925aa@PAGEOFF
	bl	__RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed
	.loh AdrpAdd	Lloh19, Lloh20
	.cfi_endproc

	.globl	__RNvCsiU7OkGI6hgA_10ffi_bridge8checksum
	.p2align	2
__RNvCsiU7OkGI6hgA_10ffi_bridge8checksum:
	.cfi_startproc
	cbz	x1, LBB8_3
	cmp	x1, #8
	b.hs	LBB8_4
	mov	x9, #0
	mov	x8, #0
	b	LBB8_7
LBB8_3:
	mov	x8, #0
	mov	x0, x8
	ret
LBB8_4:
	and	x9, x1, #0xffffffffffffff8
	add	x8, x0, #32
	movi.2d	v0, #0000000000000000
	and	x10, x1, #0xffffffffffffff8
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB8_5:
	ldp	q4, q5, [x8, #-32]
	ldp	q6, q7, [x8], #64
	add.2d	v0, v4, v0
	add.2d	v1, v5, v1
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	subs	x10, x10, #8
	b.ne	LBB8_5
	add.2d	v0, v1, v0
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x8, d0
	cmp	x1, x9
	b.eq	LBB8_9
LBB8_7:
	sub	x10, x1, x9
	add	x9, x0, x9, lsl #3
LBB8_8:
	ldr	x11, [x9], #8
	add	x8, x11, x8
	subs	x10, x10, #1
	b.ne	LBB8_8
LBB8_9:
	mov	x0, x8
	ret
	.cfi_endproc

	.p2align	2
__RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot:
	.cfi_startproc
	stp	x22, x21, [sp, #-48]!
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x20, x1
	mov	x19, x0
Lloh21:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE
Lloh22:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF
	ldapr	x8, [x8]
	cbnz	x8, LBB9_6
Lloh23:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh24:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	ldapr	x0, [x8]
	cbz	x0, LBB9_7
LBB9_2:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock
Lloh25:
	adrp	x21, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh26:
	ldr	x21, [x21, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
	ldr	x8, [x21]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB9_8
LBB9_3:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB9_13
LBB9_4:
	ldr	x8, [x21]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB9_10
LBB9_5:
Lloh27:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh28:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
	mov	w8, #6
	str	w8, [x19, #8]
	str	xzr, [x19]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB9_6:
	.cfi_restore_state
	.cfi_remember_state
	bl	__RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_
Lloh29:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh30:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	ldapr	x0, [x8]
	cbnz	x0, LBB9_2
LBB9_7:
	bl	__RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock
Lloh31:
	adrp	x21, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh32:
	ldr	x21, [x21, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
	ldr	x8, [x21]
	tst	x8, #0x7fffffffffffffff
	b.eq	LBB9_3
LBB9_8:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB9_12
	cbnz	w0, LBB9_4
	b	LBB9_5
LBB9_10:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
	tbnz	w0, #0, LBB9_5
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB9_5
LBB9_12:
	eor	w8, w0, #0x1
LBB9_13:
	mov	w9, w20
	cbz	x9, LBB9_19
Lloh33:
	adrp	x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+32
Lloh34:
	add	x10, x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+32
	ldr	x11, [x10, #8]
	sub	x9, x9, #1
	cmp	x9, x11
	b.hs	LBB9_19
	ldr	x10, [x10]
	mov	w11, #24
	madd	x9, x9, x11, x10
	ldr	w10, [x9, #16]
	lsr	x11, x20, #32
	cmp	w10, w11
	b.ne	LBB9_19
	ldr	x10, [x9]
	cbz	x10, LBB9_19
	mov	w11, #1
	ldadd	x11, x10, [x10]
	tbnz	x10, #63, LBB9_25
	ldp	x10, x9, [x9]
	stp	x10, x9, [x19]
	b	LBB9_20
LBB9_19:
	mov	w9, #3
	str	w9, [x19, #8]
	str	xzr, [x19]
LBB9_20:
	tbnz	w8, #0, LBB9_22
	ldr	x8, [x21]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB9_23
LBB9_22:
Lloh35:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh36:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	b	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
LBB9_23:
	.cfi_restore_state
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
	tbnz	w0, #0, LBB9_22
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB9_22
LBB9_25:
	brk	#0x1
	.loh AdrpAdd	Lloh21, Lloh22
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpLdr	Lloh27, Lloh28
	.loh AdrpAdd	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh31, Lloh32
	.loh AdrpAdd	Lloh33, Lloh34
	.loh AdrpLdr	Lloh35, Lloh36
	.cfi_endproc

	.globl	__RNvCsiU7OkGI6hgA_10ffi_bridge9transform
	.p2align	2
__RNvCsiU7OkGI6hgA_10ffi_bridge9transform:
	.cfi_startproc
	cmp	x1, x3
	b.ne	LBB10_4
	cbz	x1, LBB10_10
	mov	x8, #31765
	movk	x8, #32586, lsl #16
	movk	x8, #31161, lsl #32
	movk	x8, #40503, lsl #48
	mov	x9, #2259
	movk	x9, #34211, lsl #16
	movk	x9, #27272, lsl #32
	movk	x9, #9279, lsl #48
	cmp	x1, #4
	b.hs	LBB10_5
	mov	x10, #0
	b	LBB10_8
LBB10_4:
	mov	w0, #1
	mov	w1, #4
	ret
LBB10_5:
	and	x10, x1, #0xffffffffffffffc
	add	x11, x0, #16
	add	x12, x2, #16
	and	x13, x1, #0xffffffffffffffc
LBB10_6:
	ldp	x14, x15, [x11, #-16]
	ldp	x16, x17, [x11], #32
	eor	x14, x14, x14, lsr #29
	eor	x15, x15, x15, lsr #29
	eor	x16, x16, x16, lsr #29
	eor	x17, x17, x17, lsr #29
	madd	x14, x14, x8, x9
	madd	x15, x15, x8, x9
	madd	x16, x16, x8, x9
	stp	x14, x15, [x12, #-16]
	madd	x14, x17, x8, x9
	stp	x16, x14, [x12], #32
	subs	x13, x13, #4
	b.ne	LBB10_6
	cmp	x1, x10
	b.eq	LBB10_10
LBB10_8:
	lsl	x12, x10, #3
	add	x11, x2, x12
	add	x12, x0, x12
	sub	x10, x1, x10
LBB10_9:
	ldr	x13, [x12], #8
	eor	x13, x13, x13, lsr #29
	madd	x13, x13, x8, x9
	str	x13, [x11], #8
	subs	x10, x10, #1
	b.ne	LBB10_9
LBB10_10:
	mov	w0, #0
	mov	w1, #4
	ret
	.cfi_endproc

	.p2align	2
__RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert:
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception3
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
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
	.cfi_remember_state
	mov	x20, x2
	mov	x19, x0
	stp	x2, x3, [sp, #8]
	ldp	x2, x21, [x1, #8]
	cbz	x21, LBB11_4
	add	x8, x21, x21, lsl #1
	lsl	x10, x8, #3
	add	x9, x2, #16
	mov	w8, #1
LBB11_2:
	ldur	x12, [x9, #-16]
	ldr	w11, [x9]
	cmp	x12, #0
	ccmn	w11, #1, #4, eq
	b.ne	LBB11_10
	add	x9, x9, #24
	add	x8, x8, #1
	subs	x10, x10, #24
	b.ne	LBB11_2
LBB11_4:
	cmp	x21, #1, lsl #12
	b.ne	LBB11_7
LBB11_5:
	mov	x8, #1
	movk	x8, #7, lsl #32
	str	x8, [x19]
	mov	x8, #-1
	ldaddl	x8, x8, [x20]
	cmp	x8, #1
	b.ne	LBB11_12
	dmb	ishld
	add	x0, sp, #8
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
	b	LBB11_12
LBB11_7:
	ldr	x8, [x1]
	cmp	x8, x21
	b.eq	LBB11_13
	mov	w8, #1
	str	w8, [sp, #40]
	stp	x20, x3, [sp, #24]
LBB11_9:
	mov	w8, #24
	madd	x8, x21, x8, x2
	ldur	q0, [sp, #24]
	str	q0, [x8]
	ldr	x9, [sp, #40]
	str	x9, [x8, #16]
	add	x8, x21, #1
	str	x8, [x1, #16]
	orr	x8, x8, #0x100000000
	b	LBB11_11
LBB11_10:
	add	x10, x11, #1
	str	w10, [x9]
	stp	x20, x3, [x9, #-16]
	orr	x8, x8, x10, lsl #32
LBB11_11:
	str	x8, [x19, #8]
	str	wzr, [x19]
LBB11_12:
	.cfi_def_cfa wsp, 112
	ldp	x29, x30, [sp, #96]
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
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
	ret
LBB11_13:
	.cfi_restore_state
	mov	x24, x3
	mov	x23, x1
	lsl	x8, x21, #1
	mov	w9, #4
	cmp	x8, #4
	csel	x22, x8, x9, hi
	add	x0, sp, #24
	mov	x1, x21
	mov	x3, x22
	mov	w4, #24
	bl	__RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge
	ldr	w8, [sp, #24]
	tbnz	w8, #0, LBB11_5
	ldr	x2, [sp, #32]
	mov	x1, x23
	stp	x22, x2, [x23]
	mov	w8, #1
	str	w8, [sp, #40]
	stp	x20, x24, [sp, #24]
	cmp	x21, x22
	b.ne	LBB11_9
Ltmp24:
	mov	x0, x1
	bl	__RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8grow_oneBO_
Ltmp25:
	mov	x1, x23
	ldr	x2, [x23, #8]
	b	LBB11_9
LBB11_17:
Ltmp26:
	mov	x19, x0
	mov	x8, #-1
	ldaddl	x8, x8, [x20]
	cmp	x8, #1
	b.ne	LBB11_19
	dmb	ishld
	add	x0, sp, #24
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
LBB11_19:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception3:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp24-Lfunc_begin3
	.uleb128 Ltmp25-Ltmp24
	.uleb128 Ltmp26-Lfunc_begin3
	.byte	0
	.uleb128 Ltmp25-Lfunc_begin3
	.uleb128 Lfunc_end3-Ltmp25
	.byte	0
	.byte	0
Lcst_end3:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x1
	mov	x20, x0
	ldp	x1, x2, [x0]
	add	x0, sp, #8
	mov	x3, x19
	mov	w4, #8
	bl	__RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge
	ldr	w8, [sp, #8]
	tbz	w8, #0, LBB12_2
	ldr	x0, [sp, #16]
	b	LBB12_3
LBB12_2:
	ldr	x8, [sp, #16]
	stp	x19, x8, [x20]
	mov	x0, #-1
LBB12_3:
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
	.cfi_endproc

	.globl	__RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8grow_oneBO_
	.p2align	2
__RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8grow_oneBO_:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	mov	x19, x0
	ldp	x1, x2, [x0]
	lsl	x8, x1, #1
	mov	w9, #4
	cmp	x8, #4
	csel	x20, x8, x9, hi
	add	x0, sp, #8
	mov	x3, x20
	mov	w4, #24
	bl	__RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge
	ldr	x8, [sp, #8]
	cbnz	x8, LBB13_2
	ldr	x8, [sp, #16]
	stp	x20, x8, [x19]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	add	sp, sp, #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB13_2:
	.cfi_restore_state
	ldp	x0, x1, [sp, #16]
	bl	__RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error
	.cfi_endproc

	.p2align	2
__RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge:
	.cfi_startproc
	stp	x20, x19, [sp, #-32]!
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	mul	x20, x4, x3
	umulh	x8, x4, x3
	cmp	xzr, x8
	mov	x8, #9223372036854775800
	ccmp	x20, x8, #2, eq
	b.ls	LBB14_2
	mov	x20, #0
	mov	w8, #1
	mov	w9, #8
	b	LBB14_10
LBB14_2:
	cbz	x1, LBB14_4
	mul	x1, x4, x1
	mov	x0, x2
	mov	w2, #8
	mov	x3, x20
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_realloc
	cbnz	x0, LBB14_8
	b	LBB14_6
LBB14_4:
	cbz	x20, LBB14_7
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x20
	mov	w1, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
	cbnz	x0, LBB14_8
LBB14_6:
	mov	w8, #8
	str	x8, [x19, #8]
	mov	w8, #1
	b	LBB14_9
LBB14_7:
	mov	w0, #8
LBB14_8:
	mov	x8, #0
	str	x0, [x19, #8]
LBB14_9:
	mov	w9, #16
LBB14_10:
	str	x20, [x19, x9]
	str	x8, [x19]
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	ldp	x20, x19, [sp], #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
	.cfi_endproc

	.p2align	2
__RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE15append_elementsCsiU7OkGI6hgA_10ffi_bridge:
	.cfi_startproc
	stp	x22, x21, [sp, #-48]!
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x19, x2
	mov	x20, x0
	ldr	x21, [x0, #16]
	ldr	x8, [x0]
	sub	x8, x8, x21
	cmp	x2, x8
	b.hi	LBB15_4
	cbz	x19, LBB15_3
LBB15_2:
	ldr	x8, [x20, #8]
	add	x0, x8, x21, lsl #3
	lsl	x2, x19, #3
	bl	_memcpy
LBB15_3:
	add	x8, x21, x19
	str	x8, [x20, #16]
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	ldp	x22, x21, [sp], #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB15_4:
	.cfi_restore_state
	mov	x0, x20
	mov	x22, x1
	mov	x1, x21
	mov	x2, x19
	bl	__RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge
	mov	x1, x22
	ldr	x21, [x20, #16]
	b	LBB15_2
	.cfi_endproc

	.globl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
	.p2align	2
__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge:
	.cfi_startproc
	mov	x8, x0
	ldr	x0, [x0]
	cmn	x0, #1
	b.eq	LBB16_3
	ldr	x8, [x8, #8]
	add	x9, x0, #8
	mov	x10, #-1
	ldaddl	x10, x9, [x9]
	cmp	x9, #1
	b.ne	LBB16_3
	dmb	ishld
	lsl	x8, x8, #3
	add	x1, x8, #16
	mov	w2, #8
	b	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
LBB16_3:
	ret
	.cfi_endproc

	.globl	_rb_copy
	.p2align	2
_rb_copy:
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception4
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x24, x23, [sp, #16]
	stp	x22, x21, [sp, #32]
	stp	x20, x19, [sp, #48]
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_remember_state
	mov	w8, #16777216
	cmp	x2, x8
	b.ls	LBB17_4
LBB17_1:
	mov	x22, #1
	movk	x22, #2, lsl #32
LBB17_2:
	lsr	x8, x22, #32
	tst	w22, #0x1
	csel	w0, w8, wzr, ne
LBB17_3:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	ret
LBB17_4:
	.cfi_restore_state
	mov	x19, x3
	mov	x21, x2
	mov	x20, x1
	mov	x1, x0
	cbz	x2, LBB17_9
	mov	x22, #4294967297
	cbz	x20, LBB17_2
	and	x8, x20, #0x7
	cbnz	x8, LBB17_2
	adds	x8, x20, x21, lsl #3
	b.hs	LBB17_1
	mov	x9, x20
	mov	x22, #4294967297
	cbnz	x19, LBB17_10
	b	LBB17_2
LBB17_9:
	mov	x9, #0
	mov	x8, #0
	mov	x22, #4294967297
	cbz	x19, LBB17_2
LBB17_10:
	and	x10, x19, #0x7
	cbnz	x10, LBB17_2
	mov	x22, #1
	movk	x22, #2, lsl #32
	cmn	x19, #9
	b.hi	LBB17_2
	add	x10, x19, #8
	cmp	x8, x19
	ccmp	x9, x10, #2, hi
	b.hs	LBB17_14
	mov	x22, #4294967297
	b	LBB17_2
LBB17_14:
Ltmp27:
	mov	x0, sp
	bl	__RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot
Ltmp28:
	ldr	x23, [sp]
	cbz	x23, LBB17_19
	ldr	x22, [sp, #8]
	stp	x23, x22, [sp]
	cmp	x21, x22
	b.hs	LBB17_20
	mov	x22, #1
	movk	x22, #4, lsl #32
	mov	x8, #-1
	ldaddl	x8, x8, [x23]
	cmp	x8, #1
	b.ne	LBB17_2
	dmb	ishld
	mov	x0, sp
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
	b	LBB17_2
LBB17_19:
	ldr	w8, [sp, #8]
	mov	w9, #1
	orr	x22, x9, x8, lsl #32
	b	LBB17_2
LBB17_20:
	cbz	x22, LBB17_22
	lsl	x2, x22, #3
	add	x1, x23, #16
	mov	x0, x20
	bl	_memcpy
LBB17_22:
	str	x22, [x19]
	mov	x8, #-1
	ldaddl	x8, x8, [x23]
	cmp	x8, #1
	b.ne	LBB17_24
	dmb	ishld
	mov	x0, sp
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
LBB17_24:
	mov	x22, #0
	b	LBB17_2
LBB17_25:
Ltmp29:
Ltmp30:
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp31:
	mov	w0, #5
	b	LBB17_3
LBB17_27:
Ltmp32:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table17:
Lexception4:
	.byte	255
	.byte	155
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp27-Lfunc_begin4
	.uleb128 Ltmp28-Ltmp27
	.uleb128 Ltmp29-Lfunc_begin4
	.byte	3
	.uleb128 Ltmp28-Lfunc_begin4
	.uleb128 Ltmp30-Ltmp28
	.byte	0
	.byte	0
	.uleb128 Ltmp30-Lfunc_begin4
	.uleb128 Ltmp31-Ltmp30
	.uleb128 Ltmp32-Lfunc_begin4
	.byte	1
Lcst_end4:
	.byte	127
	.byte	0
	.byte	1
	.byte	125
	.p2align	2, 0x0
	.long	0
Lttbase2:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_rb_create_copy
	.p2align	2
_rb_create_copy:
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception5
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x28, x27, [sp, #48]
	stp	x26, x25, [sp, #64]
	stp	x24, x23, [sp, #80]
	stp	x22, x21, [sp, #96]
	stp	x20, x19, [sp, #112]
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
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
	mov	w9, #16777216
	cmp	x1, x9
	b.ls	LBB18_3
LBB18_1:
	mov	w0, #2
LBB18_2:
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	ldp	x20, x19, [sp, #112]
	ldp	x22, x21, [sp, #96]
	ldp	x24, x23, [sp, #80]
	ldp	x26, x25, [sp, #64]
	ldp	x28, x27, [sp, #48]
	add	sp, sp, #144
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
LBB18_3:
	.cfi_restore_state
	mov	x19, x2
	mov	x20, x0
	cbz	x1, LBB18_8
	mov	w0, #1
	cbz	x20, LBB18_2
	and	x9, x20, #0x7
	cbnz	x9, LBB18_2
	adds	x9, x20, x1, lsl #3
	b.hs	LBB18_1
	mov	x10, x20
	mov	w0, #1
	cbnz	x19, LBB18_9
	b	LBB18_2
LBB18_8:
	mov	x10, #0
	mov	x9, #0
	mov	w0, #1
	cbz	x19, LBB18_2
LBB18_9:
	and	x11, x19, #0x7
	cbnz	x11, LBB18_2
	cmn	x19, #9
	b.hi	LBB18_1
	add	x11, x19, #8
	cmp	x9, x19
	ccmp	x10, x11, #2, hi
	b.lo	LBB18_2
	mov	w9, #8
	stp	xzr, x9, [sp, #24]
	str	xzr, [sp, #40]
	cbnz	x1, LBB18_36
LBB18_13:
Lloh37:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE
Lloh38:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF
	ldapr	x8, [x8]
	cbnz	x8, LBB18_39
LBB18_14:
Lloh39:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh40:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	ldapr	x0, [x8]
	cbz	x0, LBB18_40
LBB18_15:
Ltmp39:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock
Ltmp40:
Lloh41:
	adrp	x20, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh42:
	ldr	x20, [x20, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB18_41
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB18_22
LBB18_18:
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB18_44
LBB18_19:
Lloh43:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh44:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp45:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp46:
	mov	w0, #6
	ldr	x9, [sp, #24]
	cbz	x9, LBB18_2
LBB18_21:
	ldr	x8, [sp, #32]
	lsl	x1, x9, #3
	mov	x19, x0
	mov	x0, x8
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	mov	x0, x19
	b	LBB18_2
LBB18_22:
	mov	w20, #0
LBB18_23:
	ldp	x27, x22, [sp, #24]
	ldr	x21, [sp, #40]
	lsl	x23, x21, #3
Ltmp48:
	mov	w0, #8
	mov	x1, x23
	bl	__RNvNtCs6zY7rJBZy9D_5alloc4sync32arcinner_layout_for_value_layout
Ltmp49:
	mov	x26, x0
	mov	x25, x1
	cbz	x1, LBB18_26
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x25
	mov	x1, x26
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
	mov	x24, x0
	b	LBB18_27
LBB18_26:
	mov	x24, x26
LBB18_27:
	cbz	x24, LBB18_48
	mov	w8, #1
	dup.2d	v0, x8
	mov	x0, x24
	str	q0, [x0], #16
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	cbz	x27, LBB18_30
	lsl	x1, x27, #3
	mov	x0, x22
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
LBB18_30:
Ltmp50:
Lloh45:
	adrp	x1, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+24
Lloh46:
	add	x1, x1, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+24
	add	x0, sp, #8
	mov	x2, x24
	mov	x3, x21
	bl	__RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert
Ltmp51:
	ldr	w8, [sp, #8]
	cbz	w8, LBB18_34
	ldr	w19, [sp, #12]
Ltmp54:
Lloh47:
	adrp	x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh48:
	add	x0, x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	mov	x1, x20
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_
Ltmp55:
	mov	x0, x19
	b	LBB18_2
LBB18_34:
	ldr	x21, [sp, #16]
Ltmp52:
Lloh49:
	adrp	x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh50:
	add	x0, x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	mov	x1, x20
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_
Ltmp53:
	mov	w0, #0
	str	x21, [x19]
	b	LBB18_2
LBB18_36:
	add	x0, sp, #24
	mov	x21, x1
	bl	__RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge
	cmn	x0, #1
	b.eq	LBB18_38
	mov	w0, #7
	ldr	x9, [sp, #24]
	cbnz	x9, LBB18_21
	b	LBB18_2
LBB18_38:
Ltmp33:
	add	x0, sp, #24
	mov	x1, x20
	mov	x2, x21
	bl	__RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE15append_elementsCsiU7OkGI6hgA_10ffi_bridge
Ltmp34:
	b	LBB18_13
LBB18_39:
Ltmp35:
	bl	__RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_
Ltmp36:
	b	LBB18_14
LBB18_40:
Ltmp37:
	bl	__RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge
Ltmp38:
	b	LBB18_15
LBB18_41:
Ltmp41:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp42:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB18_47
	cbnz	w0, LBB18_18
	b	LBB18_19
LBB18_44:
Ltmp43:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp44:
	tbnz	w0, #0, LBB18_19
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB18_19
LBB18_47:
	eor	w20, w0, #0x1
	b	LBB18_23
LBB18_48:
Ltmp57:
	mov	x0, x26
	mov	x1, x25
	bl	__RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error
Ltmp58:
	brk	#0x1
LBB18_50:
Ltmp56:
	mov	x19, x0
	b	LBB18_54
LBB18_51:
Ltmp47:
	mov	x19, x0
	ldr	x8, [sp, #24]
	cbz	x8, LBB18_54
	ldr	x0, [sp, #32]
	lsl	x1, x8, #3
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	b	LBB18_54
LBB18_53:
Ltmp59:
	mov	x19, x0
Ltmp60:
Lloh51:
	adrp	x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh52:
	add	x0, x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	mov	x1, x20
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_
Ltmp61:
LBB18_54:
Ltmp63:
	mov	x0, x19
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp64:
	mov	w0, #5
	b	LBB18_2
LBB18_56:
Ltmp62:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup
LBB18_57:
Ltmp65:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpLdrGot	Lloh41, Lloh42
	.loh AdrpLdr	Lloh43, Lloh44
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpAdd	Lloh51, Lloh52
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table18:
Lexception5:
	.byte	255
	.byte	155
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp39-Lfunc_begin5
	.uleb128 Ltmp46-Ltmp39
	.uleb128 Ltmp47-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp48-Lfunc_begin5
	.uleb128 Ltmp49-Ltmp48
	.uleb128 Ltmp59-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp49-Lfunc_begin5
	.uleb128 Ltmp50-Ltmp49
	.byte	0
	.byte	0
	.uleb128 Ltmp50-Lfunc_begin5
	.uleb128 Ltmp51-Ltmp50
	.uleb128 Ltmp59-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp54-Lfunc_begin5
	.uleb128 Ltmp53-Ltmp54
	.uleb128 Ltmp56-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp33-Lfunc_begin5
	.uleb128 Ltmp44-Ltmp33
	.uleb128 Ltmp47-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp57-Lfunc_begin5
	.uleb128 Ltmp58-Ltmp57
	.uleb128 Ltmp59-Lfunc_begin5
	.byte	3
	.uleb128 Ltmp60-Lfunc_begin5
	.uleb128 Ltmp61-Ltmp60
	.uleb128 Ltmp62-Lfunc_begin5
	.byte	1
	.uleb128 Ltmp63-Lfunc_begin5
	.uleb128 Ltmp64-Ltmp63
	.uleb128 Ltmp65-Lfunc_begin5
	.byte	1
Lcst_end5:
	.byte	127
	.byte	0
	.byte	1
	.byte	125
	.p2align	2, 0x0
	.long	0
Lttbase3:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_rb_generate
	.p2align	2
_rb_generate:
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception6
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x28, x27, [sp, #48]
	stp	x26, x25, [sp, #64]
	stp	x24, x23, [sp, #80]
	stp	x22, x21, [sp, #96]
	stp	x20, x19, [sp, #112]
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
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
	mov	x8, #4294967297
	cbz	x2, LBB19_28
	mov	x19, x2
	and	x9, x2, #0x7
	cbnz	x9, LBB19_28
	cmn	x19, #9
	mov	w8, #16777216
	ccmp	x1, x8, #2, ls
	b.ls	LBB19_4
	mov	x8, #1
	movk	x8, #2, lsl #32
	b	LBB19_28
LBB19_4:
	mov	w8, #8
	stp	xzr, x8, [sp, #8]
	str	xzr, [sp, #24]
	cbnz	x1, LBB19_37
	mov	x11, #0
LBB19_6:
	str	x11, [sp, #24]
Lloh53:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE
Lloh54:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF
	ldapr	x8, [x8]
	cbnz	x8, LBB19_47
LBB19_7:
Lloh55:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh56:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	ldapr	x0, [x8]
	cbz	x0, LBB19_48
LBB19_8:
Ltmp72:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock
Ltmp73:
Lloh57:
	adrp	x27, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh58:
	ldr	x27, [x27, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
	ldr	x8, [x27]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB19_49
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB19_15
LBB19_11:
	ldr	x8, [x27]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB19_52
LBB19_12:
Lloh59:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh60:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp78:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp79:
	mov	w19, #6
	ldr	x8, [sp, #8]
	cbz	x8, LBB19_26
LBB19_14:
	ldr	x0, [sp, #16]
	lsl	x1, x8, #3
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	b	LBB19_26
LBB19_15:
	mov	w20, #0
LBB19_16:
	ldp	x28, x22, [sp, #8]
	ldr	x21, [sp, #24]
	lsl	x23, x21, #3
Ltmp81:
	mov	w0, #8
	mov	x1, x23
	bl	__RNvNtCs6zY7rJBZy9D_5alloc4sync32arcinner_layout_for_value_layout
Ltmp82:
	mov	x26, x0
	mov	x25, x1
	cbz	x1, LBB19_34
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x25
	mov	x1, x26
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
	mov	x24, x0
	cbz	x0, LBB19_35
LBB19_19:
	mov	w8, #1
	dup.2d	v0, x8
	mov	x0, x24
	str	q0, [x0], #16
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	cbz	x28, LBB19_21
	lsl	x1, x28, #3
	mov	x0, x22
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
LBB19_21:
Ltmp83:
Lloh61:
	adrp	x1, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+24
Lloh62:
	add	x1, x1, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+24
	add	x0, sp, #32
	mov	x2, x24
	mov	x3, x21
	bl	__RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert
Ltmp84:
	ldr	w8, [sp, #32]
	cbz	w8, LBB19_30
	ldr	w19, [sp, #36]
	tbnz	w20, #0, LBB19_25
	ldr	x8, [x27]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB19_56
LBB19_25:
Lloh63:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh64:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp91:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp92:
LBB19_26:
	mov	w8, #1
LBB19_27:
	orr	x8, x8, x19, lsl #32
LBB19_28:
	lsr	x9, x8, #32
	tst	w8, #0x1
	csel	w0, w9, wzr, ne
LBB19_29:
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	ldp	x20, x19, [sp, #112]
	ldp	x22, x21, [sp, #96]
	ldp	x24, x23, [sp, #80]
	ldp	x26, x25, [sp, #64]
	ldp	x28, x27, [sp, #48]
	add	sp, sp, #144
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
LBB19_30:
	.cfi_restore_state
	ldr	x21, [sp, #40]
	tbnz	w20, #0, LBB19_32
	ldr	x8, [x27]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB19_59
LBB19_32:
Lloh65:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh66:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp87:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp88:
	mov	x8, #0
	str	x21, [x19]
	b	LBB19_27
LBB19_34:
	mov	x24, x26
	cbnz	x26, LBB19_19
LBB19_35:
Ltmp94:
	mov	x0, x26
	mov	x1, x25
	bl	__RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error
Ltmp95:
	brk	#0x1
LBB19_37:
	mov	x20, x0
	add	x0, sp, #8
	mov	x21, x1
	bl	__RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge
	cmn	x0, #1
	b.eq	LBB19_39
	mov	w19, #7
	ldr	x8, [sp, #8]
	cbnz	x8, LBB19_14
	b	LBB19_26
LBB19_39:
	ldr	x8, [sp, #8]
	ldr	x1, [sp, #24]
	sub	x8, x8, x1
	mov	x2, x21
	cmp	x21, x8
	b.hi	LBB19_62
LBB19_40:
	mov	x8, #31765
	movk	x8, #32586, lsl #16
	movk	x8, #31161, lsl #32
	movk	x8, #40503, lsl #48
	mov	x9, #2259
	movk	x9, #34211, lsl #16
	movk	x9, #27272, lsl #32
	movk	x9, #9279, lsl #48
	ldr	x10, [sp, #16]
	cmp	x2, #4
	b.hs	LBB19_42
	mov	x12, #0
	mov	x11, x1
	b	LBB19_45
LBB19_42:
	and	x12, x2, #0x1fffffc
	add	x11, x1, x12
	add	x13, x10, x1, lsl #3
	add	x13, x13, #16
	mov	x14, x20
	and	x15, x2, #0x1fffffc
LBB19_43:
	add	x16, x14, #1
	add	x17, x14, #2
	add	x0, x14, #3
	eor	x1, x14, x14, lsr #29
	eor	x16, x16, x16, lsr #29
	eor	x17, x17, x17, lsr #29
	eor	x0, x0, x0, lsr #29
	madd	x1, x1, x8, x9
	madd	x16, x16, x8, x9
	madd	x17, x17, x8, x9
	stp	x1, x16, [x13, #-16]
	madd	x16, x0, x8, x9
	stp	x17, x16, [x13], #32
	add	x14, x14, #4
	subs	x15, x15, #4
	b.ne	LBB19_43
	cmp	x2, x12
	b.eq	LBB19_6
LBB19_45:
	add	x13, x12, x20
	sub	x12, x2, x12
LBB19_46:
	eor	x14, x13, x13, lsr #29
	madd	x14, x14, x8, x9
	str	x14, [x10, x11, lsl #3]
	add	x11, x11, #1
	add	x13, x13, #1
	subs	x12, x12, #1
	b.ne	LBB19_46
	b	LBB19_6
LBB19_47:
Ltmp68:
	bl	__RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_
Ltmp69:
	b	LBB19_7
LBB19_48:
Ltmp70:
	bl	__RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge
Ltmp71:
	b	LBB19_8
LBB19_49:
Ltmp74:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp75:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB19_55
	cbnz	w0, LBB19_11
	b	LBB19_12
LBB19_52:
Ltmp76:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp77:
	tbnz	w0, #0, LBB19_12
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB19_12
LBB19_55:
	eor	w20, w0, #0x1
	b	LBB19_16
LBB19_56:
Ltmp89:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp90:
	tbnz	w0, #0, LBB19_25
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB19_25
LBB19_59:
Ltmp85:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp86:
	tbnz	w0, #0, LBB19_32
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB19_32
LBB19_62:
Ltmp66:
	add	x0, sp, #8
	bl	__RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge
Ltmp67:
	ldr	x1, [sp, #24]
	mov	x2, x21
	b	LBB19_40
LBB19_64:
Ltmp93:
	mov	x19, x0
	b	LBB19_68
LBB19_65:
Ltmp80:
	mov	x19, x0
	ldr	x8, [sp, #8]
	cbz	x8, LBB19_68
	ldr	x0, [sp, #16]
	lsl	x1, x8, #3
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	b	LBB19_68
LBB19_67:
Ltmp96:
	mov	x19, x0
Ltmp97:
Lloh67:
	adrp	x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh68:
	add	x0, x0, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	mov	x1, x20
	bl	__RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_
Ltmp98:
LBB19_68:
Ltmp100:
	mov	x0, x19
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp101:
	mov	w0, #5
	b	LBB19_29
LBB19_70:
Ltmp99:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup
LBB19_71:
Ltmp102:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh55, Lloh56
	.loh AdrpLdrGot	Lloh57, Lloh58
	.loh AdrpLdr	Lloh59, Lloh60
	.loh AdrpAdd	Lloh61, Lloh62
	.loh AdrpLdr	Lloh63, Lloh64
	.loh AdrpLdr	Lloh65, Lloh66
	.loh AdrpAdd	Lloh67, Lloh68
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table19:
Lexception6:
	.byte	255
	.byte	155
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp72-Lfunc_begin6
	.uleb128 Ltmp79-Ltmp72
	.uleb128 Ltmp80-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp81-Lfunc_begin6
	.uleb128 Ltmp82-Ltmp81
	.uleb128 Ltmp96-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp82-Lfunc_begin6
	.uleb128 Ltmp83-Ltmp82
	.byte	0
	.byte	0
	.uleb128 Ltmp83-Lfunc_begin6
	.uleb128 Ltmp84-Ltmp83
	.uleb128 Ltmp96-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp91-Lfunc_begin6
	.uleb128 Ltmp88-Ltmp91
	.uleb128 Ltmp93-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp94-Lfunc_begin6
	.uleb128 Ltmp95-Ltmp94
	.uleb128 Ltmp96-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp68-Lfunc_begin6
	.uleb128 Ltmp77-Ltmp68
	.uleb128 Ltmp80-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp89-Lfunc_begin6
	.uleb128 Ltmp86-Ltmp89
	.uleb128 Ltmp93-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp66-Lfunc_begin6
	.uleb128 Ltmp67-Ltmp66
	.uleb128 Ltmp80-Lfunc_begin6
	.byte	3
	.uleb128 Ltmp97-Lfunc_begin6
	.uleb128 Ltmp98-Ltmp97
	.uleb128 Ltmp99-Lfunc_begin6
	.byte	1
	.uleb128 Ltmp100-Lfunc_begin6
	.uleb128 Ltmp101-Ltmp100
	.uleb128 Ltmp102-Lfunc_begin6
	.byte	1
Lcst_end6:
	.byte	127
	.byte	0
	.byte	1
	.byte	125
	.p2align	2, 0x0
	.long	0
Lttbase4:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_rb_info
	.p2align	2
_rb_info:
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception7
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_remember_state
	cmp	w2, #24
	ccmp	w1, #1, #0, eq
	b.ne	LBB20_9
	mov	x19, x3
	mov	x8, #4294967297
	cbz	x3, LBB20_20
	and	x9, x19, #0x7
	cbnz	x9, LBB20_20
	cmn	x19, #25
	b.hi	LBB20_22
Ltmp103:
	mov	x1, x0
	mov	x0, sp
	bl	__RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot
Ltmp104:
	ldr	x8, [sp]
	cbz	x8, LBB20_10
	ldr	x9, [sp, #8]
	stp	x8, x9, [sp]
	cbz	x9, LBB20_11
	cmp	x9, #8
	b.hs	LBB20_12
	mov	x10, #0
	mov	x11, #0
	b	LBB20_15
LBB20_9:
	mov	x8, #4294967297
	b	LBB20_20
LBB20_10:
	ldr	w8, [sp, #8]
	mov	w9, #1
	orr	x8, x9, x8, lsl #32
	b	LBB20_20
LBB20_11:
	mov	x11, #0
	b	LBB20_17
LBB20_12:
	and	x10, x9, #0xfffffffffffffff8
	add	x11, x8, #64
	movi.2d	v0, #0000000000000000
	and	x12, x9, #0xfffffffffffffff8
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB20_13:
	ldp	q4, q5, [x11, #-48]
	ldp	q6, q7, [x11, #-16]
	add.2d	v0, v4, v0
	add.2d	v1, v5, v1
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	add	x11, x11, #64
	subs	x12, x12, #8
	b.ne	LBB20_13
	add.2d	v0, v1, v0
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x11, d0
	cmp	x9, x10
	b.eq	LBB20_17
LBB20_15:
	sub	x12, x9, x10
	add	x10, x8, x10, lsl #3
	add	x10, x10, #16
LBB20_16:
	ldr	x13, [x10], #8
	add	x11, x13, x11
	subs	x12, x12, #1
	b.ne	LBB20_16
LBB20_17:
	mov	x10, #1
	movk	x10, #24, lsl #32
	stp	x10, x9, [x19]
	str	x11, [x19, #16]
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB20_19
	dmb	ishld
	mov	x0, sp
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
LBB20_19:
	mov	x8, #0
LBB20_20:
	lsr	x9, x8, #32
	tst	w8, #0x1
	csel	w0, w9, wzr, ne
LBB20_21:
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	ret
LBB20_22:
	.cfi_restore_state
	mov	x8, #1
	movk	x8, #2, lsl #32
	b	LBB20_20
LBB20_23:
Ltmp105:
Ltmp106:
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp107:
	mov	w0, #5
	b	LBB20_21
LBB20_25:
Ltmp108:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table20:
Lexception7:
	.byte	255
	.byte	155
	.uleb128 Lttbase5-Lttbaseref5
Lttbaseref5:
	.byte	1
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Ltmp103-Lfunc_begin7
	.uleb128 Ltmp104-Ltmp103
	.uleb128 Ltmp105-Lfunc_begin7
	.byte	3
	.uleb128 Ltmp106-Lfunc_begin7
	.uleb128 Ltmp107-Ltmp106
	.uleb128 Ltmp108-Lfunc_begin7
	.byte	1
Lcst_end7:
	.byte	127
	.byte	0
	.byte	1
	.byte	125
	.p2align	2, 0x0
	.long	0
Lttbase5:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_rb_mix
	.p2align	2
_rb_mix:
	.cfi_startproc
	mov	x8, #4294967297
	cbz	x1, LBB21_4
	and	x9, x1, #0x7
	cbnz	x9, LBB21_4
	cmn	x1, #9
	b.hi	LBB21_5
	mov	x8, #0
	eor	x9, x0, x0, lsr #29
	mov	x10, #31765
	movk	x10, #32586, lsl #16
	movk	x10, #31161, lsl #32
	movk	x10, #40503, lsl #48
	mov	x11, #2259
	movk	x11, #34211, lsl #16
	movk	x11, #27272, lsl #32
	movk	x11, #9279, lsl #48
	madd	x9, x9, x10, x11
	str	x9, [x1]
LBB21_4:
	lsr	x9, x8, #32
	tst	w8, #0x1
	csel	w0, w9, wzr, ne
	ret
LBB21_5:
	mov	x8, #1
	movk	x8, #2, lsl #32
	lsr	x9, x8, #32
	tst	w8, #0x1
	csel	w0, w9, wzr, ne
	ret
	.cfi_endproc

	.globl	_rb_release
	.p2align	2
_rb_release:
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception8
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x22, x21, [sp, #32]
	stp	x20, x19, [sp, #48]
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_remember_state
	mov	x19, x0
Lloh69:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE
Lloh70:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF
	ldapr	x8, [x8]
	cbnz	x8, LBB22_7
LBB22_1:
Lloh71:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh72:
	add	x8, x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8
	ldapr	x0, [x8]
	cbz	x0, LBB22_8
LBB22_2:
Ltmp113:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock
Ltmp114:
Lloh73:
	adrp	x20, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGE
Lloh74:
	ldr	x20, [x20, __RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT@GOTPAGEOFF]
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB22_9
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB22_15
LBB22_5:
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB22_12
LBB22_6:
	mov	w19, #6
	b	LBB22_28
LBB22_7:
Ltmp109:
	bl	__RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_
Ltmp110:
	b	LBB22_1
LBB22_8:
Ltmp111:
	bl	__RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge
Ltmp112:
	b	LBB22_2
LBB22_9:
Ltmp115:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp116:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	ldrb	w8, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	cbz	w8, LBB22_14
	cbnz	w0, LBB22_5
	b	LBB22_6
LBB22_12:
Ltmp117:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp118:
	mov	w19, #6
	tbnz	w0, #0, LBB22_28
	b	LBB22_32
LBB22_14:
	eor	w8, w0, #0x1
LBB22_15:
	mov	w9, w19
	cbz	x9, LBB22_25
Lloh75:
	adrp	x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+40
Lloh76:
	ldr	x10, [x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+40]
	sub	x9, x9, #1
	cmp	x9, x10
	b.hs	LBB22_25
Lloh77:
	adrp	x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+32
Lloh78:
	ldr	x10, [x10, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+32]
	mov	w11, #24
	madd	x9, x9, x11, x10
	ldr	w10, [x9, #16]
	lsr	x11, x19, #32
	cmp	w10, w11
	b.ne	LBB22_25
	ldr	x19, [x9]
	cbz	x19, LBB22_25
	ldr	x21, [x9, #8]
	str	xzr, [x9]
	stp	x19, x21, [sp]
	tbnz	w8, #0, LBB22_21
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB22_33
LBB22_21:
Lloh79:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh80:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp121:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp122:
	stp	x19, x21, [sp, #16]
	mov	x8, #-1
	ldaddl	x8, x8, [x19]
	cmp	x8, #1
	b.ne	LBB22_24
	dmb	ishld
	add	x0, sp, #16
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
LBB22_24:
	mov	w19, #0
	b	LBB22_29
LBB22_25:
	tbnz	w8, #0, LBB22_27
	ldr	x8, [x20]
	tst	x8, #0x7fffffffffffffff
	b.ne	LBB22_30
LBB22_27:
	mov	w19, #3
LBB22_28:
Lloh81:
	adrp	x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+8
Lloh82:
	ldr	x0, [x8, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+8]
Ltmp126:
	bl	__RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock
Ltmp127:
LBB22_29:
	mov	x0, x19
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
LBB22_30:
	.cfi_restore_state
Ltmp124:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp125:
	mov	w19, #3
	tbnz	w0, #0, LBB22_28
LBB22_32:
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB22_28
LBB22_33:
Ltmp119:
	bl	__RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path
Ltmp120:
	tbnz	w0, #0, LBB22_21
	mov	w8, #1
	adrp	x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGE+16
	strb	w8, [x9, __RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY@PAGEOFF+16]
	b	LBB22_21
LBB22_36:
Ltmp123:
	mov	x8, x19
	mov	x19, x0
	mov	x9, #-1
	ldaddl	x9, x8, [x8]
	cmp	x8, #1
	b.ne	LBB22_39
	dmb	ishld
	mov	x0, sp
	bl	__RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge
	b	LBB22_39
LBB22_38:
Ltmp128:
	mov	x19, x0
LBB22_39:
Ltmp129:
	mov	x0, x19
	bl	__RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup
Ltmp130:
	mov	w19, #5
	b	LBB22_29
LBB22_41:
Ltmp131:
	bl	__RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind
	.loh AdrpAdd	Lloh69, Lloh70
	.loh AdrpAdd	Lloh71, Lloh72
	.loh AdrpLdrGot	Lloh73, Lloh74
	.loh AdrpLdr	Lloh75, Lloh76
	.loh AdrpLdr	Lloh77, Lloh78
	.loh AdrpLdr	Lloh79, Lloh80
	.loh AdrpLdr	Lloh81, Lloh82
Lfunc_end8:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table22:
Lexception8:
	.byte	255
	.byte	155
	.uleb128 Lttbase6-Lttbaseref6
Lttbaseref6:
	.byte	1
	.uleb128 Lcst_end8-Lcst_begin8
Lcst_begin8:
	.uleb128 Ltmp113-Lfunc_begin8
	.uleb128 Ltmp118-Ltmp113
	.uleb128 Ltmp128-Lfunc_begin8
	.byte	3
	.uleb128 Ltmp121-Lfunc_begin8
	.uleb128 Ltmp122-Ltmp121
	.uleb128 Ltmp123-Lfunc_begin8
	.byte	3
	.uleb128 Ltmp126-Lfunc_begin8
	.uleb128 Ltmp125-Ltmp126
	.uleb128 Ltmp128-Lfunc_begin8
	.byte	3
	.uleb128 Ltmp119-Lfunc_begin8
	.uleb128 Ltmp120-Ltmp119
	.uleb128 Ltmp123-Lfunc_begin8
	.byte	3
	.uleb128 Ltmp129-Lfunc_begin8
	.uleb128 Ltmp130-Ltmp129
	.uleb128 Ltmp131-Lfunc_begin8
	.byte	1
Lcst_end8:
	.byte	127
	.byte	0
	.byte	1
	.byte	125
	.p2align	2, 0x0
	.long	0
Lttbase6:
	.byte	0
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_rb_test_panic
	.p2align	2
_rb_test_panic:
	.cfi_startproc
	b	__RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_13rb_test_panic0EB2_
	.cfi_endproc

	.globl	_rb_transform
	.p2align	2
_rb_transform:
	.cfi_startproc
	mov	w8, #16777216
	cmp	x2, x8
	b.ls	LBB24_3
	mov	x10, #1
	movk	x10, #2, lsl #32
LBB24_2:
	lsr	x8, x10, #32
	tst	w10, #0x1
	csel	w0, w8, wzr, ne
	ret
LBB24_3:
	cbz	x2, LBB24_17
	mov	x10, #4294967297
	cbz	x0, LBB24_2
	and	x8, x0, #0x7
	cbnz	x8, LBB24_2
	lsl	x9, x2, #3
	adds	x8, x9, x0
	b.hs	LBB24_20
	cbz	x1, LBB24_2
	and	x11, x1, #0x7
	cbnz	x11, LBB24_2
	mov	x10, #1
	movk	x10, #2, lsl #32
	adds	x9, x9, x1
	b.hs	LBB24_2
	cmp	x9, x0
	ccmp	x8, x1, #0, hi
	b.ls	LBB24_12
	mov	x10, #4294967297
	lsr	x8, x10, #32
	tst	w10, #0x1
	csel	w0, w8, wzr, ne
	ret
LBB24_12:
	mov	x8, #31765
	movk	x8, #32586, lsl #16
	movk	x8, #31161, lsl #32
	movk	x8, #40503, lsl #48
	mov	x9, #2259
	movk	x9, #34211, lsl #16
	movk	x9, #27272, lsl #32
	movk	x9, #9279, lsl #48
	cmp	x2, #4
	b.hs	LBB24_14
	mov	x10, #0
	b	LBB24_18
LBB24_14:
	and	x10, x2, #0x1fffffc
	add	x11, x0, #16
	add	x12, x1, #16
	and	x13, x2, #0x1fffffc
LBB24_15:
	ldp	x14, x15, [x11, #-16]
	ldp	x16, x17, [x11], #32
	eor	x14, x14, x14, lsr #29
	eor	x15, x15, x15, lsr #29
	eor	x16, x16, x16, lsr #29
	eor	x17, x17, x17, lsr #29
	madd	x14, x14, x8, x9
	madd	x15, x15, x8, x9
	madd	x16, x16, x8, x9
	stp	x14, x15, [x12, #-16]
	madd	x14, x17, x8, x9
	stp	x16, x14, [x12], #32
	subs	x13, x13, #4
	b.ne	LBB24_15
	cmp	x2, x10
	b.ne	LBB24_18
LBB24_17:
	mov	x10, #0
	lsr	x8, x10, #32
	tst	w10, #0x1
	csel	w0, w8, wzr, ne
	ret
LBB24_18:
	lsl	x12, x10, #3
	add	x11, x1, x12
	add	x12, x0, x12
	sub	x13, x2, x10
	mov	x10, #0
LBB24_19:
	ldr	x14, [x12], #8
	eor	x14, x14, x14, lsr #29
	madd	x14, x14, x8, x9
	str	x14, [x11], #8
	subs	x13, x13, #1
	b.ne	LBB24_19
	b	LBB24_2
LBB24_20:
	mov	x10, #1
	movk	x10, #2, lsl #32
	lsr	x8, x10, #32
	tst	w10, #0x1
	csel	w0, w8, wzr, ne
	ret
	.cfi_endproc

	.section	__DATA,__const
	.p2align	3, 0x0
l_vtable.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtNtBf_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1f_11get_or_initNCNvB2g_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB2g_
	.quad	__RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_

	.section	__TEXT,__cstring,cstring_literals
l_alloc_42803b9b714e3e00e9cb378c7a639ffd:
	.asciz	"/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/once.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_alloc_14b41ca4a8bee6f2e6e20a17309d9f1e:
	.quad	l_alloc_42803b9b714e3e00e9cb378c7a639ffd
	.asciz	"p\000\000\000\000\000\000\000\342\000\000\000\024\000\000"

	.p2align	3, 0x0
l_alloc_696290a743386ff4d3c84dceb79925aa:
	.quad	l_alloc_42803b9b714e3e00e9cb378c7a639ffd
	.asciz	"p\000\000\000\000\000\000\000\342\000\000\0001\000\000"

	.section	__TEXT,__const
l_alloc_af2cc7126a897d51cc4d6d82b99ccb9c:
	.ascii	"intentional FFI boundary probe"

	.section	__TEXT,__cstring,cstring_literals
l_alloc_466e6e10d4d5a95679ab35d1156aa54e:
	.asciz	"src/lib.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_alloc_d0a2bb76699ee4f32e1dd71bfe0e2112:
	.quad	l_alloc_466e6e10d4d5a95679ab35d1156aa54e
	.asciz	"\n\000\000\000\000\000\000\0004\001\000\000\021\000\000"

	.section	__TEXT,__const
	.p2align	3, 0x0
l_anon.b10e0b3f9217cb4544b1a69b463540be.0:
	.asciz	"\247\253\2522\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

	.section	__DATA,__data
	.p2align	3, 0x0
__RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY:
	.asciz	"\003\000\000\000\000\000\000"
	.space	40

.subsections_via_symbols
