@echo off
echo LilithOS Simple Build Test
echo ===========================

echo Checking for GCC...
where gcc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] GCC not found. Please install MinGW or use MSYS2.
    pause
    exit /b 1
)

echo [OK] GCC found
echo.

echo Attempting to build with system GCC (for testing structure)...

if not exist build mkdir build
if not exist build\kernel mkdir build\kernel

echo Compiling kernel main...
gcc -ffreestanding -fno-stack-protector -m64 -c src/kernel/kmain.c -o build/kmain.o

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed
    pause
    exit /b 1
)

echo [OK] Kernel main compiled successfully
echo.
echo Note: This is just a structure test. For full OS build, you need:
echo - x86_64-elf-gcc cross-compiler
echo - NASM assembler  
echo - GRUB tools
echo.
echo Run setup.bat for complete installation guide.
pause
