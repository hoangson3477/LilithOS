section .text 
global _start 
extern _kmain 
_start: 
  mov esp, 0x90000 
  call _kmain 
.halt: 
  hlt 
  jmp .halt 
