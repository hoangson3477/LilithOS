@echo off
echo Building Final LilithOS Kernel
echo ==============================

if not exist build mkdir build

echo Creating Multiboot kernel...

:: Create simple C kernel file
echo #include ^<stdint.h^> > build/final_kmain.c
echo volatile uint16_t* vga = ^(uint16_t*^)0xB8000; >> build/final_kmain.c
echo void clear_screen^(void^) { >> build/final_kmain.c
echo     for^(int i = 0; i ^< 80*25; i++^) vga[i] = 0x0720; >> build/final_kmain.c
echo } >> build/final_kmain.c
echo void print^(int x, int y, char* s, int color^) { >> build/final_kmain.c
echo     int pos = y * 80 + x; >> build/final_kmain.c
echo     for^(int i = 0; s[i]; i++^) vga[pos+i] = ^(color ^<^< 8^) ^| s[i]; >> build/final_kmain.c
echo } >> build/final_kmain.c
echo void draw_box^(int x, int y, int w, int h, int c^) { >> build/final_kmain.c
echo     for^(int i = 0; i ^< w; i++^) { >> build/final_kmain.c
echo         vga[y*80+x+i] = ^(c^<^<8^)^|196; >> build/final_kmain.c
echo         vga[(y+h-1)*80+x+i] = ^(c^<^<8^)^|196; >> build/final_kmain.c
echo     } >> build/final_kmain.c
echo     for^(int i = 0; i ^< h; i++^) { >> build/final_kmain.c
echo         vga[(y+i)*80+x] = ^(c^<^<8^)^|179; >> build/final_kmain.c
echo         vga[(y+i)*80+x+w-1] = ^(c^<^<8^)^|179; >> build/final_kmain.c
echo     } >> build/final_kmain.c
echo     vga[y*80+x] = ^(c^<^<8^)^|218; >> build/final_kmain.c
echo     vga[y*80+x+w-1] = ^(c^<^<8^)^|191; >> build/final_kmain.c
echo     vga[(y+h-1)*80+x] = ^(c^<^<8^)^|192; >> build/final_kmain.c
echo     vga[(y+h-1)*80+x+w-1] = ^(c^<^<8^)^|217; >> build/final_kmain.c
echo } >> build/final_kmain.c
echo void kmain^(void^) { >> build/final_kmain.c
echo     clear_screen^(^); >> build/final_kmain.c
echo     draw_box^(5, 2, 70, 20, 0x09^); >> build/final_kmain.c
echo     print^(15, 4, "LilithOS - Windows 11 Style OS", 0x0F^); >> build/final_kmain.c
echo     draw_box^(10, 7, 60, 10, 0x0B^); >> build/final_kmain.c
echo     print^(15, 9, "SYSTEM STATUS: READY", 0x0A^); >> build/final_kmain.c
echo     print^(15, 10, "Architecture: x86 32-bit", 0x07^); >> build/final_kmain.c
echo     print^(15, 11, "Display: VGA Text Mode", 0x07^); >> build/final_kmain.c
echo     print^(15, 12, "Boot: Multiboot Compliant", 0x07^); >> build/final_kmain.c
echo     print^(15, 13, "GUI: Windows 11 Style", 0x07^); >> build/final_kmain.c
echo     print^(15, 14, "Memory: 16MB Available", 0x07^); >> build/final_kmain.c
echo     while^(1^) __asm__ volatile^("hlt"^); >> build/final_kmain.c
echo } >> build/final_kmain.c

:: Create Multiboot assembly
echo section .multiboot > build/final_boot.asm
echo align 8 >> build/final_boot.asm
echo multiboot_header: >> build/final_boot.asm
echo     dd 0x1BADB002 >> build/final_boot.asm
echo     dd 0x00 >> build/final_boot.asm
echo     dd -0x1BADB002 >> build/final_boot.asm
echo section .text >> build/final_boot.asm
echo global _start >> build/final_boot.asm
echo extern _kmain >> build/final_boot.asm
echo _start: >> build/final_boot.asm
echo     mov esp, 0x90000 >> build/final_boot.asm
echo     call _kmain >> build/final_boot.asm
echo .halt: hlt >> build/final_boot.asm
echo     jmp .halt >> build/final_boot.asm

:: Compile
gcc -ffreestanding -fno-stack-protector -m32 -c build/final_kmain.c -o build/final_kmain.o
nasm -f win32 build/final_boot.asm -o build/final_boot.o

:: Link
ld -m i386pe -Ttext 0x100000 -o build/final_kernel.exe build/final_boot.o build/final_kmain.o
objcopy -O binary build/final_kernel.exe build/final_kernel.bin

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)

echo [SUCCESS] Final LilithOS kernel built!
echo Size: 
dir build\final_kernel.bin | find "final_kernel.bin"

echo.
echo Testing with QEMU...
qemu-system-x86_64 -kernel build/final_kernel.bin -m 256M

pause
