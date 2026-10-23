.text
.global dsp_mul_wide
.type dsp_mul_wide,@function
dsp_mul_wide:
 movslq %edi, %rax
 movslq %esi, %rsi
 imulq %rsi, %rax
 ret
.size dsp_mul_wide, .-dsp_mul_wide
.section .note.GNU-stack,"",@progbits
