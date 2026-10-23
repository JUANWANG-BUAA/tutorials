.text
.global int8_dot_product_neon_a64
.type int8_dot_product_neon_a64,%function
/* int32_t int8_dot_product_neon_a64(const int8_t *a, const int8_t *b);
   x0 = pointer to 8 int8 elements, x1 = pointer to 8 int8 elements */
int8_dot_product_neon_a64:
    ldr     d0, [x0]        /* load 8 signed bytes into v0.8b */
    ldr     d1, [x1]        /* load 8 signed bytes into v1.8b */
    smull   v2.8h, v0.8b, v1.8b /* pairwise 8x8 -> 16-bit multiply */
    saddlv  s3, v2.8h       /* sum across 16-bit vector into 32-bit scalar */
    fmov    w0, s3          /* move to return register w0 */
    ret
.size int8_dot_product_neon_a64, .-int8_dot_product_neon_a64
