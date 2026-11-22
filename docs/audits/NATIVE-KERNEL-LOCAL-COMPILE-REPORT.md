# NEXORA native kernel — local compiler/linker smoke report

**Date:** 2026-11-21  
**Scope:** Compiler/linker validation of a local reconstruction of the committed kernel source snapshot. This was not a GitHub Actions run and did not produce a repository release artifact.

## Environment

- Host: x86_64 Linux container
- GCC: Debian 14.2.0-19, GCC 14.2.0
- GNU ld: Binutils 2.44

## Commands exercised

The assembly sources were compiled with GCC in 64-bit mode and freestanding/no-PIE options. The C core was compiled with C11, -O2 -Wall -Wextra -Werror, -ffreestanding, -fno-builtin, -fno-stack-protector, -fno-pic, -fno-pie, -m64, -mno-red-zone, -mcmodel=small, -mno-mmx, -mno-sse and -mno-sse2. The objects were linked with:

```sh
ld -nostdlib -z max-page-size=0x1000 -T kernel/linker.ld -o nexora-kernel.elf header.o boot.o kernel.o
```

## Observed results

- C and assembly compilation completed without compiler errors or warnings under -Werror.
- Link completed and produced an ELF executable.
- readelf -h reported ELF64 and machine Advanced Micro Devices X86-64.
- ELF entry point: 0x101000.
- .multiboot section file offset: 0x1000, within the Multiboot2 first-32-KiB header search window.
- .multiboot section length: 0x18 bytes.
- objdump -s -j .multiboot showed magic bytes d65052e8, architecture field zero, length 0x18, checksum field 12afad17, and the required end tag. An independent Python byte-level check confirmed that the header checksum sums to zero modulo 2^32 and that the end tag is correctly encoded.
- ELF load segments were separately marked read-only, executable/read, read-only, and read/write; no combined RWX load segment was shown.

## Not tested

The environment did not contain grub-file, grub-mkrescue, xorriso, or qemu-system-x86_64. A direct Git clone also failed because the container could not resolve github.com. Therefore:

- The repository Makefile was not executed against a checked-out working tree.
- GRUB did not validate the Multiboot2 header.
- No ISO was generated.
- No UEFI/OVMF or QEMU boot was run.
- No physical hardware test was run.

## Result

**Compiler/linker smoke check: PASS for the reconstructed source snapshot.**  
**Repository CI, GRUB validation, ISO generation and runtime boot: NOT VERIFIED.**

This report is deliberately narrower than a kernel boot acceptance test. The next gate is the GitHub Actions build with GRUB artifact validation and QEMU/OVMF serial-marker verification.
