ENTRY(Reset_Handler)
MEMORY {
 FLASH(rx): ORIGIN = 0x00000000, LENGTH = 256K
 RAM(rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}
SECTIONS {
 .vectors : { KEEP(*(.vectors)) } > FLASH
 .text : { *(.text*) *(.rodata*) } > FLASH
 .data : {
  _sdata = .;
  *(.data*)
  _edata = .;
 } > RAM AT> FLASH
 _sidata = LOADADDR(.data);
 .bss (NOLOAD) : {
  _sbss = .;
  *(.bss*)
  *(COMMON)
  _ebss = .;
 } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 ASSERT(_edata - _sdata == 27, ".data must have exact odd length 27 for tail test")
 ASSERT(_ebss - _sbss == 31, ".bss must have exact odd length 31 for tail test")
 ASSERT(_ebss < _estack - 1024, "RAM overflow")
}
