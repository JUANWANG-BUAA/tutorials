.section .text.entry,"ax"
.global kernel_start
.type kernel_start,@function
kernel_start:
 cld
 movq $_sbss, %rdi
 movq $_ebss, %rcx
 subq %rdi, %rcx
 xorl %eax, %eax
 rep stosb
 call kernel_main
1: cli
 hlt
 jmp 1b
.section .note.GNU-stack,"",@progbits
