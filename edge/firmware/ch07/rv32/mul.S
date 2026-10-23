.text
.align 2
.global dsp_mul_wide
.type dsp_mul_wide,@function
dsp_mul_wide:
 mulh t0, a0, a1
 mul a0, a0, a1
 mv a1, t0
 ret
.size dsp_mul_wide, .-dsp_mul_wide
