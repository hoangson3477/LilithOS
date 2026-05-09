#include <stdint.h> 
 
// Multiboot header structure 
struct multiboot_header { 
    uint32_t magic; 
    uint32_t flags; 
    uint32_t checksum; 
    uint32_t header_addr; 
    uint32_t load_addr; 
    uint32_t load_end_addr; 
    uint32_t bss_end_addr; 
    uint32_t entry_addr; 
} __attribute__((packed)); 
 
// VGA display 
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
    // Top and bottom borders 
    for(int i = 1; i < w-1; i++) { 
        vga[y * 80 + x + i] = (color << 8) | 196; // - 
        vga[(y+h-1) * 80 + x + i] = (color << 8) | 196; // - 
    } 
    // Left and right borders 
    for(int i = 0; i < h; i++) { 
