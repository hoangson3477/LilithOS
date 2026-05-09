/* LilithOS Linker Script */
ENTRY(_start)

SECTIONS
{
    . = 1M;  /* Load at 1MB */
    
    .text :
    {
        *(.text)
        *(.rodata*)
    }
    
    .data :
    {
        *(.data)
    }
    
    .bss :
    {
        __bss_start = .;
        *(.bss)
        *(COMMON)
        __bss_end = .;
    }
    
    /DISCARD/ :
    {
        *(.comment)
        *(.eh_frame)
    }
}
