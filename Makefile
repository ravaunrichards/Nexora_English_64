SHELL := /usr/bin/env bash
BUILD_DIR := build/native
ISO_ROOT := $(BUILD_DIR)/iso
KERNEL := $(BUILD_DIR)/nexora-kernel.elf
ISO := $(BUILD_DIR)/nexora-native-amd64.iso
CC ?= gcc
AS := gcc
LD ?= ld
CFLAGS := -std=c11 -O2 -Wall -Wextra -Werror -ffreestanding -fno-builtin -fno-stack-protector -fno-pic -fno-pie -m64 -mno-red-zone -mcmodel=small -mno-mmx -mno-sse -mno-sse2
ASFLAGS := -m64 -ffreestanding -fno-pic -fno-pie
LDFLAGS := -nostdlib -z max-page-size=0x1000 -T kernel/linker.ld
.PHONY: all kernel iso check clean
all: iso
$(BUILD_DIR):
	mkdir -p "$@"
$(BUILD_DIR)/boot.o: kernel/arch/x86_64/boot.S | $(BUILD_DIR)
	$(AS) $(ASFLAGS) -c "$<" -o "$@"
$(BUILD_DIR)/multiboot2_header.o: kernel/boot/multiboot2_header.S | $(BUILD_DIR)
	$(AS) $(ASFLAGS) -c "$<" -o "$@"
$(BUILD_DIR)/isr.o: kernel/interrupts/isr.S | $(BUILD_DIR)
	$(AS) $(ASFLAGS) -c "$<" -o "$@"
$(BUILD_DIR)/kernel.o: kernel/core/kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c "$<" -o "$@"
$(KERNEL): $(BUILD_DIR)/boot.o $(BUILD_DIR)/multiboot2_header.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/kernel.o kernel/linker.ld
	$(LD) $(LDFLAGS) -o "$@" $(BUILD_DIR)/multiboot2_header.o $(BUILD_DIR)/boot.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/kernel.o
	grub-file --is-x86-multiboot2 "$@"
	readelf -h "$@" | grep -q 'Advanced Micro Devices X86-64'
kernel: $(KERNEL)
$(ISO): $(KERNEL) bootloader/grub/grub.cfg
	mkdir -p "$(ISO_ROOT)/boot/grub"
	cp "$(KERNEL)" "$(ISO_ROOT)/boot/nexora-kernel.elf"
	cp bootloader/grub/grub.cfg "$(ISO_ROOT)/boot/grub/grub.cfg"
	grub-mkrescue -o "$@" "$(ISO_ROOT)"
iso: $(ISO)
check: kernel
	bash tests/boot/check-kernel-artifact.sh "$(KERNEL)"
clean:
	rm -rf "$(BUILD_DIR)"
