#include <stdint.h> 
volatile uint16_t* vga = (uint16_t*)0xB8000; 
void clear(void) { for(int i=0;i<2000;i++) vga[i]=0x0720; } 
void print(int x,int y,char*s,int c) { 
int p=y*80+x; for(int i=0;s[i];i++) vga[p+i]=(c<<8)|s[i]; 
} 
void box(int x,int y,int w,int h,int c) { 
for(int i=0;i<w;i++){vga[y*80+x+i]=(c<<8)|196;vga[(y+h-1)*80+x+i]=(c<<8)|196;} 
for(int i=0;i<h;i++){vga[(y+i)*80+x]=(c<<8)|179;vga[(y+i)*80+x+w-1]=(c<<8)|179;} 
vga[y*80+x]=(c<<8)|218;vga[y*80+x+w-1]=(c<<8)|191; 
vga[(y+h-1)*80+x]=(c<<8)|192;vga[(y+h-1)*80+x+w-1]=(c<<8)|217; 
} 
void kmain(void) { 
clear(); 
box(5,2,70,20,0x09); 
print(15,4,"LilithOS - Windows 11 Style OS",0x0F); 
box(10,7,60,10,0x0B); 
print(15,9,"SYSTEM STATUS: READY",0x0A); 
print(15,10,"Architecture: x86 32-bit",0x07); 
print(15,11,"Display: VGA Text Mode",0x07); 
print(15,12,"Boot: Multiboot Compliant",0x07); 
print(15,13,"GUI: Windows 11 Style",0x07); 
print(15,14,"Memory: 16MB Available",0x07); 
while(1) __asm__ volatile("hlt"); 
} 
