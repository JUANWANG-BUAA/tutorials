	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	.globl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	.p2align	2
__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab:
Lfunc_begin0:
	.file	1 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared" "pivot.rs"
	.loc	1 55 0
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
	mov	x19, x2
	mov	x20, x1
Ltmp0:
	.loc	1 65 12 prologue_end
	tst	x3, #0x1ffffffffffffff8
	b.eq	LBB0_2
	.loc	1 66 22
	lsr	x21, x3, #3
Ltmp1:
	.file	2 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr" "const_ptr.rs"
	.loc	2 871 18
	lsl	x24, x21, #5
Ltmp2:
	.loc	2 871 18 is_stmt 0
	lsl	x8, x21, #6
	sub	x25, x8, x21, lsl #3
Ltmp3:
	.loc	2 871 18
	add	x1, x0, x24
Ltmp4:
	.loc	2 871 18
	add	x2, x0, x25
Ltmp5:
	.loc	1 67 17 is_stmt 1
	mov	x3, x21
	mov	x22, x4
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	mov	x23, x0
Ltmp6:
	.loc	2 871 18
	add	x1, x20, x24
Ltmp7:
	.loc	2 871 18 is_stmt 0
	add	x2, x20, x25
Ltmp8:
	.loc	1 68 17 is_stmt 1
	mov	x0, x20
	mov	x3, x21
	mov	x4, x22
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	mov	x20, x0
Ltmp9:
	.loc	2 871 18
	add	x1, x19, x24
Ltmp10:
	.loc	2 871 18 is_stmt 0
	add	x2, x19, x25
Ltmp11:
	.loc	1 69 17 is_stmt 1
	mov	x0, x19
	mov	x3, x21
	mov	x4, x22
	bl	__RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab
	mov	x19, x0
	mov	x0, x23
Ltmp12:
LBB0_2:
	.loc	1 82 13
	ldr	x8, [x0]
	ldr	x9, [x20]
Ltmp13:
	.file	3 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num" "f64.rs"
	.loc	3 1547 19
	asr	x10, x8, #63
	.loc	3 1547 9 is_stmt 0
	eor	x8, x8, x10, lsr #1
	.loc	3 1548 20 is_stmt 1
	asr	x10, x9, #63
	.loc	3 1548 9 is_stmt 0
	eor	x9, x9, x10, lsr #1
Ltmp14:
	.file	4 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src" "cmp.rs"
	.loc	4 410 44 is_stmt 1
	cmp	x8, x9
	cset	w10, lt
Ltmp15:
	.loc	1 83 13
	ldr	x11, [x19]
Ltmp16:
	.loc	3 1548 20
	asr	x12, x11, #63
	.loc	3 1548 9 is_stmt 0
	eor	x11, x11, x12, lsr #1
Ltmp17:
	.loc	4 410 44 is_stmt 1
	cmp	x8, x11
	cset	w8, lt
Ltmp18:
	.loc	1 84 8
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lt
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x19, x20, ne
	cmp	w8, #0
	csel	x0, x0, x9, ne
Ltmp19:
	.cfi_def_cfa wsp, 80
	.loc	1 73 2 epilogue_begin
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
Ltmp20:
Lfunc_end0:
	.cfi_endproc
	.file	5 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops" "function.rs"
	.file	6 "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src" "slice.rs"

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
	.byte	10
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
	.byte	2
	.long	188
	.byte	3
	.long	197
	.long	274
	.byte	2
	.short	837

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	283
	.byte	2
	.long	289
	.byte	2
	.long	294
	.byte	2
	.long	301
	.byte	4
	.long	307
	.long	471
	.byte	1
	.byte	79

	.byte	1
	.byte	5
	.quad	Lfunc_begin0
Lset4 = Lfunc_end0-Lfunc_begin0
	.long	Lset4
	.byte	1
	.byte	109
	.long	1215
	.long	1104
	.byte	1
	.byte	55

	.byte	6
	.long	62
Lset5 = Ldebug_ranges0-Ldebug_range
	.long	Lset5
	.byte	1
	.byte	67
	.byte	34
	.byte	6
	.long	62
Lset6 = Ldebug_ranges1-Ldebug_range
	.long	Lset6
	.byte	1
	.byte	67
	.byte	49
	.byte	7
	.long	62
	.quad	Ltmp6
Lset7 = Ltmp7-Ltmp6
	.long	Lset7
	.byte	1
	.byte	68
	.byte	34
	.byte	7
	.long	62
	.quad	Ltmp7
Lset8 = Ltmp8-Ltmp7
	.long	Lset8
	.byte	1
	.byte	68
	.byte	49
	.byte	7
	.long	62
	.quad	Ltmp9
Lset9 = Ltmp10-Ltmp9
	.long	Lset9
	.byte	1
	.byte	69
	.byte	34
	.byte	7
	.long	62
	.quad	Ltmp10
Lset10 = Ltmp11-Ltmp10
	.long	Lset10
	.byte	1
	.byte	69
	.byte	49
	.byte	8
	.long	98
	.quad	Ltmp12
Lset11 = Ltmp19-Ltmp12
	.long	Lset11
	.byte	1
	.byte	71
	.byte	9
	.byte	8
	.long	532
	.quad	Ltmp13
Lset12 = Ltmp15-Ltmp13
	.long	Lset12
	.byte	1
	.byte	82
	.byte	13
	.byte	8
	.long	470
	.quad	Ltmp13
Lset13 = Ltmp14-Ltmp13
	.long	Lset13
	.byte	6
	.byte	196
	.byte	34
	.byte	7
	.long	439
	.quad	Ltmp13
Lset14 = Ltmp14-Ltmp13
	.long	Lset14
	.byte	5
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	496
	.quad	Ltmp14
Lset15 = Ltmp15-Ltmp14
	.long	Lset15
	.byte	6
	.byte	196
	.byte	34
	.byte	0
	.byte	8
	.long	532
	.quad	Ltmp16
Lset16 = Ltmp18-Ltmp16
	.long	Lset16
	.byte	1
	.byte	83
	.byte	13
	.byte	8
	.long	470
	.quad	Ltmp16
Lset17 = Ltmp17-Ltmp16
	.long	Lset17
	.byte	6
	.byte	196
	.byte	34
	.byte	7
	.long	439
	.quad	Ltmp16
Lset18 = Ltmp17-Ltmp16
	.long	Lset18
	.byte	5
	.byte	166
	.byte	5
	.byte	0
	.byte	7
	.long	496
	.quad	Ltmp17
Lset19 = Ltmp18-Ltmp17
	.long	Lset19
	.byte	6
	.byte	196
	.byte	34
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	578
	.byte	2
	.long	188
	.byte	9
	.long	582
	.long	624
	.byte	3
	.short	1521
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	2
	.long	634
	.byte	2
	.long	638
	.byte	2
	.long	647
	.byte	10
	.long	653
	.long	773
	.byte	5
	.byte	166
	.byte	3

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	1021
	.byte	2
	.long	1025
	.byte	3
	.long	1035
	.long	1101
	.byte	4
	.short	410

	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.long	835
	.byte	2
	.long	283
	.byte	2
	.long	188
	.byte	2
	.long	841
	.byte	10
	.long	849
	.long	965
	.byte	6
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
Lset20 = Lcu_begin0-Lsection_info
	.long	Lset20
	.byte	8
	.byte	0
	.space	4,255
	.quad	Lfunc_begin0
Lset21 = Lsec_end0-Lfunc_begin0
	.quad	Lset21
	.quad	0
	.quad	0
	.section	__DWARF,__debug_ranges,regular,debug
Ldebug_range:
Ldebug_ranges0:
Lset22 = Ltmp1-Lfunc_begin0
	.quad	Lset22
Lset23 = Ltmp2-Lfunc_begin0
	.quad	Lset23
Lset24 = Ltmp3-Lfunc_begin0
	.quad	Lset24
Lset25 = Ltmp4-Lfunc_begin0
	.quad	Lset25
	.quad	0
	.quad	0
Ldebug_ranges1:
Lset26 = Ltmp2-Lfunc_begin0
	.quad	Lset26
Lset27 = Ltmp3-Lfunc_begin0
	.quad	Lset27
Lset28 = Ltmp4-Lfunc_begin0
	.quad	Lset28
Lset29 = Ltmp5-Lfunc_begin0
	.quad	Lset29
	.quad	0
	.quad	0
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))"
	.asciz	"src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.07"
	.asciz	"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab"
	.asciz	"core"
	.asciz	"ptr"
	.asciz	"const_ptr"
	.asciz	"{impl#0}"
	.asciz	"_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCsfFAnx7WYh7o_12evidence_lab"
	.asciz	"add<f64>"
	.asciz	"slice"
	.asciz	"sort"
	.asciz	"shared"
	.asciz	"pivot"
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
	.asciz	"median3_rec<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>"
	.asciz	"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712
	.short	1
	.short	0
	.long	14
	.long	14
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	1
	.long	3
	.long	5
	.long	6
	.long	8
	.long	9
	.long	-1
	.long	10
	.long	12
	.long	-1
	.long	-1
	.long	-1
	.long	-1
	.long	-158655704
	.long	5863355
	.long	1152739981
	.long	1483294808
	.long	-518045544
	.long	-1306255931
	.long	2041624
	.long	-2087322314
	.long	2069498793
	.long	-292272776
	.long	239228802
	.long	-1258739380
	.long	1116636971
	.long	-1472205121
Lset30 = LNames10-Lnames_begin
	.long	Lset30
Lset31 = LNames12-Lnames_begin
	.long	Lset31
Lset32 = LNames11-Lnames_begin
	.long	Lset32
Lset33 = LNames7-Lnames_begin
	.long	Lset33
Lset34 = LNames8-Lnames_begin
	.long	Lset34
Lset35 = LNames5-Lnames_begin
	.long	Lset35
Lset36 = LNames2-Lnames_begin
	.long	Lset36
Lset37 = LNames6-Lnames_begin
	.long	Lset37
Lset38 = LNames1-Lnames_begin
	.long	Lset38
Lset39 = LNames0-Lnames_begin
	.long	Lset39
Lset40 = LNames13-Lnames_begin
	.long	Lset40
Lset41 = LNames9-Lnames_begin
	.long	Lset41
Lset42 = LNames3-Lnames_begin
	.long	Lset42
Lset43 = LNames4-Lnames_begin
	.long	Lset43
LNames10:
	.long	624
	.long	2
	.long	299
	.long	381
	.long	0
LNames12:
	.long	1101
	.long	2
	.long	320
	.long	402
	.long	0
LNames11:
	.long	582
	.long	2
	.long	299
	.long	381
	.long	0
LNames7:
	.long	849
	.long	2
	.long	259
	.long	341
	.long	0
LNames8:
	.long	773
	.long	2
	.long	279
	.long	361
	.long	0
LNames5:
	.long	307
	.long	1
	.long	239
	.long	0
LNames2:
	.long	274
	.long	6
	.long	135
	.long	147
	.long	159
	.long	179
	.long	199
	.long	219
	.long	0
LNames6:
	.long	965
	.long	2
	.long	259
	.long	341
	.long	0
LNames1:
	.long	1215
	.long	1
	.long	110
	.long	0
LNames0:
	.long	1104
	.long	1
	.long	110
	.long	0
LNames13:
	.long	1035
	.long	2
	.long	320
	.long	402
	.long	0
LNames9:
	.long	653
	.long	2
	.long	279
	.long	361
	.long	0
LNames3:
	.long	197
	.long	6
	.long	135
	.long	147
	.long	159
	.long	179
	.long	199
	.long	219
	.long	0
LNames4:
	.long	471
	.long	1
	.long	239
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
	.long	16
	.long	12
	.long	0
	.long	1
	.short	1
	.short	6
	.long	0
	.long	1
	.long	2
	.long	-1
	.long	-1
	.long	3
	.long	6
	.long	7
	.long	-1
	.long	-1
	.long	-1
	.long	10
	.long	12
	.long	13
	.long	14
	.long	15
	.long	253189136
	.long	-1762130655
	.long	-1738516798
	.long	193488517
	.long	193489909
	.long	274532053
	.long	-1536480714
	.long	193501687
	.long	270881047
	.long	-1553617785
	.long	193502907
	.long	-735823797
	.long	464608412
	.long	2090731117
	.long	2090156110
	.long	221207599
Lset44 = Lnamespac12-Lnamespac_begin
	.long	Lset44
Lset45 = Lnamespac2-Lnamespac_begin
	.long	Lset45
Lset46 = Lnamespac3-Lnamespac_begin
	.long	Lset46
Lset47 = Lnamespac14-Lnamespac_begin
	.long	Lset47
Lset48 = Lnamespac8-Lnamespac_begin
	.long	Lset48
Lset49 = Lnamespac4-Lnamespac_begin
	.long	Lset49
Lset50 = Lnamespac15-Lnamespac_begin
	.long	Lset50
Lset51 = Lnamespac9-Lnamespac_begin
	.long	Lset51
Lset52 = Lnamespac7-Lnamespac_begin
	.long	Lset52
Lset53 = Lnamespac13-Lnamespac_begin
	.long	Lset53
Lset54 = Lnamespac1-Lnamespac_begin
	.long	Lset54
Lset55 = Lnamespac10-Lnamespac_begin
	.long	Lset55
Lset56 = Lnamespac6-Lnamespac_begin
	.long	Lset56
Lset57 = Lnamespac5-Lnamespac_begin
	.long	Lset57
Lset58 = Lnamespac0-Lnamespac_begin
	.long	Lset58
Lset59 = Lnamespac11-Lnamespac_begin
	.long	Lset59
Lnamespac12:
	.long	835
	.long	1
	.long	512
	.long	0
Lnamespac2:
	.long	178
	.long	1
	.long	52
	.long	0
Lnamespac3:
	.long	188
	.long	3
	.long	57
	.long	434
	.long	522
	.long	0
Lnamespac14:
	.long	1021
	.long	1
	.long	486
	.long	0
Lnamespac8:
	.long	578
	.long	1
	.long	429
	.long	0
Lnamespac4:
	.long	283
	.long	2
	.long	78
	.long	517
	.long	0
Lnamespac15:
	.long	1025
	.long	1
	.long	491
	.long	0
Lnamespac9:
	.long	634
	.long	1
	.long	455
	.long	0
Lnamespac7:
	.long	301
	.long	1
	.long	93
	.long	0
Lnamespac13:
	.long	841
	.long	1
	.long	527
	.long	0
Lnamespac1:
	.long	174
	.long	1
	.long	47
	.long	0
Lnamespac10:
	.long	638
	.long	1
	.long	460
	.long	0
Lnamespac6:
	.long	294
	.long	1
	.long	88
	.long	0
Lnamespac5:
	.long	289
	.long	1
	.long	83
	.long	0
Lnamespac0:
	.long	169
	.long	1
	.long	42
	.long	0
Lnamespac11:
	.long	647
	.long	1
	.long	465
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
