ENTRY(kernel_start)
SECTIONS {
 . = 0x200000;
 .text : { KEEP(*(.text.entry)) *(.text*) }
 .rodata : { *(.rodata*) }
 .data : { *(.data*) }
 .bss (NOLOAD) : { _sbss = .; *(.bss*) *(COMMON) _ebss = .; }
 /DISCARD/ : { *(.eh_frame*) *(.comment*) }
 ASSERT(_ebss < 0x280000, "kernel image too large")
}
