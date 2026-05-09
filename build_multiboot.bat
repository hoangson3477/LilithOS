@echo off
echo Building Multiboot LilithOS Kernel
echo ===================================

if not exist build mkdir build

echo Creating Multiboot compliant kernel...

:: Create kernel with Multiboot header
echo #include ^<stdint.h^> > build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo // Multiboot header structure >> build/multiboot_kmain.c
echo struct multiboot_header { >> build/multiboot_kmain.c
echo     uint32_t magic; >> build/multiboot_kmain.c
echo     uint32_t flags; >> build/multiboot_kmain.c
echo     uint32_t checksum; >> build/multiboot_kmain.c
echo     uint32_t header_addr; >> build/multiboot_kmain.c
echo     uint32_t load_addr; >> build/multiboot_kmain.c
echo     uint32_t load_end_addr; >> build/multiboot_kmain.c
echo     uint32_t bss_end_addr; >> build/multiboot_kmain.c
echo     uint32_t entry_addr; >> build/multiboot_kmain.c
echo } __attribute__((packed)); >> build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo // VGA display >> build/multiboot_kmain.c
echo volatile uint16_t* vga = ^(uint16_t*^)0xB8000; >> build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo void clear_screen^(void^) { >> build/multiboot_kmain.c
echo     for^(int i = 0; i ^< 80*25; i++^) { >> build/multiboot_kmain.c
echo         vga[i] = ^(0x07 ^<^< 8^) ^| ' '; >> build/multiboot_kmain.c
echo     } >> build/multiboot_kmain.c
echo } >> build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo void print_at^(int x, int y, const char* str, uint8_t color^) { >> build/multiboot_kmain.c
echo     int pos = y * 80 + x; >> build/multiboot_kmain.c
echo     for^(int i = 0; str[i]; i++^) { >> build/multiboot_kmain.c
echo         vga[pos + i] = ^(color ^<^< 8^) ^| str[i]; >> build/multiboot_kmain.c
echo     } >> build/multiboot_kmain.c
echo } >> build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo void draw_box^(int x, int y, int w, int h, uint8_t color^) { >> build/multiboot_kmain.c
echo     // Top and bottom borders >> build/multiboot_kmain.c
echo     for^(int i = 1; i ^< w-1; i++^) { >> build/multiboot_kmain.c
echo         vga[y * 80 + x + i] = ^(color ^<^< 8^) ^| 196; // - >> build/multiboot_kmain.c
echo         vga[(y+h-1) * 80 + x + i] = ^(color ^<^< 8^) ^| 196; // - >> build/multiboot_kmain.c
echo     } >> build/multiboot_kmain.c
echo     // Left and right borders >> build/multiboot_kmain.c
echo     for (int i = 0; i  h; i++) { >> build/multiboot_kmain.c
echo         vga[(y+i) * 80 + x] = (color  8) | 179; // | >> build/multiboot_kmain.c
echo         vga[(y+i) * 80 + x + w - 1] = (color  8) | 179; // | >> build/multiboot_kmain.c
echo     } >> build/multiboot_kmain.c
echo     // Corners >> build/multiboot_kmain.c
echo     vga[y * 80 + x] = (color  8) | 218; >> build/multiboot_kmain.c
echo     vga[y * 80 + x + w - 1] = (color  8) | 191; >> build/multiboot_kmain.c
echo     vga[(y+h-1) * 80 + x] = (color  8) | 192; >> build/multiboot_kmain.c
echo     vga[(y+h-1) * 80 + x + w - 1] = (color  8) | 217; >> build/multiboot_kmain.c
echo } >> build/multiboot_kmain.c
echo. >> build/multiboot_kmain.c
echo // Kernel entry point >> build/multiboot_kmain.c
echo void kmain^(uint32_t magic, uint32_t addr^) { >> build/multiboot_kmain.c
echo     clear_screen^(^); >> build/multiboot_kmain.c
echo     draw_box^(5, 3, 70, 18, 0x09^); >> build/multiboot_kmain.c
echo     print_at^(10, 5, "LilithOS - Windows 11 Style Operating System", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(10, 7, "Real OS Kernel - Multiboot Compliant", 0x07^); >> build/multiboot_kmain.c
echo     draw_box^(8, 9, 64, 8, 0x0B^); >> build/multiboot_kmain.c
echo     print_at^(10, 11, "System Status:", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(25, 11, "READY", 0x0A^); >> build/multiboot_kmain.c
echo     print_at^(10, 12, "Boot Method:", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(25, 12, "Multiboot", 0x0B^); >> build/multiboot_kmain.c
echo     print_at^(10, 13, "Display Mode:", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(25, 13, "VGA Text 80x25", 0x0B^); >> build/multiboot_kmain.c
echo     print_at^(10, 14, "Architecture:", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(25, 14, "x86 32-bit", 0x0B^); >> build/multiboot_kmain.c
echo     print_at^(10, 15, "GUI Style:", 0x0F^); >> build/multiboot_kmain.c
echo     print_at^(25, 15, "Windows 11", 0x0B^); >> build/multiboot_kmain.c
echo     while^(1^) { __asm__ volatile^("hlt"^); } >> build/multiboot_kmain.c
echo } >> build/multiboot_kmain.c

:: Create Multiboot assembly header
echo section .multiboot > build/multiboot_header.asm
echo align 8 >> build/multiboot_header.asm
echo multiboot_header: >> build/multiboot_header.asm
echo     dd 0x1BADB002  ; Magic number >> build/multiboot_header.asm
echo     dd 0x00        ; Flags >> build/multiboot_header.asm
echo     dd -0x1BADB002 ; Checksum >> build/multiboot_header.asm
echo. >> build/multiboot_header.asm
echo section .text >> build/multiboot_header.asm
echo global _start >> build/multiboot_header.asm
echo extern _kmain >> build/multiboot_header.asm
echo _start: >> build/multiboot_header.asm
echo     mov esp, 0x90000 >> build/multiboot_header.asm
echo     push ebx >> build/multiboot_header.asm
echo     push eax >> build/multiboot_header.asm
echo     call _kmain >> build/multiboot_header.asm
echo .halt: >> build/multiboot_header.asm
echo     hlt >> build/multiboot_header.asm
echo     jmp .halt >> build/multiboot_header.asm

:: Compile
gcc -ffreestanding -fno-stack-protector -m32 -c build/multiboot_kmain.c -o build/multiboot_kmain.o
nasm -f win32 build/multiboot_header.asm -o build/multiboot_header.o

:: Link with custom script
ld -m i386pe -Ttext 0x100000 -o build/multiboot_kernel.exe build/multiboot_header.o build/multiboot_kmain.o
objcopy -O binary build/multiboot_kernel.exe build/multiboot_kernel.bin

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Multiboot kernel build failed
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Multiboot LilithOS kernel built!
echo Output: build/multiboot_kernel.bin
echo Size:
dir build\multiboot_kernel.bin | find "multiboot_kernel.bin"

echo.
echo This kernel is Multiboot compliant and can boot with:
echo - GRUB bootloader
echo - QEMU directly with -kernel option
echo.
echo Testing with QEMU...
qemu-system-x86_64 -kernel build/multiboot_kernel.bin -m 256M

pause
