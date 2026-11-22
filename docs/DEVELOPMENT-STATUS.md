# NEXORA English x64 — Development status

Updated: 2026-11-21

## Native kernel bring-up

Initial NEXORA-owned freestanding AMD64 kernel bootstrap sources and an automated build/UEFI-QEMU workflow are added.

| Item | Status |
|---|---|
| Freestanding C kernel entry | Source compiled in a local reconstructed snapshot; repository CI pending |
| Multiboot2 header | Source linked as ELF64 AMD64; GRUB artifact validation pending |
| 32-bit to 64-bit bootstrap | Source compiled; runtime validation pending |
| Temporary 1 GiB identity map | Source added; not production VM |
| COM1 serial diagnostics | Source compiled; runtime validation pending |
| CPU vendor and long-mode capability reporting | Source added and compiled; runtime validation pending |
| Multiboot2 memory-map summary and framebuffer metadata | Source added and compiled; runtime validation pending |
| GRUB UEFI ISO recipe | Source added; image build pending |
| QEMU + OVMF smoke test | Automated; not yet run |
| Exceptions, IDT, allocator, scheduler, syscalls | Not implemented |
| Userland, services, drivers, desktop, installer | Not implemented |

A local compiler/linker smoke check passed for a reconstructed copy of the committed source snapshot using GCC 14.2.0 and GNU ld 2.44. The updated kernel, including CPUID vendor/long-mode reporting and Multiboot2 memory-map summary parsing, compiled and linked. The resulting ELF was ELF64 AMD64 with entry point 0x101000 and a 24-byte Multiboot2 header at file offset 0x1000; a separate byte-level check verified its checksum and end tag. See [the local compile report](audits/NATIVE-KERNEL-LOCAL-COMPILE-REPORT.md). This is not evidence of a repository checkout build or runtime boot.

## Verification policy

No successful compilation, ISO build, QEMU boot or hardware test is claimed until workflow logs and artifacts are inspected. The kernel intentionally halts after serial diagnostics; this is a bring-up milestone, not a usable desktop OS.

## Next kernel milestones

1. Run CI and repair build/UEFI boot failures.
2. Implement IDT, exception stubs and panic diagnostics.
3. Parse the full Multiboot2 memory map and reserve occupied regions.
4. Implement physical page allocation and virtual memory.
5. Add APIC/PIC handling, timer and interrupt-safe logging.
6. Add kernel threads and a preemptive scheduler.
7. Define a syscall ABI and user/kernel privilege transition.
8. Add init, IPC, VFS, device discovery and drivers.
