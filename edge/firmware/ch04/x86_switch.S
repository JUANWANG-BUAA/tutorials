/* SysV AMD64 cooperative call boundary only; NOT an interrupt gate. */
.text
.global x86_switch
.type x86_switch,@function
x86_switch:
 pushq %rbp
 pushq %rbx
 pushq %r12
 pushq %r13
 pushq %r14
 pushq %r15
 movq %rsp, (%rdi)
 movq %rsi, %rsp
 popq %r15
 popq %r14
 popq %r13
 popq %r12
 popq %rbx
 popq %rbp
 ret
.size x86_switch, .-x86_switch
.section .note.GNU-stack,"",@progbits
