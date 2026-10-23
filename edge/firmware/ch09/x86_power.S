.text
.global enter_cstate_c1_x86
.type enter_cstate_c1_x86,@function
/* void enter_cstate_c1_x86(void);
   Safely enables interrupts and enters C1 Halt state */
enter_cstate_c1_x86:
    sti
    hlt                     /* Processor enters C1 state until next external interrupt */
    ret
.size enter_cstate_c1_x86, .-enter_cstate_c1_x86
.section .note.GNU-stack,"",@progbits
