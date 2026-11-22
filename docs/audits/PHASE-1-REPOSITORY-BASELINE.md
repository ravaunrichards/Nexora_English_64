# NEXORA English x64 — Phase 1 Repository Baseline

**Audit date:** 2026-11-21  
**Repository:** https://github.com/ravaunrichards/Nexora_English_64  
**Inspected ref:** `main`  
**Baseline commit:** `d49c49ced45f93f6ad2d1b8c3a0c4dc549dff32f`  
**Development branch:** `nexora/development` (created from the baseline commit)

## 1. Repository access and Git baseline

- Repository is public and accessible.
- GitHub connection reports administrative, maintain, pull, and push permissions.
- Default branch at inspection: `main`.
- Branches returned by GitHub at inspection: `main` only.
- Recursive Git tree response: 2,061 entries, not truncated.
- Tree composition: 1,875 file entries and 186 directory entries.
- GitHub repository size metadata: 52,347 KB (GitHub-reported repository size; not a working-copy measurement).
- A separate development branch, `nexora/development`, was created at the inspected baseline SHA. The original `main` branch was not changed by this audit.

## 2. Verified repository structure

Top-level entries:

- `autorun.inf`
- `boot/`
- `bootmgr`
- `bootmgr.efi`
- `efi/`
- `setup.exe`
- `sources/`
- `support/`

The recursive tree is dominated by Windows installation-media paths, including:

- `boot/` and Windows boot resources
- `efi/boot/` and `efi/microsoft/boot/`
- `sources/dlmanifests/`
- `sources/etwproviders/`
- `sources/inf/`
- `sources/migration/`
- `sources/replacementmanifests/`
- `sources/sxs/`
- `support/logging/`

The tree includes 1,875 files. Common extensions include .manifest (746), .man (526), .dll (170), .mui (66), .resx (45), .aspx (33), .ttf (32), .exe (26), .browser (25), and .inf (23).

## 3. Source/content inspection performed

The following text files were fetched and read:

- `autorun.inf`
- `sources/inf/setup.cfg`
- `sources/migration/wtr/adminpack_en-us.inf`
- `sources/migration/wtr/adobe_flash.inf`
- `sources/migration/wtr/ftp_7.0.inf`
- `sources/migration/wtr/gwxmig.inf`
- `sources/migration/wtr/powershell_en-us_noloc.inf`
- `sources/migration/wtr/webdav_7.0.inf`

The migration INF files identify Windows-specific migration registrations and paths for IIS Administration Pack, Adobe Flash ActiveX, IIS FTP, GWX, the IIS PowerShell snap-in, and IIS WebDAV. These are Windows migration metadata, not Linux implementations of those features.

The setup configuration enumerates Windows setup and compatibility components. The autorun file launches Windows Setup executables.

## 4. Initial technical assessment

**Verified:** The current tracked tree is a Windows installation-media-style repository, not a recognizable Ubuntu/KDE Linux distribution source tree.

No Linux distribution build system, kernel source tree, Debian packaging metadata, Ubuntu live-build configuration, Calamares configuration, KDE Plasma source integration, or Linux CI workflow was identified in the inspected tree inventory.

No README, LICENSE, Makefile, CMake project, Python project manifest, Cargo manifest, shell build script, or GitHub Actions workflow appeared in the inspected filename inventory. This is an inventory observation, not proof that no undocumented build procedure exists outside the tracked tree.

The directory naming includes Windows component version identifiers such as `10.0.10586.0`, consistent with Windows 10 version 1511-era installation components. Exact media provenance and licensing have not yet been independently established.

## 5. Compatibility and preservation findings

- Existing Windows boot executables, EFI binaries, DLLs, manifests, fonts, and setup components must not be assumed reusable in NEXORA.
- Do not copy, redistribute, modify, or ship Microsoft or third-party proprietary binaries until provenance and redistribution rights are verified.
- Preserve the source branch and historical commits. Do not mass-delete the existing Windows installation files.
- Treat the AdminPack, Flash, FTP, GWX, PowerShell, and WebDAV INF files as reference evidence only. Reimplement desired capabilities using supported Linux technologies and independently licensed software.
- Adobe Flash is obsolete and must not be reintroduced as a runtime dependency.

## 6. Outstanding Phase 1 work

This is a **partial baseline**, not a completed full source audit. The following remain outstanding:

1. Inspect all 2,061 tree entries in categorized inventories and preserve a machine-readable inventory.
2. Read all relevant text source/configuration files beyond the initial sample.
3. Identify and fingerprint binary formats, versions, publishers, and licensing evidence where technically possible.
4. Review the full commit history and all branches/tags, not only the recent commit sample and branch listing.
5. Inspect GitHub Actions, releases, tags, issues, and repository settings where available.
6. Determine whether any source material exists outside the current default branch.
7. Produce a complete dependency, provenance, licensing, and risk register.

## 7. Execution constraints

The GitHub connector can inspect and modify repository Git objects and text files, but it does not provide a local Linux build host, package installation, QEMU/KVM execution, ISO boot testing, or physical hardware access. Those validation activities require an external build runner or a connected development environment. No build, boot, installation, or hardware test is claimed as completed by this audit.

## 8. Baseline status

| Area | Status |
|---|---|
| Repository access | Verified |
| Default branch and baseline SHA | Verified |
| Recursive tree inventory | Verified; 2,061 entries |
| Development branch | Created |
| Initial text-file review | Partial |
| Full source review | Pending |
| Full commit/tag/history review | Pending |
| Licensing/provenance review | Pending |
| Linux OS implementation | Not yet present/verified |
| Build and boot tests | Not run |

**Next action:** Complete the source/provenance inventory, then define a safe migration strategy that retains the original Windows-media history while introducing a reproducible Ubuntu/KDE-based NEXORA build system on the development branch.
