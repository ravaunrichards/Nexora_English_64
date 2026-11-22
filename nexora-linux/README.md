# NEXORA Linux image source

This directory contains the active Ubuntu-based Linux distribution configuration. It is intentionally separate from the legacy Windows media files at repository root.

## Current build target

- Ubuntu 24.04 LTS (Noble)
- AMD64 / x86-64
- Linux generic kernel from Ubuntu archive
- KDE Plasma desktop and SDDM
- NetworkManager for network management
- live-build for a hybrid BIOS/UEFI live ISO

The first image is a live-session development image. It does not yet provide a supported disk installer, upgrade path, recovery environment, or release-grade secure-boot validation.

Package selections are in `config/package-lists/`; filesystem overlays are in `config/includes.chroot/`.
