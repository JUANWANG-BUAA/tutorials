ENTRY(_start)
MEMORY { RAM(rwx): ORIGIN = 0x80000000, LENGTH = 128K }
SECTIONS {
 .text : { KEEP(*(.init)) *(.text*) *(.rodata*) } > RAM
 .data : { _sdata = .; *(.sdata*) *(.data*) _edata = .; } > RAM
 .bss (NOLOAD) : { . = ALIGN(16); _sbss = .; *(.sbss*) *(.bss*) *(COMMON) _ebss = .; } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 PROVIDE(__global_pointer$ = ADDR(.data) + 0x800);
 ASSERT(_ebss + 16384 < _estack, "boot stack collision")
}
