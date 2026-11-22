# NEXORA Linux architecture — implementation baseline

## Platform

| Layer | Initial implementation |
|---|---|
| Distribution base | Ubuntu 24.04 LTS (Noble), official Ubuntu archives |
| CPU | AMD64 / x86-64 |
| Kernel | Ubuntu `linux-image-generic` metapackage |
| Init and services | systemd |
| Live environment | live-boot and live-config |
| Desktop | KDE Plasma |
| Display manager | SDDM |
| Network | NetworkManager, BlueZ |
| Storage utilities | udisks2, e2fsprogs, btrfs-progs, cryptsetup, LVM2 |
| Image format | hybrid ISO, intended for UEFI and legacy BIOS boot |
| Build tooling | Debian live-build in Ubuntu mode |

## Repository separation

The original root-level Windows setup media is retained as legacy input. Linux distribution source and packaging live under `nexora-linux/`; build automation lives under `scripts/`. This avoids mixing Windows migration metadata with the Linux root filesystem.

## Boot flow target

Firmware → GRUB (UEFI or BIOS path) → Linux kernel + initramfs → live-boot root filesystem → systemd → SDDM → KDE Plasma session.

The exact boot path must be confirmed on real UEFI and BIOS virtual machines. The configuration is not a certification of Secure Boot compatibility.

## Desktop policy

The initial desktop uses upstream KDE Plasma and Ubuntu packages. NEXORA branding is introduced through release metadata and a small system-information utility. Further shell layout, theme, wallpaper, settings integration, and NEXORA Classic mode require separate implementation and visual/hardware testing.

## Security policy

- Use Ubuntu-signed repository metadata and package archives.
- Do not bundle proprietary Windows binaries without a verified redistribution license.
- Do not restore Adobe Flash or ActiveX components.
- Keep Secure Boot claims disabled until the boot chain is tested and signing requirements are met.
- Do not ship default administrative passwords or hard-coded credentials.
- Treat the live image as disposable; no persistence or disk installer is promised.

## Known gaps

This baseline does not yet implement a NEXORA installer, upgrade service, recovery system, software store, account/cloud service, AI agent, custom kernel, custom driver stack, Hyper-V guest integration, gaming stack, or full admin/developer suite. These are tracked in the roadmap and must be built and tested individually.
