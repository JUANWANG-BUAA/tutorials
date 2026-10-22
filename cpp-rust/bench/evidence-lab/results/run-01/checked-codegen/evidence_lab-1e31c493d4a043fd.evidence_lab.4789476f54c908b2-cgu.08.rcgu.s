	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab
	.globl	__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab
	.p2align	2
__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"
	.loc	1 863 0
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
Ltmp0:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "uint_macros.rs"
	.loc	2 3212 26 prologue_end
	lsl	x19, x0, #3
	and	x9, x0, #0xe000000000000000
	mov	x10, #9223372036854775800
	cmp	x19, x10
	ccmp	x9, #0, #0, ls
Ltmp1:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics" "mod.rs"
	.loc	3 478 8
	b.eq	LBB0_3
Ltmp2:
	.loc	3 0 8 is_stmt 0
	mov	x20, #0
LBB0_2:
Ltmp3:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec" "mod.rs"
	.loc	4 443 25 is_stmt 1
	mov	x0, x20
	mov	x1, x19
	bl	__RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error
Ltmp4:
LBB0_3:
	.loc	4 461 12
	cbz	x19, LBB0_6
	.loc	4 0 12 is_stmt 0
	mov	x21, x0
	mov	x22, x8
	bl	__RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w20, #8
Ltmp5:
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "alloc.rs"
	.loc	5 130 9 is_stmt 1
	mov	x0, x19
	mov	w1, #8
	bl	__RNvCsdtSMxSA38aw_7___rustc12___rust_alloc
Ltmp6:
	.loc	4 470 19
	cbz	x0, LBB0_2
Ltmp7:
	.loc	4 0 19 is_stmt 0
	mov	x8, x22
	b	LBB0_7
LBB0_6:
	mov	x21, #0
	mov	w0, #8
LBB0_7:
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec" "mod.rs"
	.loc	6 969 9 is_stmt 1
	stp	x21, x0, [x8]
	str	xzr, [x8, #16]
Ltmp8:
	.cfi_def_cfa wsp, 48
	.loc	1 865 6 epilogue_begin
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
Ltmp9:
Lfunc_end0:
	.cfi_endproc
	.file	7 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc" "layout.rs"

	.private_extern	__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab
	.globl	__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab
	.p2align	2
__RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab:
Lfunc_begin1:
	.cfi_startproc
	.loc	6 3306 39 prologue_end
	ldp	x9, x8, [x0, #8]
Ltmp10:
	.loc	4 616 49
	ldr	x10, [x0]
Ltmp11:
	.file	8 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "mut_ptr.rs"
	.loc	8 970 18
	add	x0, x9, x8, lsl #3
Ltmp12:
	.loc	6 3307 17
	sub	x1, x10, x8
Ltmp13:
	.loc	1 869 6
	ret
Ltmp14:
Lfunc_end1:
	.cfi_endproc

	.private_extern	__RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab
	.globl	__RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab
	.p2align	2
__RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab:
Lfunc_begin2:
	.cfi_startproc
	.loc	6 4361 6 prologue_end
	ret
Ltmp15:
Lfunc_end2:
	.cfi_endproc

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
	.byte	0
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.ascii	"\347\177"
	.byte	25
	.byte	64
	.byte	24
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
	.byte	5
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
	.byte	5
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
	.byte	10
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
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.ascii	"\347\177"
	.byte	25
	.byte	64
	.byte	24
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
Lset3 = Lfunc_end2-Lfunc_begin0
	.long	Lset3
	.byte	2
	.long	366
	.byte	2
	.long	469
	.byte	2
	.long	539
	.byte	3
	.long	691
	.long	794
	.byte	4
	.short	434

	.byte	1
	.byte	3
	.long	1890
	.long	1984
	.byte	4
	.short	615

	.byte	1
	.byte	0
	.byte	2
	.long	833
	.byte	4
	.long	840
	.long	940
	.byte	4
	.byte	175

	.byte	1
	.byte	3
	.long	2015
	.long	2106
	.byte	4
	.short	308

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	984
	.byte	2
	.long	988
	.byte	3
	.long	992
	.long	940
	.byte	6
	.short	968

	.byte	1
	.byte	3
	.long	1085
	.long	1172
	.byte	6
	.short	521

	.byte	1
	.byte	3
	.long	1750
	.long	1844
	.byte	6
	.short	3300

	.byte	1
	.byte	0
	.byte	2
	.long	2433
	.byte	5
	.quad	Lfunc_begin2
Lset4 = Lfunc_end2-Lfunc_begin2
	.long	Lset4

	.byte	1
	.byte	111
	.long	2475
	.long	2443
	.byte	6
	.short	4353

	.byte	0
	.byte	0
	.byte	2
	.long	1579
	.byte	2
	.long	1585
	.byte	6
	.quad	Lfunc_begin0
Lset5 = Lfunc_end0-Lfunc_begin0
	.long	Lset5
	.byte	1
	.byte	109
	.long	1595
	.long	1172
	.byte	1
	.short	863

	.byte	7
	.long	139
	.quad	Ltmp0
Lset6 = Ltmp8-Ltmp0
	.long	Lset6
	.byte	1
	.short	864
	.byte	9
	.byte	7
	.long	126
	.quad	Ltmp0
Lset7 = Ltmp8-Ltmp0
	.long	Lset7
	.byte	6
	.short	522
	.byte	9
	.byte	7
	.long	89
	.quad	Ltmp0
Lset8 = Ltmp7-Ltmp0
	.long	Lset8
	.byte	6
	.short	969
	.byte	20
	.byte	8
	.long	57
	.quad	Ltmp0
Lset9 = Ltmp7-Ltmp0
	.long	Lset9
	.byte	4
	.byte	177
	.byte	20
	.byte	9
	.long	838
Lset10 = Ldebug_ranges0-Ldebug_range
	.long	Lset10
	.byte	4
	.short	435
	.byte	15
	.byte	10
	.long	820
	.quad	Ltmp0
Lset11 = Ltmp2-Ltmp0
	.long	Lset11
	.byte	4
	.short	455
	.byte	28
	.byte	10
	.long	774
	.quad	Ltmp0
Lset12 = Ltmp2-Ltmp0
	.long	Lset12
	.byte	4
	.short	901
	.byte	17
	.byte	10
	.long	744
	.quad	Ltmp0
Lset13 = Ltmp2-Ltmp0
	.long	Lset13
	.byte	7
	.short	533
	.byte	39
	.byte	11
	.long	731
	.quad	Ltmp0
Lset14 = Ltmp1-Ltmp0
	.long	Lset14
	.byte	2
	.short	1330
	.byte	31
	.byte	11
	.long	795
	.quad	Ltmp1
Lset15 = Ltmp2-Ltmp1
	.long	Lset15
	.byte	2
	.short	1331
	.byte	16
	.byte	0
	.byte	0
	.byte	0
	.byte	10
	.long	907
	.quad	Ltmp5
Lset16 = Ltmp6-Ltmp5
	.long	Lset16
	.byte	4
	.short	466
	.byte	47
	.byte	10
	.long	888
	.quad	Ltmp5
Lset17 = Ltmp6-Ltmp5
	.long	Lset17
	.byte	5
	.short	541
	.byte	14
	.byte	10
	.long	875
	.quad	Ltmp5
Lset18 = Ltmp6-Ltmp5
	.long	Lset18
	.byte	5
	.short	424
	.byte	9
	.byte	11
	.long	858
	.quad	Ltmp5
Lset19 = Ltmp6-Ltmp5
	.long	Lset19
	.byte	5
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
	.byte	12
	.quad	Lfunc_begin1
Lset20 = Lfunc_end1-Lfunc_begin1
	.long	Lset20

	.byte	1
	.byte	111
	.long	2272
	.long	2247
	.byte	1
	.short	867

	.byte	7
	.long	152
	.quad	Lfunc_begin1
Lset21 = Ltmp13-Lfunc_begin1
	.long	Lset21
	.byte	1
	.short	868
	.byte	14
	.byte	7
	.long	101
	.quad	Ltmp10
Lset22 = Ltmp11-Ltmp10
	.long	Lset22
	.byte	6
	.short	3307
	.byte	26
	.byte	13
	.long	70
	.quad	Ltmp10
Lset23 = Ltmp11-Ltmp10
	.long	Lset23
	.byte	4
	.short	309
	.byte	20
	.byte	0
	.byte	13
	.long	668
	.quad	Ltmp11
Lset24 = Ltmp12-Ltmp11
	.long	Lset24
	.byte	6
	.short	3306
	.byte	35
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	219
	.byte	2
	.long	2142
	.byte	2
	.long	2146
	.byte	2
	.long	2154
	.byte	3
	.long	2163
	.long	2238
	.byte	8
	.short	936

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
Ldebug_info_end0:
Lcu_begin1:
Lset25 = Ldebug_info_end1-Ldebug_info_start1
	.long	Lset25
Ldebug_info_start1:
	.short	4
Lset26 = Lsection_abbrev-Lsection_abbrev
	.long	Lset26
	.byte	8
	.byte	14
	.long	0
	.short	28
	.long	169
Lset27 = Lline_table_start0-Lsection_line
	.long	Lset27
	.long	107

	.byte	2
	.long	219
	.byte	2
	.long	224
	.byte	2
	.long	228
	.byte	3
	.long	238
	.long	290
	.byte	2
	.short	3211

	.byte	1
	.byte	3
	.long	306
	.long	354
	.byte	2
	.short	1329

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	366
	.byte	2
	.long	372
	.byte	2
	.long	379
	.byte	3
	.long	386
	.long	455
	.byte	7
	.short	532

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1191
	.byte	3
	.long	1202
	.long	1249
	.byte	3
	.short	477

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	366
	.byte	2
	.long	469
	.byte	3
	.long	477
	.long	526
	.byte	4
	.short	896

	.byte	1
	.byte	2
	.long	539
	.byte	3
	.long	551
	.long	653
	.byte	4
	.short	447

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	366
	.byte	4
	.long	1258
	.long	366
	.byte	5
	.byte	124

	.byte	1
	.byte	2
	.long	1297
	.byte	3
	.long	1304
	.long	1373
	.byte	5
	.short	297

	.byte	1
	.byte	3
	.long	1392
	.long	1453
	.byte	5
	.short	423

	.byte	1
	.byte	0
	.byte	2
	.long	1464
	.byte	15
	.long	1473
	.long	1570
	.byte	5
	.short	540
	.byte	3

	.byte	1
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
Lset28 = Lcu_begin0-Lsection_info
	.long	Lset28
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset29 = Lsec_end0-Lfunc_begin0
	.quad	Lset29
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset30 = Ltmp0-Lfunc_begin0
	.quad	Lset30
Lset31 = Ltmp2-Lfunc_begin0
	.quad	Lset31
Lset32 = Ltmp4-Lfunc_begin0
	.quad	Lset32
Lset33 = Ltmp7-Lfunc_begin0
	.quad	Lset33
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.08"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.05"
	.asciz	"core"
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
	.asciz	"slice"
	.asciz	"{impl#10}"
	.asciz	"_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab"
	.asciz	"_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecdE18spare_capacity_mutCs68MIsFmw01O_12evidence_lab"
	.asciz	"spare_capacity_mut<f64, alloc::alloc::Global>"
	.asciz	"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner8capacityCs68MIsFmw01O_12evidence_lab"
	.asciz	"capacity<alloc::alloc::Global>"
	.asciz	"_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE8capacityCs68MIsFmw01O_12evidence_lab"
	.asciz	"capacity<f64, alloc::alloc::Global>"
	.asciz	"ptr"
	.asciz	"mut_ptr"
	.asciz	"{impl#0}"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab"
	.asciz	"add<f64>"
	.asciz	"as_uninit_slice_mut<f64>"
	.asciz	"_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab"
	.asciz	"{impl#27}"
	.asciz	"drop<f64, alloc::alloc::Global>"
	.asciz	"_RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	20
	.long	40
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	1
	.long	5
	.long	-1
	.long	6
	.long	10
	.long	13
	.long	-1
	.long	15
	.long	17
	.long	18
	.long	19
	.long	21
	.long	24
	.long	25
	.long	26
	.long	29
	.long	34
	.long	-1
	.long	39
	.long	-1414582076
	.long	635942621
	.long	-1577237315
	.long	-1299049695
	.long	-1170908755
	.long	-1931130574
	.long	2041624
	.long	1607869944
	.long	-1740421212
	.long	-1050942852
	.long	788507125
	.long	-598347711
	.long	-160625911
	.long	639507826
	.long	2117357066
	.long	838842488
	.long	-4346368
	.long	-1844739467
	.long	-1231915286
	.long	142103591
	.long	204316431
	.long	1185083612
	.long	1189325192
	.long	-189511624
	.long	-1802194023
	.long	-210901402
	.long	69321255
	.long	114643935
	.long	117866855
	.long	253189136
	.long	400243036
	.long	669388376
	.long	-2140179020
	.long	-739326420
	.long	105046517
	.long	275550577
	.long	1291623497
	.long	1700587017
	.long	-734464339
	.long	-877343777
Lset34 = LNames24-Lnames_begin
	.long	Lset34
Lset35 = LNames29-Lnames_begin
	.long	Lset35
Lset36 = LNames28-Lnames_begin
	.long	Lset36
Lset37 = LNames10-Lnames_begin
	.long	Lset37
Lset38 = LNames6-Lnames_begin
	.long	Lset38
Lset39 = LNames18-Lnames_begin
	.long	Lset39
Lset40 = LNames36-Lnames_begin
	.long	Lset40
Lset41 = LNames5-Lnames_begin
	.long	Lset41
Lset42 = LNames16-Lnames_begin
	.long	Lset42
Lset43 = LNames34-Lnames_begin
	.long	Lset43
Lset44 = LNames21-Lnames_begin
	.long	Lset44
Lset45 = LNames22-Lnames_begin
	.long	Lset45
Lset46 = LNames31-Lnames_begin
	.long	Lset46
Lset47 = LNames1-Lnames_begin
	.long	Lset47
Lset48 = LNames20-Lnames_begin
	.long	Lset48
Lset49 = LNames0-Lnames_begin
	.long	Lset49
Lset50 = LNames37-Lnames_begin
	.long	Lset50
Lset51 = LNames25-Lnames_begin
	.long	Lset51
Lset52 = LNames23-Lnames_begin
	.long	Lset52
Lset53 = LNames8-Lnames_begin
	.long	Lset53
Lset54 = LNames7-Lnames_begin
	.long	Lset54
Lset55 = LNames11-Lnames_begin
	.long	Lset55
Lset56 = LNames9-Lnames_begin
	.long	Lset56
Lset57 = LNames32-Lnames_begin
	.long	Lset57
Lset58 = LNames14-Lnames_begin
	.long	Lset58
Lset59 = LNames39-Lnames_begin
	.long	Lset59
Lset60 = LNames30-Lnames_begin
	.long	Lset60
Lset61 = LNames38-Lnames_begin
	.long	Lset61
Lset62 = LNames17-Lnames_begin
	.long	Lset62
Lset63 = LNames26-Lnames_begin
	.long	Lset63
Lset64 = LNames2-Lnames_begin
	.long	Lset64
Lset65 = LNames15-Lnames_begin
	.long	Lset65
Lset66 = LNames33-Lnames_begin
	.long	Lset66
Lset67 = LNames35-Lnames_begin
	.long	Lset67
Lset68 = LNames13-Lnames_begin
	.long	Lset68
Lset69 = LNames4-Lnames_begin
	.long	Lset69
Lset70 = LNames19-Lnames_begin
	.long	Lset70
Lset71 = LNames3-Lnames_begin
	.long	Lset71
Lset72 = LNames12-Lnames_begin
	.long	Lset72
Lset73 = LNames27-Lnames_begin
	.long	Lset73
LNames24:
	.long	1373
	.long	1
	.long	481
	.long	0
LNames29:
	.long	2272
	.long	1
	.long	532
	.long	0
LNames28:
	.long	2247
	.long	1
	.long	532
	.long	0
LNames10:
	.long	526
	.long	1
	.long	331
	.long	0
LNames6:
	.long	794
	.long	1
	.long	298
	.long	0
LNames18:
	.long	1249
	.long	1
	.long	415
	.long	0
LNames36:
	.long	2238
	.long	1
	.long	622
	.long	0
LNames5:
	.long	840
	.long	1
	.long	277
	.long	0
LNames16:
	.long	290
	.long	1
	.long	394
	.long	0
LNames34:
	.long	1984
	.long	1
	.long	600
	.long	0
LNames21:
	.long	1473
	.long	1
	.long	439
	.long	0
LNames22:
	.long	1453
	.long	1
	.long	460
	.long	0
LNames31:
	.long	1750
	.long	1
	.long	558
	.long	0
LNames1:
	.long	1595
	.long	1
	.long	209
	.long	0
LNames20:
	.long	1570
	.long	1
	.long	439
	.long	0
LNames0:
	.long	1172
	.long	2
	.long	209
	.long	235
	.long	0
LNames37:
	.long	2163
	.long	1
	.long	622
	.long	0
LNames25:
	.long	1304
	.long	1
	.long	481
	.long	0
LNames23:
	.long	1392
	.long	1
	.long	460
	.long	0
LNames8:
	.long	653
	.long	1
	.long	318
	.long	0
LNames7:
	.long	691
	.long	1
	.long	298
	.long	0
LNames11:
	.long	477
	.long	1
	.long	331
	.long	0
LNames9:
	.long	551
	.long	1
	.long	318
	.long	0
LNames32:
	.long	2106
	.long	1
	.long	579
	.long	0
LNames14:
	.long	354
	.long	1
	.long	373
	.long	0
LNames39:
	.long	2475
	.long	1
	.long	171
	.long	0
LNames30:
	.long	1844
	.long	1
	.long	558
	.long	0
LNames38:
	.long	2443
	.long	1
	.long	171
	.long	0
LNames17:
	.long	238
	.long	1
	.long	394
	.long	0
LNames26:
	.long	366
	.long	1
	.long	502
	.long	0
LNames2:
	.long	1085
	.long	1
	.long	235
	.long	0
LNames15:
	.long	306
	.long	1
	.long	373
	.long	0
LNames33:
	.long	2015
	.long	1
	.long	579
	.long	0
LNames35:
	.long	1890
	.long	1
	.long	600
	.long	0
LNames13:
	.long	386
	.long	1
	.long	352
	.long	0
LNames4:
	.long	992
	.long	1
	.long	256
	.long	0
LNames19:
	.long	1202
	.long	1
	.long	415
	.long	0
LNames3:
	.long	940
	.long	2
	.long	256
	.long	277
	.long	0
LNames12:
	.long	455
	.long	1
	.long	352
	.long	0
LNames27:
	.long	1258
	.long	1
	.long	502
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
	.long	3
	.long	5
	.long	-1
	.long	10
	.long	12
	.long	14
	.long	17
	.long	18
	.long	2090156110
	.long	-1252119626
	.long	193508931
	.long	907186092
	.long	-476042384
	.long	193474083
	.long	274532053
	.long	-1536480813
	.long	-1536479493
	.long	-834400883
	.long	1035240715
	.long	-98386551
	.long	253189136
	.long	-1536480780
	.long	193500757
	.long	193502907
	.long	-1738516699
	.long	-1738516798
	.long	183218979
	.long	-1069113597
Lset74 = Lnamespac0-Lnamespac_begin
	.long	Lset74
Lset75 = Lnamespac12-Lnamespac_begin
	.long	Lset75
Lset76 = Lnamespac9-Lnamespac_begin
	.long	Lset76
Lset77 = Lnamespac6-Lnamespac_begin
	.long	Lset77
Lset78 = Lnamespac17-Lnamespac_begin
	.long	Lset78
Lset79 = Lnamespac10-Lnamespac_begin
	.long	Lset79
Lset80 = Lnamespac14-Lnamespac_begin
	.long	Lset80
Lset81 = Lnamespac15-Lnamespac_begin
	.long	Lset81
Lset82 = Lnamespac19-Lnamespac_begin
	.long	Lset82
Lset83 = Lnamespac8-Lnamespac_begin
	.long	Lset83
Lset84 = Lnamespac11-Lnamespac_begin
	.long	Lset84
Lset85 = Lnamespac7-Lnamespac_begin
	.long	Lset85
Lset86 = Lnamespac3-Lnamespac_begin
	.long	Lset86
Lset87 = Lnamespac2-Lnamespac_begin
	.long	Lset87
Lset88 = Lnamespac1-Lnamespac_begin
	.long	Lset88
Lset89 = Lnamespac16-Lnamespac_begin
	.long	Lset89
Lset90 = Lnamespac13-Lnamespac_begin
	.long	Lset90
Lset91 = Lnamespac18-Lnamespac_begin
	.long	Lset91
Lset92 = Lnamespac4-Lnamespac_begin
	.long	Lset92
Lset93 = Lnamespac5-Lnamespac_begin
	.long	Lset93
Lnamespac0:
	.long	219
	.long	2
	.long	716
	.long	648
	.long	0
Lnamespac12:
	.long	1297
	.long	1
	.long	870
	.long	0
Lnamespac9:
	.long	984
	.long	1
	.long	116
	.long	0
Lnamespac6:
	.long	469
	.long	2
	.long	47
	.long	815
	.long	0
Lnamespac17:
	.long	2146
	.long	1
	.long	658
	.long	0
Lnamespac10:
	.long	988
	.long	1
	.long	121
	.long	0
Lnamespac14:
	.long	1579
	.long	1
	.long	199
	.long	0
Lnamespac15:
	.long	1585
	.long	1
	.long	204
	.long	0
Lnamespac19:
	.long	2433
	.long	1
	.long	166
	.long	0
Lnamespac8:
	.long	833
	.long	1
	.long	84
	.long	0
Lnamespac11:
	.long	1191
	.long	1
	.long	790
	.long	0
Lnamespac7:
	.long	539
	.long	2
	.long	52
	.long	833
	.long	0
Lnamespac3:
	.long	366
	.long	4
	.long	42
	.long	759
	.long	810
	.long	853
	.long	0
Lnamespac2:
	.long	228
	.long	1
	.long	726
	.long	0
Lnamespac1:
	.long	224
	.long	1
	.long	721
	.long	0
Lnamespac16:
	.long	2142
	.long	1
	.long	653
	.long	0
Lnamespac13:
	.long	1464
	.long	1
	.long	902
	.long	0
Lnamespac18:
	.long	2154
	.long	1
	.long	663
	.long	0
Lnamespac4:
	.long	372
	.long	1
	.long	764
	.long	0
Lnamespac5:
	.long	379
	.long	1
	.long	769
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
