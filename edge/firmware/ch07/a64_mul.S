.text
.global dsp_mul_wide
.type dsp_mul_wide,%function
dsp_mul_wide:
 smull x0, w0, w1
 ret
.size dsp_mul_wide, .-dsp_mul_wide
