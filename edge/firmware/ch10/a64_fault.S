.text
.global read_esr_el1_a64
.type read_esr_el1_a64,%function
read_esr_el1_a64:
    mrs     x0, esr_el1
    ret
.size read_esr_el1_a64, .-read_esr_el1_a64

.global read_far_el1_a64
.type read_far_el1_a64,%function
read_far_el1_a64:
    mrs     x0, far_el1
    ret
.size read_far_el1_a64, .-read_far_el1_a64
