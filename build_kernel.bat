@echo off
echo Building LilithOS Kernel (32-bit with system GCC)
echo ===================================================

if not exist build mkdir build

echo Compiling kernel files...

:: Compile C files
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/kmain.c -o build/kmain.o -I.
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/boot/gdt.c -o build/gdt.o -I.
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/interrupts/idt.c -o build/idt.o -I.
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/interrupts/isr.c -o build/isr.o -I.

:: Compile assembly files
nasm -f win32 src/kernel/boot/boot.asm -o build/boot.o
nasm -f win32 src/kernel/interrupts/isr.asm -o build/isr_asm.o
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/boot/gdt_asm.S -o build/gdt_asm.o -I.
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/interrupts/idt_asm.S -o build/idt_asm.o -I.

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed
    pause
    exit /b 1
)

echo [OK] All files compiled successfully

:: Link kernel (32-bit) - create flat binary
echo Linking kernel...
ld -m i386pe -Ttext 0x100000 -o build/kernel.exe build/boot.o build/kmain.o build/gdt.o build/idt.o build/isr.o build/gdt_asm.o build/idt_asm.o build/isr_asm.o
objcopy -O binary build/kernel.exe build/kernel.bin

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Linking failed
    pause
    exit /b 1
)

echo [SUCCESS] Kernel built successfully!
echo Output: build/kernel.bin
echo.
echo To create bootable ISO, you need:
echo 1. GRUB tools (install with MSYS2)
echo 2. Run: make iso
echo.
pause
