ENTRY(_start)
MEMORY {
 RAM(rwx) : ORIGIN = 0x80000000, LENGTH = 128K
}
SECTIONS {
 .text : { *(.init) *(.text*) *(.rodata*) } > RAM
 .data : {
  _sdata = .;
  *(.sdata*)
  *(.data*)
  _edata = .;
 } > RAM
 .bss (NOLOAD) : {
  _sbss = .;
  *(.sbss*)
  *(.bss*)
  *(COMMON)
  _ebss = .;
 } > RAM
 _estack = ORIGIN(RAM) + LENGTH(RAM);
 PROVIDE(__global_pointer$ = ADDR(.data) + 0x800);
 ASSERT(_edata - _sdata == 27, ".data must have exact odd length 27 for tail test")
 ASSERT(_ebss - _sbss == 31, ".bss must have exact odd length 31 for tail test")
 ASSERT(_ebss < _estack - 2048, "stack overflow")
}
