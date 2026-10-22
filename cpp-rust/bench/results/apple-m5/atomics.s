	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_add_relaxed
	.p2align	2
_add_relaxed:
	.cfi_startproc
	ldadd	x1, x8, [x0]
	ret
	.cfi_endproc

	.globl	_add_return_old
	.p2align	2
_add_return_old:
	.cfi_startproc
	ldadd	x1, x0, [x0]
	ret
	.cfi_endproc

	.globl	_add_seqcst
	.p2align	2
_add_seqcst:
	.cfi_startproc
	ldaddal	x1, x8, [x0]
	ret
	.cfi_endproc

	.globl	_load_acquire
	.p2align	2
_load_acquire:
	.cfi_startproc
	ldapr	x0, [x0]
	ret
	.cfi_endproc

	.globl	_load_relaxed
	.p2align	2
_load_relaxed:
	.cfi_startproc
	ldr	x0, [x0]
	ret
	.cfi_endproc

	.globl	_load_seqcst
	.p2align	2
_load_seqcst:
	.cfi_startproc
	ldar	x0, [x0]
	ret
	.cfi_endproc

	.globl	_store_relaxed
	.p2align	2
_store_relaxed:
	.cfi_startproc
	str	x1, [x0]
	ret
	.cfi_endproc

	.globl	_store_release
	.p2align	2
_store_release:
	.cfi_startproc
	stlr	x1, [x0]
	ret
	.cfi_endproc

	.globl	_store_seqcst
	.p2align	2
_store_seqcst:
	.cfi_startproc
	stlr	x1, [x0]
	ret
	.cfi_endproc

.subsections_via_symbols
