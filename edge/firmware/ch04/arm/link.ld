ENTRY(Reset_Handler)
MEMORY { FLASH(rx): ORIGIN = 0, LENGTH = 256K
         RAM(rwx): ORIGIN = 0x20000000, LENGTH = 64K }
SECTIONS {
 .vectors : { KEEP(*(.vectors)) } > FLASH
 .text : { *(.text*) *(.rodata*) } > FLASH
 .data : { _sdata = .; *(.data*) _edata = .; } > RAM AT> FLASH
 _sidata = LOADADDR(.data);
 .bss (NOLOAD) : { . = ALIGN(8); _sbss = .; *(.bss*) *(COMMON) . = ALIGN(8); _ebss = .; } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 ASSERT(_ebss < _estack - 2048, "RAM overflow into handler stack")
}
