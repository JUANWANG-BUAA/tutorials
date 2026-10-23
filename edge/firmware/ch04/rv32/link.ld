ENTRY(_start)
MEMORY { RAM(rwx): ORIGIN = 0x80000000, LENGTH = 128K }
SECTIONS {
 .text : { *(.init) *(.text*) *(.rodata*) } > RAM
 .data : { *(.sdata*) *(.data*) } > RAM
 .bss (NOLOAD) : { . = ALIGN(16); _sbss = .; *(.sbss*) *(.bss*) *(COMMON) _ebss = .; } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 PROVIDE(__global_pointer$ = ADDR(.data) + 0x800);
 ASSERT(_ebss < _estack - 4096, "stack overlap")
}
