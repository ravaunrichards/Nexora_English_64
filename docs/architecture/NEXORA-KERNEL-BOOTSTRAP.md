# NEXORA English x64 — Native kernel bootstrap

**Status:** Initial source implementation; build and runtime verification pending CI.
**Target:** AMD64/x86-64, UEFI via GRUB 2 and Multiboot2.
**Ownership:** NEXORA source is under kernel/. GRUB is third-party and is not represented as NEXORA code.

## Implemented in this slice

- Multiboot2 header retained in the ELF image.
- 32-bit protected-mode entry from a Multiboot2 loader.
- Bootstrap PML4, PDPT and page directory.
- Identity map of the first 1 GiB using 2 MiB pages.
- PAE and EFER.LME activation, paging enablement and 64-bit far jump.
- 16 KiB bootstrap stack.
- Freestanding C entry point and COM1 serial diagnostics.
- IDT setup for CPU exception vectors 0–31, with error-code-aware assembly stubs.
- Fatal exception diagnostics including vector, error code, instruction pointer and page-fault address (CR2).
- CPUID vendor/long-mode capability reporting and Multiboot2 memory-map summary parsing.
- Basic validation and inspection of Multiboot2 memory summary, memory-map and framebuffer tags.
- GRUB menu entry and UEFI ISO build recipe.

## Explicit limitations

This is a bring-up kernel, not a complete operating system. The first 1 GiB identity map is temporary, not a production virtual-memory design. The IDT and fatal exception path for vectors 0–31 are now present but have not been exercised by runtime fault injection. The current bootstrap still lacks physical/virtual allocators, scheduler, userspace, syscall ABI, device model, filesystem, network stack, graphics driver and installer. The kernel halts after reporting boot information.

GRUB supplies the Multiboot2 handoff; this is not a NEXORA-written UEFI firmware loader. Secure Boot signing and legacy BIOS validation are separate work.

## Build on Ubuntu 24.04 AMD64

```sh
sudo apt-get update
sudo apt-get install -y build-essential grub-common grub-pc-bin grub-efi-amd64-bin xorriso mtools qemu-system-x86 ovmf
make clean iso check
bash tests/boot/qemu-smoke-test.sh
```

Outputs: build/native/nexora-kernel.elf and build/native/nexora-native-amd64.iso.

Artifact validation is not a boot test. QEMU testing is not physical hardware certification.
