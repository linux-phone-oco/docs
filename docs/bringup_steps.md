<!-- Generated from data/ by tad. Do not edit by hand. -->

# Bringup Steps

<a id="bootloader-unlocked"></a>
### Bootloader unlocked

Stage
: prepare

Ord
: 1

Applies
: boot:android

Done when
: fastboot getvar all says unlocked: yes

Proof
: fastboot-unlocked

Proof kind
: host-check

Helper
: lpoco lab fastboot getvar

Guide
: Unlocking wipes the user's data and is the owner's act. Read the state before anything else (walleye google-walleye-bootloader-first-look, surya first-fastboot-probe).

Checked on
: 2026-11-18


<a id="stock-measured"></a>
### The stock system measured

Stage
: prepare

Ord
: 2

Applies
: any

Done when
: what works on the stock system, its battery and its partitions are recorded as the reference

Proof
: android-reference

Proof kind
: research

Guide
: Measure the stock system before anything is flashed: it is the reference 'as good as Android' is judged by, and an unlock may wipe it (walleye android-reference-walleye-measured).

Checked on
: 2026-11-18


<a id="stock-facts-read"></a>
### The stock boot's facts read

Stage
: prepare

Ord
: 3

Applies
: any

Done when
: the stock cmdline, boot header and offsets, dtb ids (msm-id, board-id), running fdt and ramoops region are recorded

Proof
: stock-facts-recorded

Proof kind
: research

Helper
: lpoco bringup image info

Guide
: Read them from the running stock system and its boot image (walleye walleye-stock-ids-recorded, walleye-boot-cmdline-known). The running fdt is worth keeping whole: on walleye it named the cause of the dead dtbs (walleye-our-dts-gpio-reserved).

Checked on
: 2026-11-18


<a id="slot-state-known"></a>
### Slots read, a way back known

Stage
: prepare

Ord
: 4

Applies
: boot:android-ab

Done when
: both slots' flags are reported before and after every try, and the phone returns to the stock system by itself

Proof
: slot-report

Proof kind
: host-check

Helper
: lpoco lab fastboot state

Guide
: On walleye the Load Error was the slot state left by refusals, not the image: restore the first state (Android booted to completion on a good slot) before each try (walleye-load-error-first-state).

Checked on
: 2026-11-18


<a id="control-image-boots"></a>
### A known-good image boots from memory

Stage
: boot

Ord
: 1

Applies
: boot:android

Done when
: fastboot boot of a known-good stock-format image leaves fastboot and runs, nothing written

Proof
: fastboot-boot-control

Proof kind
: host-check

Helper
: lpoco lab fastboot boot

Guide
: The control tells 'the bootloader refuses' from 'our image is wrong' (walleye walleye-loaderror-control).

Checked on
: 2026-11-18


<a id="boot-image-packs"></a>
### Our boot image packs as the device wants

Stage
: boot

Ord
: 2

Applies
: boot:android

Done when
: header version, offsets, page size, dtb placement and os word match the control where they should

Proof
: bringup-pack-matches-mkbootimg

Proof kind
: build-check

Helper
: lpoco bringup image pack, check

Guide
: Pack from the device's [boot] declaration and count it against the control (walleye walleye-bootimage). The helper packs header v0 only.

Checked on
: 2026-11-18


<a id="dtbo-accepted"></a>
### The bootloader's dtbo overlay accepted

Stage
: boot

Ord
: 3

Applies
: boot:android-dtbo

Done when
: our dtb, built with -@ and the overlay's labels, merges with the stock dtbo, or the bootloader does not need it

Proof
: dtbo-overlay-merges

Proof kind
: build-check

Guide
: On walleye our dtb with -@ and the 137 labels merged; the dtbo stub that was planned was never needed (walleye-dtb-overlay-symbols-build, walleye-loaderror-dtbo-stub).

Checked on
: 2026-11-18


<a id="initramfs-gadget-emulated"></a>
### Our initramfs brings the gadget up, emulated

Stage
: boot

Ord
: 4

Applies
: usb:gadget

Done when
: in QEMU with dummy_hcd our initramfs makes the gadget (ACM console and a window) and the host side sees it

Proof
: selftest-initramfs

Proof kind
: build-check

Helper
: lpoco bringup initramfs build

Guide
: Prove the init before any phone time (walleye walleye-initramfs-usb-gadget). The generic init under lpoco is backlog bringup-generic-init.

Checked on
: 2026-11-18


<a id="stock-kernel-runs-our-init"></a>
### The stock kernel runs our init

Stage
: boot

Ord
: 5

Applies
: boot:android

Done when
: the stock kernel with only our ramdisk swapped runs our /init, and it shows (a gadget, a mass-storage window)

Proof
: massstorage-window-read

Proof kind
: host-check

Helper
: lpoco bringup image swap

Guide
: Proves the image path apart from our kernel. On walleye the NCM function panics the vendor 4.4 kernel; a mass-storage window works (walleye-ncm-split, walleye-massstorage-window).

Checked on
: 2026-11-18


<a id="crash-window"></a>
### A window on a dead boot

Stage
: boot

Ord
: 6

Applies
: any

Done when
: a dead or hung boot leaves something the host reads: UART, pstore at the phone's own ramoops region, or a timing channel

Proof
: crash-window-read

Proof kind
: host-check

Guide
: On walleye ramoops survives only at the region the stock fdt names and only across a warm reset (walleye-pstore-warm-reset, walleye-pstore-t1-try); a timing channel told alive from dead (walleye-ml4-timing-channel); UART waits a cable (walleye-get-uart-setup).

Checked on
: 2026-11-18


<a id="kernel-builds"></a>
### Our kernel and dts build

Stage
: kernel

Ord
: 1

Applies
: any

Done when
: the mainline kernel and the device's dts build with no dtc warning from our file, and the dtb carries the ids the bootloader matches

Proof
: dtb-builds-with-ids

Proof kind
: build-check

Guide
: Start from the nearest sibling's dts in mainline (walleye from taimen, walleye-kernel-dts).

Checked on
: 2026-11-18


<a id="reference-kernel-boots"></a>
### Someone else's mainline kernel boots here

Stage
: kernel

Ord
: 2

Applies
: any

Done when
: another project's mainline kernel and dtb for this device or a sibling reach their init on this phone

Proof
: reference-alive

Proof kind
: host-check

Helper
: lpoco bringup image bisect

Guide
: The reference to bisect against when ours is dead: swap one part at a time (walleye pk5 alive against ours dead: walleye-bisect-porthole-vs-ours, walleye-our-dtb-bisect, walleye-property-bisect).

Checked on
: 2026-11-18


<a id="kernel-reaches-init"></a>
### Our kernel reaches our init

Stage
: kernel

Ord
: 3

Applies
: any

Done when
: our kernel and our dtb reach /init: the phone stays up as long as /init says, with no early reset

Proof
: kernel-alive

Proof kind
: host-check

Helper
: lpoco bringup image bisect

Guide
: Two traps on walleye: earlycon on an undeclared UART kills the kernel (walleye-no-earlycon); a pinctrl node without gpio-reserved-ranges touches the secure world's pins and resets the phone (walleye-our-dts-gpio-reserved).

Checked on
: 2026-11-18


<a id="uart-console"></a>
### Kernel log on UART

Stage
: console

Ord
: 1

Applies
: any

Done when
: the kernel's log reaches the host over the debug UART

Proof
: uart-log

Proof kind
: host-check

Guide
: Needs the device's debug cable or pads; on walleye it waits the cable (walleye-get-uart-setup), so the USB gadget was the console.

Checked on
: 2026-11-18


<a id="gadget-enumerates"></a>
### The host sees our gadget

Stage
: console

Ord
: 2

Applies
: usb:gadget

Done when
: the host enumerates our own kernel's gadget by its vendor:product and serial

Proof
: gadget-enumerates

Proof kind
: host-check

Guide
: walleye y2: 1d6b:0104 18 s after the jump (walleye-try-y).

Checked on
: 2026-11-18


<a id="banner-on-console"></a>
### The banner on the console

Stage
: console

Ord
: 3

Applies
: any

Done when
: /init's banner with a heartbeat reaches the host on the console, read as the lab user

Proof
: banner-seen

Proof kind
: host-check

Guide
: The gadget serial must be the one the host's udev rule names, or the tty is root's (walleye-banner-serial-fix, walleye-try-banner2).

Checked on
: 2026-11-18


<a id="shell-on-console"></a>
### A shell answers on the console

Stage
: console

Ord
: 4

Applies
: any

Done when
: commands sent on the console answer, one at a time, reliably across hangups

Proof
: shell-answers

Proof kind
: host-check

Guide
: On walleye an interactive ash stayed silent; a plain read/exec loop and the host tty raw and -hupcl made it answer (walleye-shell-reliable, walleye-command-loop, walleye-try-z6).

Checked on
: 2026-11-18


<a id="first-dmesg-mapped"></a>
### The first dmesg mapped

Stage
: kernel

Ord
: 4

Applies
: any

Done when
: the first full dmesg of our kernel is read and every line placed: works, defers, fails, and whose

Proof
: dmesg-map

Proof kind
: research

Guide
: The map orders what follows (walleye-z6-dmesg-map, research walleye-bringup-order-plan).

Checked on
: 2026-11-18


<a id="dmesg-clean"></a>
### dmesg clean

Stage
: kernel

Ord
: 5

Applies
: any

Done when
: no WARN, oops or -110, and no probe deferred but the known ones

Proof
: dmesg-clean

Proof kind
: host-check

Guide
: walleye z7: the GPU smmu off cleared the gpu_gx WARNs (walleye-dmesg-clean); on a rootfs the suite's no-oops and boot-warnings carry it.

Checked on
: 2026-11-18


<a id="pmic-bound"></a>
### The PMIC bound

Stage
: power

Ord
: 1

Applies
: any

Done when
: the PMIC's children bind on their bus, the RTC and the power-on reason read

Proof
: pmic-bound

Proof kind
: host-check

Guide
: walleye: pm8998 and pmi8998 on SPMI (walleye-pmic-spmi, proven in z7). UFS rails are RPM regulators and do not wait for it (walleye-bringup-order-plan).

Checked on
: 2026-11-18


<a id="charger-online"></a>
### The charger online

Stage
: power

Ord
: 2

Applies
: power:battery

Done when
: a power_supply of type USB appears, online follows the cable, and the voltage rises while connected

Proof
: charger-online

Proof kind
: host-check

Guide
: Until it works, tries are rationed by the battery. walleye c2: the charger defers on its tps61099 supplier (walleye-charger-wait-tps61099, walleye-charger-supplier).

Checked on
: 2026-11-18


<a id="watchdog-way-back"></a>
### A hung kernel comes back by itself

Stage
: power

Ord
: 3

Applies
: any

Done when
: a hung kernel resets by itself and the phone returns to a known system without hands

Proof
: way-back

Proof kind
: host-check

Guide
: surya: qcom_wdt kept armed through sleep (way-back.sh). walleye: the PMIC watchdog (walleye-pmic-wdt-proof).

Checked on
: 2026-11-18


<a id="storage-readonly"></a>
### Internal storage read-only

Stage
: storage

Ord
: 1

Applies
: any

Done when
: the internal storage lists its partitions by name, nothing written

Proof
: storage-lists

Proof kind
: host-check

Guide
: Gives the firmware partitions every later part needs (walleye-ufs-readonly).

Checked on
: 2026-11-18


<a id="usb-network"></a>
### Network over USB

Stage
: userspace

Ord
: 1

Applies
: usb:gadget

Done when
: ssh over the USB gadget's network answers

Proof
: gadget-up

Proof kind
: host-check

Guide
: walleye: walleye-usb-net. surya had the distribution's own gadget.

Checked on
: 2026-11-18


<a id="rootfs-boots"></a>
### A distribution root boots

Stage
: userspace

Ord
: 2

Applies
: any

Done when
: a distribution's root filesystem boots to its init and ssh answers

Proof
: rootfs-ssh

Proof kind
: host-check

Helper
: lpoco lab flash, provision

Guide
: surya boots Nura through U-Boot, systemd-boot and an EFI kernel (first-fastboot-probe).

Checked on
: 2026-11-18


<a id="health-suite-runs"></a>
### The health suite runs after every boot

Stage
: userspace

Ord
: 3

Applies
: any

Done when
: the phone's own suite runs after every boot and its run is filed in the device's base

Proof
: suite-filed

Proof kind
: phone-suite

Helper
: lpoco lab suite put, run

Guide
: From here a part's status is measured, not judged (surya 2026-11-17-health-on-the-phone).

Checked on
: 2026-11-18
