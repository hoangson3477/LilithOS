#include <stdint.h> 
volatile uint16_t* vga = (uint16_t*)0xB8000; 
void kmain(void) { 
    for(int i = 0; i < 80*25; i++) { 
        vga[i] = (0x0F << 8) | ' '; 
    } 
    char* msg = "LilithOS - Windows 11 Style OS"; 
    for(int i = 0; msg[i]; i++) { 
        vga[80*2 + i + 20] = (0x0F << 8) | msg[i]; 
    } 
    while(1) { __asm__ volatile("hlt"); } 
} 
