# NEXORA component reuse and disposition register

**Branch:** nexora/development  
**Status:** Preliminary classification; final reuse approval requires payload and license evidence.

| Component group | Existing material | Classification | Proposed disposition |
|---|---|---|---|
| Windows boot manager and EFI setup files | bootmgr, bootmgr.efi, boot/, efi/ | Proprietary/restricted or unknown pending provenance | Preserve as audit/reference material; do not ship in NEXORA |
| Windows setup engine | setup.exe and sources setup components | Proprietary/restricted or unknown | Do not treat as source code or redistribute |
| Windows DLLs and executables | sources/**/*.dll, *.exe | Unknown/proprietary pending signature and license review | No reuse until individually cleared |
| Windows manifests and INF files | sources/**/*.manifest, *.inf | Reference material; Windows-specific | Extract documented behavior only; do not mistake for implementation |
| AdminPack migration metadata | sources/migration/wtr/*adminpack*.inf | Reference material | Reimplement required admin functions using independently licensed components |
| Adobe Flash migration metadata | sources/migration/wtr/adobe_flash.inf | Legacy/unsafe reference | Explicitly exclude Flash/ActiveX runtime |
| FTP and WebDAV migration metadata | sources/migration/wtr/*ftp*.inf, *webdav*.inf | Reference material | Implement secure native protocol services only when needed |
| GWX migration metadata | sources/migration/wtr/gwxmig.inf | Legacy reference | No runtime reuse; document any migration behavior needed |
| PowerShell migration metadata | sources/migration/wtr/*powershell*.inf | Reference material | Research PowerShell runtime interoperability and licensing separately |
| Existing Ubuntu live-build configuration | nexora-linux/ | Adaptable experiment, not native OS | Keep isolated; do not describe as NEXORA-owned kernel |
| Native kernel bootstrap | kernel/ | NEXORA-owned source | Continue development; validate with CI/QEMU |
| GRUB 2 | bootloader/grub/grub.cfg and build dependencies | Third-party bootloader integration | Use under its applicable license; preserve attribution and dependency records |
| Build/test workflow | Makefile, tests/boot/, .github/workflows/nexora-native-kernel.yml | NEXORA project infrastructure | Maintain, test and pin dependency versions |

## Reuse gate

No third-party binary is approved for redistribution by this register. Before reuse, record the exact file path, byte-level SHA-256, detected format, architecture, version, publisher, signature result, source provenance, license text, redistribution permission and security review. If any required field is unknown, retain the file as reference only.
