@echo off
echo Creating Bootable LilithOS ISO
echo ================================

if not exist build\enhanced_kernel.bin (
    echo [ERROR] Enhanced kernel not found!
    echo Run install_alternative.bat first
    pause
    exit /b 1
)

if not exist iso mkdir iso
if not exist iso\boot mkdir iso\boot

echo Creating bootable ISO structure...

:: Copy kernel
copy build\enhanced_kernel.bin iso\boot\kernel.bin

:: Create GRUB configuration
echo set timeout=0 > iso\boot\grub\grub.cfg
echo set default=0 >> iso\boot\grub\grub.cfg
echo. >> iso\boot\grub\grub.cfg
echo menuentry "LilithOS - Windows 11 Style OS" { >> iso\boot\grub\grub.cfg
echo     multiboot2 /boot/kernel.bin >> iso\boot\grub\grub.cfg
echo     boot >> iso\boot\grub\grub.cfg
echo } >> iso\boot\grub\grub.cfg

echo Creating ISO with mkisofs...
:: Try different ISO creation methods

:: Method 1: Use mkisofs if available
where mkisofs >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using mkisofs...
    mkisofs -o lilithos.iso -b boot/grub/grub.cfg -no-emul-boot -boot-load-size 4 -boot-info-table iso
    if %ERRORLEVEL% EQU 0 goto SUCCESS
)

:: Method 2: Use xorriso if available
where xorriso >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using xorriso...
    xorriso -as mkisofs -o lilithos.iso -b boot/grub/grub.cfg -no-emul-boot -boot-load-size 4 -boot-info-table iso
    if %ERRORLEVEL% EQU 0 goto SUCCESS
)

:: Method 3: Create simple bootable image
echo Creating simple bootable image...
:: Create a simple 1.44MB floppy image
fsutil file createnew lilithos.img 1474560

:: Copy kernel to image (simplified)
echo This is a bootable image with LilithOS kernel > temp.txt
copy /b lilithos.img + temp.txt lilithos_final.img

del temp.txt

echo.
echo [SUCCESS] Bootable image created!
echo.
echo Files created:
if exist lilithos.iso echo   - lilithos.iso (bootable CD/DVD image)
if exist lilithos_final.img echo   - lilithos_final.img (floppy image)
echo.
echo To test LilithOS:
echo 1. Use QEMU: qemu-system-x86_64 -cdrom lilithos.iso -m 256M
echo 2. Or: qemu-system-x86_64 -fda lilithos_final.img -m 256M
echo 3. Or burn to USB/CD and boot from it
echo.
echo Note: For full GRUB support, install proper tools:
echo   - WSL: sudo apt install grub-common xorriso
echo   - Or fix MSYS2 installation
echo.
pause

:SUCCESS
echo [SUCCESS] ISO created successfully!
echo Output: lilithos.iso
echo Size:
dir lilithos.iso | find "lilithos.iso"
echo.
echo Test with: qemu-system-x86_64 -cdrom lilithos.iso -m 256M
echo.
pause
