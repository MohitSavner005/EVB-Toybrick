OUTPUT_FORMAT("elf32-littlearm")
SECTIONS {
 .m0_bin 0 : {
  KEEP(*(.isr_vector))
  ASSERT(. == 0xc0, "ISR vector has the wrong size.");
  ASSERT(. == 0xc0, "M0 params should go right behind ISR table.");
  . += 0x28;
  *(.text*)
  *(.rodata*)
  *(.data*)
  *(.bss*)
  . = ALIGN(8);
  *(.co_stack*)
 }
 /DISCARD/ : { *(.comment) *(.note*) }
}
