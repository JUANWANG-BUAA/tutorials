__RNvMs_NtCseHZXeO4ot7L_6tidekv7segmentNtB4_7Segment12get_no_bloom:
Lfunc_begin229:
	.loc	138 219 0
	.cfi_startproc
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x28, x27, [sp, #64]
	stp	x26, x25, [sp, #80]
	stp	x24, x23, [sp, #96]
	stp	x22, x21, [sp, #112]
	stp	x20, x19, [sp, #128]
	stp	x29, x30, [sp, #144]
	add	x29, sp, #144
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
	mov	x25, x8
Ltmp13668:
	.loc	138 227 22 prologue_end
	ldr	x19, [x0, #32]
Ltmp13669:
	.loc	138 228 15
	cbz	x19, LBB229_10
	.loc	138 0 15 is_stmt 0
	mov	x20, x2
	mov	x21, x1
	str	x25, [sp, #8]
	mov	x27, #0
	ldr	x25, [x0, #120]
	ldp	x23, x22, [x0, #64]
	b	LBB229_3
LBB229_2:
	mov	x19, x26
	.loc	138 228 15 is_stmt 1
	cmp	x27, x26
	b.hs	LBB229_9
LBB229_3:
	.loc	138 229 28
	sub	x8, x19, x27
	.loc	138 229 23 is_stmt 0
	add	x26, x27, x8, lsr #1
Ltmp13670:
	.loc	138 204 17 is_stmt 1
	mov	w8, #12
	madd	x0, x26, x8, x25
Ltmp13671:
	.loc	138 205 52
	add	x1, x0, #4
Ltmp13672:
	.loc	17 1092 16
	cmn	x0, #5
	ccmp	x1, x22, #2, ls
	b.hi	LBB229_13
Ltmp13673:
	.loc	138 206 55
	add	x8, x0, #12
Ltmp13674:
	.loc	17 1092 16
	cmp	x8, x1
	ccmp	x8, x22, #2, hs
	b.hi	LBB229_14
Ltmp13675:
	.loc	34 1722 17
	ldr	w8, [x23, x0]
Ltmp13676:
	.loc	34 1722 17 is_stmt 0
	ldr	x24, [x23, x1]
Ltmp13677:
	.loc	138 231 40 is_stmt 1
	add	x9, x24, #17
	stp	x9, x8, [sp, #16]
Ltmp13678:
	.loc	138 308 19
	add	x10, x9, x8
Ltmp13679:
	.loc	138 310 13
	cmp	x10, x22
	b.hi	LBB229_15
Ltmp13680:
	.loc	54 331 22
	subs	x28, x8, x20
	csel	x2, x8, x20, lo
Ltmp13681:
	.loc	10 871 18
	add	x0, x23, x9
Ltmp13682:
	.loc	54 339 34
	mov	x1, x21
	bl	_memcmp
	sxtw	x8, w0
Ltmp13683:
	.loc	54 340 12
	cmp	w0, #0
	csel	x8, x28, x8, eq
Ltmp13684:
	.loc	18 2239 21
	cmp	x8, #0
	cset	w8, gt
	csinv	w8, w8, wzr, pl
	and	w8, w8, #0xff
Ltmp13685:
	.loc	138 232 13
	cmp	w8, #1
	b.eq	LBB229_2
	cmp	w8, #255
	b.ne	LBB229_11
	.loc	138 233 45
	add	x27, x26, #1
	mov	x26, x19
	b	LBB229_2
Ltmp13686:
LBB229_9:
	.loc	138 0 45 is_stmt 0
	mov	x8, #0
	ldr	x25, [sp, #8]
	.loc	138 228 15 is_stmt 1
	b	LBB229_12
LBB229_10:
	.loc	138 0 15 is_stmt 0
	mov	x8, #0
	.loc	138 228 15
	b	LBB229_12
Ltmp13687:
LBB229_11:
	.loc	138 0 15
	ldr	x25, [sp, #8]
Ltmp13688:
	.loc	138 221 9 is_stmt 1
	add	x0, x25, #8
	.loc	138 221 19 is_stmt 0
	mov	x1, x23
	mov	x2, x22
	mov	x3, x24
	bl	__RNvMs_NtCseHZXeO4ot7L_6tidekv7segmentNtB4_7Segment7look_at
	mov	w8, #1
Ltmp13689:
LBB229_12:
	.loc	138 0 0
	str	x8, [x25]
	.cfi_def_cfa wsp, 160
	.loc	138 222 6 epilogue_begin is_stmt 1
	ldp	x29, x30, [sp, #144]
	ldp	x20, x19, [sp, #128]
	ldp	x22, x21, [sp, #112]
	ldp	x24, x23, [sp, #96]
	ldp	x26, x25, [sp, #80]
	ldp	x28, x27, [sp, #64]
	add	sp, sp, #160
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
LBB229_13:
	.cfi_restore_state
Ltmp13690:
	.loc	15 413 13
Lloh766:
	adrp	x3, l_alloc_034c2632d57a041d726b1bca58bb32f7@PAGE
Lloh767:
	add	x3, x3, l_alloc_034c2632d57a041d726b1bca58bb32f7@PAGEOFF
	mov	x2, x22
	bl	__RNvNtNtCs3bJEMBXHbwl_4core5slice5index16slice_index_fail
Ltmp13691:
LBB229_14:
	.loc	15 413 13
Lloh768:
	adrp	x3, l_alloc_0db0730a4301df7563b292fd223b19c2@PAGE
Lloh769:
	add	x3, x3, l_alloc_0db0730a4301df7563b292fd223b19c2@PAGEOFF
	mov	x0, x1
	mov	x1, x8
	mov	x2, x22
	bl	__RNvNtNtCs3bJEMBXHbwl_4core5slice5index16slice_index_fail
Ltmp13692:
LBB229_15:
	.loc	138 309 9
Lloh770:
	adrp	x8, __RNvXsi_NtNtNtCs3bJEMBXHbwl_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGE
Lloh771:
	ldr	x8, [x8, __RNvXsi_NtNtNtCs3bJEMBXHbwl_4core3fmt3num3impjNtB9_7Display3fmt@GOTPAGEOFF]
	add	x9, sp, #16
	stp	x9, x8, [sp, #32]
	add	x9, sp, #24
	stp	x9, x8, [sp, #48]
Ltmp13693:
	.loc	138 309 9 is_stmt 0
Lloh772:
	adrp	x0, l_alloc_feed657792439457ab2825b91c8d0a0a@PAGE
Lloh773:
	add	x0, x0, l_alloc_feed657792439457ab2825b91c8d0a0a@PAGEOFF
Lloh774:
	adrp	x2, l_alloc_2745249799c604ca3b185fee2e5fb617@PAGE
Lloh775:
	add	x2, x2, l_alloc_2745249799c604ca3b185fee2e5fb617@PAGEOFF
	add	x1, sp, #32
	bl	__RNvNtCs3bJEMBXHbwl_4core9panicking9panic_fmt
Ltmp13694:
	.loh AdrpAdd	Lloh766, Lloh767
	.loh AdrpAdd	Lloh768, Lloh769
	.loh AdrpAdd	Lloh774, Lloh775
	.loh AdrpAdd	Lloh772, Lloh773
	.loh AdrpLdrGot	Lloh770, Lloh771
Lfunc_end229:
	.cfi_endproc

	.globl	__RNvMs_NtCseHZXeO4ot7L_6tidekv7segmentNtB4_7Segment3get
	.p2align	2
