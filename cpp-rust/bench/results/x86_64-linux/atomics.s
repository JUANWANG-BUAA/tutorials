	.att_syntax
	.file	"atomics.160c9ef2bcbf9454-cgu.0"
	.section	.text.add_relaxed,"ax",@progbits
	.globl	add_relaxed
	.prefalign	4, .Lfunc_end0, nop
	.type	add_relaxed,@function
add_relaxed:
	.cfi_startproc
	lock		addq	%rsi, (%rdi)
	retq
.Lfunc_end0:
	.size	add_relaxed, .Lfunc_end0-add_relaxed
	.cfi_endproc

	.section	.text.add_return_old,"ax",@progbits
	.globl	add_return_old
	.prefalign	4, .Lfunc_end1, nop
	.type	add_return_old,@function
add_return_old:
	.cfi_startproc
	movq	%rsi, %rax
	lock		xaddq	%rax, (%rdi)
	retq
.Lfunc_end1:
	.size	add_return_old, .Lfunc_end1-add_return_old
	.cfi_endproc

	.section	.text.add_seqcst,"ax",@progbits
	.globl	add_seqcst
	.prefalign	4, .Lfunc_end2, nop
	.type	add_seqcst,@function
add_seqcst:
	.cfi_startproc
	lock		addq	%rsi, (%rdi)
	retq
.Lfunc_end2:
	.size	add_seqcst, .Lfunc_end2-add_seqcst
	.cfi_endproc

	.section	.text.load_acquire,"ax",@progbits
	.globl	load_acquire
	.prefalign	4, .Lfunc_end3, nop
	.type	load_acquire,@function
load_acquire:
	.cfi_startproc
	movq	(%rdi), %rax
	retq
.Lfunc_end3:
	.size	load_acquire, .Lfunc_end3-load_acquire
	.cfi_endproc

	.section	.text.load_relaxed,"ax",@progbits
	.globl	load_relaxed
	.prefalign	4, .Lfunc_end4, nop
	.type	load_relaxed,@function
load_relaxed:
	.cfi_startproc
	movq	(%rdi), %rax
	retq
.Lfunc_end4:
	.size	load_relaxed, .Lfunc_end4-load_relaxed
	.cfi_endproc

	.section	.text.load_seqcst,"ax",@progbits
	.globl	load_seqcst
	.prefalign	4, .Lfunc_end5, nop
	.type	load_seqcst,@function
load_seqcst:
	.cfi_startproc
	movq	(%rdi), %rax
	retq
.Lfunc_end5:
	.size	load_seqcst, .Lfunc_end5-load_seqcst
	.cfi_endproc

	.section	.text.store_relaxed,"ax",@progbits
	.globl	store_relaxed
	.prefalign	4, .Lfunc_end6, nop
	.type	store_relaxed,@function
store_relaxed:
	.cfi_startproc
	movq	%rsi, (%rdi)
	retq
.Lfunc_end6:
	.size	store_relaxed, .Lfunc_end6-store_relaxed
	.cfi_endproc

	.section	.text.store_release,"ax",@progbits
	.globl	store_release
	.prefalign	4, .Lfunc_end7, nop
	.type	store_release,@function
store_release:
	.cfi_startproc
	movq	%rsi, (%rdi)
	retq
.Lfunc_end7:
	.size	store_release, .Lfunc_end7-store_release
	.cfi_endproc

	.section	.text.store_seqcst,"ax",@progbits
	.globl	store_seqcst
	.prefalign	4, .Lfunc_end8, nop
	.type	store_seqcst,@function
store_seqcst:
	.cfi_startproc
	xchgq	%rsi, (%rdi)
	retq
.Lfunc_end8:
	.size	store_seqcst, .Lfunc_end8-store_seqcst
	.cfi_endproc

	.ident	"rustc version 1.99.0 (b940084d7 2026-09-28)"
	.section	".note.GNU-stack","",@progbits
