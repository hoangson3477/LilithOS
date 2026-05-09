section .multiboot 
align 8 
multiboot_header: 
    dd 0x1BADB002 
    dd 0x00 
    dd -0x1BADB002 
section .text 
global _start 
extern kmain 
_start: 
    mov esp, 0x90000 
    call kmain 
.halt: hlt 
    jmp .halt 
