ENTRY(start32)
SECTIONS {
 . = 0x100000;
 .multiboot : { KEEP(*(.multiboot)) }
 .text : { *(.text*) }
 .rodata : { *(.rodata*) }
 . = 0x200000;
 .payload : { *(.payload) }
 /DISCARD/ : { *(.eh_frame*) *(.comment*) }
}
