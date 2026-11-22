# NEXORA English x64 — 16-phase development roadmap

**Target:** Independent NEXORA operating system for AMD64/x86-64.  
**Development branch:** nexora/development  
**Status policy:** Source added is not the same as built; built is not the same as booted; booted in QEMU is not hardware certification.

| Phase | Required scope | Current status |
|---|---|---|
| 1 | Complete repository inspection, file inventory, binary provenance, component reuse, risk and licensing audit | **Partially complete** — tracked paths inventoried; remaining payload-by-payload inspection, byte-level SHA-256, signatures and licensing evidence outstanding |
| 2 | Complete native NEXORA OS, kernel, boot, security, service, desktop, installer and developer architecture | **In progress** — architecture baseline and kernel bootstrap design recorded; detailed subsystem contracts remain |
| 3 | NEXORA-owned AMD64 kernel: entry, CPU setup, GDT/IDT, exceptions, memory, heap, threads, scheduler, syscalls, logging and hardware discovery | **In progress** — freestanding C/assembly bootstrap, temporary first-GiB identity map, CPU feature reporting, Multiboot2 memory-map summary, IDT and exception stubs added; local reconstructed source compile/link smoke passed; repository CI and runtime boot unverified |
| 4 | Bootloader, UEFI startup, kernel loading/handoff, recovery entries and diagnostics | **In progress** — GRUB 2 / Multiboot2 configuration and ISO recipe added; GRUB validation, ISO build and UEFI/QEMU boot not yet verified |
| 5 | NEXORA core services: init, service/device/account/session/permission managers, configuration, logging, time, storage, VFS, IPC, diagnostics and power | **Planned** |
| 6 | NEXORA Desktop and NEXORA Classic shells, window management, launcher, taskbar, notifications, accessibility and input | **Planned** |
| 7 | NEXORA system applications: settings, file manager, terminal, task/device/network/disk managers, software/update/security/backup/recovery and utilities | **Planned** |
| 8 | Hardware abstraction and drivers: AMD/Intel CPU, PCIe, USB, SATA/AHCI, NVMe, input, display, graphics, audio, Ethernet, Wi-Fi, Bluetooth, printers and ACPI | **Planned** |
| 9 | Networking: TCP/IP, IPv4/IPv6, DNS, DHCP, Ethernet, Wi-Fi, Bluetooth, firewall, VPN, diagnostics, sharing, remote access, SSH, FTP, SFTP and WebDAV | **Planned** |
| 10 | Administration and advanced tools: AdminPack capability analysis, PowerShell interoperability research, FTP/WebDAV, deployment, migration, user/device/network/storage administration and recovery | **Planned** — legacy INF files are reference metadata, not working implementations; Flash/ActiveX excluded |
| 11 | Virtualization and developer platform: hypervisor strategy, virtual disks/networks, containers, compilers, debugger, Git, SDK, APIs and build automation | **Planned** |
| 12 | Audio, video and multimedia: audio drivers/routing, codecs, playback, recording, capture, metadata and media applications | **Planned** |
| 13 | Graphics and gaming: GPU drivers, 2D/3D interfaces, Vulkan evaluation, display management, controllers, compatibility and performance tools | **Planned** |
| 14 | Security and privacy: isolation, accounts, ACLs, secure services, firewall, app permissions, signed packages/updates, encryption, audit and vulnerability response | **Planned** |
| 15 | Installer, deployment and recovery: bootable media, partitioning, filesystems, system deployment, boot entries, first run, repair, backup, restore, upgrade and rollback | **Planned** |
| 16 | Package manager, software ecosystem, signed repositories, dependency resolution, update delivery, SDK, documentation portal, CI/CD, releases and long-term maintenance | **Planned** |

## Immediate execution order

1. Run the new native kernel build in GitHub Actions and inspect every job log.
2. Repair compile, link, GRUB, ISO or UEFI boot failures before adding dependent kernel features.
3. Implement IDT, exception stubs, panic reporting and CPU feature detection.
4. Parse the full Multiboot2 memory map and reserve kernel/bootloader memory.
5. Implement physical page-frame allocation, virtual memory and kernel heap.
6. Add APIC/PIC handling, timer, interrupt-safe logging, kernel threads and scheduling.
7. Define a stable syscall ABI, privilege transition, init and first user process.
8. Add device model, PCI enumeration, storage, VFS and basic filesystems.
9. Add networking, graphics, input, audio and additional drivers.
10. Build core services, applications, desktop sessions, installer, package manager and recovery.
11. Add virtualization, multimedia, gaming, security hardening and compatibility only after their foundations are testable.

## Phase acceptance gates

A phase is not complete merely because a folder, design, document or configuration file exists. Every phase requires:

- Committed source and configuration.
- Reproducible dependency/toolchain records.
- Build and static checks appropriate to the component.
- Runtime tests on the intended target, QEMU first where practical.
- Logs, hashes, test results, known limitations and review evidence.
- No unresolved critical failure in a prerequisite subsystem.

## Preservation and safety rules

- Continue on nexora/development; preserve main.
- Preserve supplied Windows installation-media files and repository history until a documented disposition exists.
- Do not treat Windows executables, DLLs, EFI binaries or migration INF files as source code for NEXORA.
- Do not redistribute proprietary or unverified binaries.
- Do not bundle Adobe Flash or unsafe ActiveX runtimes.
- Keep the previous nexora-linux live-image experiment isolated; it is not the native NEXORA kernel.
- A local compiler smoke check is not a repository CI pass. An ELF artifact is not an ISO. An ISO is not proof of boot. A QEMU boot is not hardware certification.
