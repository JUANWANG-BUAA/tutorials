.text
.global enter_sleep_wfi_a64
.type enter_sleep_wfi_a64,%function
enter_sleep_wfi_a64:
    dsb     sy              /* Ensure all memory transactions completed before sleep */
    wfi                     /* Wait For Interrupt */
    isb
    ret
.size enter_sleep_wfi_a64, .-enter_sleep_wfi_a64

.global enter_sleep_wfe_a64
.type enter_sleep_wfe_a64,%function
enter_sleep_wfe_a64:
    dsb     sy
    wfe                     /* Wait For Event */
    isb
    ret
.size enter_sleep_wfe_a64, .-enter_sleep_wfe_a64
