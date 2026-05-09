section .text 
global _start 
extern kmain 
_start: 
  mov esp, 0x90000 
  call kmain 
.halt: 
  hlt 
  jmp .halt 
