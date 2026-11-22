# NEXORA English x64 — Complete tracked-tree inventory and audit

**Repository:** https://github.com/ravaunrichards/Nexora_English_64  
**Branch inspected:** `nexora/development`  
**Tree commit:** `9d49729b6b91edadd7e7d52613768fd57aae727b`  
**Recursive tree response:** complete; GitHub returned `truncated: false`.

## Coverage

This inventory records every path returned by the recursive Git tree, including directory entries and files. It includes each Git object type, file mode, byte size (for blobs), and Git object SHA. The machine-readable row-by-row inventory is in [NEXORA-ENGLISH-X64-TREE-INVENTORY.csv](NEXORA-ENGLISH-X64-TREE-INVENTORY.csv).

- Total tracked tree entries: **2093**
- Files (blobs): **1891**
- Directories (trees): **202**
- Total tracked file bytes: **171164920**
- Tree SHA: **9d49729b6b91edadd7e7d52613768fd57aae727b**

## Top-level inventory

| Root path | Files | Directories | Tracked bytes |
|---|---:|---:|---:|
| `.github` | 1 | 2 | 996 |
| `README.md` | 1 | 0 | 1735 |
| `autorun.inf` | 1 | 0 | 128 |
| `boot` | 24 | 4 | 17498908 |
| `bootmgr` | 1 | 0 | 400228 |
| `bootmgr.efi` | 1 | 0 | 1147736 |
| `docs` | 5 | 3 | 14889 |
| `efi` | 24 | 6 | 20246492 |
| `nexora-linux` | 7 | 10 | 2753 |
| `scripts` | 2 | 1 | 3464 |
| `setup.exe` | 1 | 0 | 271040 |
| `sources` | 1792 | 173 | 131162937 |
| `support` | 31 | 3 | 413614 |

## What the repository actually contains

The root is still predominantly a Windows installation-media tree:
- `autorun.inf`, `bootmgr`, `bootmgr.efi`, `setup.exe`, `boot/`, `efi/`, `sources/`, and `support/`.
- `sources/` contains 1,792 files and 173 directories, including Windows setup, migration, servicing, side-by-side assembly, manifests, DLLs, MUI resources, and compatibility metadata.
- The largest structured areas include `sources/sxs/`, `sources/dlmanifests/`, and `sources/replacementmanifests/`.
- `boot/` and `efi/` contain Windows boot manager, EFI boot, BCD, fonts, memory-test, and resource files.
- `sources/migration/wtr/` contains Windows migration metadata for IIS AdminPack, Adobe Flash ActiveX, IIS FTP, GWX, IIS PowerShell snap-in, and WebDAV. These INF files do not implement equivalent Linux services.
- `nexora-linux/` contains a small Ubuntu live-image configuration, two package lists, OS identity overlays, and a system-info utility.
- `scripts/` contains the live ISO build script and a source-check script.
- `.github/workflows/` contains one manual live ISO workflow.
- `docs/` contains build, testing, roadmap, architecture, and prior baseline audit documents.

## Text/configuration files actually read in this pass

Read directly from the inspected branch:
- Root README and `autorun.inf`
- `sources/inf/setup.cfg`
- Windows migration INF files: AdminPack (localized and nonlocalized), Adobe Flash, FTP 7.0 and 7.5, GWX, IIS PowerShell, WebDAV 7.0 and 7.5
- `sources/uninstall.xml`, `sources/uninstall_data.xml`, `sources/upgrade_bulk.xml`, `sources/upgrade_data.xml`, `sources/upgrade_frmwrk.xml`, `sources/upgradeagent.xml`, `sources/wicadevicefilters.xml`
- NEXORA package lists, OS release metadata, NEXORA Linux README
- Build and source-check scripts
- Build, test, roadmap, architecture, and previous audit documentation

**Important limitation:** This is a complete tracked-path and Git-object inventory, not a claim that every byte of every binary has been reverse-engineered or that every one of the 1,891 file payloads has been individually reviewed. Binary files require format-specific parsing, version/signature extraction, provenance and license checks. The remaining text payloads (including the many hundreds of Windows manifests) still need a systematic content scan. The CSV ensures no tracked path is silently omitted from follow-up review.

## Critical findings

1. **The repository is not currently a native Linux OS source tree.** It is a Windows setup-media collection with a small Linux live-build project added alongside it.
2. **The Linux build target is a live session only.** The live-build config disables Debian Installer; there is no NEXORA disk installer, partitioner flow, installed-system upgrade path, or recovery system.
3. **Architecture documentation mismatch:** the architecture document names `live-boot` and `live-config`, while the current core package list selects Ubuntu `casper`. The docs need to be corrected to match the actual package selection and boot flow.
4. **Boot path remains unverified:** the build script selects GRUB and uses `boot=casper`, but there is no recorded ISO build/boot test result for UEFI or legacy BIOS.
5. **The Windows migration INF files are not Linux implementations.** They are declarative migration records for Windows registry paths, Windows system directories, GAC assemblies and IIS services.
6. **Adobe Flash must not be reintroduced.** The INF is a legacy Windows migration record; Flash/ActiveX is obsolete and unsafe. Do not turn this into a Linux runtime package.
7. **Proprietary-binary risk:** the tree contains large numbers of Windows executables, DLLs, EFI binaries, fonts, and localized resources. No complete publisher, signature, provenance, or redistribution-license report has been established.
8. **Source-check coverage is narrow.** It checks a handful of expected Linux files, shell syntax, and Flash/ActiveX strings only under the Linux config; it does not validate all package names, YAML, XML, manifests, binary signatures, or build/boot behavior.
9. **No feature-completion evidence:** most roadmap areas remain in progress or not started; no successful ISO build, VM boot, physical hardware test, or install test is recorded.

## Immediate technical corrections required

- Correct the architecture documentation so the live initramfs description matches Ubuntu Casper.
- Add automated syntax/structure checks for YAML, XML, shell scripts, package lists, and required overlay files.
- Generate a content-level inventory for all text/configuration files and a binary fingerprint/provenance register for executable and library payloads.
- Separate Windows legacy input from the Linux distribution in a documented archival boundary; preserve original Git history.
- Implement and test the installer, installed-system boot, upgrade/recovery, security, hardware, and user-facing desktop features before claiming a complete OS.

## Validation boundary

The GitHub tree confirms the exact tracked paths and object metadata at the commit above. This audit does not claim execution of the build script, package installation, QEMU/KVM boot, physical hardware tests, or binary malware analysis.
