.text
.global daq_stream_copy_x86
.type daq_stream_copy_x86,@function
/* void daq_stream_copy_x86(void *dst, const void *src, size_t num_quads);
   rdi = dst (assumed 64-bit aligned), rsi = src, rdx = num_quads */
daq_stream_copy_x86:
    testq   %rdx, %rdx
    jz      .L_done
.L_loop:
    movq    (%rsi), %rax
    movnti  %rax, (%rdi)    /* Non-temporal streaming store: bypass cache */
    addq    $8, %rsi
    addq    $8, %rdi
    decq    %rdx
    jnz     .L_loop
    sfence                  /* Store fence: guarantee streaming stores committed */
.L_done:
    ret
.size daq_stream_copy_x86, .-daq_stream_copy_x86
.section .note.GNU-stack,"",@progbits
