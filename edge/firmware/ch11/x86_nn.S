.text
.global int8_dot_product_4_x86
.type int8_dot_product_4_x86,@function
/* int32_t int8_dot_product_4_x86(uint32_t a_packed, uint32_t b_packed);
   edi = 4 packed signed bytes a, esi = 4 packed signed bytes b */
int8_dot_product_4_x86:
    /* byte 0 */
    movsbl  %dil, %eax
    movsbl  %sil, %edx
    imull   %edx, %eax

    /* byte 1 */
    shrl    $8, %edi
    shrl    $8, %esi
    movsbl  %dil, %ecx
    movsbl  %sil, %edx
    imull   %edx, %ecx
    addl    %ecx, %eax

    /* byte 2 */
    shrl    $8, %edi
    shrl    $8, %esi
    movsbl  %dil, %ecx
    movsbl  %sil, %edx
    imull   %edx, %ecx
    addl    %ecx, %eax

    /* byte 3 */
    shrl    $8, %edi
    shrl    $8, %esi
    movsbl  %dil, %ecx
    movsbl  %sil, %edx
    imull   %edx, %ecx
    addl    %ecx, %eax

    ret
.size int8_dot_product_4_x86, .-int8_dot_product_4_x86
.section .note.GNU-stack,"",@progbits
