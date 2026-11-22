#!/usr/bin/env bash
set -Eeuo pipefail
kernel="${1:-build/native/nexora-kernel.elf}"
[[ -s "$kernel" ]] || { echo "FAIL: missing kernel: $kernel" >&2; exit 1; }
command -v grub-file >/dev/null
command -v readelf >/dev/null
grub-file --is-x86-multiboot2 "$kernel"
readelf -h "$kernel" | grep -q 'Class:.*ELF64'
readelf -h "$kernel" | grep -q 'Machine:.*Advanced Micro Devices X86-64'
readelf -s "$kernel" | grep -q 'kernel_main'
readelf -s "$kernel" | grep -q 'isr_stub_table'
readelf -s "$kernel" | grep -q 'nexora_exception_handler'
echo "PASS: ELF64 AMD64 kernel and Multiboot2 header validated."
echo "NOTE: static artifact validation is not a runtime boot test."
