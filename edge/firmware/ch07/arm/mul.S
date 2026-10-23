.syntax unified
.cpu cortex-m3
.thumb
.text
.global dsp_mul_wide
.type dsp_mul_wide,%function
.thumb_func
dsp_mul_wide:
 smull r2, r3, r0, r1
 mov r0, r2
 mov r1, r3
 bx lr
.size dsp_mul_wide, .-dsp_mul_wide
