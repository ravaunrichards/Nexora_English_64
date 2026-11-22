# NEXORA English x64 — Native Operating-System Architecture

**Status:** Architecture baseline (proposed engineering specification)  
**Target:** Independent NEXORA OS for AMD64 / x86-64  
**Kernel direction:** NEXORA-owned freestanding kernel; not the Linux kernel and not the Windows NT kernel  
**Repository branch:** `nexora/development`

## 1. Product definition

NEXORA is to become an independently developed operating system with its own kernel, boot path, memory and process management, device model, system-call interface, services, desktop shell, system applications, installer, update system, and developer platform.

A bootloader, compiler, firmware interface, or selected third-party library may be used as a documented component. Those dependencies must remain replaceable and must not be represented as NEXORA-authored code. The kernel and NEXORA user-facing system are the project's own implementation.

## 2. Hardware and firmware baseline

### Initial supported target

- CPU architecture: AMD64 / x86-64.
- Firmware: UEFI first; legacy BIOS is a later compatibility target.
- Boot media: virtual disk and ISO/hybrid test media.
- Initial test platform: QEMU x86-64 with serial-console diagnostics.
- Initial memory model: 4 KiB pages; large-page support after baseline paging is stable.
- Initial storage target: virtual block device; NVMe and SATA/AHCI are later driver milestones.
- Initial display target: framebuffer supplied by the boot protocol; accelerated graphics are later milestones.

Hardware support must be capability-based and explicitly tested. A device appearing in a list is not evidence that its driver works.

## 3. Kernel design

The first kernel is a small, freestanding, monolithic kernel with strict subsystem boundaries. This keeps the initial implementation achievable while allowing later components to move behind stable interfaces.

### Kernel responsibilities

1. Boot handoff and early platform discovery.
2. CPU feature detection and exception handling.
3. Physical and virtual memory management.
4. Kernel heap and allocation diagnostics.
5. Interrupt descriptor table and programmable interrupt controller / APIC support.
6. Timer and scheduler foundations.
7. Kernel threads and process/address-space foundations.
8. System-call boundary and user/kernel privilege separation.
9. Device and driver framework.
10. Virtual filesystem interface and initial in-memory filesystem.
11. Logging, panic handling, crash diagnostics, and tracing.

### Implementation language policy

- C (freestanding, fixed language standard) for the initial kernel core.
- x86-64 assembly only for boot entry, context/interrupt transitions, and CPU-specific operations.
- Rust may be evaluated for isolated components after the ABI, allocator, and toolchain are stable; it is not a prerequisite for the first boot milestone.
- No hosted standard-library assumptions in kernel code.
- Compiler, linker, flags, and binary format must be pinned and recorded.

## 4. Boot architecture

The current bring-up implementation uses GRUB 2 with the Multiboot2 protocol. GRUB is a third-party loader, not NEXORA kernel code. The Multiboot2 entry arrives in 32-bit protected mode; NEXORA assembly creates a temporary first-GiB identity map, enables long mode and calls the freestanding C kernel entry. GRUB/Multiboot2 dependency versions and licenses must be recorded and pinned for reproducible releases. Limine remains a candidate for later evaluation, not the currently implemented loader.

Boot sequence target:

1. UEFI firmware initializes hardware and selects the NEXORA boot entry.
2. GRUB loads the NEXORA ELF kernel using Multiboot2.
3. GRUB supplies Multiboot2 information, including available memory-map and framebuffer tags.
4. NEXORA assembly transitions from protected mode to 64-bit long mode using temporary bootstrap page tables.
5. The freestanding kernel validates the handoff and emits COM1 serial diagnostics.
6. The current bootstrap halts safely; production page tables, exceptions, interrupts, timer and allocator remain future milestones.

Secure Boot signing, measured boot, recovery entries, and bootloader updates require dedicated later design and testing. Do not claim Secure Boot support until signed boot artifacts are verified on real UEFI systems.

## 5. System layers

| Layer | NEXORA-owned responsibility |
|---|---|
| Firmware boundary | UEFI discovery and boot handoff |
| Boot layer | Boot configuration, module loading, recovery selection |
| Kernel | CPU, memory, interrupts, scheduler, processes, syscalls |
| Driver layer | Storage, USB, input, display, audio, network, PCI |
| Core services | VFS, device manager, service manager, IPC, logging |
| Userland runtime | C runtime, libraries, shell, process tools |
| Desktop | NEXORA Desktop and NEXORA Classic session |
| Applications | Settings, file manager, terminal, task manager, admin tools |
| Platform | Package manager, signed updates, software catalog, developer SDK |
| Deployment | Installer, partitioning, recovery, upgrade, rollback |

Each layer requires a documented interface and tests before dependent work is treated as complete.

## 6. Desktop and user experience

The desktop is a NEXORA product, not a requirement to copy KDE or Windows. Design goals:

- NEXORA Desktop: modern, accessible, keyboard- and touch-capable shell.
- NEXORA Classic: compact, familiar desktop workflow.
- Consistent settings, notifications, search, task switching, file management, and system status.
- Explicit accessibility, localization, high-DPI, and input-device support.
- Theme and branding assets separated from privileged system services.

The desktop must run as userland software over documented NEXORA system interfaces. It must not be mistaken for the kernel.

## 7. Core services and applications

Planned services include account/session management, service supervision, device discovery, networking, audio, printing, time synchronization, logging, security policy, software installation, updates, backup, recovery, and remote access.

Planned system applications include:

- NEXORA Settings
- NEXORA File Manager
- NEXORA Terminal and command shell
- NEXORA Task and Process Manager
- NEXORA Device Manager
- NEXORA Network Manager
- NEXORA Software Center and Package Manager
- NEXORA Security Center
- NEXORA Backup and Recovery
- NEXORA System Information and Diagnostics
- NEXORA Administration Toolkit

PowerShell compatibility, FTP, WebDAV, virtualization, gaming, multimedia, and developer tooling are separate product capabilities. Their presence in old Windows migration metadata does not implement those capabilities in NEXORA.

## 8. Supplied repository material: classification and reuse rules

The existing repository is predominantly Windows setup media. It is useful as an inventory of legacy components and requested capabilities, but it is not a kernel source tree.

| Existing material | Planned treatment |
|---|---|
| `boot/`, `efi/`, `bootmgr`, `bootmgr.efi` | Inspect boot formats, metadata, versions, signatures, and licenses; do not assume they can boot a NEXORA kernel |
| `sources/` setup binaries and DLLs | Inventory and identify; do not link into NEXORA kernel or redistribute without rights |
| `sources/inf/setup.cfg` | Use as a historical component manifest and capability clue |
| Migration INF files | Extract feature requirements; do not treat them as working implementations |
| AdminPack, FTP, WebDAV, PowerShell, GWX records | Translate desired capabilities into independent NEXORA specifications; assess compatibility and security |
| Adobe Flash migration record | Historical only; no bundled Flash/ActiveX runtime |
| Fonts, images, localization files | Review each asset's origin and license before reuse |
| Existing Linux live-image project | Retained as historical experiment; not the active architecture |

No original file is to be deleted or overwritten merely to make the repository look cleaner. Every proposed reuse or removal needs a path-level decision and provenance/license record.

## 9. Security baseline

- Kernel/user privilege separation from the first process milestone.
- Memory safety checks, bounds validation, and defensive parsing.
- Least-privilege service model.
- Signed package metadata and update payloads before public package distribution.
- Reproducible build records and artifact hashes.
- Secure defaults for firewall, remote access, and network services.
- No obsolete Flash/ActiveX runtime.
- Vulnerability reporting, security response, and update policy before production release.

## 10. Repository organization target

The following is the target layout for new NEXORA-authored components. It is additive; the existing Windows media tree remains intact until separately classified.

```text
Nexora_English_64/
├── boot/                         # Existing supplied boot media; preserve/classify
├── efi/                          # Existing supplied EFI material; preserve/classify
├── sources/                      # Existing supplied setup payload; preserve/classify
├── support/                      # Existing supplied support payload; preserve/classify
├── kernel/
│   ├── arch/x86_64/
│   │   ├── boot/
│   │   ├── cpu/
│   │   ├── interrupts/
│   │   └── mm/
│   ├── core/
│   ├── drivers/
│   ├── include/
│   └── mm/
├── bootloader/
│   ├── config/
│   └── modules/
├── userland/
│   ├── libc/
│   ├── init/
│   ├── shell/
│   ├── services/
│   └── apps/
├── desktop/
│   ├── nexora-desktop/
│   └── nexora-classic/
├── system/
│   ├── configuration/
│   ├── security/
│   ├── networking/
│   └── packaging/
├── installer/
├── sdk/
├── tests/
│   ├── unit/
│   ├── integration/
│   ├── boot/
│   └── hardware/
├── tools/
├── docs/
└── .github/workflows/
```

## 11. Build and verification gates

A milestone is complete only when its evidence is committed.

| Gate | Required evidence |
|---|---|
| Toolchain | Pinned compiler/linker versions; clean reproducible build |
| Kernel artifact | ELF format, architecture, sections, symbols, and linker map inspected |
| Emulator boot | QEMU reaches NEXORA kernel entry; serial log archived |
| CPU/interrupts | Exception and interrupt tests pass |
| Memory | Allocator, mapping, and fault tests pass |
| Userland | First user process starts with privilege separation |
| Storage | Filesystem and block-device tests pass |
| Networking | Loopback and protocol tests pass |
| Desktop | Session starts from installed userland; input/display tests pass |
| Installer | VM install, reboot, upgrade, rollback, and recovery tests pass |
| Release | Artifact hashes, provenance, licensing, security, and test report published |

No milestone may be marked passed solely because a source file exists or a workflow is configured.

## 12. Implementation sequence

1. Preserve and audit the supplied repository; establish the native architecture baseline.
2. Pin the cross-toolchain and dependency/license manifest.
3. Create the minimal x86-64 kernel, linker layout, boot protocol integration, and serial diagnostics.
4. Boot the kernel in QEMU under automated CI.
5. Add CPU exceptions, interrupts, physical memory manager, virtual memory, and heap.
6. Add timer, scheduler, kernel threads, and process model.
7. Add syscall ABI, user mode, init process, and shell.
8. Add device model, storage, VFS, and filesystem.
9. Add networking, audio, USB, graphics, and hardware drivers.
10. Add service manager, security model, and core utilities.
11. Build NEXORA Desktop and NEXORA Classic.
12. Add package manager, signed update system, installer, recovery, and developer SDK.
13. Expand compatibility, gaming, virtualization, multimedia, administration, and enterprise features.
14. Run hardware matrix, security review, performance profiling, and release qualification.

**Current status:** This document defines the engineering baseline. It does not claim that a NEXORA kernel, bootable ISO, installer, desktop, or driver stack has already been implemented.
