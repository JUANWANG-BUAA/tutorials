/* Multiboot loader enters 32-bit protected mode; this is NOT BIOS reset code. */
.section .multiboot,"a"
.balign 4
.long 0x1badb002, 0, -0x1badb002
.text
.code32
.global start32
start32:
 cli
 cld
 movl $0x80000, %esp
 /* Clear PML4, PDPT and PD at fixed, identity-mapped low physical RAM. */
 movl $0x90000, %edi
 xorl %eax, %eax
 movl $3072, %ecx
 rep stosl
 movl $0x91003, 0x90000
 movl $0x92003, 0x91000
 movl $0x92000, %edi
 movl $0x83, %eax
 movl $512, %ecx
1: movl %eax, (%edi)
 addl $0x200000, %eax
 addl $8, %edi
 loop 1b
 lgdt gdt_pointer
 movl %cr4, %eax
 orl $(1 << 5), %eax
 movl %eax, %cr4
 movl $0x90000, %eax
 movl %eax, %cr3
 movl $0xc0000080, %ecx
 rdmsr
 orl $(1 << 8), %eax
 wrmsr
 movl %cr0, %eax
 orl $0x80000001, %eax
 movl %eax, %cr0
 ljmpl $0x08, $long_entry
.code64
long_entry:
 movw $0x10, %ax
 movw %ax, %ds
 movw %ax, %es
 movw %ax, %ss
 movq $0x80000, %rsp
 xorq %rbp, %rbp
 movq $0x200000, %rax
 jmp *%rax
.section .rodata
.balign 8
gdt:
 .quad 0, 0x00af9a000000ffff, 0x00cf92000000ffff
gdt_end:
gdt_pointer:
 .word gdt_end - gdt - 1
 .long gdt
.section .payload,"a"
.incbin ".build/ch06/can64.bin"
.section .note.GNU-stack,"",@progbits
