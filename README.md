# LilithOS - Windows 11 Style Operating System

Một hệ điều hành thực sự (không phải simulation) với giao diện Windows 11 style, bo góc hiện đại.

## 🚀 Tính năng chính

- ✅ **OS thực sự**: Boot được trên hardware/VM qua GRUB bootloader
- 🎨 **Windows 11 Style**: Giao diện bo góc mềm mại, thiết kế hiện đại
- 🔧 **Kernel tùy chỉnh**: X86_64 kernel với memory management, interrupts
- 🖥️ **GUI Framework**: Window manager với rounded corners
- 💾 **Filesystem**: Hỗ trợ FAT32 để lưu trữ file
- ⌨️ **I/O Drivers**: Keyboard, VGA display drivers

## 📋 Yêu cầu hệ thống

### Phần cứng tối thiểu
- RAM: 256MB
- Storage: 50MB
- Architecture: x86_64

### Phần mềm phát triển
- **Windows**: MSYS2 + MinGW64
- **Linux**: gcc-x86-64-elf, nasm, grub-common
- **macOS**: x86-64-elf-gcc, nasm, grub

## 🛠️ Cài đặt môi trường

### Windows (MSYS2)

1. **Cài đặt MSYS2**:
   ```bash
   # Download từ https://www.msys2.org/
   # Sau khi cài, chạy MSYS2 MinGW 64-bit
   ```

2. **Cài đặt toolchain**:
   ```bash
   pacman -Syu
   pacman -Su
   pacman -S mingw-w64-x86_64-toolchain
   pacman -S mingw-w64-x86_64-nasm
   pacman -S grub
   ```

3. **Thêm vào PATH**:
   ```
   C:\msys64\mingw64\bin
   C:\msys64\usr\bin
   ```

4. **Chạy setup script**:
   ```cmd
   setup.bat
   ```

### Linux/Ubuntu

```bash
sudo apt update
sudo apt install gcc-x86-64-elf nasm grub-common xorriso qemu-system-x86
```

### macOS

```bash
brew install x86_64-elf-gcc nasm grub qemu
```

## 🏗️ Build & Run

### Build kernel
```bash
make all
```

### Tạo ISO image
```bash
make iso
```

### Chạy trong QEMU
```bash
make run
```

### Clean build
```bash
make clean
```

## 📁 Cấu trúc dự án

```
LilithOS/
├── src/
│   └── kernel/
│       ├── boot/          # Bootloader & multiboot
│       ├── mm/            # Memory management
│       ├── interrupts/    # Interrupt handling
│       ├── drivers/       # Device drivers
│       └── gui/           # GUI framework
├── build/                 # Build output
├── iso/                   # ISO generation
├── Makefile              # Build system
├── linker.ld             # Linker script
└── grub.cfg              # GRUB configuration
```

## 🎯 Development Roadmap

### Phase 1: Basic Kernel ✅
- [x] Bootloader (GRUB-compatible)
- [x] Basic kernel structure
- [ ] Memory management (Paging)
- [ ] Interrupt handling
- [ ] Basic I/O (VGA, Keyboard)

### Phase 2: GUI Framework 🔄
- [ ] VGA graphics mode
- [ ] Font rendering
- [ ] Window management
- [ ] Rounded corners rendering
- [ ] Mouse support

### Phase 3: Desktop Environment ⏳
- [ ] Taskbar
- [ ] Start menu
- [ ] File explorer
- [ ] App launcher
- [ ] Settings panel

### Phase 4: System Services ⏳
- [ ] Process management
- [ ] File system (FAT32)
- [ ] Network stack
- [ ] USB drivers
- [ ] Audio system

## 🧪 Testing

### Test trong Virtual Machine
```bash
# Tạo ISO
make iso

# Chạy QEMU
qemu-system-x86_64 -cdrom build/lilithos.iso -m 256M
```

### Test trên real hardware
```bash
# Flash ra USB
dd if=build/lilithos.iso of=/dev/sdX bs=4M status=progress

# Boot từ USB
```

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 License

MIT License - xem file LICENSE

## 🙏 Credits

- GRUB bootloader
- OSDev wiki tutorials
- Windows 11 design inspiration

---

**LilithOS** - Bringing Windows 11 style to custom operating systems! 🚀
