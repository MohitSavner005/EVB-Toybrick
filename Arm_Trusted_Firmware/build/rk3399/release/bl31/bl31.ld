OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(bl31_entrypoint)
MEMORY {
    RAM (rwx): ORIGIN = ((0x0) + 0x40000), LENGTH = ((0x0) + (0x100000)) - ((0x0) + 0x40000)
}
MEMORY {
    SRAM (rwx): ORIGIN = (0xF8000000 + 0x078C0000), LENGTH = ((192) * 1024)
    PMUSRAM (rwx): ORIGIN = (0xF8000000 + 0x073B0000), LENGTH = ((8) * 1024)
}
SECTIONS
{
 . = (0xF8000000 + 0x078C0000);
 ASSERT(. == ALIGN(((1) << (12))),
  "SRAM_BASE address is not aligned on a page boundary.")
 .incbin_sram : ALIGN(((1) << (12))) {
  __sram_incbin_start = .;
  *(.sram.incbin)
   __sram_incbin_real_end = .;
  . = ALIGN(((1) << (12)));
  __sram_incbin_end = .;
 } >SRAM
 ASSERT((__sram_incbin_real_end - __sram_incbin_start) <=
  (4 * 1024), ".incbin_sram has exceeded its limit")
 .text_sram : ALIGN(((1) << (12))) {
  __bl31_sram_text_start = .;
  *(.sram.text)
  *(.sram.rodata)
  __bl31_sram_text_real_end = .;
  . = ALIGN(((1) << (12)));
  __bl31_sram_text_end = .;
 } >SRAM
 ASSERT((__bl31_sram_text_real_end - __bl31_sram_text_start) <=
  (4 * 1024), ".text_sram has exceeded its limit")
 .data_sram : ALIGN(((1) << (12))) {
  __bl31_sram_data_start = .;
  *(.sram.data)
  __bl31_sram_data_real_end = .;
  . = ALIGN(((1) << (12)));
  __bl31_sram_data_end = .;
 } >SRAM
 ASSERT((__bl31_sram_data_real_end - __bl31_sram_data_start) <=
  (4 * 1024), ".data_sram has exceeded its limit")
 .stack_sram : ALIGN(((1) << (12))) {
  __bl31_sram_stack_start = .;
  . += ((1) << (12));
  __bl31_sram_stack_end = .;
 } >SRAM
 . = (0xF8000000 + 0x073B0000);
 .pmusram : {
  ASSERT(. == ALIGN(64 * 1024),
   ".pmusram.entry request 64K aligned.");
  *(.pmusram.entry)
  __bl31_pmusram_text_start = .;
  *(.pmusram.text)
  *(.pmusram.rodata)
  __bl31_pmusram_text_end = .;
  . = ALIGN(4096);
  __pmusram_incbin_start = .;
  *(.pmusram.incbin)
  __pmusram_incbin_end = .;
  __bl31_pmusram_data_start = .;
  *(.pmusram.data)
  __bl31_pmusram_data_end = .;
 } >PMUSRAM
}
SECTIONS
{
    . = ((0x0) + 0x40000);
    ASSERT(. == ALIGN(((1) << (12))),
           "BL31_BASE address is not aligned on a page boundary.")
    __BL31_START__ = .;
    ro . : {
        __RO_START__ = .;
        *bl31_entrypoint.o(.text*)
        *(SORT_BY_ALIGNMENT(.text*))
        *(SORT_BY_ALIGNMENT(.rodata*))
 . = ALIGN(8); __RT_SVC_DESCS_START__ = .; KEEP(*(rt_svc_descs)) __RT_SVC_DESCS_END__ = .; . = ALIGN(8); __FCONF_POPULATOR_START__ = .; KEEP(*(.fconf_populator)) __FCONF_POPULATOR_END__ = .; . = ALIGN(8); __PMF_SVC_DESCS_START__ = .; KEEP(*(pmf_svc_descs)) __PMF_SVC_DESCS_END__ = .; . = ALIGN(8); __PARSER_LIB_DESCS_START__ = .; KEEP(*(.img_parser_lib_descs)) __PARSER_LIB_DESCS_END__ = .; . = ALIGN(8); __CPU_OPS_START__ = .; KEEP(*(cpu_ops)) __CPU_OPS_END__ = .; . = ALIGN(8); __GOT_START__ = .; *(.got) __GOT_END__ = .;
        . = ALIGN(8);
__pubsub_psci_cpu_on_finish_start = .; KEEP(*(__pubsub_psci_cpu_on_finish)); __pubsub_psci_cpu_on_finish_end = .;
__pubsub_psci_suspend_pwrdown_start_start = .; KEEP(*(__pubsub_psci_suspend_pwrdown_start)); __pubsub_psci_suspend_pwrdown_start_end = .;
__pubsub_psci_suspend_pwrdown_finish_start = .; KEEP(*(__pubsub_psci_suspend_pwrdown_finish)); __pubsub_psci_suspend_pwrdown_finish_end = .;
__pubsub_cm_entering_secure_world_start = .; KEEP(*(__pubsub_cm_entering_secure_world)); __pubsub_cm_entering_secure_world_end = .;
__pubsub_cm_exited_secure_world_start = .; KEEP(*(__pubsub_cm_exited_secure_world)); __pubsub_cm_exited_secure_world_end = .;
__pubsub_cm_entering_normal_world_start = .; KEEP(*(__pubsub_cm_entering_normal_world)); __pubsub_cm_entering_normal_world_end = .;
__pubsub_cm_exited_normal_world_start = .; KEEP(*(__pubsub_cm_exited_normal_world)); __pubsub_cm_exited_normal_world_end = .;
        *(.vectors)
        __RO_END_UNALIGNED__ = .;
        . = ALIGN(((1) << (12)));
        __RO_END__ = .;
    } >RAM
    ASSERT(__CPU_OPS_END__ > __CPU_OPS_START__,
           "cpu_ops not defined for this platform.")
    __RW_START__ = . ;
    .data . : ALIGN(1) { __DATA_START__ = .; *(SORT_BY_ALIGNMENT(.data*)) __DATA_END__ = .; } >RAM
    .rela.dyn : ALIGN(8) { __RELA_START__ = .; *(.rela*) __RELA_END__ = .; } >RAM
    stacks (NOLOAD) : { __STACKS_START__ = .; *(tzfw_normal_stacks) __STACKS_END__ = .; } >RAM
    .bss (NOLOAD) : ALIGN(16) { __BSS_START__ = .; *(SORT_BY_ALIGNMENT(.bss*)) *(COMMON) . = ALIGN((1 << 6)); __PMF_TIMESTAMP_START__ = .; KEEP(*(pmf_timestamp_array)) . = ALIGN((1 << 6)); __PMF_PERCPU_TIMESTAMP_END__ = .; __PERCPU_TIMESTAMP_SIZE__ = ABSOLUTE(. - __PMF_TIMESTAMP_START__); . = . + (__PERCPU_TIMESTAMP_SIZE__ * (((2) + (4)) - 1)); __PMF_TIMESTAMP_END__ = .; . = ALIGN(16); *(base_xlat_table) __BSS_END__ = .; } >RAM
    xlat_table (NOLOAD) : { *(xlat_table) } >RAM
    coherent_ram (NOLOAD) : ALIGN(((1) << (12))) {
        __COHERENT_RAM_START__ = .;
        *(bakery_lock)
        *(tzfw_coherent_mem)
        __COHERENT_RAM_END_UNALIGNED__ = .;
        . = ALIGN(((1) << (12)));
        __COHERENT_RAM_END__ = .;
    } >RAM
    __RW_END__ = .;
    __BL31_END__ = .;
    /DISCARD/ : {
        *(.dynsym .dynstr .hash .gnu.hash)
    }
    ASSERT(. <= ((0x0) + (0x100000)), "BL31 image has exceeded its limit.")
}
