# NEXORA development image testing

## Current test target

The first image is a **live-session development image** for AMD64. The build configuration deliberately disables Debian Installer and does not yet ship a NEXORA disk installer. Do not use it to replace an existing operating system or install to a disk.

## 1. Verify the downloaded image

On Linux:

```bash
sha256sum live-image-amd64.hybrid.iso
```

Compare the result with the SHA-256 printed by the build job or build script. Do not boot an image whose digest does not match.

## 2. Test in a virtual machine first

Create a new VM with:
- Architecture: x86-64 / AMD64
- Firmware: test UEFI first; test legacy BIOS separately if your hypervisor supports it
- RAM: 4 GB minimum, 8 GB recommended
- CPUs: 2 or more
- Disk: no virtual disk is required for a live-only test; if one is attached, do not select an installer
- Network: NAT initially

Attach the ISO as a virtual optical disk and boot it. Use a disposable VM; do not pass through host disks.

## 3. Record these results

- Does the boot menu appear?
- Does the live kernel start without panic?
- Does SDDM appear and can you enter the desktop?
- Does Plasma start in X11 or Wayland as expected by the selected session?
- Does the display resolution change correctly?
- Do keyboard, mouse, audio, network, USB and file manager work?
- Does **NEXORA System Information** open and report the correct release and architecture?
- Does shutdown and reboot work?

## 4. Physical hardware testing

Only after VM testing, use a spare USB drive and a non-production machine. Confirm the target machine's boot mode and make a full backup first. Never write the ISO to an internal system disk. Test Wi-Fi, Ethernet, Bluetooth, graphics, audio, suspend/resume, touchpad, printers and external displays individually.

## 5. Report failures

For each issue, record:
- ISO SHA-256
- machine or VM model and firmware mode
- exact steps to reproduce
- expected and actual result
- relevant output from `journalctl -b`, `dmesg`, or `inxi -Fxxxz`

Do not include passwords, access tokens, serial numbers, or other private identifiers in reports.

## Not yet covered

Disk installation, partitioning, Secure Boot signing, encrypted install, system upgrades, recovery, persistence, release signing, and physical-hardware certification are not implemented or validated by this initial image.
