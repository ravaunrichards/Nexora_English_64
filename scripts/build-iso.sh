#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/nexora-linux"
BUILD_DIR="${REPO_ROOT}/build/nexora-live-build"
ISO_PATH="${BUILD_DIR}/live-image-amd64.hybrid.iso"

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ -d "${SOURCE_DIR}/config/package-lists" ]] || fail "NEXORA Linux configuration not found."
[[ "$(dpkg --print-architecture 2>/dev/null || true)" == "amd64" ]] || fail "Build on an AMD64 Ubuntu host."
[[ -r /etc/os-release ]] || fail "Cannot identify build host."
. /etc/os-release
[[ "${ID:-}" == "ubuntu" ]] || fail "Build host must be Ubuntu 24.04."
[[ "${VERSION_ID:-}" == "24.04" ]] || fail "Build host must be Ubuntu 24.04 LTS (Noble)."

if [[ "${EUID}" -ne 0 ]]; then
  command -v sudo >/dev/null 2>&1 || fail "Run as root or install sudo."
  exec sudo --preserve-env=DEBIAN_FRONTEND bash "$0" "$@"
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  live-build debootstrap squashfs-tools xorriso \
  grub-pc-bin grub-efi-amd64-bin mtools dosfstools \
  isolinux syslinux-common ca-certificates rsync

# Guard the cleanup target so this script never removes an arbitrary path.
[[ "${BUILD_DIR}" == "${REPO_ROOT}/build/nexora-live-build" ]] || fail "Unsafe build directory."
mkdir -p "${REPO_ROOT}/build"
rm -rf -- "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cp -a "${SOURCE_DIR}/config" "${BUILD_DIR}/config"
cd "${BUILD_DIR}"

lb config \
  --mode ubuntu \
  --distribution noble \
  --architectures amd64 \
  --archive-areas "main restricted universe multiverse" \
  --binary-images iso-hybrid \
  --bootloaders "grub-efi grub-pc" \
  --debian-installer false \
  --apt-recommends true \
  --iso-application "NEXORA English x64" \
  --iso-publisher "NEXORA Project" \
  --iso-volume "NEXORA_ENGLISH_X64" \
  --bootappend-live "boot=live components hostname=nexora username=nexora" \
  --mirror-bootstrap "http://archive.ubuntu.com/ubuntu/" \
  --mirror-chroot "http://archive.ubuntu.com/ubuntu/" \
  --mirror-binary "http://archive.ubuntu.com/ubuntu/" \
  --mirror-chroot-security "http://security.ubuntu.com/ubuntu/" \
  --mirror-binary-security "http://security.ubuntu.com/ubuntu/"

lb build

[[ -s "${ISO_PATH}" ]] || fail "live-build finished without the expected ISO: ${ISO_PATH}"
printf '\nBuild output: %s\n' "${ISO_PATH}"
printf 'SHA256: '
sha256sum "${ISO_PATH}"
