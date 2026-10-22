	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECs68MIsFmw01O_12evidence_lab
	.p2align	2
__RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECs68MIsFmw01O_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable" "mod.rs"
	.loc	1 94 0
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	stp	x26, x25, [sp, #-80]!
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
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_remember_state
	sub	sp, sp, #1, lsl #12
	ldr	xzr, [sp]
	mov	x19, x2
Ltmp3:
	.loc	1 115 18 prologue_end
	sub	x8, x1, x1, lsr #1
Ltmp4:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src" "cmp.rs"
	.loc	2 1090 5
	mov	w9, #16960
	movk	w9, #15, lsl #16
	cmp	x1, x9
	csel	x9, x1, x9, lo
Ltmp5:
	.loc	2 1051 5
	cmp	x9, x8
	csel	x23, x9, x8, hi
Ltmp6:
	.loc	1 124 22
	cmp	x23, #513
	b.hs	LBB0_2
	.loc	1 0 22 is_stmt 0
	mov	x20, sp
	mov	w3, #512
	.loc	1 124 22
	b	LBB0_7
LBB0_2:
Ltmp7:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "uint_macros.rs"
	.loc	3 3212 26 is_stmt 1
	lsl	x21, x23, #3
	and	x8, x8, #0xe000000000000000
	mov	x9, #9223372036854775800
	cmp	x21, x9
	ccmp	x8, #0, #0, ls
Ltmp8:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics" "mod.rs"
	.loc	4 478 8
	b.eq	LBB0_5
Ltmp9:
	.loc	4 0 8 is_stmt 0
	mov	x22, #0
LBB0_4:
Ltmp10:
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec" "mod.rs"
	.loc	5 443 25 is_stmt 1
	mov	x0, x22
	mov	x1, x21
	bl	__RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error
Ltmp11:
LBB0_5:
	.loc	5 0 25 is_stmt 0
	mov	x24, x0
	mov	x25, x1
Ltmp12:
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w22, #8
Ltmp13:
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "alloc.rs"
	.loc	6 130 9 is_stmt 1
	mov	x0, x21
	mov	w1, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
Ltmp14:
	.loc	5 470 19
	cbz	x0, LBB0_4
Ltmp15:
	.loc	5 0 19 is_stmt 0
	mov	x20, x0
	mov	x3, x23
	mov	x1, x25
	mov	x0, x24
LBB0_7:
Ltmp16:
	.loc	1 134 22 is_stmt 1
	cmp	x1, #65
	cset	w4, lo
Ltmp0:
Ltmp17:
	.loc	1 135 5
	mov	x2, x20
	mov	x5, x19
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab
Ltmp18:
Ltmp1:
	.loc	1 136 1
	cmp	x23, #512
	b.ls	LBB0_10
Ltmp19:
	.loc	3 1401 17
	lsl	x1, x23, #3
Ltmp20:
	.loc	6 175 14
	mov	x0, x20
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
Ltmp21:
LBB0_10:
	.loc	1 136 2 epilogue_begin
	add	sp, sp, #1, lsl #12
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldp	x26, x25, [sp], #80
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
	ret
LBB0_11:
	.cfi_restore_state
Ltmp2:
	.loc	1 0 2 is_stmt 0
	mov	x19, x0
Ltmp22:
	.loc	1 136 1 is_stmt 1
	cmp	x23, #513
	b.hs	LBB0_13
	.loc	1 0 1 is_stmt 0
	mov	x0, x19
	bl	__Unwind_Resume
LBB0_13:
Ltmp23:
	.loc	3 1401 17 is_stmt 1
	lsl	x1, x23, #3
Ltmp24:
	.loc	6 175 14
	mov	x0, x20
	mov	w2, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc
	mov	x0, x19
	bl	__Unwind_Resume
Ltmp25:
Lfunc_end0:
	.cfi_endproc
	.file	7 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc" "layout.rs"
	.file	8 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec" "mod.rs"
	.file	9 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"
	.file	10 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mod.rs"
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table0:
Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp0-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp0-Lfunc_begin0
	.uleb128 Ltmp1-Ltmp0
	.uleb128 Ltmp2-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp1-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp1
	.byte	0
	.byte	0
Lcst_end0:
	.p2align	2, 0x0

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
	.byte	5
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
	.byte	5
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	8
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
	.byte	9
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
	.byte	10
	.byte	29
	.byte	1
	.byte	49
	.byte	16
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
	.byte	11
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
	.byte	12
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
	.byte	13
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
	.byte	14
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
	.long	182
	.long	252
	.byte	2
	.short	1085

	.byte	1
	.byte	3
	.long	328
	.long	398
	.byte	2
	.short	1046

	.byte	1
	.byte	0
	.byte	3
	.long	263
	.long	252
	.byte	2
	.short	1586

	.byte	1
	.byte	3
	.long	409
	.long	398
	.byte	2
	.short	1693

	.byte	1
	.byte	0
	.byte	2
	.long	2590
	.byte	3
	.long	2594
	.long	2706
	.byte	10
	.short	847

	.byte	1
	.byte	4
	.long	2767
	.long	2872
	.byte	10
	.short	847
	.byte	3

	.byte	1
	.byte	0
	.byte	2
	.long	1541
	.byte	2
	.long	3283
	.byte	2
	.long	3288
	.byte	5
	.quad	Lfunc_begin0
Lset4 = Lfunc_end0-Lfunc_begin0
	.long	Lset4
	.byte	1
	.byte	109
	.long	3453
	.long	3295
	.byte	1
	.byte	94

	.byte	6
	.long	84
	.quad	Ltmp4
Lset5 = Ltmp5-Ltmp4
	.long	Lset5
	.byte	1
	.byte	115
	.byte	33
	.byte	7
	.long	57
	.quad	Ltmp4
Lset6 = Ltmp5-Ltmp4
	.long	Lset6
	.byte	2
	.short	1587
	.byte	8
	.byte	0
	.byte	6
	.long	97
	.quad	Ltmp5
Lset7 = Ltmp6-Ltmp5
	.long	Lset7
	.byte	1
	.byte	115
	.byte	9
	.byte	7
	.long	70
	.quad	Ltmp5
Lset8 = Ltmp6-Ltmp5
	.long	Lset8
	.byte	2
	.short	1694
	.byte	8
	.byte	0
	.byte	8
	.long	1502
	.quad	Ltmp7
Lset9 = Ltmp15-Ltmp7
	.long	Lset9
	.byte	1
	.byte	127
	.byte	20
	.byte	9
	.long	1477
	.quad	Ltmp7
Lset10 = Ltmp15-Ltmp7
	.long	Lset10
	.byte	9
	.short	864
	.byte	9
	.byte	9
	.long	1464
	.quad	Ltmp7
Lset11 = Ltmp15-Ltmp7
	.long	Lset11
	.byte	8
	.short	522
	.byte	9
	.byte	9
	.long	1440
	.quad	Ltmp7
Lset12 = Ltmp15-Ltmp7
	.long	Lset12
	.byte	8
	.short	969
	.byte	20
	.byte	8
	.long	1421
	.quad	Ltmp7
Lset13 = Ltmp15-Ltmp7
	.long	Lset13
	.byte	5
	.byte	177
	.byte	20
	.byte	10
	.long	1190
Lset14 = Ldebug_ranges0-Ldebug_range
	.long	Lset14
	.byte	5
	.short	435
	.byte	15
	.byte	9
	.long	1172
	.quad	Ltmp7
Lset15 = Ltmp9-Ltmp7
	.long	Lset15
	.byte	5
	.short	455
	.byte	28
	.byte	9
	.long	1126
	.quad	Ltmp7
Lset16 = Ltmp9-Ltmp7
	.long	Lset16
	.byte	5
	.short	901
	.byte	17
	.byte	9
	.long	1083
	.quad	Ltmp7
Lset17 = Ltmp9-Ltmp7
	.long	Lset17
	.byte	7
	.short	533
	.byte	39
	.byte	11
	.long	1070
	.quad	Ltmp7
Lset18 = Ltmp8-Ltmp7
	.long	Lset18
	.byte	3
	.short	1330
	.byte	31
	.byte	11
	.long	1147
	.quad	Ltmp8
Lset19 = Ltmp9-Ltmp8
	.long	Lset19
	.byte	3
	.short	1331
	.byte	16
	.byte	0
	.byte	0
	.byte	0
	.byte	9
	.long	1332
	.quad	Ltmp13
Lset20 = Ltmp14-Ltmp13
	.long	Lset20
	.byte	5
	.short	466
	.byte	47
	.byte	9
	.long	1287
	.quad	Ltmp13
Lset21 = Ltmp14-Ltmp13
	.long	Lset21
	.byte	6
	.short	541
	.byte	14
	.byte	9
	.long	1274
	.quad	Ltmp13
Lset22 = Ltmp14-Ltmp13
	.long	Lset22
	.byte	6
	.short	424
	.byte	9
	.byte	11
	.long	1257
	.quad	Ltmp13
Lset23 = Ltmp14-Ltmp13
	.long	Lset23
	.byte	6
	.short	302
	.byte	73
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.long	129
	.quad	Ltmp19
Lset24 = Ltmp21-Ltmp19
	.long	Lset24
	.byte	1
	.byte	136
	.byte	1
	.byte	12
	.long	116
	.quad	Ltmp19
Lset25 = Ltmp21-Ltmp19
	.long	Lset25
	.byte	10
	.short	847
	.byte	1
	.byte	9
	.long	1237
	.quad	Ltmp19
Lset26 = Ltmp21-Ltmp19
	.long	Lset26
	.byte	10
	.short	847
	.byte	1
	.byte	9
	.long	1217
	.quad	Ltmp19
Lset27 = Ltmp21-Ltmp19
	.long	Lset27
	.byte	5
	.short	425
	.byte	29
	.byte	9
	.long	1203
	.quad	Ltmp19
Lset28 = Ltmp20-Ltmp19
	.long	Lset28
	.byte	5
	.short	874
	.byte	52
	.byte	11
	.long	1096
	.quad	Ltmp19
Lset29 = Ltmp20-Ltmp19
	.long	Lset29
	.byte	5
	.short	639
	.byte	53
	.byte	0
	.byte	9
	.long	1346
	.quad	Ltmp20
Lset30 = Ltmp21-Ltmp20
	.long	Lset30
	.byte	5
	.short	876
	.byte	28
	.byte	9
	.long	1313
	.quad	Ltmp20
Lset31 = Ltmp21-Ltmp20
	.long	Lset31
	.byte	6
	.short	554
	.byte	23
	.byte	9
	.long	1300
	.quad	Ltmp20
Lset32 = Ltmp21-Ltmp20
	.long	Lset32
	.byte	6
	.short	436
	.byte	9
	.byte	11
	.long	1361
	.quad	Ltmp20
Lset33 = Ltmp21-Ltmp20
	.long	Lset33
	.byte	6
	.short	321
	.byte	22
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.long	129
	.quad	Ltmp23
Lset34 = Ltmp25-Ltmp23
	.long	Lset34
	.byte	1
	.byte	136
	.byte	1
	.byte	12
	.long	116
	.quad	Ltmp23
Lset35 = Ltmp25-Ltmp23
	.long	Lset35
	.byte	10
	.short	847
	.byte	1
	.byte	9
	.long	1237
	.quad	Ltmp23
Lset36 = Ltmp25-Ltmp23
	.long	Lset36
	.byte	10
	.short	847
	.byte	1
	.byte	9
	.long	1217
	.quad	Ltmp23
Lset37 = Ltmp25-Ltmp23
	.long	Lset37
	.byte	5
	.short	425
	.byte	29
	.byte	9
	.long	1203
	.quad	Ltmp23
Lset38 = Ltmp24-Ltmp23
	.long	Lset38
	.byte	5
	.short	874
	.byte	52
	.byte	11
	.long	1096
	.quad	Ltmp23
Lset39 = Ltmp24-Ltmp23
	.long	Lset39
	.byte	5
	.short	639
	.byte	53
	.byte	0
	.byte	9
	.long	1346
	.quad	Ltmp24
Lset40 = Ltmp25-Ltmp24
	.long	Lset40
	.byte	5
	.short	876
	.byte	28
	.byte	9
	.long	1313
	.quad	Ltmp24
Lset41 = Ltmp25-Ltmp24
	.long	Lset41
	.byte	6
	.short	554
	.byte	23
	.byte	9
	.long	1300
	.quad	Ltmp24
Lset42 = Ltmp25-Ltmp24
	.long	Lset42
	.byte	6
	.short	436
	.byte	9
	.byte	11
	.long	1361
	.quad	Ltmp24
Lset43 = Ltmp25-Ltmp24
	.long	Lset43
	.byte	6
	.short	321
	.byte	22
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end0:
Lcu_begin1:
Lset44 = Ldebug_info_end1-Ldebug_info_start1
	.long	Lset44
Ldebug_info_start1:
	.short	4
Lset45 = Lsection_abbrev-Lsection_abbrev
	.long	Lset45
	.byte	8
	.byte	13
	.long	0
	.short	28
	.long	474
Lset46 = Lline_table_start0-Lsection_line
	.long	Lset46
	.long	107

	.byte	2
	.long	169
	.byte	2
	.long	524
	.byte	2
	.long	528
	.byte	3
	.long	538
	.long	590
	.byte	3
	.short	3211

	.byte	1
	.byte	3
	.long	606
	.long	654
	.byte	3
	.short	1329

	.byte	1
	.byte	3
	.long	2100
	.long	2150
	.byte	3
	.short	1389

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	666
	.byte	2
	.long	672
	.byte	2
	.long	679
	.byte	3
	.long	686
	.long	755
	.byte	7
	.short	532

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1712
	.byte	3
	.long	1723
	.long	1770
	.byte	4
	.short	477

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	666
	.byte	2
	.long	769
	.byte	3
	.long	777
	.long	826
	.byte	5
	.short	896

	.byte	1
	.byte	2
	.long	839
	.byte	3
	.long	851
	.long	953
	.byte	5
	.short	447

	.byte	1
	.byte	4
	.long	2164
	.long	2265
	.byte	5
	.short	630
	.byte	3

	.byte	1
	.byte	4
	.long	2302
	.long	2399
	.byte	5
	.short	872
	.byte	3

	.byte	1
	.byte	0
	.byte	2
	.long	1985
	.byte	3
	.long	2432
	.long	2558
	.byte	5
	.short	423

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	666
	.byte	14
	.long	1779
	.long	666
	.byte	6
	.byte	124

	.byte	1
	.byte	2
	.long	1818
	.byte	3
	.long	1825
	.long	1894
	.byte	6
	.short	297

	.byte	1
	.byte	3
	.long	1913
	.long	1974
	.byte	6
	.short	423

	.byte	1
	.byte	3
	.long	2992
	.long	3066
	.byte	6
	.short	311

	.byte	1
	.byte	3
	.long	3090
	.long	3156
	.byte	6
	.short	435

	.byte	1
	.byte	0
	.byte	2
	.long	1985
	.byte	4
	.long	1994
	.long	2091
	.byte	6
	.short	540
	.byte	3

	.byte	1
	.byte	4
	.long	3172
	.long	3272
	.byte	6
	.short	552
	.byte	3

	.byte	1
	.byte	0
	.byte	14
	.long	2926
	.long	2976
	.byte	6
	.byte	174

	.byte	1
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end1:
Lcu_begin2:
Lset47 = Ldebug_info_end2-Ldebug_info_start2
	.long	Lset47
Ldebug_info_start2:
	.short	4
Lset48 = Lsection_abbrev-Lsection_abbrev
	.long	Lset48
	.byte	8
	.byte	13
	.long	0
	.short	28
	.long	991
Lset49 = Lline_table_start0-Lsection_line
	.long	Lset49
	.long	107

	.byte	2
	.long	666
	.byte	2
	.long	769
	.byte	2
	.long	839
	.byte	3
	.long	1041
	.long	1144
	.byte	5
	.short	434

	.byte	1
	.byte	0
	.byte	2
	.long	1183
	.byte	14
	.long	1190
	.long	1290
	.byte	5
	.byte	175

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	1334
	.byte	2
	.long	1338
	.byte	3
	.long	1342
	.long	1290
	.byte	8
	.short	968

	.byte	1
	.byte	3
	.long	1435
	.long	1522
	.byte	8
	.short	521

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	1541
	.byte	2
	.long	1547
	.byte	3
	.long	1557
	.long	1522
	.byte	9
	.short	863

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end2:
	.section	__TEXT,__text,regular,pure_instructions
Lsec_end0:
	.section	__DWARF,__debug_aranges,regular,debug
	.long	44
	.short	2
Lset50 = Lcu_begin0-Lsection_info
	.long	Lset50
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset51 = Lsec_end0-Lfunc_begin0
	.quad	Lset51
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset52 = Ltmp7-Lfunc_begin0
	.quad	Lset52
Lset53 = Ltmp9-Lfunc_begin0
	.quad	Lset53
Lset54 = Ltmp12-Lfunc_begin0
	.quad	Lset54
Lset55 = Ltmp15-Lfunc_begin0
	.quad	Lset55
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.06"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"core"
	.asciz	"cmp"
	.asciz	"Ord"
	.asciz	"_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCs68MIsFmw01O_12evidence_lab"
	.asciz	"min<usize>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab"
	.asciz	"_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3maxCs68MIsFmw01O_12evidence_lab"
	.asciz	"max<usize>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3cmp3maxjECs68MIsFmw01O_12evidence_lab"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.05"
	.asciz	"num"
	.asciz	"{impl#11}"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul"
	.asciz	"overflowing_mul"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul"
	.asciz	"checked_mul"
	.asciz	"alloc"
	.asciz	"layout"
	.asciz	"Layout"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed"
	.asciz	"repeat_packed"
	.asciz	"raw_vec"
	.asciz	"_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array"
	.asciz	"layout_array"
	.asciz	"RawVecInner"
	.asciz	"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab"
	.asciz	"try_allocate_in<alloc::alloc::Global>"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.08"
	.asciz	"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab"
	.asciz	"with_capacity_in<alloc::alloc::Global>"
	.asciz	"RawVec"
	.asciz	"_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab"
	.asciz	"with_capacity_in<f64, alloc::alloc::Global>"
	.asciz	"vec"
	.asciz	"Vec"
	.asciz	"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab"
	.asciz	"_RNvMNtCs6zY7rJBZy9D_5alloc3vecINtB2_3VecdE13with_capacityCs68MIsFmw01O_12evidence_lab"
	.asciz	"with_capacity<f64>"
	.asciz	"slice"
	.asciz	"{impl#10}"
	.asciz	"_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab"
	.asciz	"intrinsics"
	.asciz	"_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely"
	.asciz	"unlikely"
	.asciz	"_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc"
	.asciz	"Global"
	.asciz	"_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime"
	.asciz	"alloc_impl_runtime"
	.asciz	"_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl"
	.asciz	"alloc_impl"
	.asciz	"{impl#3}"
	.asciz	"_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate"
	.asciz	"allocate"
	.asciz	"_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_mul"
	.asciz	"unchecked_mul"
	.asciz	"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCs68MIsFmw01O_12evidence_lab"
	.asciz	"current_memory<alloc::alloc::Global>"
	.asciz	"_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCs68MIsFmw01O_12evidence_lab"
	.asciz	"deallocate<alloc::alloc::Global>"
	.asciz	"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"
	.asciz	"drop<f64, alloc::alloc::Global>"
	.asciz	"ptr"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVecdEECs68MIsFmw01O_12evidence_lab"
	.asciz	"drop_glue<alloc::raw_vec::RawVec<f64, alloc::alloc::Global>>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecdEECs68MIsFmw01O_12evidence_lab"
	.asciz	"drop_glue<alloc::vec::Vec<f64, alloc::alloc::Global>>"
	.asciz	"_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull"
	.asciz	"dealloc_nonnull"
	.asciz	"_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime"
	.asciz	"deallocate_impl_runtime"
	.asciz	"_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl"
	.asciz	"deallocate_impl"
	.asciz	"_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate"
	.asciz	"deallocate"
	.asciz	"sort"
	.asciz	"stable"
	.asciz	"driftsort_main<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>, alloc::vec::Vec<f64, alloc::alloc::Global>>"
	.asciz	"_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECs68MIsFmw01O_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	28
	.long	56
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	-1
	.long	0
	.long	3
	.long	4
	.long	7
	.long	10
	.long	13
	.long	16
	.long	19
	.long	20
	.long	23
	.long	24
	.long	25
	.long	-1
	.long	27
	.long	30
	.long	31
	.long	33
	.long	37
	.long	38
	.long	41
	.long	48
	.long	-1
	.long	50
	.long	52
	.long	53
	.long	55
	.long	-1
	.long	275550577
	.long	-2000997827
	.long	-598347711
	.long	-1931130574
	.long	1123839811
	.long	1610783527
	.long	-1347980089
	.long	253189136
	.long	400243036
	.long	1704302688
	.long	-1299049695
	.long	-391463043
	.long	-351479295
	.long	639507826
	.long	1355391806
	.long	2117357066
	.long	114643935
	.long	142103591
	.long	-185145349
	.long	838842488
	.long	105046517
	.long	1011703401
	.long	-1170908755
	.long	-716619170
	.long	204316431
	.long	1552838964
	.long	-473782364
	.long	1439135390
	.long	-570131118
	.long	-557196266
	.long	117866855
	.long	1607869944
	.long	-802970604
	.long	540871033
	.long	1291623497
	.long	1700587017
	.long	-199311883
	.long	-1231915286
	.long	1429264583
	.long	-1098931133
	.long	-1050138221
	.long	669388376
	.long	1185083612
	.long	1189325192
	.long	-1740421212
	.long	-1414582076
	.long	-443719372
	.long	-376659204
	.long	788507125
	.long	-1844739467
	.long	1567618355
	.long	-877343777
	.long	1697101948
	.long	-1802194023
	.long	-734464339
	.long	-1580801242
Lset56 = LNames12-Lnames_begin
	.long	Lset56
Lset57 = LNames47-Lnames_begin
	.long	Lset57
Lset58 = LNames30-Lnames_begin
	.long	Lset58
Lset59 = LNames26-Lnames_begin
	.long	Lset59
Lset60 = LNames0-Lnames_begin
	.long	Lset60
Lset61 = LNames52-Lnames_begin
	.long	Lset61
Lset62 = LNames38-Lnames_begin
	.long	Lset62
Lset63 = LNames34-Lnames_begin
	.long	Lset63
Lset64 = LNames10-Lnames_begin
	.long	Lset64
Lset65 = LNames7-Lnames_begin
	.long	Lset65
Lset66 = LNames18-Lnames_begin
	.long	Lset66
Lset67 = LNames39-Lnames_begin
	.long	Lset67
Lset68 = LNames41-Lnames_begin
	.long	Lset68
Lset69 = LNames9-Lnames_begin
	.long	Lset69
Lset70 = LNames55-Lnames_begin
	.long	Lset70
Lset71 = LNames28-Lnames_begin
	.long	Lset71
Lset72 = LNames40-Lnames_begin
	.long	Lset72
Lset73 = LNames16-Lnames_begin
	.long	Lset73
Lset74 = LNames6-Lnames_begin
	.long	Lset74
Lset75 = LNames8-Lnames_begin
	.long	Lset75
Lset76 = LNames21-Lnames_begin
	.long	Lset76
Lset77 = LNames44-Lnames_begin
	.long	Lset77
Lset78 = LNames14-Lnames_begin
	.long	Lset78
Lset79 = LNames4-Lnames_begin
	.long	Lset79
Lset80 = LNames15-Lnames_begin
	.long	Lset80
Lset81 = LNames1-Lnames_begin
	.long	Lset81
Lset82 = LNames50-Lnames_begin
	.long	Lset82
Lset83 = LNames54-Lnames_begin
	.long	Lset83
Lset84 = LNames51-Lnames_begin
	.long	Lset84
Lset85 = LNames43-Lnames_begin
	.long	Lset85
Lset86 = LNames25-Lnames_begin
	.long	Lset86
Lset87 = LNames13-Lnames_begin
	.long	Lset87
Lset88 = LNames53-Lnames_begin
	.long	Lset88
Lset89 = LNames3-Lnames_begin
	.long	Lset89
Lset90 = LNames27-Lnames_begin
	.long	Lset90
Lset91 = LNames11-Lnames_begin
	.long	Lset91
Lset92 = LNames5-Lnames_begin
	.long	Lset92
Lset93 = LNames31-Lnames_begin
	.long	Lset93
Lset94 = LNames49-Lnames_begin
	.long	Lset94
Lset95 = LNames37-Lnames_begin
	.long	Lset95
Lset96 = LNames48-Lnames_begin
	.long	Lset96
Lset97 = LNames23-Lnames_begin
	.long	Lset97
Lset98 = LNames19-Lnames_begin
	.long	Lset98
Lset99 = LNames17-Lnames_begin
	.long	Lset99
Lset100 = LNames24-Lnames_begin
	.long	Lset100
Lset101 = LNames32-Lnames_begin
	.long	Lset101
Lset102 = LNames36-Lnames_begin
	.long	Lset102
Lset103 = LNames42-Lnames_begin
	.long	Lset103
Lset104 = LNames29-Lnames_begin
	.long	Lset104
Lset105 = LNames33-Lnames_begin
	.long	Lset105
Lset106 = LNames2-Lnames_begin
	.long	Lset106
Lset107 = LNames35-Lnames_begin
	.long	Lset107
Lset108 = LNames46-Lnames_begin
	.long	Lset108
Lset109 = LNames22-Lnames_begin
	.long	Lset109
Lset110 = LNames20-Lnames_begin
	.long	Lset110
Lset111 = LNames45-Lnames_begin
	.long	Lset111
LNames12:
	.long	1342
	.long	1
	.long	309
	.long	0
LNames47:
	.long	2100
	.long	2
	.long	689
	.long	906
	.long	0
LNames30:
	.long	1974
	.long	1
	.long	513
	.long	0
LNames26:
	.long	1770
	.long	1
	.long	468
	.long	0
LNames0:
	.long	3295
	.long	1
	.long	159
	.long	0
LNames52:
	.long	3066
	.long	2
	.long	753
	.long	970
	.long	0
LNames38:
	.long	2706
	.long	2
	.long	605
	.long	822
	.long	0
LNames34:
	.long	666
	.long	1
	.long	555
	.long	0
LNames10:
	.long	1435
	.long	1
	.long	288
	.long	0
LNames7:
	.long	328
	.long	1
	.long	246
	.long	0
LNames18:
	.long	826
	.long	1
	.long	384
	.long	0
LNames39:
	.long	2594
	.long	2
	.long	605
	.long	822
	.long	0
LNames41:
	.long	2432
	.long	2
	.long	626
	.long	843
	.long	0
LNames9:
	.long	1557
	.long	1
	.long	268
	.long	0
LNames55:
	.long	2926
	.long	2
	.long	774
	.long	991
	.long	0
LNames28:
	.long	2091
	.long	1
	.long	492
	.long	0
LNames40:
	.long	2558
	.long	2
	.long	626
	.long	843
	.long	0
LNames16:
	.long	953
	.long	1
	.long	371
	.long	0
LNames6:
	.long	409
	.long	1
	.long	226
	.long	0
LNames8:
	.long	1522
	.long	2
	.long	268
	.long	288
	.long	0
LNames21:
	.long	686
	.long	1
	.long	405
	.long	0
LNames44:
	.long	2265
	.long	2
	.long	668
	.long	885
	.long	0
LNames14:
	.long	1144
	.long	1
	.long	351
	.long	0
LNames4:
	.long	182
	.long	1
	.long	204
	.long	0
LNames15:
	.long	1041
	.long	1
	.long	351
	.long	0
LNames1:
	.long	3453
	.long	1
	.long	159
	.long	0
LNames50:
	.long	3156
	.long	2
	.long	732
	.long	949
	.long	0
LNames54:
	.long	2976
	.long	2
	.long	774
	.long	991
	.long	0
LNames51:
	.long	3090
	.long	2
	.long	732
	.long	949
	.long	0
LNames43:
	.long	2302
	.long	2
	.long	647
	.long	864
	.long	0
LNames25:
	.long	538
	.long	1
	.long	447
	.long	0
LNames13:
	.long	1190
	.long	1
	.long	330
	.long	0
LNames53:
	.long	2992
	.long	2
	.long	753
	.long	970
	.long	0
LNames3:
	.long	263
	.long	1
	.long	184
	.long	0
LNames27:
	.long	1723
	.long	1
	.long	468
	.long	0
LNames11:
	.long	1290
	.long	2
	.long	309
	.long	330
	.long	0
LNames5:
	.long	398
	.long	2
	.long	226
	.long	246
	.long	0
LNames31:
	.long	1913
	.long	1
	.long	513
	.long	0
LNames49:
	.long	3172
	.long	2
	.long	711
	.long	928
	.long	0
LNames37:
	.long	2767
	.long	2
	.long	585
	.long	802
	.long	0
LNames48:
	.long	3272
	.long	2
	.long	711
	.long	928
	.long	0
LNames23:
	.long	606
	.long	1
	.long	426
	.long	0
LNames19:
	.long	777
	.long	1
	.long	384
	.long	0
LNames17:
	.long	851
	.long	1
	.long	371
	.long	0
LNames24:
	.long	590
	.long	1
	.long	447
	.long	0
LNames32:
	.long	1894
	.long	1
	.long	534
	.long	0
LNames36:
	.long	2872
	.long	2
	.long	585
	.long	802
	.long	0
LNames42:
	.long	2399
	.long	2
	.long	647
	.long	864
	.long	0
LNames29:
	.long	1994
	.long	1
	.long	492
	.long	0
LNames33:
	.long	1825
	.long	1
	.long	534
	.long	0
LNames2:
	.long	252
	.long	2
	.long	184
	.long	204
	.long	0
LNames35:
	.long	1779
	.long	1
	.long	555
	.long	0
LNames46:
	.long	2150
	.long	2
	.long	689
	.long	906
	.long	0
LNames22:
	.long	654
	.long	1
	.long	426
	.long	0
LNames20:
	.long	755
	.long	1
	.long	405
	.long	0
LNames45:
	.long	2164
	.long	2
	.long	668
	.long	885
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
	.long	10
	.long	21
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	3
	.long	4
	.long	6
	.long	-1
	.long	10
	.long	12
	.long	14
	.long	-1
	.long	19
	.long	193466890
	.long	2090156110
	.long	-1252119626
	.long	193508931
	.long	478822272
	.long	907186092
	.long	193474083
	.long	274532053
	.long	-1536480813
	.long	-834400883
	.long	1035240715
	.long	-98386551
	.long	253189136
	.long	-1536480780
	.long	193488517
	.long	193500757
	.long	193502907
	.long	2090731117
	.long	-1738516699
	.long	183218979
	.long	-1069113597
Lset112 = Lnamespac2-Lnamespac_begin
	.long	Lset112
Lset113 = Lnamespac0-Lnamespac_begin
	.long	Lset113
Lset114 = Lnamespac16-Lnamespac_begin
	.long	Lset114
Lset115 = Lnamespac11-Lnamespac_begin
	.long	Lset115
Lset116 = Lnamespac20-Lnamespac_begin
	.long	Lset116
Lset117 = Lnamespac8-Lnamespac_begin
	.long	Lset117
Lset118 = Lnamespac12-Lnamespac_begin
	.long	Lset118
Lset119 = Lnamespac13-Lnamespac_begin
	.long	Lset119
Lset120 = Lnamespac14-Lnamespac_begin
	.long	Lset120
Lset121 = Lnamespac10-Lnamespac_begin
	.long	Lset121
Lset122 = Lnamespac15-Lnamespac_begin
	.long	Lset122
Lset123 = Lnamespac9-Lnamespac_begin
	.long	Lset123
Lset124 = Lnamespac5-Lnamespac_begin
	.long	Lset124
Lset125 = Lnamespac4-Lnamespac_begin
	.long	Lset125
Lset126 = Lnamespac1-Lnamespac_begin
	.long	Lset126
Lset127 = Lnamespac3-Lnamespac_begin
	.long	Lset127
Lset128 = Lnamespac18-Lnamespac_begin
	.long	Lset128
Lset129 = Lnamespac19-Lnamespac_begin
	.long	Lset129
Lset130 = Lnamespac17-Lnamespac_begin
	.long	Lset130
Lset131 = Lnamespac6-Lnamespac_begin
	.long	Lset131
Lset132 = Lnamespac7-Lnamespac_begin
	.long	Lset132
Lnamespac2:
	.long	178
	.long	1
	.long	52
	.long	0
Lnamespac0:
	.long	169
	.long	2
	.long	1055
	.long	42
	.long	0
Lnamespac16:
	.long	1818
	.long	1
	.long	1269
	.long	0
Lnamespac11:
	.long	1334
	.long	1
	.long	1454
	.long	0
Lnamespac20:
	.long	3288
	.long	1
	.long	154
	.long	0
Lnamespac8:
	.long	769
	.long	2
	.long	1411
	.long	1167
	.long	0
Lnamespac12:
	.long	1338
	.long	1
	.long	1459
	.long	0
Lnamespac13:
	.long	1541
	.long	2
	.long	1492
	.long	144
	.long	0
Lnamespac14:
	.long	1547
	.long	1
	.long	1497
	.long	0
Lnamespac10:
	.long	1183
	.long	1
	.long	1435
	.long	0
Lnamespac15:
	.long	1712
	.long	1
	.long	1142
	.long	0
Lnamespac9:
	.long	839
	.long	2
	.long	1416
	.long	1185
	.long	0
Lnamespac5:
	.long	666
	.long	4
	.long	1406
	.long	1111
	.long	1162
	.long	1252
	.long	0
Lnamespac4:
	.long	528
	.long	1
	.long	1065
	.long	0
Lnamespac1:
	.long	174
	.long	1
	.long	47
	.long	0
Lnamespac3:
	.long	524
	.long	1
	.long	1060
	.long	0
Lnamespac18:
	.long	2590
	.long	1
	.long	111
	.long	0
Lnamespac19:
	.long	3283
	.long	1
	.long	149
	.long	0
Lnamespac17:
	.long	1985
	.long	2
	.long	1232
	.long	1327
	.long	0
Lnamespac6:
	.long	672
	.long	1
	.long	1116
	.long	0
Lnamespac7:
	.long	679
	.long	1
	.long	1121
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
