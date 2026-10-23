ENTRY(Reset_Handler)
MEMORY { FLASH(rx): ORIGIN = APP_BASE, LENGTH = 896
         RAM(rwx): ORIGIN = 0x20008000, LENGTH = 24K }
SECTIONS {
 .vectors : { KEEP(*(.vectors)) } > FLASH
 .text : { *(.text*) *(.rodata*) } > FLASH
 .data : { _sdata = .; *(.data*) _edata = .; } > RAM AT> FLASH
 _sidata = LOADADDR(.data);
 .bss (NOLOAD) : { . = ALIGN(8); _sbss = .; *(.bss*) *(COMMON) _ebss = .; } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) }
 ASSERT(LOADADDR(.data) + SIZEOF(.data) <= APP_BASE + 896, "app image exceeds model payload")
 ASSERT(_ebss + 2048 < _estack, "app stack collision")
}
