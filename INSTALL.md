# LilithOS Installation Guide

## Overview
LilithOS là một hệ điều hành thực sự với style Windows 11, được xây dựng từ đầu với kernel tùy chỉnh.

## Requirements

### Windows Development Environment
- Windows 10/11 (64-bit)
- Visual Studio Code hoặc text editor
- Command Prompt/PowerShell với admin rights

### Required Tools

#### 1. MSYS2 (Required for cross-compiler)
1. Download: https://www.msys2.org/
2. Install to `C:\msys64`
3. Run MSYS2 MinGW 64-bit terminal
4. Update packages:
   ```bash
   pacman -Syu
   pacman -Su
   ```

#### 2. Cross-Compiler Toolchain
Trong MSYS2 terminal, chạy:
```bash
# Install toolchain
pacman -S mingw-w64-x86_64-toolchain
pacman -S mingw-w64-x86_64-nasm

# Install GRUB tools
pacman -S msys2-grub2

# Hoặc thử với toolchain khác
pacman -S base-devel
pacman -S mingw-w64-x86_64-gcc
```

#### 3. Add to PATH
Thêm vào Windows PATH:
```
C:\msys64\mingw64\bin
C:\msys64\usr\bin
```

#### 4. QEMU (for testing)
```bash
# Chocolatey
choco install qemu

# Hoặc download từ: https://www.qemu.org/
```

## Build Instructions

### Quick Test (Minimal Kernel)
```cmd
.\build_minimal.bat
```
Đây là kernel đơn giản đã build thành công.

### Full OS Build
```cmd
# Sau khi cài đặt MSYS2 và toolchain
make all
```

### Create Bootable ISO
```cmd
make iso
```

### Run in QEMU
```cmd
make run
```

## Project Structure
```
LilithOS/
├── src/
│   └── kernel/
│       ├── kmain.c           # Kernel entry point
│       ├── boot/
│       │   ├── boot.asm      # Boot assembly
│       │   ├── gdt.c         # Global Descriptor Table
│       │   └── gdt_asm.S    # GDT assembly functions
│       └── interrupts/
│           ├── idt.c         # Interrupt Descriptor Table
│           ├── idt_asm.S    # IDT assembly
│           ├── isr.c         # Interrupt handlers
│           └── isr.asm      # ISR assembly
├── Makefile                 # Build system
├── linker.ld               # Linker script
├── grub.cfg               # GRUB configuration
└── build/                  # Build output
```

## Features Implemented

### ✅ Working Components
- **Kernel Entry Point**: Boot sequence và initialization
- **VGA Text Mode**: Hiển thị text với Windows 11 style
- **GDT**: Global Descriptor Table cho memory segmentation
- **IDT**: Interrupt Descriptor Table cho interrupt handling
- **Assembly Integration**: C và assembly code working together
- **Build System**: Makefile và build scripts

### 🚧 In Progress
- **Memory Management**: Paging và virtual memory
- **GUI System**: Windows 11 style graphical interface
- **Driver Support**: Keyboard, mouse, storage
- **File System**: FAT32 hoặc custom filesystem
- **Network Stack**: TCP/IP networking

### 📋 Planned Features
- **Windows 11 Style GUI**: Rounded corners, modern design
- **Task Manager**: Process management
- **File Explorer**: File management interface
- **Settings Panel**: System configuration
- **App Store**: Software installation
- **Developer Tools**: SDK và APIs

## Troubleshooting

### Common Issues

#### 1. "x86_64-elf-gcc not found"
- Solution: Install MSYS2 và thêm vào PATH
- Verify: `where x86_64-elf-gcc`

#### 2. "nasm not found"
- Solution: Install NASM qua MSYS2 hoặc Chocolatey
- Verify: `where nasm`

#### 3. "grub-mkrescue not found"
- Solution: Install GRUB tools qua MSYS2
- Verify: `where grub-mkrescue`

#### 4. Linking errors
- Solution: Đảm bảo tất cả object files được compile đúng
- Clean build: `make clean` rồi build lại

### Debug Mode
```cmd
# Enable debug output
make CFLAGS="-DDEBUG -g"

# Verbose build
make V=1
```

## Development Workflow

### 1. Code Changes
- Edit source files trong `src/kernel/`
- Test compilation với `make`

### 2. Testing
```cmd
# Build và run
make all
make run

# Hoặc test minimal version
.\build_minimal.bat
```

### 3. Debugging
- Sử dụng QEMU debug mode
- Check kernel logs trong QEMU console
- Use GDB với QEMU cho advanced debugging

## Contributing

### Code Style
- Use 4 spaces for indentation
- Follow Linux kernel coding style
- Add comments for complex functions
- Include Windows 11 style UI elements

### Testing
- Test trong QEMU trước khi chạy trên real hardware
- Verify boot sequence
- Test interrupt handling
- Validate memory management

## Next Steps

1. **Install MSYS2** và toolchain
2. **Build full kernel** với `make all`
3. **Create ISO** với `make iso`
4. **Test in QEMU** với `make run`
5. **Develop GUI** với Windows 11 style
6. **Add more features** theo roadmap

## Support

Nếu gặp issues:
1. Check troubleshooting section
2. Verify toolchain installation
3. Clean build directory
4. Test minimal kernel first

---

**LilithOS** - Building a real OS with Windows 11 style interface! 🚀
