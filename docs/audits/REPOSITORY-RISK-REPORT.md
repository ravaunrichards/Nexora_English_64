# NEXORA repository risk report

**Assessment point:** 2026-11-21  
**Branch:** nexora/development

| Risk | Severity | Evidence / impact | Required mitigation |
|---|---|---|---|
| Proprietary Windows payload redistribution | Critical | Setup executables, DLLs, EFI binaries and fonts exist in legacy tree | Do not ship; verify provenance, signatures and redistribution rights per file |
| Obsolete Flash/ActiveX | Critical | Adobe Flash migration INF exists | Exclude runtime and all unsafe dependencies |
| Binary provenance incomplete | High | Byte-level SHA-256, publisher and signature results not established for all candidates | Complete binary register from downloaded payloads |
| Legacy media confused with OS source | High | Existing root is Windows installation-media structure | Keep legacy material separate and document all reuse decisions |
| Native kernel unverified | High | New bootstrap and CI workflow added; no build/boot result inspected yet | Run CI, inspect logs, repair failures and preserve artifacts |
| Temporary low-memory identity map | High | Initial bootstrap maps first 1 GiB only | Replace with complete physical-memory discovery and managed page tables |
| Bootloader dependency | Medium | GRUB supplies Multiboot2 handoff | Track version, package provenance, license and security updates |
| Toolchain reproducibility | Medium | CI currently installs Ubuntu repository toolchain packages | Pin exact package versions or container/toolchain digest and record versions |
| Test coverage narrow | High | Current tests validate ELF/Multiboot2 and serial boot marker only | Add unit, exception, memory, scheduler, integration and hardware tests |
| No install/recovery/update platform | High | Not implemented | Build only after kernel, storage, VFS and userspace foundations |

## Release blockers

- No proprietary or unknown legacy binary may be included in a public release.
- Native kernel build and QEMU boot must pass on a clean CI runner.
- Kernel boot tests must capture serial logs and artifact hashes.
- Security-sensitive components require review and tests before exposure.
- Installer, update, rollback and recovery features must not be advertised until implemented and tested.

## Current disposition

The native kernel source is a first engineering milestone, not a completed OS. All unverified legacy binaries remain reference-only. Do not delete original material or change main as part of this work.
