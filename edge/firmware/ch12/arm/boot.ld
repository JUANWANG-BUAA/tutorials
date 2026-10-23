ENTRY(Reset_Handler)
MEMORY { FLASH(rx): ORIGIN = 0, LENGTH = 64K
         RAM(rwx): ORIGIN = 0x20000000, LENGTH = 32K }
SECTIONS {
 .vectors : { KEEP(*(.vectors)) } > FLASH
 .text : { *(.text*) *(.rodata*) } > FLASH
 .data : { _sdata = .; *(.data*) _edata = .; } > RAM AT> FLASH
 _sidata = LOADADDR(.data);
 .bss (NOLOAD) : { . = ALIGN(8); _sbss = .; *(.bss*) *(COMMON) _ebss = .; } > RAM
 _estack = 0x20008000;
 /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) }
 ASSERT(_ebss + 8192 < _estack, "boot stack collision")
}
