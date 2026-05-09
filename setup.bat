@echo off
echo LilithOS Development Environment Setup
echo ========================================
echo.

echo Installing x86_64-elf-gcc toolchain...
echo You need to install MSYS2 first if not already installed.
echo.
echo Steps:
echo 1. Download MSYS2 from https://www.msys2.org/
echo 2. Install MSYS2 to default location
echo 3. Run MSYS2 MinGW 64-bit terminal
echo 4. Run these commands:
echo    pacman -Syu
echo    pacman -Su
echo    pacman -S mingw-w64-x86_64-toolchain
echo    pacman -S mingw-w64-x86_64-nasm
echo    pacman -S grub
echo.
echo After installation, add to PATH:
echo C:\msys64\mingw64\bin
echo C:\msys64\usr\bin
echo.

echo Checking for existing tools...
where x86_64-elf-gcc >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] x86_64-elf-gcc found
) else (
    echo [ERROR] x86_64-elf-gcc not found in PATH
)

where nasm >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] NASM found
) else (
    echo [ERROR] NASM not found in PATH
)

where grub-mkrescue >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] GRUB tools found
) else (
    echo [ERROR] GRUB tools not found in PATH
)

echo.
echo Press any key to continue...
pause >nul
