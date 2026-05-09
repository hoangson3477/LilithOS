# LilithOS Makefile
# Build system for x86_64 OS

CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm

CFLAGS = -ffreestanding -fno-stack-protector -fno-pic -mno-red-zone -m64 -c
LDFLAGS = -m elf_x86_64 -nostdlib -static
ASMFLAGS = -f elf64

# Directories
SRC_DIR = src
BUILD_DIR = build
ISO_DIR = iso

# Kernel files
KERNEL_C_FILES = $(SRC_DIR)/kernel/kmain.c $(SRC_DIR)/kernel/boot/gdt.c $(SRC_DIR)/kernel/interrupts/idt.c $(SRC_DIR)/kernel/interrupts/isr.c
KERNEL_ASM_FILES = $(SRC_DIR)/kernel/boot/boot.asm $(SRC_DIR)/kernel/interrupts/isr.asm
KERNEL_S_FILES = $(SRC_DIR)/kernel/boot/gdt_asm.S $(SRC_DIR)/kernel/interrupts/idt_asm.S
KERNEL_OBJS = $(KERNEL_C_FILES:.c=.o) $(KERNEL_ASM_FILES:.asm=.o) $(KERNEL_S_FILES:.S=.o)

# Output files
KERNEL = $(BUILD_DIR)/kernel.bin
ISO = $(BUILD_DIR)/lilithos.iso

.PHONY: all clean iso run

all: $(KERNEL)

$(KERNEL): $(KERNEL_OBJS)
	@mkdir -p $(BUILD_DIR)
	$(LD) $(LDFLAGS) -T linker.ld -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -o $@ $<

iso: $(KERNEL)
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL) $(ISO_DIR)/boot/
	cp grub.cfg $(ISO_DIR)/boot/grub/
	grub-mkrescue -o $(ISO) $(ISO_DIR)

run: iso
	qemu-system-x86_64 -cdrom $(ISO) -m 256M -serial stdio

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR)
	find $(SRC_DIR) -name "*.o" -delete

setup-toolchain:
	@echo "Setting up cross-compiler toolchain..."
	@if ! command -v $(CC) &> /dev/null; then \
		echo "Installing x86_64-elf-gcc toolchain..."; \
		echo "On Ubuntu/Debian: sudo apt install gcc-x86-64-elf"; \
		echo "On Windows with MSYS2: pacman -S mingw-w64-x86_64-elf-gcc"; \
		echo "On macOS: brew install x86_64-elf-gcc"; \
	fi
	@if ! command -v $(ASM) &> /dev/null; then \
		echo "Installing NASM..."; \
		echo "On Ubuntu/Debian: sudo apt install nasm"; \
		echo "On Windows: choco install nasm"; \
		echo "On macOS: brew install nasm"; \
	fi
	@if ! command -v grub-mkrescue &> /dev/null; then \
		echo "Installing GRUB tools..."; \
		echo "On Ubuntu/Debian: sudo apt install grub-common xorriso"; \
		echo "On Windows with MSYS2: pacman -S grub"; \
		echo "On macOS: brew install grub"; \
	fi
