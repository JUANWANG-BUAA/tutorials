ENTRY(_start)
MEMORY { CODE(rx): ORIGIN = APP_BASE, LENGTH = 896
         RAM(rwx): ORIGIN = 0x80400000, LENGTH = 64K }
SECTIONS {
 .text : { KEEP(*(.init)) *(.text*) *(.rodata*) } > CODE
 .data : { _sdata = .; *(.sdata*) *(.data*) _edata = .; } > RAM AT> CODE
 _sidata = LOADADDR(.data);
 .bss (NOLOAD) : { . = ALIGN(16); _sbss = .; *(.sbss*) *(.bss*) *(COMMON) _ebss = .; } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 PROVIDE(__global_pointer$ = ADDR(.data) + 0x800);
 ASSERT(app_trap == APP_BASE + 256, "trap contract mismatch")
 ASSERT(LOADADDR(.data) + SIZEOF(.data) <= APP_BASE + 896, "app image exceeds model payload")
 ASSERT(_ebss + 2048 < _estack, "app stack collision")
}
