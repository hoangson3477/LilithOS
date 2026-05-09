@echo off
echo Building Minimal LilithOS Kernel
echo ==================================

if not exist build mkdir build

echo Creating minimal kernel...

:: Create simple kernel C file
echo #include ^<stdint.h^> > build/minimal_kmain.c
echo volatile uint16_t* vga = ^(uint16_t*^)0xB8000; >> build/minimal_kmain.c
echo void kmain^(void^) { >> build/minimal_kmain.c
echo     for^(int i = 0; i ^< 80*25; i++^) { >> build/minimal_kmain.c
echo         vga[i] = ^(0x0F ^<^< 8^) ^| ' '; >> build/minimal_kmain.c
echo     } >> build/minimal_kmain.c
echo     char* msg = "LilithOS - Windows 11 Style OS"; >> build/minimal_kmain.c
echo     for^(int i = 0; msg[i]; i++^) { >> build/minimal_kmain.c
echo         vga[80*2 + i + 20] = ^(0x0F ^<^< 8^) ^| msg[i]; >> build/minimal_kmain.c
echo     } >> build/minimal_kmain.c
echo     while^(1^) { __asm__ volatile^("hlt"^); } >> build/minimal_kmain.c
echo } >> build/minimal_kmain.c

:: Create simple boot.asm
echo section .text > build/minimal_boot.asm
echo global _start >> build/minimal_boot.asm
echo extern _kmain >> build/minimal_boot.asm
echo _start: >> build/minimal_boot.asm
echo   mov esp, 0x90000 >> build/minimal_boot.asm
echo   call _kmain >> build/minimal_boot.asm
echo .halt: >> build/minimal_boot.asm
echo   hlt >> build/minimal_boot.asm
echo   jmp .halt >> build/minimal_boot.asm

:: Compile
gcc -ffreestanding -fno-stack-protector -m32 -c build/minimal_kmain.c -o build/minimal_kmain.o
nasm -f win32 build/minimal_boot.asm -o build/minimal_boot.o

:: Link
ld -m i386pe -Ttext 0x100000 -o build/kernel.exe build/minimal_boot.o build/minimal_kmain.o
objcopy -O binary build/kernel.exe build/kernel.bin

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)

echo [SUCCESS] Minimal kernel built!
echo Output: build/kernel.bin
echo Size:
dir build\kernel.bin | find "kernel.bin"

echo.
echo This kernel will display "LilithOS - Windows 11 Style OS" on screen
echo when booted with GRUB or similar bootloader.
echo.
echo Next steps:
echo 1. Install MSYS2 with x86_64-elf-gcc, nasm, grub
echo 2. Run 'make all' for full OS build
echo 3. Create ISO with 'make iso'
echo.
pause
