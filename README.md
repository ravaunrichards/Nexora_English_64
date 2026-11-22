# NEXORA English x64

NEXORA is being developed as an Ubuntu-based, 64-bit desktop operating system with KDE Plasma.

## Repository status

The original repository contains Windows installation-media files. Those files are preserved unchanged as historical input; they are not a Linux kernel, Linux distribution source tree, or a working NEXORA installer. Active Linux development is isolated under [`nexora-linux/`](nexora-linux/).

The first implementation target is a bootable Ubuntu 24.04 LTS (Noble) live desktop image for AMD64. This is a development baseline, not a claim that every planned operating-system feature is complete.

## Build

On a clean Ubuntu 24.04 AMD64 machine with internet access:

```bash
git clone https://github.com/ravaunrichards/Nexora_English_64.git
cd Nexora_English_64
git switch nexora/development
bash scripts/check-source.sh
bash scripts/build-iso.sh
```

The ISO is written to `build/nexora-live-build/live-image-amd64.hybrid.iso`. See [building](docs/BUILDING.md) and [testing](docs/TESTING.md).

## Development rules

- Preserve the existing repository history and legacy files.
- Build in the `nexora/development` branch until the owner approves a release.
- Prefer supported Ubuntu packages over copied proprietary Windows binaries.
- Do not reintroduce Adobe Flash; it is obsolete and unsafe.
- Mark a feature complete only after implementation and recorded test evidence.
- Never describe an image as installable unless an installer has actually been integrated and tested.

## Architecture and progress

- [Linux architecture](docs/architecture/NEXORA-LINUX-ARCHITECTURE.md)
- [Development roadmap](docs/ROADMAP.md)
- [Baseline repository audit](docs/audits/PHASE-1-REPOSITORY-BASELINE.md)
