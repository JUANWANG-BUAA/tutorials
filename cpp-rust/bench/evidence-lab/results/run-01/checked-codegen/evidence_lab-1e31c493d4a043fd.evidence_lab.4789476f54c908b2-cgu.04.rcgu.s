	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab
	.globl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab
	.p2align	2
__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable" "merge.rs"
	.loc	1 8 0
	.cfi_startproc
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
	subs	x21, x1, x4
Ltmp0:
	.loc	1 16 8 prologue_end
	ccmp	x4, #0, #4, hi
	b.eq	LBB0_2
Ltmp1:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src" "cmp.rs"
	.loc	2 1090 5
	cmp	x21, x4
	csel	x8, x21, x4, lo
Ltmp2:
	.loc	1 16 34
	cmp	x3, x8
	b.hs	LBB0_3
Ltmp3:
LBB0_2:
	.cfi_def_cfa wsp, 80
	.loc	1 63 2 epilogue_begin
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
LBB0_3:
	.cfi_restore_state
	.loc	1 0 2 is_stmt 0
	mov	x23, x1
Ltmp4:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mut_ptr.rs"
	.loc	3 970 18 is_stmt 1
	add	x20, x0, x4, lsl #3
Ltmp5:
	.loc	1 48 28
	cmp	x4, x21
	mov	x22, x0
	csel	x1, x20, x0, hi
Ltmp6:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mod.rs"
	.loc	4 573 14
	lsl	x19, x8, #3
	mov	x0, x2
	mov	x24, x2
	mov	x2, x19
	mov	x25, x4
	bl	_memcpy
	mov	x1, x24
Ltmp7:
	.loc	3 970 18
	add	x8, x24, x19
Ltmp8:
	.loc	1 48 28
	cmp	x25, x21
Ltmp9:
	.loc	1 55 12
	b.ls	LBB0_7
Ltmp10:
	.loc	1 130 20
	lsl	x9, x23, #3
	sub	x9, x9, #8
	mov	x10, x22
Ltmp11:
LBB0_5:
	.loc	1 122 36
	ldr	x11, [x8, #-8]!
	ldr	x12, [x20, #-8]!
Ltmp12:
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "f64.rs"
	.loc	5 1547 19
	asr	x13, x11, #63
	.loc	5 1547 9 is_stmt 0
	eor	x13, x11, x13, lsr #1
	.loc	5 1548 20 is_stmt 1
	asr	x14, x12, #63
	.loc	5 1548 9 is_stmt 0
	eor	x14, x12, x14, lsr #1
Ltmp13:
	.loc	2 410 44 is_stmt 1
	cmp	x13, x14
Ltmp14:
	.loc	1 124 27
	csel	x11, x12, x11, lt
Ltmp15:
	.loc	2 410 44
	cset	w12, lt
Ltmp16:
	.loc	4 573 14
	str	x11, [x10, x9]
Ltmp17:
	.loc	2 410 44
	cset	w11, ge
Ltmp18:
	.loc	3 970 18
	add	x20, x20, w11, uxtw #3
Ltmp19:
	.loc	3 970 18 is_stmt 0
	add	x8, x8, w12, uxtw #3
Ltmp20:
	.loc	1 130 20 is_stmt 1
	sub	x9, x9, #8
	cmp	x20, x10
	ccmp	x8, x1, #4, ne
	b.ne	LBB0_5
Ltmp21:
	.loc	1 0 20 is_stmt 0
	mov	x0, x20
	b	LBB0_9
LBB0_7:
	mov	x0, x22
	add	x9, x22, x23, lsl #3
LBB0_8:
Ltmp22:
	.loc	1 90 37 is_stmt 1
	ldr	x10, [x20]
	ldr	x11, [x1]
Ltmp23:
	.loc	5 1547 19
	asr	x12, x10, #63
	.loc	5 1547 9 is_stmt 0
	eor	x12, x10, x12, lsr #1
	.loc	5 1548 20 is_stmt 1
	asr	x13, x11, #63
	.loc	5 1548 9 is_stmt 0
	eor	x13, x11, x13, lsr #1
Ltmp24:
	.loc	2 410 44 is_stmt 1
	cmp	x12, x13
Ltmp25:
	.loc	1 92 30
	csel	x10, x10, x11, lt
Ltmp26:
	.loc	2 410 44
	cset	w11, lt
	cset	w12, ge
Ltmp27:
	.loc	4 573 14
	str	x10, [x0], #8
Ltmp28:
	.loc	3 970 18
	add	x1, x1, w12, uxtw #3
Ltmp29:
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "const_ptr.rs"
	.loc	6 871 18
	add	x20, x20, w11, uxtw #3
Ltmp30:
	.loc	1 89 19
	cmp	x1, x8
	ccmp	x20, x9, #4, ne
	b.ne	LBB0_8
Ltmp31:
LBB0_9:
	.loc	6 733 18
	sub	x2, x8, x1
Ltmp32:
	.cfi_def_cfa wsp, 80
	.loc	4 573 14 epilogue_begin
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
	b	_memcpy
Ltmp33:
Lfunc_end0:
	.cfi_endproc
	.file	7 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops" "function.rs"
	.file	8 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"

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
	.byte	6
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
	.byte	7
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
	.byte	10
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
	.byte	11
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
	.long	178
	.byte	3
	.long	182
	.long	252
	.byte	2
	.short	1085

	.byte	1
	.byte	0
	.byte	3
	.long	263
	.long	252
	.byte	2
	.short	1586

	.byte	1
	.byte	2
	.long	1316
	.byte	3
	.long	1326
	.long	1392
	.byte	2
	.short	410

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	328
	.byte	2
	.long	332
	.byte	2
	.long	340
	.byte	3
	.long	349
	.long	424
	.byte	3
	.short	936

	.byte	1
	.byte	3
	.long	349
	.long	424
	.byte	3
	.short	936

	.byte	1
	.byte	3
	.long	349
	.long	424
	.byte	3
	.short	936

	.byte	1
	.byte	3
	.long	1896
	.long	1870
	.byte	3
	.short	887

	.byte	1
	.byte	0
	.byte	0
	.byte	3
	.long	433
	.long	515
	.byte	4
	.short	552

	.byte	1
	.byte	3
	.long	433
	.long	515
	.byte	4
	.short	552

	.byte	1
	.byte	3
	.long	433
	.long	515
	.byte	4
	.short	552

	.byte	1
	.byte	2
	.long	1688
	.byte	2
	.long	340
	.byte	3
	.long	1698
	.long	424
	.byte	6
	.short	837

	.byte	1
	.byte	3
	.long	1775
	.long	1870
	.byte	6
	.short	705

	.byte	1
	.byte	0
	.byte	0
	.byte	3
	.long	2143
	.long	2265
	.byte	4
	.short	847

	.byte	1
	.byte	3
	.long	433
	.long	515
	.byte	4
	.short	552

	.byte	1
	.byte	0
	.byte	2
	.long	540
	.byte	2
	.long	546
	.byte	2
	.long	551
	.byte	2
	.long	558
	.byte	2
	.long	564
	.byte	4
	.long	575
	.long	763
	.byte	1
	.byte	108
	.byte	3

	.byte	1
	.byte	4
	.long	1395
	.long	1580
	.byte	1
	.byte	78
	.byte	3

	.byte	1
	.byte	0
	.byte	2
	.long	1989
	.byte	5
	.long	1998
	.long	2133
	.byte	1
	.byte	139

	.byte	1
	.byte	0
	.byte	6
	.quad	Lfunc_begin0
Lset4 = Lfunc_end0-Lfunc_begin0
	.long	Lset4
	.byte	1
	.byte	109
	.long	2431
	.long	2326
	.byte	1
	.byte	8

	.byte	7
	.long	71
	.quad	Ltmp1
Lset5 = Ltmp2-Ltmp1
	.long	Lset5
	.byte	1
	.byte	16
	.byte	50
	.byte	8
	.long	57
	.quad	Ltmp1
Lset6 = Ltmp2-Ltmp1
	.long	Lset6
	.byte	2
	.short	1587
	.byte	8
	.byte	0
	.byte	9
	.long	119
	.quad	Ltmp4
Lset7 = Ltmp5-Ltmp4
	.long	Lset7
	.byte	1
	.byte	41
	.byte	28
	.byte	9
	.long	173
	.quad	Ltmp6
Lset8 = Ltmp7-Ltmp6
	.long	Lset8
	.byte	1
	.byte	51
	.byte	9
	.byte	9
	.long	119
	.quad	Ltmp7
Lset9 = Ltmp8-Ltmp7
	.long	Lset9
	.byte	1
	.byte	53
	.byte	65
	.byte	7
	.long	302
	.quad	Ltmp10
Lset10 = Ltmp21-Ltmp10
	.long	Lset10
	.byte	1
	.byte	58
	.byte	25
	.byte	9
	.long	186
	.quad	Ltmp16
Lset11 = Ltmp17-Ltmp16
	.long	Lset11
	.byte	1
	.byte	125
	.byte	17
	.byte	9
	.long	132
	.quad	Ltmp18
Lset12 = Ltmp19-Ltmp18
	.long	Lset12
	.byte	1
	.byte	127
	.byte	33
	.byte	9
	.long	132
	.quad	Ltmp19
Lset13 = Ltmp20-Ltmp19
	.long	Lset13
	.byte	1
	.byte	128
	.byte	34
	.byte	10
	.long	956
Lset14 = Ldebug_ranges0-Ldebug_range
	.long	Lset14
	.byte	1
	.byte	122
	.byte	36
	.byte	7
	.long	919
	.quad	Ltmp12
Lset15 = Ltmp13-Ltmp12
	.long	Lset15
	.byte	8
	.byte	196
	.byte	34
	.byte	9
	.long	888
	.quad	Ltmp12
Lset16 = Ltmp13-Ltmp12
	.long	Lset16
	.byte	7
	.byte	166
	.byte	5
	.byte	0
	.byte	11
	.long	89
Lset17 = Ldebug_ranges1-Ldebug_range
	.long	Lset17
	.byte	8
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	7
	.long	315
	.quad	Ltmp22
Lset18 = Ltmp31-Ltmp22
	.long	Lset18
	.byte	1
	.byte	56
	.byte	25
	.byte	10
	.long	956
Lset19 = Ldebug_ranges2-Ldebug_range
	.long	Lset19
	.byte	1
	.byte	90
	.byte	37
	.byte	7
	.long	919
	.quad	Ltmp23
Lset20 = Ltmp24-Ltmp23
	.long	Lset20
	.byte	8
	.byte	196
	.byte	34
	.byte	9
	.long	888
	.quad	Ltmp23
Lset21 = Ltmp24-Ltmp23
	.long	Lset21
	.byte	7
	.byte	166
	.byte	5
	.byte	0
	.byte	11
	.long	89
Lset22 = Ldebug_ranges3-Ldebug_range
	.long	Lset22
	.byte	8
	.byte	196
	.byte	34
	.byte	0
	.byte	9
	.long	199
	.quad	Ltmp27
Lset23 = Ltmp28-Ltmp27
	.long	Lset23
	.byte	1
	.byte	93
	.byte	17
	.byte	9
	.long	145
	.quad	Ltmp28
Lset24 = Ltmp29-Ltmp28
	.long	Lset24
	.byte	1
	.byte	95
	.byte	30
	.byte	9
	.long	222
	.quad	Ltmp29
Lset25 = Ltmp30-Ltmp29
	.long	Lset25
	.byte	1
	.byte	96
	.byte	31
	.byte	0
	.byte	7
	.long	250
	.quad	Ltmp31
Lset26 = Ltmp33-Ltmp31
	.long	Lset26
	.byte	1
	.byte	62
	.byte	5
	.byte	12
	.long	334
	.quad	Ltmp31
Lset27 = Ltmp33-Ltmp31
	.long	Lset27
	.byte	4
	.short	847
	.byte	1
	.byte	7
	.long	158
	.quad	Ltmp31
Lset28 = Ltmp32-Ltmp31
	.long	Lset28
	.byte	1
	.byte	146
	.byte	32
	.byte	8
	.long	235
	.quad	Ltmp31
Lset29 = Ltmp32-Ltmp31
	.long	Lset29
	.byte	3
	.short	892
	.byte	37
	.byte	0
	.byte	9
	.long	263
	.quad	Ltmp32
Lset30 = Ltmp33-Ltmp32
	.long	Lset30
	.byte	1
	.byte	147
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	873
	.byte	2
	.long	340
	.byte	13
	.long	877
	.long	919
	.byte	5
	.short	1521
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	929
	.byte	2
	.long	933
	.byte	2
	.long	942
	.byte	4
	.long	948
	.long	1068
	.byte	7
	.byte	166
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1130
	.byte	2
	.long	540
	.byte	2
	.long	340
	.byte	2
	.long	1136
	.byte	4
	.long	1144
	.long	1260
	.byte	8
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
Lset31 = Lcu_begin0-Lsection_info
	.long	Lset31
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset32 = Lsec_end0-Lfunc_begin0
	.quad	Lset32
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset33 = Ltmp12-Lfunc_begin0
	.quad	Lset33
Lset34 = Ltmp14-Lfunc_begin0
	.quad	Lset34
Lset35 = Ltmp15-Lfunc_begin0
	.quad	Lset35
Lset36 = Ltmp16-Lfunc_begin0
	.quad	Lset36
Lset37 = Ltmp17-Lfunc_begin0
	.quad	Lset37
Lset38 = Ltmp18-Lfunc_begin0
	.quad	Lset38
	.quad	0
	.quad	0
Ldebug_ranges1:
Lset39 = Ltmp13-Lfunc_begin0
	.quad	Lset39
Lset40 = Ltmp14-Lfunc_begin0
	.quad	Lset40
Lset41 = Ltmp15-Lfunc_begin0
	.quad	Lset41
Lset42 = Ltmp16-Lfunc_begin0
	.quad	Lset42
Lset43 = Ltmp17-Lfunc_begin0
	.quad	Lset43
Lset44 = Ltmp18-Lfunc_begin0
	.quad	Lset44
	.quad	0
	.quad	0
Ldebug_ranges2:
Lset45 = Ltmp23-Lfunc_begin0
	.quad	Lset45
Lset46 = Ltmp25-Lfunc_begin0
	.quad	Lset46
Lset47 = Ltmp26-Lfunc_begin0
	.quad	Lset47
Lset48 = Ltmp27-Lfunc_begin0
	.quad	Lset48
	.quad	0
	.quad	0
Ldebug_ranges3:
Lset49 = Ltmp24-Lfunc_begin0
	.quad	Lset49
Lset50 = Ltmp25-Lfunc_begin0
	.quad	Lset50
Lset51 = Ltmp26-Lfunc_begin0
	.quad	Lset51
Lset52 = Ltmp27-Lfunc_begin0
	.quad	Lset52
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.04"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"core"
	.asciz	"cmp"
	.asciz	"Ord"
	.asciz	"_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCs68MIsFmw01O_12evidence_lab"
	.asciz	"min<usize>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab"
	.asciz	"ptr"
	.asciz	"mut_ptr"
	.asciz	"{impl#0}"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab"
	.asciz	"add<f64>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab"
	.asciz	"copy_nonoverlapping<f64>"
	.asciz	"slice"
	.asciz	"sort"
	.asciz	"stable"
	.asciz	"merge"
	.asciz	"MergeState"
	.asciz	"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"
	.asciz	"merge_down<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"f64"
	.asciz	"_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp"
	.asciz	"total_cmp"
	.asciz	"ops"
	.asciz	"function"
	.asciz	"FnMut"
	.asciz	"_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCs68MIsFmw01O_12evidence_lab"
	.asciz	"call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>"
	.asciz	"alloc"
	.asciz	"sort_by"
	.asciz	"_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0Cs68MIsFmw01O_12evidence_lab"
	.asciz	"{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>"
	.asciz	"{impl#13}"
	.asciz	"_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq"
	.asciz	"eq"
	.asciz	"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"
	.asciz	"merge_up<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"const_ptr"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd20offset_from_unsignedCs68MIsFmw01O_12evidence_lab"
	.asciz	"offset_from_unsigned<f64>"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd20offset_from_unsignedCs68MIsFmw01O_12evidence_lab"
	.asciz	"{impl#1}"
	.asciz	"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"
	.asciz	"drop<f64>"
	.asciz	"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECs68MIsFmw01O_12evidence_lab"
	.asciz	"drop_glue<core::slice::sort::stable::merge::MergeState<f64>>"
	.asciz	"merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	14
	.long	29
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	3
	.long	6
	.long	8
	.long	9
	.long	13
	.long	14
	.long	16
	.long	18
	.long	20
	.long	21
	.long	23
	.long	25
	.long	27
	.long	771273104
	.long	-2136098668
	.long	-158655704
	.long	5863355
	.long	1152739981
	.long	-678578939
	.long	890257608
	.long	-518045544
	.long	540871033
	.long	2041624
	.long	306328292
	.long	-2087322314
	.long	-1654993144
	.long	-1126720797
	.long	-1740281842
	.long	-4346368
	.long	383088517
	.long	-1769440831
	.long	239228802
	.long	2115196196
	.long	1567618355
	.long	180816380
	.long	-716619170
	.long	1842170859
	.long	-559089349
	.long	-668322542
	.long	-617523486
	.long	1823506621
	.long	-216507723
Lset53 = LNames28-Lnames_begin
	.long	Lset53
Lset54 = LNames21-Lnames_begin
	.long	Lset54
Lset55 = LNames15-Lnames_begin
	.long	Lset55
Lset56 = LNames17-Lnames_begin
	.long	Lset56
Lset57 = LNames16-Lnames_begin
	.long	Lset57
Lset58 = LNames26-Lnames_begin
	.long	Lset58
Lset59 = LNames20-Lnames_begin
	.long	Lset59
Lset60 = LNames13-Lnames_begin
	.long	Lset60
Lset61 = LNames3-Lnames_begin
	.long	Lset61
Lset62 = LNames5-Lnames_begin
	.long	Lset62
Lset63 = LNames24-Lnames_begin
	.long	Lset63
Lset64 = LNames11-Lnames_begin
	.long	Lset64
Lset65 = LNames8-Lnames_begin
	.long	Lset65
Lset66 = LNames25-Lnames_begin
	.long	Lset66
Lset67 = LNames0-Lnames_begin
	.long	Lset67
Lset68 = LNames6-Lnames_begin
	.long	Lset68
Lset69 = LNames9-Lnames_begin
	.long	Lset69
Lset70 = LNames12-Lnames_begin
	.long	Lset70
Lset71 = LNames18-Lnames_begin
	.long	Lset71
Lset72 = LNames10-Lnames_begin
	.long	Lset72
Lset73 = LNames2-Lnames_begin
	.long	Lset73
Lset74 = LNames27-Lnames_begin
	.long	Lset74
Lset75 = LNames4-Lnames_begin
	.long	Lset75
Lset76 = LNames22-Lnames_begin
	.long	Lset76
Lset77 = LNames7-Lnames_begin
	.long	Lset77
Lset78 = LNames19-Lnames_begin
	.long	Lset78
Lset79 = LNames23-Lnames_begin
	.long	Lset79
Lset80 = LNames1-Lnames_begin
	.long	Lset80
Lset81 = LNames14-Lnames_begin
	.long	Lset81
LNames28:
	.long	1775
	.long	1
	.long	829
	.long	0
LNames21:
	.long	1698
	.long	1
	.long	747
	.long	0
LNames15:
	.long	919
	.long	2
	.long	586
	.long	673
	.long	0
LNames17:
	.long	1392
	.long	2
	.long	607
	.long	694
	.long	0
LNames16:
	.long	877
	.long	2
	.long	586
	.long	673
	.long	0
LNames26:
	.long	1870
	.long	2
	.long	809
	.long	829
	.long	0
LNames20:
	.long	1395
	.long	1
	.long	621
	.long	0
LNames13:
	.long	1068
	.long	2
	.long	566
	.long	653
	.long	0
LNames3:
	.long	263
	.long	1
	.long	372
	.long	0
LNames5:
	.long	424
	.long	6
	.long	414
	.long	454
	.long	514
	.long	534
	.long	727
	.long	747
	.long	0
LNames24:
	.long	2133
	.long	1
	.long	788
	.long	0
LNames11:
	.long	1260
	.long	2
	.long	554
	.long	641
	.long	0
LNames8:
	.long	433
	.long	4
	.long	434
	.long	494
	.long	707
	.long	851
	.long	0
LNames25:
	.long	1998
	.long	1
	.long	788
	.long	0
LNames0:
	.long	2326
	.long	1
	.long	347
	.long	0
LNames6:
	.long	349
	.long	5
	.long	414
	.long	454
	.long	514
	.long	534
	.long	727
	.long	0
LNames9:
	.long	763
	.long	1
	.long	474
	.long	0
LNames12:
	.long	1144
	.long	2
	.long	554
	.long	641
	.long	0
LNames18:
	.long	1326
	.long	2
	.long	607
	.long	694
	.long	0
LNames10:
	.long	575
	.long	1
	.long	474
	.long	0
LNames2:
	.long	252
	.long	2
	.long	372
	.long	392
	.long	0
LNames27:
	.long	1896
	.long	1
	.long	809
	.long	0
LNames4:
	.long	182
	.long	1
	.long	392
	.long	0
LNames22:
	.long	2265
	.long	1
	.long	768
	.long	0
LNames7:
	.long	515
	.long	4
	.long	434
	.long	494
	.long	707
	.long	851
	.long	0
LNames19:
	.long	1580
	.long	1
	.long	621
	.long	0
LNames23:
	.long	2143
	.long	1
	.long	768
	.long	0
LNames1:
	.long	2431
	.long	1
	.long	347
	.long	0
LNames14:
	.long	948
	.long	2
	.long	566
	.long	653
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
	.long	20
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	2
	.long	6
	.long	9
	.long	-1
	.long	-1
	.long	10
	.long	12
	.long	16
	.long	17
	.long	193466890
	.long	2090156110
	.long	267174901
	.long	-1762130655
	.long	-1738516765
	.long	-1553617785
	.long	478822272
	.long	-1536480714
	.long	-476042384
	.long	274532053
	.long	253189136
	.long	-2119460170
	.long	193488517
	.long	193501687
	.long	193502907
	.long	2090731117
	.long	-1738516798
	.long	193489909
	.long	221207599
	.long	-735823797
Lset82 = Lnamespac2-Lnamespac_begin
	.long	Lset82
Lset83 = Lnamespac0-Lnamespac_begin
	.long	Lset83
Lset84 = Lnamespac9-Lnamespac_begin
	.long	Lset84
Lset85 = Lnamespac18-Lnamespac_begin
	.long	Lset85
Lset86 = Lnamespac19-Lnamespac_begin
	.long	Lset86
Lset87 = Lnamespac16-Lnamespac_begin
	.long	Lset87
Lset88 = Lnamespac8-Lnamespac_begin
	.long	Lset88
Lset89 = Lnamespac17-Lnamespac_begin
	.long	Lset89
Lset90 = Lnamespac4-Lnamespac_begin
	.long	Lset90
Lset91 = Lnamespac6-Lnamespac_begin
	.long	Lset91
Lset92 = Lnamespac15-Lnamespac_begin
	.long	Lset92
Lset93 = Lnamespac10-Lnamespac_begin
	.long	Lset93
Lset94 = Lnamespac1-Lnamespac_begin
	.long	Lset94
Lset95 = Lnamespac12-Lnamespac_begin
	.long	Lset95
Lset96 = Lnamespac3-Lnamespac_begin
	.long	Lset96
Lset97 = Lnamespac7-Lnamespac_begin
	.long	Lset97
Lset98 = Lnamespac5-Lnamespac_begin
	.long	Lset98
Lset99 = Lnamespac11-Lnamespac_begin
	.long	Lset99
Lset100 = Lnamespac14-Lnamespac_begin
	.long	Lset100
Lset101 = Lnamespac13-Lnamespac_begin
	.long	Lset101
Lnamespac2:
	.long	178
	.long	1
	.long	52
	.long	0
Lnamespac0:
	.long	169
	.long	1
	.long	42
	.long	0
Lnamespac9:
	.long	558
	.long	1
	.long	292
	.long	0
Lnamespac18:
	.long	1688
	.long	1
	.long	212
	.long	0
Lnamespac19:
	.long	1989
	.long	1
	.long	329
	.long	0
Lnamespac16:
	.long	1136
	.long	1
	.long	951
	.long	0
Lnamespac8:
	.long	551
	.long	1
	.long	287
	.long	0
Lnamespac17:
	.long	1316
	.long	1
	.long	84
	.long	0
Lnamespac4:
	.long	332
	.long	1
	.long	109
	.long	0
Lnamespac6:
	.long	540
	.long	2
	.long	277
	.long	941
	.long	0
Lnamespac15:
	.long	1130
	.long	1
	.long	936
	.long	0
Lnamespac10:
	.long	564
	.long	1
	.long	297
	.long	0
Lnamespac1:
	.long	174
	.long	1
	.long	47
	.long	0
Lnamespac12:
	.long	929
	.long	1
	.long	904
	.long	0
Lnamespac3:
	.long	328
	.long	1
	.long	104
	.long	0
Lnamespac7:
	.long	546
	.long	1
	.long	282
	.long	0
Lnamespac5:
	.long	340
	.long	4
	.long	114
	.long	217
	.long	883
	.long	946
	.long	0
Lnamespac11:
	.long	873
	.long	1
	.long	878
	.long	0
Lnamespac14:
	.long	942
	.long	1
	.long	914
	.long	0
Lnamespac13:
	.long	933
	.long	1
	.long	909
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
