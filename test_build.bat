@echo off
echo LilithOS Structure Test
echo ========================

echo Testing code compilation with system GCC...
echo.

if not exist build mkdir build

echo Compiling kmain.c...
gcc -ffreestanding -fno-stack-protector -c src/kernel/kmain.c -o build/kmain_test.o -I.

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] kmain.c compilation failed
    pause
    exit /b 1
)

echo [OK] kmain.c compiled successfully

echo Compiling gdt.c...
gcc -ffreestanding -fno-stack-protector -c src/kernel/boot/gdt.c -o build/gdt_test.o -I.

echo Compiling gdt_asm.S...
gcc -ffreestanding -fno-stack-protector -c src/kernel/boot/gdt_asm.S -o build/gdt_asm_test.o

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] gdt.c compilation failed
    pause
    exit /b 1
)

echo [OK] gdt.c compiled successfully

echo Compiling idt.c...
gcc -ffreestanding -fno-stack-protector -c src/kernel/interrupts/idt.c -o build/idt_test.o -I.

echo Compiling idt_asm.S...
gcc -ffreestanding -fno-stack-protector -c src/kernel/interrupts/idt_asm.S -o build/idt_asm_test.o

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] idt.c compilation failed
    pause
    exit /b 1
)

echo [OK] idt.c compiled successfully

echo Compiling isr.c...
gcc -ffreestanding -fno-stack-protector -c src/kernel/interrupts/isr.c -o build/isr_test.o -I.

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] isr.c compilation failed
    pause
    exit /b 1
)

echo [OK] isr.c compiled successfully

echo.
echo [SUCCESS] All C files compiled successfully!
echo.
echo Next steps:
echo 1. Install x86_64-elf-gcc toolchain (run setup.bat)
echo 2. Install NASM assembler
echo 3. Install GRUB tools
echo 4. Run 'make all' to build full kernel
echo.
pause
