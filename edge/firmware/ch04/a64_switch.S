/* AAPCS64 cooperative INTEGER-ONLY context, 112 bytes. */
.text
.global a64_switch
.type a64_switch,%function
a64_switch:
 sub sp, sp, #112
 stp x19, x20, [sp, #0]
 stp x21, x22, [sp, #16]
 stp x23, x24, [sp, #32]
 stp x25, x26, [sp, #48]
 stp x27, x28, [sp, #64]
 stp x29, x30, [sp, #80]
 mov x9, sp
 str x9, [x0]
 mov sp, x1
 ldp x19, x20, [sp, #0]
 ldp x21, x22, [sp, #16]
 ldp x23, x24, [sp, #32]
 ldp x25, x26, [sp, #48]
 ldp x27, x28, [sp, #64]
 ldp x29, x30, [sp, #80]
 add sp, sp, #112
 ret
.size a64_switch, .-a64_switch
