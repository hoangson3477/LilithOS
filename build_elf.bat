@echo off
echo Building ELF Multiboot LilithOS Kernel
echo =======================================

if not exist build mkdir build

echo Creating ELF Multiboot kernel...

:: Create C kernel
echo #include ^<stdint.h^> > build/elf_kmain.c
echo volatile uint16_t* vga = ^(uint16_t*^)0xB8000; >> build/elf_kmain.c
echo void clear^(void^) { for(int i=0;i^<2000;i++^) vga[i]=0x0720; } >> build/elf_kmain.c
echo void print^(int x,int y,char*s,int c^) { >> build/elf_kmain.c
echo int p=y*80+x; for(int i=0;s[i];i++^) vga[p+i]=^(c^<^<8^)^|s[i]; >> build/elf_kmain.c
echo } >> build/elf_kmain.c
echo void box^(int x,int y,int w,int h,int c^) { >> build/elf_kmain.c
echo for(int i=0;i^<w;i++^){vga[y*80+x+i]=^(c^<^<8^)^|196;vga[(y+h-1)*80+x+i]=^(c^<^<8^)^|196;} >> build/elf_kmain.c
echo for(int i=0;i^<h;i++^){vga[(y+i)*80+x]=^(c^<^<8^)^|179;vga[(y+i)*80+x+w-1]=^(c^<^<8^)^|179;} >> build/elf_kmain.c
echo vga[y*80+x]=^(c^<^<8^)^|218;vga[y*80+x+w-1]=^(c^<^<8^)^|191; >> build/elf_kmain.c
echo vga[(y+h-1)*80+x]=^(c^<^<8^)^|192;vga[(y+h-1)*80+x+w-1]=^(c^<^<8^)^|217; >> build/elf_kmain.c
echo } >> build/elf_kmain.c
echo void kmain^(void^) { >> build/elf_kmain.c
echo clear^(^); >> build/elf_kmain.c
echo box^(5,2,70,20,0x09^); >> build/elf_kmain.c
echo print^(15,4,"LilithOS - Windows 11 Style OS",0x0F^); >> build/elf_kmain.c
echo box^(10,7,60,10,0x0B^); >> build/elf_kmain.c
echo print^(15,9,"SYSTEM STATUS: READY",0x0A^); >> build/elf_kmain.c
echo print^(15,10,"Architecture: x86 32-bit",0x07^); >> build/elf_kmain.c
echo print^(15,11,"Display: VGA Text Mode",0x07^); >> build/elf_kmain.c
echo print^(15,12,"Boot: Multiboot Compliant",0x07^); >> build/elf_kmain.c
echo print^(15,13,"GUI: Windows 11 Style",0x07^); >> build/elf_kmain.c
echo print^(15,14,"Memory: 16MB Available",0x07^); >> build/elf_kmain.c
echo while^(1^) __asm__ volatile^("hlt"^); >> build/elf_kmain.c
echo } >> build/elf_kmain.c

:: Create assembly with ELF format
echo section .multiboot > build/elf_boot.asm
echo align 8 >> build/elf_boot.asm
echo multiboot_header: >> build/elf_boot.asm
echo     dd 0x1BADB002 >> build/elf_boot.asm
echo     dd 0x00 >> build/elf_boot.asm
echo     dd -0x1BADB002 >> build/elf_boot.asm
echo section .text >> build/elf_boot.asm
echo global _start >> build/elf_boot.asm
echo extern kmain >> build/elf_boot.asm
echo _start: >> build/elf_boot.asm
echo     mov esp, 0x90000 >> build/elf_boot.asm
echo     call kmain >> build/elf_boot.asm
echo .halt: hlt >> build/elf_boot.asm
echo     jmp .halt >> build/elf_boot.asm

:: Compile with ELF output
gcc -ffreestanding -fno-stack-protector -m32 -c build/elf_kmain.c -o build/elf_kmain.o
nasm -f elf32 build/elf_boot.asm -o build/elf_boot.o

:: Link as ELF
ld -m elf_i386 -Ttext 0x100000 -o build/elf_kernel build/elf_boot.o build/elf_kmain.o

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] ELF build failed
    pause
    exit /b 1
)

echo [SUCCESS] ELF Multiboot kernel built!
echo Size:
dir build\elf_kernel | find "elf_kernel"

echo.
echo Testing with QEMU...
qemu-system-x86_64 -kernel build/elf_kernel -m 256M

pause
