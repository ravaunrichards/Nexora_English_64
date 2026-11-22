#!/usr/bin/env bash
set -Eeuo pipefail
iso="${1:-build/native/nexora-native-amd64.iso}"
log="${2:-build/native/qemu-serial.log}"
[[ -s "$iso" ]] || { echo "FAIL: missing ISO: $iso" >&2; exit 1; }
command -v qemu-system-x86_64 >/dev/null
ovmf_code="${OVMF_CODE:-}"
if [[ -z "$ovmf_code" ]]; then
  for candidate in /usr/share/OVMF/OVMF_CODE_4M.fd /usr/share/OVMF/OVMF_CODE.fd /usr/share/edk2/ovmf/OVMF_CODE.fd; do
    if [[ -r "$candidate" ]]; then ovmf_code="$candidate"; break; fi
  done
fi
[[ -r "$ovmf_code" ]] || { echo "FAIL: OVMF firmware not found; set OVMF_CODE." >&2; exit 1; }
mkdir -p "$(dirname "$log")"
rm -f "$log"
set +e
timeout 20s qemu-system-x86_64 -machine q35 -cpu qemu64 -m 1G -bios "$ovmf_code" -cdrom "$iso" -boot d -display none -monitor none -serial "file:$log" -no-reboot -no-shutdown
status=$?
set -e
if [[ $status -ne 0 && $status -ne 124 ]]; then
  echo "FAIL: QEMU exited with status $status" >&2
  cat "$log" 2>/dev/null || true
  exit "$status"
fi
grep -q "NEXORA: entered 64-bit long mode" "$log" || { echo "FAIL: long-mode marker missing" >&2; cat "$log" 2>/dev/null || true; exit 1; }
grep -q "NEXORA: bootstrap complete" "$log" || { echo "FAIL: bootstrap completion marker missing" >&2; cat "$log" 2>/dev/null || true; exit 1; }
echo "PASS: kernel booted under QEMU/OVMF and emitted expected serial markers."
