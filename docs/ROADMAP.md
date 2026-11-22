# NEXORA English x64 — 16-phase native OS development roadmap

**Target:** Independent NEXORA operating system for AMD64/x86-64.  
**Kernel:** NEXORA-owned freestanding kernel; neither Linux nor Windows.  
**Status rule:** Planned means no implementation evidence yet. Implemented — untested means source exists but runtime behavior is unverified. Tested requires recorded, reproducible evidence.

| Phase | Scope | Current status |
|---|---|---|
| 1 | Complete repository inventory, content classification, binary fingerprints, provenance and licensing audit | **Partially complete** — full tracked-path inventory committed; payload-by-payload review, signatures and license evidence outstanding |
| 2 | NEXORA identity, repository boundaries, architecture and technical specifications | **In progress** — native architecture baseline committed; detailed subsystem specifications and asset audit outstanding |
| 3 | NEXORA kernel, AMD64 boot path, toolchain, linker layout and early core | **Planned** — no native kernel implementation or boot test yet |
| 4 | NEXORA Desktop and NEXORA Classic shell architecture and implementation | **Planned** |
| 5 | Core user applications: settings, file manager, terminal, task/process manager, device manager, diagnostics and recovery tools | **Planned** |
| 6 | Hardware discovery and drivers: CPU, PCI, storage, USB, display, input and power | **Planned** |
| 7 | Networking: Ethernet, Wi-Fi, TCP/IP, DNS, DHCP, Bluetooth, firewall, VPN, sharing, FTP, WebDAV and remote access | **Planned** |
| 8 | Administration framework, command shell, scripting, PowerShell interoperability research and legacy migration utilities | **Planned** — supplied migration INF files are reference metadata, not implementations; Flash/ActiveX runtime excluded |
| 9 | Virtualization, developer SDK, compilers, debugging, containers and development tools | **Planned** |
| 10 | Audio, video, codecs, media framework, capture and device routing | **Planned** |
| 11 | Graphics acceleration, GPU drivers, game input, controller support and gaming compatibility | **Planned** |
| 12 | Security architecture, privilege separation, accounts, permissions, encryption, secure updates, firewall and privacy controls | **Planned** |
| 13 | NEXORA platform ecosystem: package manager, software catalog, signed updates, account/cloud services and AI integration | **Planned** |
| 14 | Installer, partitioning, disk layout, boot entries, first-run setup, recovery and rollback | **Planned** |
| 15 | Reproducible build pipeline, CI, unit/integration tests, QEMU boot tests and hardware qualification | **Planned** — previous Linux live-image workflow is not evidence for the native OS |
| 16 | Documentation, release engineering, support, security response and long-term maintenance | **In progress** — audit and native architecture records exist; release system not implemented |

## Immediate execution order

1. Finish classifying the existing Windows setup-media files without deleting or overwriting them.
2. Establish a pinned AMD64 cross-toolchain and dependency/license manifest.
3. Implement a minimal NEXORA-owned kernel and bootloader handoff.
4. Build the kernel reproducibly and boot it in QEMU with serial diagnostics.
5. Add CPU exceptions, interrupts, memory management, timer, scheduler and kernel threads.
6. Establish user/kernel separation, system calls, init and a first user process.
7. Add device model, storage, VFS and basic filesystem.
8. Add networking, graphics, input, audio and additional hardware drivers.
9. Build core services and system applications.
10. Build the NEXORA Desktop and Classic sessions.
11. Add package management, secure updates, installer and recovery.
12. Expand compatibility, virtualization, gaming, multimedia and enterprise features.

## Phase completion gate

A phase is not complete merely because files or documentation were added. Each phase must include:

- Committed source and configuration changes.
- Build instructions and pinned dependencies.
- Automated checks appropriate to the phase.
- Runtime tests on the intended target (QEMU first, then physical hardware where relevant).
- Logs, test results, artifact hashes and known limitations.
- A clear owner-review point before destructive changes or release promotion.

## Repository safety rules

- Continue development on `nexora/development`; preserve `main`.
- Preserve supplied legacy files until a path-level classification and disposition decision exists.
- Do not treat proprietary Windows binaries as reusable source code.
- Do not bundle assets or binaries unless provenance and redistribution rights are established.
- Keep the previous `nexora-linux/` live-image experiment isolated and inactive; it is not the selected NEXORA architecture.
- Do not claim that NEXORA boots, installs, supports hardware, or is production-ready until tests demonstrate those claims.
