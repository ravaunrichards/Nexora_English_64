# NEXORA English x64

**NEXORA is an independent operating-system project for AMD64/x86-64.** Its goal is to develop a NEXORA-owned kernel, boot path, system services, desktop, installer, security model, and application platform.

NEXORA is not an Ubuntu respin, is not a renamed Windows installation, and does not use the Linux kernel as its operating-system core.

## Repository status

The repository currently contains a large Windows installation-media collection alongside project documentation and earlier experimental Linux live-image work. These existing files are retained as project input and historical material. They are **not** a native NEXORA kernel or complete operating system.

The complete tracked-path inventory is recorded in [the repository audit](docs/audits/NEXORA-ENGLISH-X64-COMPLETE-TREE-AUDIT.md) and [the machine-readable inventory](docs/audits/NEXORA-ENGLISH-X64-TREE-INVENTORY.csv). The inventory covers every tracked path; it does not claim every binary has been reverse-engineered or licensed for redistribution.

## Native architecture

The approved engineering direction is a NEXORA-owned, freestanding AMD64 kernel developed independently of Linux and Windows. A documented, replaceable bootloader may be used to load the kernel; using a boot protocol does not make the bootloader the NEXORA kernel.

Read [NEXORA Native OS Architecture](docs/architecture/NEXORA-NATIVE-OS-ARCHITECTURE.md) for the kernel strategy, subsystem boundaries, repository layout, build stages, and verification gates.

## Development principles

- Preserve the original repository history and all supplied files until each is classified and an explicit disposition is recorded.
- Develop on `nexora/development`; do not modify `main` without approval.
- Build NEXORA-owned components rather than relabeling another operating system.
- Reuse existing files only when their technical role, provenance, compatibility, and license are verified.
- Treat Windows setup executables, DLLs, EFI binaries, fonts, and manifests as untrusted legacy inputs until individually assessed.
- Do not copy proprietary Microsoft binaries into a redistributable NEXORA image without the necessary rights.
- Do not reintroduce Adobe Flash/ActiveX as a bundled runtime; it is obsolete and unsafe. Preserve its migration metadata for historical analysis only.
- Mark a feature complete only after implementation and reproducible test evidence.
- Never claim a bootable, installable, or production-ready OS until the corresponding build and tests pass.

## Current milestone

**Milestone 0 — repository preservation and native architecture definition.** The next implementation milestone is a minimal NEXORA-owned AMD64 kernel that boots in an emulator, prints diagnostic output, and has automated build/boot tests. This is a milestone target, not a claim that it already exists.

## Legacy and experimental material

- `boot/`, `efi/`, `bootmgr*`, `setup.exe`, `sources/`, and `support/`: supplied Windows setup-media material; inspect, classify, and preserve.
- `nexora-linux/` and its related live-image scripts/workflow: earlier experiment, not the selected NEXORA architecture. It is retained for history and is not the active build target.
- `docs/audits/`: tracked-tree and content-review records.
