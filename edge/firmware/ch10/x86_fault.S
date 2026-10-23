.text
.global decode_page_fault_x86
.type decode_page_fault_x86,@function
/* uint64_t decode_page_fault_x86(void);
   Returns CR2 register containing faulting linear address */
decode_page_fault_x86:
    movq    %cr2, %rax
    ret
.size decode_page_fault_x86, .-decode_page_fault_x86
.section .note.GNU-stack,"",@progbits
