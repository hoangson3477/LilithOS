@echo off
echo Building LilithOS Simple Kernel
echo ================================

if not exist build mkdir build

echo Compiling minimal kernel...

:: Compile only essential files
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/kmain.c -o build/kmain.o -I.
gcc -ffreestanding -fno-stack-protector -m32 -c src/kernel/boot/gdt.c -o build/gdt.o -I.

:: Create simple assembly stub for missing functions
echo Creating assembly stubs...

:: Create simple boot.asm without multiboot
echo section .text > build/simple_boot.asm
echo global _start >> build/simple_boot.asm
echo extern kmain >> build/simple_boot.asm
echo _start: >> build/simple_boot.asm
echo   mov esp, 0x90000 >> build/simple_boot.asm
echo   call kmain >> build/simple_boot.asm
echo .halt: >> build/simple_boot.asm
echo   hlt >> build/simple_boot.asm
echo   jmp .halt >> build/simple_boot.asm

:: Create simple gdt_flush
echo global gdt_flush > build/simple_gdt.asm
echo gdt_flush: >> build/simple_gdt.asm
echo   ret >> build/simple_gdt.asm

:: Compile assembly files
nasm -f win32 build/simple_boot.asm -o build/simple_boot.o
nasm -f win32 build/simple_gdt.asm -o build/simple_gdt.o

echo Linking kernel...
ld -m i386pe -Ttext 0x100000 -o build/kernel.exe build/simple_boot.o build/kmain.o build/gdt.o build/simple_gdt.o
objcopy -O binary build/kernel.exe build/kernel.bin

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)

echo [SUCCESS] Simple kernel built!
echo Output: build/kernel.bin
echo Size: 
dir build\kernel.bin | find "kernel.bin"
echo.
echo This is a minimal kernel without full OS features.
echo Install MSYS2 and run 'make all' for full build.
echo.
pause
