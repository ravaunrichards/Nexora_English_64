#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  "nexora-linux/config/package-lists/nexora-core.list.chroot"
  "nexora-linux/config/package-lists/nexora-desktop.list.chroot"
  "nexora-linux/config/includes.chroot/etc/os-release"
  "nexora-linux/config/includes.chroot/usr/local/bin/nexora-system-info"
  "scripts/build-iso.sh"
)
for path in "${required[@]}"; do
  [[ -s "${ROOT}/${path}" ]] || { printf 'FAIL missing/empty: %s\n' "$path" >&2; exit 1; }
done
bash -n "${ROOT}/scripts/build-iso.sh"
bash -n "${ROOT}/scripts/check-source.sh"
bash -n "${ROOT}/nexora-linux/config/includes.chroot/usr/local/bin/nexora-system-info"
if grep -RniE 'adobe.?flash|activex' "${ROOT}/nexora-linux/config" --exclude='*.md'; then
  printf '%s\n' "FAIL: obsolete Flash/ActiveX references found in Linux image configuration." >&2
  exit 1
fi
printf '%s\n' "PASS: required source files exist and shell scripts parse."
printf '%s\n' "NOTE: this check does not build or boot the ISO."
