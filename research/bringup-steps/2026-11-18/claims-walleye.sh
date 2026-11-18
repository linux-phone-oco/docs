#!/bin/sh
# walleye's claims as its own base will make them (item walleye-steps-claimed: tad r step in google-walleye-lab).
# Tried in a scratch copy of docs through a stand-in record (step-claim) that wrote step_status directly, as the
# feed will: with it bringup-chain-walleye.sh passes. Every run named is a record id in google-walleye-lab.
set -eu
k() { tad r step-claim --device google-walleye --updated 2026-11-18 "$@" >/dev/null; }
k --step bootloader-unlocked --status done --proof fastboot-unlocked --run google-walleye-bootloader-first-look
k --step stock-measured --status partial --proof android-reference --run android-reference-walleye-measured
k --step stock-facts-read --status done --proof stock-facts-recorded --run walleye-stock-ids-recorded
k --step slot-state-known --status done --proof slot-report --run walleye-load-error-first-state
k --step control-image-boots --status done --proof fastboot-boot-control --run walleye-try-vendor-gadget4
k --step boot-image-packs --status done --proof check-bootimg.sh --run walleye-bootimage
k --step dtbo-accepted --status done --proof tests/host/dtbo-overlay-merges.sh --run walleye-dtb-overlay-symbols-build
k --step initramfs-gadget-emulated --status done --proof selftest-initramfs --run walleye-initramfs-usb-gadget
k --step stock-kernel-runs-our-init --status done --proof tests/host/massstorage-read.sh --run walleye-retry-massstorage-after-reboot
k --step crash-window --status partial --proof tests/host/pstore-t1-read.sh --run walleye-pstore-t1-try
k --step kernel-builds --status done --proof dtb-builds-with-ids --run walleye-kernel-dts
k --step reference-kernel-boots --status done --proof reference-alive --run walleye-try-bisect-pk
k --step kernel-reaches-init --status done --proof kernel-alive --run walleye-y-tried
k --step uart-console --status open --notes "waits the cable: walleye-get-uart-setup"
k --step gadget-enumerates --status done --proof tests/host/mainline-light-up.sh --run walleye-y-tried
k --step banner-on-console --status done --proof tests/host/banner-check.sh --run walleye-banner2-tried
k --step shell-on-console --status done --proof tests/host/mainline-shell-read.sh --run walleye-z6-tried
k --step first-dmesg-mapped --status done --proof dmesg-map --run walleye-z6-dmesg-mapped
k --step dmesg-clean --status done --proof tests/host/dmesg-clean-check.sh --run walleye-z7-tried
k --step pmic-bound --status done --proof tests/host/pmic-dmesg-check.sh --run walleye-z7-tried
k --step charger-online --status failing --proof tests/host/charger-check.sh --run walleye-c2-tried
for s in watchdog-way-back storage-readonly usb-network rootfs-boots health-suite-runs; do k --step $s --status open; done
