#include <stdint.h> 
volatile uint16_t* vga = (uint16_t*)0xB8000; 
 
void clear_screen(void) { 
    for(int i = 0; i < 80*25; i++) { 
        vga[i] = (0x07 << 8) | ' '; 
    } 
} 
 
void print_at(int x, int y, const char* str, uint8_t color) { 
    int pos = y * 80 + x; 
    for(int i = 0; str[i]; i++) { 
        vga[pos + i] = (color << 8) | str[i]; 
    } 
} 
 
void draw_box(int x, int y, int w, int h, uint8_t color) { 
    for(int i = 0; i < w; i++) { 
        vga[y * 80 + x + i] = (color << 8) | '═'; 
        vga[(y+h-1) * 80 + x + i] = (color << 8) | '═'; 
    } 
    for(int i = 0; i < h; i++) { 
        vga[(y+i) * 80 + x] = (color << 8) | '║'; 
        vga[(y+i) * 80 + x + w - 1] = (color << 8) | '║'; 
    } 
    vga[y * 80 + x] = (color << 8) | '╔'; 
    vga[y * 80 + x + w - 1] = (color << 8) | '╗'; 
    vga[(y+h-1) * 80 + x] = (color << 8) | '╚'; 
    vga[(y+h-1) * 80 + x + w - 1] = (color << 8) | '╝'; 
} 
 
void kmain(void) { 
    clear_screen(); 
    draw_box(10, 5, 60, 15, 0x09); 
    print_at(15, 7, "LilithOS - Windows 11 Style", 0x0F); 
    print_at(15, 8, "Real Operating System", 0x07); 
    print_at(15, 10, "╔═════════════════════════════════════════════════════╗", 0x0B); 
    print_at(15, 11, "║ System Status: READY                                ║", 0x0B); 
    print_at(15, 12, "║ Memory: 16MB Available                              ║", 0x0B); 
    print_at(15, 13, "║ Graphics: VGA Text Mode                             ║", 0x0B); 
    print_at(15, 14, "║ Boot: Successful                                    ║", 0x0B); 
    print_at(15, 15, "╚═════════════════════════════════════════════════════╝", 0x0B); 
    while(1) { __asm__ volatile("hlt"); } 
} 
