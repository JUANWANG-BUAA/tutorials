.text
.global daq_stream_copy_a64
.type daq_stream_copy_a64,%function
/* void daq_stream_copy_a64(void *dst, const void *src, size_t num_pairs);
   x0 = dst, x1 = src, x2 = num_pairs (each pair is 16 bytes) */
daq_stream_copy_a64:
    cbz     x2, .L_done
.L_loop:
    ldp     x3, x4, [x1], #16
    stp     x3, x4, [x0], #16
    subs    x2, x2, #1
    b.ne    .L_loop
    dsb     st              /* Data Synchronization Barrier for store transactions */
.L_done:
    ret
.size daq_stream_copy_a64, .-daq_stream_copy_a64
