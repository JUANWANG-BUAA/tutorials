	.file	"atomics.160c9ef2bcbf9454-cgu.0"
	.section	.text.add_relaxed,"ax",@progbits
	.globl	add_relaxed
	.p2align	2
	.type	add_relaxed,@function
add_relaxed:
	.cfi_startproc
.LBB0_1:
	ldxr	x8, [x0]
	add	x8, x8, x1
	stxr	w9, x8, [x0]
	cbnz	w9, .LBB0_1
	ret
.Lfunc_end0:
	.size	add_relaxed, .Lfunc_end0-add_relaxed
	.cfi_endproc

	.section	.text.add_return_old,"ax",@progbits
	.globl	add_return_old
	.p2align	2
	.type	add_return_old,@function
add_return_old:
	.cfi_startproc
	mov	x8, x0
.LBB1_1:
	ldxr	x0, [x8]
	add	x9, x0, x1
	stxr	w10, x9, [x8]
	cbnz	w10, .LBB1_1
	ret
.Lfunc_end1:
	.size	add_return_old, .Lfunc_end1-add_return_old
	.cfi_endproc

	.section	.text.add_seqcst,"ax",@progbits
	.globl	add_seqcst
	.p2align	2
	.type	add_seqcst,@function
add_seqcst:
	.cfi_startproc
.LBB2_1:
	ldaxr	x8, [x0]
	add	x8, x8, x1
	stlxr	w9, x8, [x0]
	cbnz	w9, .LBB2_1
	ret
.Lfunc_end2:
	.size	add_seqcst, .Lfunc_end2-add_seqcst
	.cfi_endproc

	.section	.text.load_acquire,"ax",@progbits
	.globl	load_acquire
	.p2align	2
	.type	load_acquire,@function
load_acquire:
	.cfi_startproc
	ldar	x0, [x0]
	ret
.Lfunc_end3:
	.size	load_acquire, .Lfunc_end3-load_acquire
	.cfi_endproc

	.section	.text.load_relaxed,"ax",@progbits
	.globl	load_relaxed
	.p2align	2
	.type	load_relaxed,@function
load_relaxed:
	.cfi_startproc
	ldr	x0, [x0]
	ret
.Lfunc_end4:
	.size	load_relaxed, .Lfunc_end4-load_relaxed
	.cfi_endproc

	.section	.text.load_seqcst,"ax",@progbits
	.globl	load_seqcst
	.p2align	2
	.type	load_seqcst,@function
load_seqcst:
	.cfi_startproc
	ldar	x0, [x0]
	ret
.Lfunc_end5:
	.size	load_seqcst, .Lfunc_end5-load_seqcst
	.cfi_endproc

	.section	.text.store_relaxed,"ax",@progbits
	.globl	store_relaxed
	.p2align	2
	.type	store_relaxed,@function
store_relaxed:
	.cfi_startproc
	str	x1, [x0]
	ret
.Lfunc_end6:
	.size	store_relaxed, .Lfunc_end6-store_relaxed
	.cfi_endproc

	.section	.text.store_release,"ax",@progbits
	.globl	store_release
	.p2align	2
	.type	store_release,@function
store_release:
	.cfi_startproc
	stlr	x1, [x0]
	ret
.Lfunc_end7:
	.size	store_release, .Lfunc_end7-store_release
	.cfi_endproc

	.section	.text.store_seqcst,"ax",@progbits
	.globl	store_seqcst
	.p2align	2
	.type	store_seqcst,@function
store_seqcst:
	.cfi_startproc
	stlr	x1, [x0]
	ret
.Lfunc_end8:
	.size	store_seqcst, .Lfunc_end8-store_seqcst
	.cfi_endproc

	.ident	"rustc version 1.99.0 (b940084d7 2026-09-28)"
	.section	".note.GNU-stack","",@progbits
