<!-- Generated from data/ by bin/render-pages.sh. Do not edit by hand. -->

# Bring-up guidebook

Every small step that makes Linux run on a phone, in the order a bring-up meets them: 116 steps in 20 stages, one chapter each. A step shows what done means, what it needs and what it enables, the proof that tests it, the helper that does it or the gap, and how it is done with the traps met so far. A **World gap** marks a step the world has no open answer to yet. Where each phone stands on each step is the [bring-up steps view of the face](../en/linux-phones/steps.html); the steps drawn as a graph, a goal on the left and what it needs to the right, are the [bring-up graph](graph.html); the rows themselves are in the [steps table](bringup_steps.md).

## The chapters

1. [Prepare](#stage-prepare) - 4 steps
2. [Boot](#stage-boot) - 6 steps
3. [Console](#stage-console) - 4 steps
4. [Kernel](#stage-kernel) - 5 steps
5. [Power](#stage-power) - 13 steps
6. [Storage](#stage-storage) - 2 steps
7. [Userspace](#stage-userspace) - 3 steps
8. [Lab](#stage-lab) - 2 steps
9. [Coprocessors](#stage-coprocessors) - 4 steps
10. [Display and input](#stage-display) - 6 steps
11. [Sound](#stage-audio) - 9 steps
12. [Modem, SMS and data](#stage-modem) - 7 steps
13. [Calls](#stage-calls) - 4 steps
14. [Local radios](#stage-radios) - 6 steps
15. [Sensors and location](#stage-sensors) - 5 steps
16. [Camera](#stage-camera) - 7 steps
17. [Sleep and battery life](#stage-sleep) - 10 steps
18. [Updates and endurance](#stage-upkeep) - 5 steps
19. [Shell](#stage-shell) - 11 steps
20. [Goals](#stage-goals) - 3 steps

<a id="stage-prepare"></a>
## 1. Prepare

Read what the machine is and what it allows before anything is changed: the stock system, the boot facts, the way back.

<a id="step-stock-measured"></a>
### The stock system measured

Step 1 in the chain, id `stock-measured`, applies to `any`, checked on 2026-11-18.

- **Done when:** what works on the stock system, its battery and its partitions are recorded as the reference
- **Needs:** nothing
- **Enables:** [bootloader-unlocked](#step-bootloader-unlocked)
- **Proof:** `android-reference`, research
- **Helper:** no helper yet - a helper to write
- **Guide:** Measure the stock system before anything is flashed: it is the reference 'as good as Android' is judged by, and an unlock may wipe it (walleye android-reference-walleye-measured).

<a id="step-stock-facts-read"></a>
### The stock boot's facts read

Step 2 in the chain, id `stock-facts-read`, applies to `any`, checked on 2026-11-18.

- **Done when:** the stock cmdline, boot header and offsets, dtb ids (msm-id, board-id), running fdt and ramoops region are recorded
- **Needs:** nothing
- **Enables:** [boot-image-packs](#step-boot-image-packs), [crash-window](#step-crash-window), [kernel-builds](#step-kernel-builds)
- **Proof:** `stock-facts-recorded`, research
- **Helper:** `lpoco bringup image info`
- **Guide:** Read them from the running stock system and its boot image (walleye walleye-stock-ids-recorded, walleye-boot-cmdline-known). The running fdt is worth keeping whole: on walleye it named the cause of the dead dtbs (walleye-our-dts-gpio-reserved).

<a id="step-slot-state-known"></a>
### Slots read, a way back known

Step 3 in the chain, id `slot-state-known`, applies to `boot:android-ab`, checked on 2026-11-18.

- **Done when:** both slots' flags are reported before and after every try, and the phone returns to the stock system by itself
- **Needs:** nothing
- **Enables:** [control-image-boots](#step-control-image-boots), [update-rolls-back](#step-update-rolls-back)
- **Proof:** `slot-report`, host-check
- **Helper:** `lpoco lab fastboot state`
- **Guide:** On walleye the Load Error was the slot state left by refusals, not the image: restore the first state (Android booted to completion on a good slot) before each try (walleye-load-error-first-state).

<a id="step-bootloader-unlocked"></a>
### Bootloader unlocked

Step 5 in the chain, id `bootloader-unlocked`, applies to `boot:android`, checked on 2026-11-18.

- **Done when:** fastboot getvar all says unlocked: yes
- **Needs:**
  - [stock-measured](#step-stock-measured) - soft: an unlock may wipe the stock system
- **Enables:** [control-image-boots](#step-control-image-boots)
- **Proof:** `fastboot-unlocked`, host-check
- **Helper:** `lpoco lab fastboot getvar`
- **Guide:** Unlocking wipes the user's data and is the owner's act. Read the state before anything else (walleye google-walleye-bootloader-first-look, surya first-fastboot-probe).

<a id="stage-boot"></a>
## 2. Boot

Get an image of ours accepted by the bootloader and run, one part swapped at a time, until it is known what refuses it.

<a id="step-initramfs-gadget-emulated"></a>
### Our initramfs brings the gadget up, emulated

Step 4 in the chain, id `initramfs-gadget-emulated`, applies to `usb:gadget`, checked on 2026-11-18.

- **Done when:** in QEMU with dummy\_hcd our initramfs makes the gadget (ACM console and a window) and the host side sees it
- **Needs:** nothing
- **Enables:** [stock-kernel-runs-our-init](#step-stock-kernel-runs-our-init), [gadget-enumerates](#step-gadget-enumerates)
- **Proof:** `selftest-initramfs`, build-check
- **Helper:** `lpoco bringup initramfs build`
- **Guide:** Prove the init before any phone time (walleye walleye-initramfs-usb-gadget). The generic init under lpoco is backlog bringup-generic-init.

<a id="step-boot-image-packs"></a>
### Our boot image packs as the device wants

Step 6 in the chain, id `boot-image-packs`, applies to `boot:android`, checked on 2026-11-18.

- **Done when:** header version, offsets, page size, dtb placement and os word match the control where they should
- **Needs:**
  - [stock-facts-read](#step-stock-facts-read) - hard: the header and offsets are the stock image's
- **Enables:** [stock-kernel-runs-our-init](#step-stock-kernel-runs-our-init), [reference-kernel-boots](#step-reference-kernel-boots), [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `bringup-pack-matches-mkbootimg`, build-check
- **Helper:** `lpoco bringup image pack, check`
- **Guide:** Pack from the device's \[boot\] declaration and count it against the control (walleye walleye-bootimage). The helper packs header v0 only.

<a id="step-crash-window"></a>
### A window on a dead boot

Step 7 in the chain, id `crash-window`, applies to `any`, checked on 2026-11-18.

- **Done when:** a dead or hung boot leaves something the host reads: UART, pstore at the phone's own ramoops region, or a timing channel
- **Needs:**
  - [stock-facts-read](#step-stock-facts-read) - soft: the ramoops region is the stock fdt's
- **Enables:** [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `crash-window-read`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** On walleye ramoops survives only at the region the stock fdt names and only across a warm reset (walleye-pstore-warm-reset, walleye-pstore-t1-try); a timing channel told alive from dead (walleye-ml4-timing-channel); UART waits a cable (walleye-get-uart-setup).

<a id="step-control-image-boots"></a>
### A known-good image boots from memory

Step 9 in the chain, id `control-image-boots`, applies to `boot:android`, checked on 2026-11-18.

- **Done when:** fastboot boot of a known-good stock-format image leaves fastboot and runs, nothing written
- **Needs:**
  - [bootloader-unlocked](#step-bootloader-unlocked) - hard: fastboot boot needs an unlocked bootloader
  - [slot-state-known](#step-slot-state-known) - hard: walleye: refusals were the slot state (walleye-load-error-first-state)
- **Enables:** [stock-kernel-runs-our-init](#step-stock-kernel-runs-our-init), [reference-kernel-boots](#step-reference-kernel-boots), [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `fastboot-boot-control`, host-check
- **Helper:** `lpoco lab fastboot boot`
- **Guide:** The control tells 'the bootloader refuses' from 'our image is wrong' (walleye walleye-loaderror-control).

<a id="step-dtbo-accepted"></a>
### The bootloader's dtbo overlay accepted

Step 10 in the chain, id `dtbo-accepted`, applies to `boot:android-dtbo`, checked on 2026-11-18.

- **Done when:** our dtb, built with -@ and the overlay's labels, merges with the stock dtbo, or the bootloader does not need it
- **Needs:**
  - [kernel-builds](#step-kernel-builds) - hard: it is our dtb that must merge
- **Enables:** [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `dtbo-overlay-merges`, build-check
- **Helper:** no helper yet - a helper to write
- **Guide:** On walleye our dtb with -@ and the 137 labels merged; the dtbo stub that was planned was never needed (walleye-dtb-overlay-symbols-build, walleye-loaderror-dtbo-stub).

<a id="step-stock-kernel-runs-our-init"></a>
### The stock kernel runs our init

Step 12 in the chain, id `stock-kernel-runs-our-init`, applies to `boot:android`, checked on 2026-11-18.

- **Done when:** the stock kernel with only our ramdisk swapped runs our /init, and it shows (a gadget, a mass-storage window)
- **Needs:**
  - [boot-image-packs](#step-boot-image-packs) - hard: the swap repacks
  - [control-image-boots](#step-control-image-boots) - hard: the control is the image swapped into
  - [initramfs-gadget-emulated](#step-initramfs-gadget-emulated) - soft: an init proven emulated spends no phone time
- **Enables:** nothing
- **Proof:** `massstorage-window-read`, host-check
- **Helper:** `lpoco bringup image swap`
- **Guide:** Proves the image path apart from our kernel. On walleye the NCM function panics the vendor 4.4 kernel; a mass-storage window works (walleye-ncm-split, walleye-massstorage-window).

<a id="stage-console"></a>
## 3. Console

A window onto the running kernel: a banner, a shell, over UART or the USB gadget.

<a id="step-uart-console"></a>
### Kernel log on UART

Step 11 in the chain, id `uart-console`, applies to `any`, checked on 2026-11-18.

- **Done when:** the kernel's log reaches the host over the debug UART
- **Needs:**
  - [kernel-builds](#step-kernel-builds) - hard: it is our kernel's log
- **Enables:** [banner-on-console](#step-banner-on-console)
- **Proof:** `uart-log`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Needs the device's debug cable or pads; on walleye it waits the cable (walleye-get-uart-setup), so the USB gadget was the console.

<a id="step-gadget-enumerates"></a>
### The host sees our gadget

Step 15 in the chain, id `gadget-enumerates`, applies to `usb:gadget`, checked on 2026-11-18.

- **Done when:** the host enumerates our own kernel's gadget by its vendor:product and serial
- **Needs:**
  - [initramfs-gadget-emulated](#step-initramfs-gadget-emulated) - hard: the init makes the gadget
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: our kernel's gadget
- **Enables:** [banner-on-console](#step-banner-on-console), [usb-network](#step-usb-network)
- **Proof:** `gadget-enumerates`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** walleye y2: 1d6b:0104 18 s after the jump (walleye-try-y).

<a id="step-banner-on-console"></a>
### The banner on the console

Step 20 in the chain, id `banner-on-console`, applies to `any`, checked on 2026-11-18.

- **Done when:** /init's banner with a heartbeat reaches the host on the console, read as the lab user
- **Needs:**
  - [gadget-enumerates](#step-gadget-enumerates) - hard, one of the alternatives `console`: the console over the gadget
  - [uart-console](#step-uart-console) - hard, one of the alternatives `console`: or over UART
- **Enables:** [shell-on-console](#step-shell-on-console)
- **Proof:** `banner-seen`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** The gadget serial must be the one the host's udev rule names, or the tty is root's (walleye-banner-serial-fix, walleye-try-banner2).

<a id="step-shell-on-console"></a>
### A shell answers on the console

Step 28 in the chain, id `shell-on-console`, applies to `any`, checked on 2026-11-18.

- **Done when:** commands sent on the console answer, one at a time, reliably across hangups
- **Needs:**
  - [banner-on-console](#step-banner-on-console) - hard: a console that carries text first
- **Enables:** [first-dmesg-mapped](#step-first-dmesg-mapped), [pmic-bound](#step-pmic-bound), [storage-readonly](#step-storage-readonly)
- **Proof:** `shell-answers`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** On walleye an interactive ash stayed silent; a plain read/exec loop and the host tty raw and -hupcl made it answer (walleye-shell-reliable, walleye-command-loop, walleye-try-z6).

<a id="stage-kernel"></a>
## 4. Kernel

Our kernel builds, reaches its init and says nothing worse than it should.

<a id="step-kernel-builds"></a>
### Our kernel and dts build

Step 8 in the chain, id `kernel-builds`, applies to `any`, checked on 2026-11-18.

- **Done when:** the mainline kernel and the device's dts build with no dtc warning from our file, and the dtb carries the ids the bootloader matches
- **Needs:**
  - [stock-facts-read](#step-stock-facts-read) - soft: the dtb ids the bootloader matches
- **Enables:** [dtbo-accepted](#step-dtbo-accepted), [uart-console](#step-uart-console), [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `dtb-builds-with-ids`, build-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Start from the nearest sibling's dts in mainline (walleye from taimen, walleye-kernel-dts).

<a id="step-reference-kernel-boots"></a>
### Someone else's mainline kernel boots here

Step 13 in the chain, id `reference-kernel-boots`, applies to `any`, checked on 2026-11-18.

- **Done when:** another project's mainline kernel and dtb for this device or a sibling reach their init on this phone
- **Needs:**
  - [boot-image-packs](#step-boot-image-packs) - hard: packed the device's way
  - [control-image-boots](#step-control-image-boots) - hard: same bootloader path
- **Enables:** [kernel-reaches-init](#step-kernel-reaches-init)
- **Proof:** `reference-alive`, host-check
- **Helper:** `lpoco bringup image bisect`
- **Guide:** The reference to bisect against when ours is dead: swap one part at a time (walleye pk5 alive against ours dead: walleye-bisect-porthole-vs-ours, walleye-our-dtb-bisect, walleye-property-bisect).

<a id="step-kernel-reaches-init"></a>
### Our kernel reaches our init

Step 14 in the chain, id `kernel-reaches-init`, applies to `any`, checked on 2026-11-18.

- **Done when:** our kernel and our dtb reach /init: the phone stays up as long as /init says, with no early reset
- **Needs:**
  - [boot-image-packs](#step-boot-image-packs) - hard: packed the device's way
  - [control-image-boots](#step-control-image-boots) - hard: the bootloader accepts images
  - [dtbo-accepted](#step-dtbo-accepted) - hard: walleye: no start without the merge (walleye-dtbo-overlay-merge-why)
  - [kernel-builds](#step-kernel-builds) - hard: it is our kernel
  - [crash-window](#step-crash-window) - soft: without one a dead kernel says nothing
  - [reference-kernel-boots](#step-reference-kernel-boots) - soft: the bisect reference
- **Enables:** [gadget-enumerates](#step-gadget-enumerates), [firmware-reachable](#step-firmware-reachable), [pd-mapper-before-remoteproc](#step-pd-mapper-before-remoteproc), [panel-lit](#step-panel-lit), [camera-bus-bound](#step-camera-bus-bound), [touch-input](#step-touch-input), [watchdog-way-back](#step-watchdog-way-back)
- **Proof:** `kernel-alive`, host-check
- **Helper:** `lpoco bringup image bisect`
- **Guide:** Two traps on walleye: earlycon on an undeclared UART kills the kernel (walleye-no-earlycon); a pinctrl node without gpio-reserved-ranges touches the secure world's pins and resets the phone (walleye-our-dts-gpio-reserved).

<a id="step-first-dmesg-mapped"></a>
### The first dmesg mapped

Step 33 in the chain, id `first-dmesg-mapped`, applies to `any`, checked on 2026-11-18.

- **Done when:** the first full dmesg of our kernel is read and every line placed: works, defers, fails, and whose
- **Needs:**
  - [shell-on-console](#step-shell-on-console) - hard: dmesg is read through the shell
- **Enables:** [dmesg-clean](#step-dmesg-clean), [pmic-bound](#step-pmic-bound)
- **Proof:** `dmesg-map`, research
- **Helper:** no helper yet - a helper to write
- **Guide:** The map orders what follows (walleye-z6-dmesg-map, research walleye-bringup-order-plan).

<a id="step-dmesg-clean"></a>
### dmesg clean

Step 37 in the chain, id `dmesg-clean`, applies to `any`, checked on 2026-11-18.

- **Done when:** no WARN, oops or -110, and no probe deferred but the known ones
- **Needs:**
  - [first-dmesg-mapped](#step-first-dmesg-mapped) - hard: the map names what to clean
- **Enables:** [storage-readonly](#step-storage-readonly), [linux-runs](#step-linux-runs)
- **Proof:** `dmesg-clean`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** walleye z7: the GPU smmu off cleared the gpu\_gx WARNs (walleye-dmesg-clean); on a rootfs the suite's no-oops and boot-warnings carry it.

<a id="stage-power"></a>
## 5. Power

The PMIC, the charger and the watchdog: what keeps the machine alive and safe to leave running.

<a id="step-pmic-bound"></a>
### The PMIC bound

Step 38 in the chain, id `pmic-bound`, applies to `any`, checked on 2026-11-18.

- **Done when:** the PMIC's children bind on their bus, the RTC and the power-on reason read
- **Needs:**
  - [shell-on-console](#step-shell-on-console) - hard: read through the shell
  - [first-dmesg-mapped](#step-first-dmesg-mapped) - soft: the map names the PMIC's faults
- **Enables:** [charger-online](#step-charger-online), [watchdog-way-back](#step-watchdog-way-back), [battery-gauge-reads](#step-battery-gauge-reads), [pon-reason-read](#step-pon-reason-read), [reset-types-right](#step-reset-types-right), [key-reset-recovers](#step-key-reset-recovers), [power-off-stays-off](#step-power-off-stays-off), [buttons-report](#step-buttons-report)
- **Proof:** `pmic-bound`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** walleye: pm8998 and pmi8998 on SPMI (walleye-pmic-spmi, proven in z7). UFS rails are RPM regulators and do not wait for it (walleye-bringup-order-plan).

<a id="step-charger-online"></a>
### The charger online

Step 43 in the chain, id `charger-online`, applies to `power:battery`, checked on 2026-11-18.

- **Done when:** a power\_supply of type USB appears, online follows the cable, and the voltage rises while connected
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the charger is a PMIC child
- **Enables:** [linux-runs](#step-linux-runs), [off-mode-charging](#step-off-mode-charging)
- **Proof:** `charger-online`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Until it works, tries are rationed by the battery. walleye c2: the charger defers on its tps61099 supplier (walleye-charger-wait-tps61099, walleye-charger-supplier).

<a id="step-watchdog-way-back"></a>
### A hung kernel comes back by itself

Step 44 in the chain, id `watchdog-way-back`, applies to `any`, checked on 2026-11-18.

- **Done when:** a hung kernel resets by itself and the phone returns to a known system without hands
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: it is our kernel that hangs
  - [pmic-bound](#step-pmic-bound) - soft: walleye's way is the PMIC watchdog
- **Enables:** [reset-state-survives](#step-reset-state-survives), [suspend-way-back](#step-suspend-way-back), [linux-runs](#step-linux-runs), [update-rolls-back](#step-update-rolls-back)
- **Proof:** `way-back`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: qcom\_wdt kept armed through sleep (way-back.sh). walleye: the PMIC watchdog (walleye-pmic-wdt-proof).

<a id="step-battery-gauge-reads"></a>
### The battery gauge reads true

Step 45 in the chain, id `battery-gauge-reads`, applies to `power:battery`, checked on 2026-11-18, first light of the part `battery`.

- **Done when:** capacity, voltage and current read in power\_supply agree with a meter within 5 % over a discharge
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the gauge is a PMIC function
- **Enables:** [charger-mode-entered](#step-charger-mode-entered), [off-mode-charging](#step-off-mode-charging), [standby-current](#step-standby-current)
- **Proof:** `battery-gauge`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write. surya read gauge averages in its standby run (2026-11-17-r3-partial-and-the-reset-after); walleye open (walleye-fuel-gauge). PMI8998-class gauges are still RFCs (pmi8998-fg-rfc).
- **Sources:** [PMI8998 Gen3 fuel gauge RFC](https://lkml.iu.edu/2511.3/01492.html)

<a id="step-pon-reason-read"></a>
### Why it turned on, and why it last turned off, are read

Step 46 in the chain, id `pon-reason-read`, applies to `any`, checked on 2026-11-18.

- **Done when:** each boot logs the power-on reason (key, USB charger, RTC alarm, warm reset, watchdog, key-combo reset) and the last power-off reason, read from the PMIC
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the reasons are the PMIC's registers
- **Enables:** [reset-types-right](#step-reset-types-right), [reset-state-survives](#step-reset-state-survives), [key-reset-recovers](#step-key-reset-recovers), [power-off-stays-off](#step-power-off-stays-off), [charger-mode-entered](#step-charger-mode-entered), [rtc-alarm-powers-on](#step-rtc-alarm-powers-on)
- **Proof:** `pon-reason`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write. On Qualcomm the PON block keeps PON\_REASON, WARM\_RESET\_REASON and POFF\_REASON (gen2 moves POFF\_REASON1 to 0xc5; downstream-qpnp-power-on-sm6150 logs them, mainline's qcom-pon does not show them). surya read its PON registers by hand (surya-lab PR 269; upstreams-lane). Every step of the off side is told apart by this reason.
- **Sources:** [Vendor GPL qpnp-power-on.c, LineageOS sm6150 tree](https://raw.githubusercontent.com/LineageOS/android_kernel_xiaomi_sm6150/lineage-20/drivers/input/misc/qpnp-power-on.c)

<a id="step-reset-types-right"></a>
### Power-off, reboot and a bite each reach the right PMIC reset

Step 49 in the chain, id `reset-types-right`, applies to `any`, checked on 2026-11-18.

- **Done when:** power-off ends in the PMIC's shutdown, reboot in a warm or hard reset, and a watchdog bite in a hard reset - each read back from the PMIC and seen in the next boot's reason
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the reset types are the PMIC's
  - [pon-reason-read](#step-pon-reason-read) - soft: blind without it: the next boot's reason is the proof
- **Enables:** [power-off-stays-off](#step-power-off-stays-off)
- **Proof:** `reset-types`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** On Qualcomm, power-off goes by PSCI SYSTEM\_OFF to the secure firmware, which sets the PS\_HOLD reset type and drops PS\_HOLD; reboot sets another type. A wrong type, the firmware's own choice, or a power-on trigger still pending (a plugged cable, an armed PMIC watchdog, an RTC alarm) turns off into a new boot. surya: the firmware leaves S2 at warm reset 0x01; patch 5/5 sets hard reset 0x07 with a read-back (upstreams-lane). walleye: a bite powered off instead of restarting (pmic-wdt-reset-type). Test to write.
- **Sources:** [Vendor GPL qpnp-power-on.c, LineageOS sm6150 tree](https://raw.githubusercontent.com/LineageOS/android_kernel_xiaomi_sm6150/lineage-20/drivers/input/misc/qpnp-power-on.c), [watchdog: qcom: Add suspend/resume support (Sai Prakash Ranjan, 2019)](https://lkml.iu.edu/1901.2/01680.html)

<a id="step-reset-state-survives"></a>
### What must survive a reset does, and the rest is set again

Step 50 in the chain, id `reset-state-survives`, applies to `any`, checked on 2026-11-18.

- **Done when:** across a warm reset the reboot mode (the PMIC's spare register: bootloader, recovery), the RTC and ramoops survive; after any reset the kernel sets again the PMIC state it relies on (S2 reset type, watchdogs) and reads it back
- **Needs:**
  - [pon-reason-read](#step-pon-reason-read) - hard: read after each kind of reset
  - [watchdog-way-back](#step-watchdog-way-back) - hard: the watchdog state is part of it
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `reset-state`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** The PMIC keeps its registers across a warm reset and the firmware rewrites some at boot (surya's S2 type 0x01 from firmware, upstreams-lane). ramoops survives a warm reset only if its memory is not cleared (ramoops-doc). Test to write.
- **Sources:** [Linux kernel: ramoops](https://docs.kernel.org/admin-guide/ramoops.html), [Vendor GPL qpnp-power-on.c, LineageOS sm6150 tree](https://raw.githubusercontent.com/LineageOS/android_kernel_xiaomi_sm6150/lineage-20/drivers/input/misc/qpnp-power-on.c)

<a id="step-key-reset-recovers"></a>
### A held key resets a hung phone

Step 51 in the chain, id `key-reset-recovers`, applies to `any`, checked on 2026-11-18, first light of the part `buttons`.

- **Done when:** holding power (with volume down where so wired) for the set time hard-resets a hung phone, and the next boot's reason says so
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the key reset is the PMIC's
  - [pon-reason-read](#step-pon-reason-read) - soft: the reason proves it was the key
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `key-reset`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** The PMIC's S1/S2 key reset, set by the firmware or the PON driver; a user's way back that needs no software. Test by hand.

<a id="step-power-off-stays-off"></a>
### Off stays off

Step 55 in the chain, id `power-off-stays-off`, applies to `any`, checked on 2026-11-18.

- **Done when:** poweroff leaves the machine off, and plugging a charger in does not boot the full system
- **Needs:**
  - [pmic-bound](#step-pmic-bound) - hard: the power-on reason and power-off are the PMIC's
  - [reset-types-right](#step-reset-types-right) - hard: off must end in the PMIC's shutdown, not a reset
  - [pon-reason-read](#step-pon-reason-read) - soft: tells a reboot from a charger or alarm power-on
- **Enables:** [charger-mode-entered](#step-charger-mode-entered), [rtc-alarm-powers-on](#step-rtc-alarm-powers-on), [off-mode-charging](#step-off-mode-charging)
- **Proof:** `stays-off`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya fails: poweroff and a plugged charger both boot pmOS (off-state-charging); only the old eOS recovery's power-off held, so the PMIC can stay off and our power-off path is what differs. Read the power-on reason (pon-reason-read) and the reset types (reset-types-right) to tell a reboot from a charger power-on.
- **Sources:** [Vendor GPL qpnp-power-on.c, LineageOS sm6150 tree](https://raw.githubusercontent.com/LineageOS/android_kernel_xiaomi_sm6150/lineage-20/drivers/input/misc/qpnp-power-on.c)

<a id="step-thermal-zones-sane"></a>
### Thermal zones read and throttle

Step 56 in the chain, id `thermal-zones-sane`, applies to `any`, checked on 2026-11-18.

- **Done when:** every thermal zone reads a plausible temperature, trips are set, and a load throttles before any shutdown
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: the zones are read from userspace under load
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `thermal-zones`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write; never touched in our labs. Android has a thermal HAL and a policy; Linux phones have the kernel's zones and no policy daemon (aosp-compat-matrix, sailfish-hadk-checklist).
- **Sources:** [AOSP framework compatibility matrix 202604](https://android.googlesource.com/platform/hardware/interfaces/+/refs/heads/main/compatibility_matrices/compatibility_matrix.202604.xml), [Sailfish OS HADK: hardware adaptation checklist](https://hadk.sailfishos.org/ha-checklist/)

<a id="step-charger-mode-entered"></a>
### A charger power-on starts the charging screen, not the system

Step 66 in the chain, id `charger-mode-entered`, applies to `power:battery`, checked on 2026-11-18, first light of the part `battery`.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** plugged in while off, the phone starts a small charger mode that shows the level and turns the screen off again; the power key starts the full system
- **Needs:**
  - [panel-lit](#step-panel-lit) - hard: it shows the level
  - [pon-reason-read](#step-pon-reason-read) - hard: a charger power-on is told by its reason
  - [power-off-stays-off](#step-power-off-stays-off) - hard: a charger mode needs an off to start from
  - [battery-gauge-reads](#step-battery-gauge-reads) - soft: the level is the gauge's
- **Enables:** [off-mode-charging](#step-off-mode-charging)
- **Proof:** `charger-mode`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Android: the bootloader reads the power-on reason and passes androidboot.mode=charger; init then runs only the charger - the same kernel, no separate processor (Sailfish's act-dead mode, sailfish-hadk-checklist). World gap: no maintained charger mode in any mainline distribution; charging-sdl is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064).
- **Sources:** [Sailfish OS HADK: hardware adaptation checklist](https://hadk.sailfishos.org/ha-checklist/), [pmaports issue 1064: charging-sdl](https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/1064)

<a id="step-rtc-alarm-powers-on"></a>
### An alarm turns the phone on from off

Step 67 in the chain, id `rtc-alarm-powers-on`, applies to `any`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** an alarm set before power-off turns the phone on at its time, and the reason reads RTC alarm
- **Needs:**
  - [pon-reason-read](#step-pon-reason-read) - hard: the reason reads RTC alarm
  - [power-off-stays-off](#step-power-off-stays-off) - hard: it must be off to be turned on
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `rtc-poweron`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Android's power-off alarm: the PMIC RTC alarm powers it up and the bootloader boots an alarm mode. PCs have rtcwake -m off. World gap: no mainline phone distribution sets an alarm that survives power-off, and whether rtc-pm8xxx keeps the alarm armed through shutdown is not known yet.

<a id="step-off-mode-charging"></a>
### Charges while off

Step 79 in the chain, id `off-mode-charging`, applies to `power:battery`, checked on 2026-11-18, first light of the part `battery`.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** plugged in while off it charges, shows its level, and boots on the power key
- **Needs:**
  - [charger-mode-entered](#step-charger-mode-entered) - hard: the screen and the power key while off
  - [charger-online](#step-charger-online) - hard: it charges
  - [power-off-stays-off](#step-power-off-stays-off) - hard: off must be off before it can charge while off (surya off-state-charging)
  - [battery-gauge-reads](#step-battery-gauge-reads) - soft: the level shown is the gauge's
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `off-mode-charging`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Sailfish names it act-dead mode (sailfish-hadk-checklist). World gap: the usual tool, charging-sdl, is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064).
- **Sources:** [Sailfish OS HADK: hardware adaptation checklist](https://hadk.sailfishos.org/ha-checklist/), [pmaports issue 1064: charging-sdl](https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/1064)

<a id="stage-storage"></a>
## 6. Storage

Internal storage seen, first read-only.

<a id="step-storage-readonly"></a>
### Internal storage read-only

Step 47 in the chain, id `storage-readonly`, applies to `any`, checked on 2026-11-18.

- **Done when:** the internal storage lists its partitions by name, nothing written
- **Needs:**
  - [shell-on-console](#step-shell-on-console) - hard: read through the shell
  - [dmesg-clean](#step-dmesg-clean) - soft: smmu and supplier faults stop DMA devices
- **Enables:** [storage-full-speed](#step-storage-full-speed), [rootfs-boots](#step-rootfs-boots), [linux-runs](#step-linux-runs)
- **Proof:** `storage-lists`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Gives the firmware partitions every later part needs (walleye-ufs-readonly).

<a id="step-storage-full-speed"></a>
### Internal storage links at full speed

Step 52 in the chain, id `storage-full-speed`, applies to `any`, checked on 2026-11-19.

- **Done when:** the internal storage's link runs at the fastest mode the SoC and the card both support - UFS: the HS gear and lane count of the SoC's spec, both lanes up; eMMC: HS400 (or HS200 where HS400 is not supported) - read from the kernel, and a sequential read measures within reach of that mode
- **Needs:**
  - [storage-readonly](#step-storage-readonly) - hard: the link speed is read on a card that already lists its partitions
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `storage-link-speed: the link mode from debugfs or dmesg (UFS power mode HS-Gn, lanes; eMMC timing) matches the SoC's documented maximum, and a read-only dd of a partition measures the throughput`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Upstream-readiness: a storage driver that links at PWM or one lane boots but is not done. On Qualcomm UFS the PHY tables and the gear limits per SoC decide it; compare with the downstream tree's settings. Read only: never write the internal storage to measure it.

<a id="stage-userspace"></a>
## 7. Userspace

A distribution's root boots, the network is up and the health suite runs on every boot.

<a id="step-usb-network"></a>
### Network over USB

Step 21 in the chain, id `usb-network`, applies to `usb:gadget`, checked on 2026-11-18.

- **Done when:** ssh over the USB gadget's network answers
- **Needs:**
  - [gadget-enumerates](#step-gadget-enumerates) - hard: the network rides the gadget
- **Enables:** [lab-link-held-awake](#step-lab-link-held-awake), [rootfs-boots](#step-rootfs-boots)
- **Proof:** `gadget-up`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** walleye: walleye-usb-net. surya had the distribution's own gadget.

<a id="step-rootfs-boots"></a>
### A distribution root boots

Step 53 in the chain, id `rootfs-boots`, applies to `any`, checked on 2026-11-18.

- **Done when:** a distribution's root filesystem boots to its init and ssh answers
- **Needs:**
  - [storage-readonly](#step-storage-readonly) - hard: the root is on the storage
  - [usb-network](#step-usb-network) - hard: ssh is the proof
- **Enables:** [thermal-zones-sane](#step-thermal-zones-sane), [health-suite-runs](#step-health-suite-runs), [fastrpc-helpers-stable](#step-fastrpc-helpers-stable), [buttons-report](#step-buttons-report), [haptics-buzz](#step-haptics-buzz), [ucm-hifi-profile](#step-ucm-hifi-profile), [modem-file-services](#step-modem-file-services), [nfc-reads-tag](#step-nfc-reads-tag), [usb-host-works](#step-usb-host-works), [fingerprint-unlocks](#step-fingerprint-unlocks), [test-layer-boots](#step-test-layer-boots), [update-applies](#step-update-applies), [shell-runs-with-hardware](#step-shell-runs-with-hardware), [gnss-fix](#step-gnss-fix), [s2idle-cycle-returns](#step-s2idle-cycle-returns)
- **Proof:** `rootfs-ssh`, host-check
- **Helper:** `lpoco lab flash, provision`
- **Guide:** surya boots Nura through U-Boot, systemd-boot and an EFI kernel (first-fastboot-probe).

<a id="step-health-suite-runs"></a>
### The health suite runs after every boot

Step 57 in the chain, id `health-suite-runs`, applies to `any`, checked on 2026-11-18.

- **Done when:** the phone's own suite runs after every boot and its run is filed in the device's base
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: the suite runs on the root
- **Enables:** [test-layer-boots](#step-test-layer-boots), [update-applies](#step-update-applies), [kernel-upgrade-keeps-steps](#step-kernel-upgrade-keeps-steps), [linux-runs](#step-linux-runs), [cycles-repeat-clean](#step-cycles-repeat-clean)
- **Proof:** `suite-filed`, phone-suite
- **Helper:** `lpoco lab suite put, run`
- **Guide:** From here a part's status is measured, not judged (surya 2026-11-17-health-on-the-phone).

<a id="stage-lab"></a>
## 8. Lab

What the lab needs of a machine to work on it without hands: the ways in, a try that cannot brick, and a hardware-test layer with no shell to suspend, lock or answer keys on its own.

<a id="step-lab-link-held-awake"></a>
### The lab's link holds the phone awake

Step 29 in the chain, id `lab-link-held-awake`, applies to `any`, checked on 2026-11-18.

- **Done when:** while a host holds the USB link, nothing suspends the phone, and the hold is released on purpose for sleep tests
- **Needs:**
  - [usb-network](#step-usb-network) - hard: the link is the USB network
- **Enables:** [shell-autosleep-tamed](#step-shell-autosleep-tamed), [usb-host-works](#step-usb-host-works), [test-layer-boots](#step-test-layer-boots)
- **Proof:** `usb-awake`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: 26 link drops in 5 minutes before the hold (2026-11-10-usb-flapping), the screen blanking by itself (2026-11-18-screen-blanks-by-itself); held by devlab-usb-awake-hold-through-resume, moving to a package (surya-awake-from-package).

<a id="step-test-layer-boots"></a>
### The test layer boots, with no shell

Step 68 in the chain, id `test-layer-boots`, applies to `any`, checked on 2026-11-19.

- **Done when:** a boot with no phone shell (multi-user.target, no display manager) is up with a tty, ssh and the lab's services, and nothing in it suspends, locks or reacts to keys unless a test asks; the lab's suspend work runs there
- **Needs:**
  - [health-suite-runs](#step-health-suite-runs) - hard: the layer is proven by a health check
  - [lab-link-held-awake](#step-lab-link-held-awake) - hard: lpoco-awake is part of the layer: the lab's link stays up unless a test asks
  - [rootfs-boots](#step-rootfs-boots) - hard: a root with its services
- **Enables:** [s2idle-cycle-returns](#step-s2idle-cycle-returns)
- **Proof:** `test-layer-quiet`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Hardware steps are proven here, the shell's own in the shell stage (2026-11-19-hardware-test-layer). lab-tools' health-test-layer-quiet reads it: no shell or idle-suspend process runs, logind's IdleAction and HandlePowerKey are ignore, no suspend this boot but the health suite's own cycles; in a shell layer it says skip and names the shell, so the step stays unknown until the test layer boots. surya: the image it runs, booted from a second entry with systemd.unit=multi-user.target, the sxmo entry beside it. A new device's first root filesystem is this layer. Measured: test-layer-sxmo-cost-measured, test-layer-landscape.

<a id="stage-coprocessors"></a>
## 9. Coprocessors

The processors a phone leans on - the modem's, the audio and sensor DSPs, the Wi-Fi core - get their firmware, run, and stay up.

<a id="step-firmware-reachable"></a>
### The device's firmware is reachable

Step 16 in the chain, id `firmware-reachable`, applies to `any`, checked on 2026-11-18.

- **Done when:** every firmware file the kernel asks for is found: no failed direct firmware load for a needed file
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: the kernel asks for the files
- **Enables:** [remoteprocs-running](#step-remoteprocs-running), [touch-input](#step-touch-input), [gpu-renders](#step-gpu-renders), [bt-controller-up](#step-bt-controller-up), [wifi-joins](#step-wifi-joins), [nfc-reads-tag](#step-nfc-reads-tag)
- **Proof:** `firmware-found`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Signed blobs are the stock system's, per device: from the stock partitions read-only (msm-firmware-loader, which assumes eMMC) or a firmware package (pmos-firmware-docs; surya firmware-xiaomi-surya).
- **Sources:** [msm-firmware-loader: eMMC assumption](https://gitlab.com/postmarketOS/msm-firmware-loader/-/issues/3), [postmarketOS: firmware packaging](https://docs.postmarketos.org/pmaports/main/firmware.html), [firmware-xiaomi-surya (sensors configs and pre-parsed registry)](https://github.com/sm7150-mainline/firmware-xiaomi-surya)

<a id="step-pd-mapper-before-remoteproc"></a>
### The domain mapper is up before the DSPs

Step 17 in the chain, id `pd-mapper-before-remoteproc`, applies to `soc:qcom`, checked on 2026-11-18.

- **Done when:** the protection-domain mapper serves before qcom\_q6v5\_pas probes, so the audio domain comes up on 20 boots of 20
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: an order of modules at boot
- **Enables:** [remoteprocs-running](#step-remoteprocs-running), [sound-card-registered](#step-sound-card-registered)
- **Proof:** `sound-card`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: 8 boots of 42 had no sound card without a softdep (no-sound-card-boots; surya-lab lab/devlab-pd-mapper.conf), 21 of 21 with it; the upstream form is open (upstream-pd-mapper-order). The mapper is in the kernel since 2024 (inkernel-pd-mapper).
- **Sources:** [In-kernel protection-domain mapper, v9](https://lkml.iu.edu/2406.2/09265.html)

<a id="step-remoteprocs-running"></a>
### Every coprocessor runs

Step 22 in the chain, id `remoteprocs-running`, applies to `any`, checked on 2026-11-18.

- **Done when:** every remoteproc the device has reads running and none crashed this boot
- **Needs:**
  - [firmware-reachable](#step-firmware-reachable) - hard: each coprocessor boots a signed blob
  - [pd-mapper-before-remoteproc](#step-pd-mapper-before-remoteproc) - hard: the audio domain needs the mapper first (no-sound-card-boots)
- **Enables:** [audio-codec-attached](#step-audio-codec-attached), [wifi-joins](#step-wifi-joins), [fastrpc-helpers-stable](#step-fastrpc-helpers-stable), [modem-file-services](#step-modem-file-services), [coprocessor-restart-recovers](#step-coprocessor-restart-recovers)
- **Proof:** `adsp-running,cdsp-running,modem-running,no-processor-crashes`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya done; walleye open (walleye-radios-research). Trap: the ADSP 'handover signaled' every second (adsp-handover-loop).

<a id="step-fastrpc-helpers-stable"></a>
### The DSP helpers run without crashing the DSP

Step 58 in the chain, id `fastrpc-helpers-stable`, applies to `soc:qcom`, checked on 2026-11-18.

- **Done when:** the FastRPC helpers (hexagonrpcd) serve and the DSP they talk to stays up over three boots
- **Needs:**
  - [remoteprocs-running](#step-remoteprocs-running) - hard: the helpers talk to a running DSP
  - [rootfs-boots](#step-rootfs-boots) - hard: hexagonrpcd is userspace
- **Enables:** [sensor-hub-stable](#step-sensor-hub-stable)
- **Proof:** `no-processor-crashes`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the rootpd helper crashed the ADSP 24 times of 24 (2026-11-10-suspend-crash-found, adsp-sensor-crash-loop); masked in surya's device.toml.

<a id="stage-display"></a>
## 10. Display and input

The panel lights, touch and keys answer, the GPU renders.

<a id="step-panel-lit"></a>
### The panel lights

Step 18 in the chain, id `panel-lit`, applies to `any`, checked on 2026-11-18, first light of the part `display-panel`.

- **Done when:** the console or a test pattern shows on the panel and the backlight follows its control
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: the panel driver is the kernel's
- **Enables:** [gpu-renders](#step-gpu-renders), [display-any-order](#step-display-any-order), [charger-mode-entered](#step-charger-mode-entered), [shell-runs-with-hardware](#step-shell-runs-with-hardware), [brightness-follows-light](#step-brightness-follows-light)
- **Proof:** `panel-connected,backlight`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Qualcomm DSI panels: a driver generated from the downstream tree (lmdpdg). walleye needs a command-mode panel driver (walleye-display-s6e3fa5).
- **Sources:** [linux-mdss-dsi-panel-driver-generator](https://github.com/msm8916-mainline/linux-mdss-dsi-panel-driver-generator)

<a id="step-touch-input"></a>
### Touch answers

Step 23 in the chain, id `touch-input`, applies to `any`, checked on 2026-11-18, first light of the part `touchscreen`.

- **Done when:** a touch at each corner gives events at the right coordinates
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: the touch driver is the kernel's
  - [firmware-reachable](#step-firmware-reachable) - soft: some touch controllers load firmware
- **Enables:** [shell-runs-with-hardware](#step-shell-runs-with-hardware)
- **Proof:** `touch-device`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya done; walleye open (walleye-touch-rmi4). The suite proves presence; coordinates need a hand or a robot.

<a id="step-gpu-renders"></a>
### The GPU renders

Step 24 in the chain, id `gpu-renders`, applies to `any`, checked on 2026-11-18, first light of the part `gpu`.

- **Done when:** a GL and a Vulkan client render on the GPU (not a software renderer) to the panel
- **Needs:**
  - [firmware-reachable](#step-firmware-reachable) - hard: the zap shader and GMU firmware
  - [panel-lit](#step-panel-lit) - hard: renders to the panel
- **Enables:** [camera-stream-viewable](#step-camera-stream-viewable), [shell-runs-with-hardware](#step-shell-runs-with-hardware), [complete-phone](#step-complete-phone)
- **Proof:** `gpu-renders`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write; never measured in our labs. Adreno needs its zap shader and GMU firmware from the device.

<a id="step-display-any-order"></a>
### The display comes up at boot in any order

Step 25 in the chain, id `display-any-order`, applies to `any`, checked on 2026-11-19, first light of the part `display-panel`.

- **Done when:** on three cold boots the panel, its bridge and the GPU bind by deferred probe with their modules autoloaded (modalias), no initramfs module list or modprobe ordering of ours, and the console shows on the panel each time
- **Needs:**
  - [panel-lit](#step-panel-lit) - hard: the panel must light by hand before its order can be left to deferred probe
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `display-boots-any-order: three boots; each boot's dmesg shows the panel bound after any deferral, lsmod lists the modules with no ordering file in the image, the panel lit`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Upstream-readiness: a driver that only works with a hand-ordered module list is not ready for mainline. Return -EPROBE\_DEFER for each supplier not yet there (regulators, the DSI host, the backlight, the GPIO expander), declare the suppliers in the device tree so fw\_devlink orders it, and drop any modules-load or initramfs ordering list. walleye's B1 bring-up met the order dependence (walleye-display-s6e3fa5).

<a id="step-buttons-report"></a>
### The keys report one event a press

Step 59 in the chain, id `buttons-report`, applies to `any`, checked on 2026-11-18, first light of the part `buttons`.

- **Done when:** power and volume keys give one press and one release each, no chatter
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: events are read in userspace
  - [pmic-bound](#step-pmic-bound) - soft: the power and volume-down keys are the PMIC's on most phones
- **Enables:** [lock-and-unlock](#step-lock-and-unlock)
- **Proof:** `key-events`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the volume-down key on the PMIC chatters (2026-11-18-screen-off-while-typing-key-events, surya-key-chatter-resin).

<a id="step-haptics-buzz"></a>
### The vibrator buzzes

Step 60 in the chain, id `haptics-buzz`, applies to `any`, checked on 2026-11-18, first light of the part `haptics`.

- **Done when:** a force-feedback effect is felt
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: the effect is played from userspace
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `vibrator`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** The suite proves presence only; the buzz is a hand's witness. walleye open (walleye-audio-haptics, DRV2624).

<a id="stage-audio"></a>
## 11. Sound

The card, the codec and the amplifiers, a profile for the shell, sound heard and recorded.

<a id="step-audio-codec-attached"></a>
### The codec attaches and stays

Step 30 in the chain, id `audio-codec-attached`, applies to `any`, checked on 2026-11-18.

- **Done when:** the codec enumerates on its buses (SoundWire, I2S, I2C) and stays attached across the boot
- **Needs:**
  - [remoteprocs-running](#step-remoteprocs-running) - hard: on DSP-routed audio the codec's bus is the DSP's
- **Enables:** [sound-card-registered](#step-sound-card-registered)
- **Proof:** `sound-card,mic-records`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya WCD937x: a wrong aoncc address hung the boot (wcd937x-dt-aoncc); the sleep pin state drove reset low (microphone-codec-drops-off); the LPI mux from the vendor tree (2026-11-11-lpi-mux-from-vendor). Hazard: reading the LPASS pinctrl in debugfs hangs the phone.
- **Sources:** [The vendor-derived WCD937x driver (LineageOS sm6150 kernel)](https://github.com/LineageOS/android_kernel_xiaomi_sm6150/tree/lineage-23.2/techpack/audio/asoc/codecs/wcd937x), [Xiaomi's GPL kernel for surya: the LPASS pin states](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/surya-q-oss/arch/arm64/boot/dts/qcom/sm6150-lpi.dtsi)

<a id="step-sound-card-registered"></a>
### The sound card registers

Step 34 in the chain, id `sound-card-registered`, applies to `any`, checked on 2026-11-18.

- **Done when:** the machine's card is listed on every boot
- **Needs:**
  - [audio-codec-attached](#step-audio-codec-attached) - hard: the card binds its codec
  - [pd-mapper-before-remoteproc](#step-pd-mapper-before-remoteproc) - hard: 8 boots of 42 had no card without it (no-sound-card-boots)
- **Enables:** [speaker-amps-fed](#step-speaker-amps-fed), [mic-captures](#step-mic-captures), [call-audio-path](#step-call-audio-path)
- **Proof:** `sound-card`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: lost on 8 boots of 42 until the domain mapper was ordered (no-sound-card-boots).

<a id="step-speaker-amps-fed"></a>
### The amplifiers get their channels

Step 39 in the chain, id `speaker-amps-fed`, applies to `any`, checked on 2026-11-18.

- **Done when:** each speaker amplifier gets its slot and is unmuted at the chip, not only in the driver's cache
- **Needs:**
  - [sound-card-registered](#step-sound-card-registered) - hard: the amplifiers are the card's links
- **Enables:** [ucm-hifi-profile](#step-ucm-hifi-profile)
- **Proof:** `amp-channels,amp-volume-0x4c,amp-volume-0x4d`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya tas2562: the slot length (upstream-tas2562-slot-length) and a volume write that reached only the cache (plasma-silent, upstream-tas2562-volume).

<a id="step-mic-captures"></a>
### The microphones capture

Step 40 in the chain, id `mic-captures`, applies to `any`, checked on 2026-11-18, first light of the part `audio-mic`.

- **Done when:** a second of capture from each microphone is not digital silence
- **Needs:**
  - [sound-card-registered](#step-sound-card-registered) - hard: capture is the card's
- **Enables:** [video-recorded](#step-video-recorded), [headset-jack](#step-headset-jack), [mic-hears-speaker](#step-mic-hears-speaker), [call-audio-path](#step-call-audio-path)
- **Proof:** `mic-records`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: zeros meant the link named the wrong DAI (mic-zeros-meant-no-input); the mics are analog through the WCD, ADC2 on its own port (2026-11-17-microphones-analog-wcd-path).
- **Sources:** [LineageOS sm6150 kernel: the vendor bolero codec (tx-macro, va-macro, bolero-cdc) and sm6150 machine driver](https://github.com/LineageOS/android_kernel_xiaomi_sm6150/tree/lineage-23.2/techpack/audio/asoc/codecs/bolero)

<a id="step-ucm-hifi-profile"></a>
### A UCM profile plays to the real card

Step 61 in the chain, id `ucm-hifi-profile`, applies to `any`, checked on 2026-11-18.

- **Done when:** the shell's sound server picks the card's HiFi verb and plays in stereo, the right channel to the right speaker
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: UCM and the sound server are userspace
  - [speaker-amps-fed](#step-speaker-amps-fed) - hard: the profile drives the amplifiers
- **Enables:** [speaker-heard](#step-speaker-heard), [earpiece-plays](#step-earpiece-plays), [headset-jack](#step-headset-jack), [bt-pairs-carries-audio](#step-bt-pairs-carries-audio), [shell-runs-with-hardware](#step-shell-runs-with-hardware)
- **Proof:** `default-output,speaker-stereo`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya ucm/Xiaomi/surya/HiFi.conf (2026-11-11-right-is-bottom), upstream open (upstream-ucm-surya-stereo).
- **Sources:** [sm7125-mainline/alsa-ucm-conf: miatoll HiFi (TX macro, TX\_CODEC\_DMA\_TX\_3 mic entries)](https://github.com/sm7125-mainline/alsa-ucm-conf/blob/059aa77e6ebc78f10f1d160fd9c4f07d50080912/ucm2/Xiaomi/miatoll/HiFi.conf)

<a id="step-speaker-heard"></a>
### The speaker is heard

Step 69 in the chain, id `speaker-heard`, applies to `any`, checked on 2026-11-18, first light of the part `audio-speaker`.

- **Done when:** a quiet tone on each channel is heard by the lab's ear
- **Needs:**
  - [ucm-hifi-profile](#step-ucm-hifi-profile) - hard: the tone plays through the profile
- **Enables:** [mic-hears-speaker](#step-mic-hears-speaker), [notifications-arrive](#step-notifications-arrive), [alarm-wakes-from-sleep](#step-alarm-wakes-from-sleep), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `heard-left,heard-right`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Quiet tones only. surya: one 'heard' was withdrawn when the microphone had moved (2026-11-10-heard).

<a id="step-earpiece-plays"></a>
### The earpiece plays

Step 70 in the chain, id `earpiece-plays`, applies to `form:phone`, checked on 2026-11-18, first light of the part `audio-earpiece`.

- **Done when:** a tone through the earpiece is heard by the bottom microphone
- **Needs:**
  - [ucm-hifi-profile](#step-ucm-hifi-profile) - hard: routed by the profile
- **Enables:** [call-audio-path](#step-call-audio-path), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `earpiece-heard`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the earpiece is the second TAS256x at 0x4d, not the codec's EAR amplifier (parts row audio-earpiece).

<a id="step-headset-jack"></a>
### A headset works through the jack

Step 71 in the chain, id `headset-jack`, applies to `any`, checked on 2026-11-18, first light of the part `audio-headphone`.

- **Done when:** plugging is detected, sound plays to the headset and its microphone records
- **Needs:**
  - [ucm-hifi-profile](#step-ucm-hifi-profile) - hard: routed by the profile
  - [mic-captures](#step-mic-captures) - soft: the headset's microphone is a capture path
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `jack-detector,headset-loop`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya partial: detection only (verify-headphone-mic-earpiece). A loopback plug can prove both ways without hands.

<a id="step-mic-hears-speaker"></a>
### Each microphone hears the speaker

Step 80 in the chain, id `mic-hears-speaker`, applies to `any`, checked on 2026-11-18.

- **Done when:** each microphone finds the phone's own tone 20 dB above the noise
- **Needs:**
  - [mic-captures](#step-mic-captures) - hard: it records
  - [speaker-heard](#step-speaker-heard) - hard: the tone it listens for
- **Enables:** [coprocessor-restart-recovers](#step-coprocessor-restart-recovers), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `mic-hears-speaker,mic-top-hears-speaker`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** A closed loop with no hands: surya done (mic-held).

<a id="stage-modem"></a>
## 12. Modem, SMS and data

The modem seen, the SIM read, the network joined; messages and data both ways.

<a id="step-modem-file-services"></a>
### The modem's file services serve

Step 62 in the chain, id `modem-file-services`, applies to `soc:qcom`, checked on 2026-11-18.

- **Done when:** rmtfs, the qrtr name service, pd-mapper and tqftpserv run and the modem's mode is online, not shutting down
- **Needs:**
  - [remoteprocs-running](#step-remoteprocs-running) - hard: the modem runs
  - [rootfs-boots](#step-rootfs-boots) - hard: rmtfs and tqftpserv are userspace
- **Enables:** [modem-seen](#step-modem-seen)
- **Proof:** `modem-running`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: tqftpserv 1.1.1 never wrote short files and the modem looped 4769 times; 1.2 or later fixed it (modem-online-tqftpserv, upstream-alpine-tqftpserv).
- **Sources:** [modem/tqftpserv: upgrade and add patches for rsize & seek option handling (pmaports !4747)](https://gitlab.com/postmarketOS/pmaports/-/merge_requests/4747), [qcom-sm7150 (xiaomi-surya) unable to unlock sim: QMI protocol error (3) - root cause tqftpserv 1.1.1 (pmaports #4441)](https://gitlab.nura.eco/nura/pmaports/-/work_items/4441)

<a id="step-modem-seen"></a>
### The modem is seen

Step 72 in the chain, id `modem-seen`, applies to `radio:cellular`, checked on 2026-11-18.

- **Done when:** ModemManager (or oFono) lists the modem
- **Needs:**
  - [modem-file-services](#step-modem-file-services) - hard: the modem stays offline without them (modem-online-tqftpserv)
- **Enables:** [sim-ready](#step-sim-ready), [emergency-numbers-known](#step-emergency-numbers-known), [gnss-fix](#step-gnss-fix)
- **Proof:** `modem-seen`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** On Qualcomm SoCs through the qcom-soc plugin over QRTR and IPA or BAM-DMUX (mm-qcom-soc-plugin).
- **Sources:** [ModemManager qcom-soc plugin](https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/374)

<a id="step-sim-ready"></a>
### The SIM is read

Step 81 in the chain, id `sim-ready`, applies to `radio:cellular`, checked on 2026-11-18.

- **Done when:** the SIM reads present and unlocked, in each slot the device has
- **Needs:**
  - [modem-seen](#step-modem-seen) - hard: read through the modem
- **Enables:** [modem-registered](#step-modem-registered)
- **Proof:** `sim-ready`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the SIM works only in slot 2 (modem-online-tqftpserv); checks that need a SIM skip, not fail, without one (sim-removed-skips).
- **Sources:** [qcom-sm7150 (xiaomi-surya) unable to unlock sim: QMI protocol error (3) - root cause tqftpserv 1.1.1 (pmaports #4441)](https://gitlab.nura.eco/nura/pmaports/-/work_items/4441)

<a id="step-modem-registered"></a>
### The modem joins the network

Step 89 in the chain, id `modem-registered`, applies to `radio:cellular`, checked on 2026-11-18.

- **Done when:** the modem is registered on a network
- **Needs:**
  - [sim-ready](#step-sim-ready) - hard: no registration without a SIM
- **Enables:** [sms-both-ways](#step-sms-both-ways), [mobile-data](#step-mobile-data), [call-audio-path](#step-call-audio-path), [coprocessor-restart-recovers](#step-coprocessor-restart-recovers)
- **Proof:** `modem-registered`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Read-only first (2026-11-11-modem-read-only-first). surya done.

<a id="step-sms-both-ways"></a>
### SMS both ways

Step 96 in the chain, id `sms-both-ways`, applies to `radio:cellular`, checked on 2026-11-18, first light of the part `modem-sms`.

- **Done when:** a message sent to the phone's own number comes back
- **Needs:**
  - [modem-registered](#step-modem-registered) - hard: needs the network
- **Enables:** [mms-both-ways](#step-mms-both-ways), [notifications-arrive](#step-notifications-arrive), [call-wakes-from-sleep](#step-call-wakes-from-sleep), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `sms-loopback`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya done (tests/health/telephony/sms-loopback.sh); it costs money, so it runs at most once a day.

<a id="step-mobile-data"></a>
### Mobile data

Step 97 in the chain, id `mobile-data`, applies to `radio:cellular`, checked on 2026-11-18, first light of the part `modem-data`.

- **Done when:** pings and a 100 kB download go over the bearer's own interface, so Wi-Fi cannot stand in
- **Needs:**
  - [modem-registered](#step-modem-registered) - hard: needs the network
- **Enables:** [mms-both-ways](#step-mms-both-ways), [hotspot-shares-data](#step-hotspot-shares-data), [volte-call](#step-volte-call), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `mobile-data`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: naming the APN gave 'Multiple PDN connection', so the connection carries none (modem-online-tqftpserv); budget mobile-data-check-budget.

<a id="step-mms-both-ways"></a>
### MMS both ways

Step 102 in the chain, id `mms-both-ways`, applies to `radio:cellular`, checked on 2026-11-18.

- **Done when:** a picture message sent to the phone's own number comes back
- **Needs:**
  - [mobile-data](#step-mobile-data) - hard: MMS is fetched over data
  - [sms-both-ways](#step-sms-both-ways) - hard: MMS is announced by SMS
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `mms-loopback`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write; never tried in our labs (mmsd-tng).

<a id="stage-calls"></a>
## 13. Calls

A call with sound both ways, the screen dark at the ear, emergency numbers known, calls over LTE.

<a id="step-emergency-numbers-known"></a>
### Emergency numbers are known

Step 82 in the chain, id `emergency-numbers-known`, applies to `form:phone`, checked on 2026-11-18.

- **Done when:** the modem's emergency list is read, and 112 would be dialled as an emergency call even without a SIM - proven without dialling
- **Needs:**
  - [modem-seen](#step-modem-seen) - hard: the list is the modem's and the SIM's
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `emergency-list`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write. Android's rule: 112 and 911 always; the list from network, SIM, modem or defaults (android-emergency-call). surya open (volte-and-emergency).
- **Sources:** [Android emergency calls](https://source.android.com/docs/core/connect/emergency-call)

<a id="step-call-audio-path"></a>
### The call's sound path exists

Step 98 in the chain, id `call-audio-path`, applies to `form:phone`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** the voice DSP path (q6voice on Qualcomm), its routing and a Voice Call UCM verb are present
- **Needs:**
  - [mic-captures](#step-mic-captures) - hard: the uplink is a capture (call-audio-on-surya)
  - [modem-registered](#step-modem-registered) - hard: a call needs the network
  - [sound-card-registered](#step-sound-card-registered) - hard: the voice path is the card's
  - [earpiece-plays](#step-earpiece-plays) - soft: the downlink's usual way out
- **Enables:** [voice-call-both-ways](#step-voice-call-both-ways)
- **Proof:** `call-audio-path`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: a TX topology sent silence; the uplink needs a 1-channel capture on TX\_CODEC\_DMA\_TX\_3 (call-audio-on-surya, calls-q6voice-kernel, calls-voice-ucm-uplink). World gap: q6voice lives out of tree in diverging copies and nothing exists for AudioReach SoCs (ixit-sdm845-upstreaming-0).
- **Sources:** [sdm845 upstreaming, month 0](https://ixit.cz/blog/2025-12-21-upstreaming-0)

<a id="step-voice-call-both-ways"></a>
### A call carries sound both ways

Step 103 in the chain, id `voice-call-both-ways`, applies to `form:phone`, checked on 2026-11-18, first light of the part `modem-calls`.

- **Done when:** a tone sent into a call comes back from an echo line
- **Needs:**
  - [call-audio-path](#step-call-audio-path) - hard: sound both ways
- **Enables:** [volte-call](#step-volte-call), [call-wakes-from-sleep](#step-call-wakes-from-sleep), [proximity-blanks-in-call](#step-proximity-blanks-in-call), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `call-echo`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Proven by an echo call, no hands (2026-11-17-calls-proven-by-echo-call, echo-call-test-design). surya done.
- **Sources:** [Programmable voice (a number that answers and plays a tone)](https://www.twilio.com/docs/voice)

<a id="step-volte-call"></a>
### A call over LTE

Step 109 in the chain, id `volte-call`, applies to `radio:cellular`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** a call is known to go over IMS and carries sound both ways
- **Needs:**
  - [mobile-data](#step-mobile-data) - hard: IMS rides a data bearer the AP serves (voltd-81)
  - [voice-call-both-ways](#step-voice-call-both-ways) - hard: a call first
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `volte-call`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** World gap: no open IMS works across carriers; 81voltd serves the IMS data service on some phones and carriers, OpenIMSd reverse-engineers the rest, one emergency VoLTE call on a Fairphone 6 (linmob-weekly-34-2026). surya open (volte-and-emergency).
- **Sources:** [81voltd README](https://sources.debian.org/src/81voltd/1.1.0-1/README.md), [NLnet: VoLTE on Qualcomm (OpenIMSd)](https://nlnet.nl/project/VoLTE-Qualcom/), [VoLTE project: QMI sniffing with Frida](https://nura.eco/blog/2025/06/17/volte-project-qmi-sniffing-with-frida/), [Weekly Linux phone update 34/2026](https://linmob.net/weekly-update-34-2026/)

<a id="stage-radios"></a>
## 14. Local radios

Wi-Fi, Bluetooth, NFC, USB host and sharing the connection.

<a id="step-bt-controller-up"></a>
### The Bluetooth controller is up

Step 26 in the chain, id `bt-controller-up`, applies to `any`, checked on 2026-11-18, first light of the part `bluetooth`.

- **Done when:** the controller is listed and powers on
- **Needs:**
  - [firmware-reachable](#step-firmware-reachable) - hard: the controller's firmware
- **Enables:** [bt-pairs-carries-audio](#step-bt-pairs-carries-audio), [radios-survive-suspend](#step-radios-survive-suspend), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `bt-controller,bt-powered`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya done; walleye open (walleye-wifi-wcn3990).

<a id="step-wifi-joins"></a>
### Wi-Fi joins and reaches the gateway

Step 31 in the chain, id `wifi-joins`, applies to `any`, checked on 2026-11-18, first light of the part `wifi`.

- **Done when:** the interface joins a network and reaches its gateway
- **Needs:**
  - [firmware-reachable](#step-firmware-reachable) - hard: the Wi-Fi core's firmware
  - [remoteprocs-running](#step-remoteprocs-running) - hard: WCN3990: the Wi-Fi firmware runs on the modem's processor
- **Enables:** [radios-survive-suspend](#step-radios-survive-suspend), [hotspot-shares-data](#step-hotspot-shares-data), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `wifi-interface,wifi-connected,wifi-reaches-gateway`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** walleye open: the WCN3990 firmware from the vendor partition (walleye-wifi-wcn3990). 5 GHz and speed never measured.

<a id="step-nfc-reads-tag"></a>
### NFC reads a tag

Step 63 in the chain, id `nfc-reads-tag`, applies to `any`, checked on 2026-11-18, first light of the part `nfc`.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** a tag held to the phone is read
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: read in userspace
  - [firmware-reachable](#step-firmware-reachable) - soft: some controllers load firmware
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `nfc-reads-tag`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the controller probes (nfc-device), nothing reads tags. World gap: NFC unclaimed on these phones.

<a id="step-usb-host-works"></a>
### USB host works

Step 64 in the chain, id `usb-host-works`, applies to `any`, checked on 2026-11-18, first light of the part `usb-otg`.

- **Done when:** the port switches to host and a plugged device enumerates
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: the device is read in userspace
  - [lab-link-held-awake](#step-lab-link-held-awake) - soft: switching the port cuts the lab's USB link: another way in first
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `usb-role,usb-host-device`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Switching the port cuts the lab's USB link: a second way in first.

<a id="step-bt-pairs-carries-audio"></a>
### Bluetooth pairs and carries sound

Step 73 in the chain, id `bt-pairs-carries-audio`, applies to `any`, checked on 2026-11-18.

- **Done when:** a headset pairs, plays and records, in a call too
- **Needs:**
  - [bt-controller-up](#step-bt-controller-up) - hard: pairs through it
  - [ucm-hifi-profile](#step-ucm-hifi-profile) - soft: the sound server carries the audio
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `bt-pairs`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya open (bt-pairing).

<a id="step-hotspot-shares-data"></a>
### The phone shares its data

Step 104 in the chain, id `hotspot-shares-data`, applies to `radio:cellular`, checked on 2026-11-18.

- **Done when:** a client on the phone's Wi-Fi hotspot reaches the internet over mobile data
- **Needs:**
  - [mobile-data](#step-mobile-data) - hard: it shares the data
  - [wifi-joins](#step-wifi-joins) - hard: over the Wi-Fi core
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `hotspot`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write; never tried.

<a id="stage-sensors"></a>
## 15. Sensors and location

Motion, light and proximity read and used; a position fix; the fingerprint reader.

<a id="step-fingerprint-unlocks"></a>
### The fingerprint unlocks

Step 65 in the chain, id `fingerprint-unlocks`, applies to `any`, checked on 2026-11-18, first light of the part `fingerprint`.

- **Done when:** a finger enrols and unlocks through fprintd
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: fprintd is userspace
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `fingerprint-unlock`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the reader is not exposed (reader-exposed fails, a declared gap). Most phone readers are not in libfprint.

<a id="step-sensor-hub-stable"></a>
### The sensor hub runs without crashing its DSP

Step 74 in the chain, id `sensor-hub-stable`, applies to `soc:qcom`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** the sensor domain runs with no DSP crash over three boots
- **Needs:**
  - [fastrpc-helpers-stable](#step-fastrpc-helpers-stable) - hard: the sensor helper is a FastRPC client
- **Enables:** [sensors-exposed](#step-sensors-exposed)
- **Proof:** `no-processor-crashes`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: the registry kept current and a hexagonrpcd patch (2026-11-17-sensors-registry-kept-current, 2026-11-17-sensors-lasting-install-three-boots). World gap: why registry writes fail on some firmware.
- **Sources:** [hexagonrpc source (rpcd\_builder.c, apps\_std.c, hexagonfs\_mapped.c), v0.4.0 to v0.5.0](https://github.com/linux-msm/hexagonrpc), [libssc: Qualcomm Sensor Core sensors for Linux](https://codeberg.org/DylanVanAssche/libssc), [postmarketOS wiki, POCO X3 NFC: revision 56784 'SSC works'](https://wiki.nura.eco/wiki/Xiaomi_POCO_X3_NFC_(xiaomi-surya))

<a id="step-sensors-exposed"></a>
### Motion and light sensors read

Step 83 in the chain, id `sensors-exposed`, applies to `any`, checked on 2026-11-18, first light of the part `sensors`.

- **Done when:** accelerometer, gyroscope and light give changing values through iio-sensor-proxy
- **Needs:**
  - [sensor-hub-stable](#step-sensor-hub-stable) - hard: the hub serves them (on Qualcomm's sensor DSP)
- **Enables:** [proximity-reads](#step-proximity-reads), [sensors-across-suspend](#step-sensors-across-suspend), [auto-rotate-follows](#step-auto-rotate-follows), [brightness-follows-light](#step-brightness-follows-light), [coprocessor-restart-recovers](#step-coprocessor-restart-recovers)
- **Proof:** `motion-and-light`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya done (motion-and-light; the test once counted devices only, sensors-hardware-surya). Behind the Qualcomm DSP through libssc (iio-sensor-proxy-libssc).
- **Sources:** [iio-sensor-proxy: libssc support](https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/381)

<a id="step-gnss-fix"></a>
### A position fix

Step 84 in the chain, id `gnss-fix`, applies to `any`, checked on 2026-11-18, first light of the part `gnss`.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** a fix outdoors within 5 minutes, reaching geoclue
- **Needs:**
  - [modem-seen](#step-modem-seen) - hard: on Qualcomm the location engine is the modem's (QMI LOC)
  - [rootfs-boots](#step-rootfs-boots) - hard: ModemManager, gnss-share and geoclue are userspace
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `gps-fix`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** On Qualcomm the location engine is the modem's (QMI LOC), through ModemManager and gnss-share. surya open (gps-measurable). World gap: no assisted GPS (XTRA) anywhere.
- **Sources:** [gnss-share](https://gitlab.postmarketos.org/postmarketOS/gnss-share)

<a id="step-proximity-reads"></a>
### Proximity reads near and far

Step 90 in the chain, id `proximity-reads`, applies to `any`, checked on 2026-11-18.

- **Done when:** covering the sensor changes its reading from far to near and back
- **Needs:**
  - [sensors-exposed](#step-sensors-exposed) - hard: through the same service
- **Enables:** [proximity-blanks-in-call](#step-proximity-blanks-in-call)
- **Proof:** `proximity-reads`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya partial: covering it waits a witness (sensors-proximity-cover-witnessed).

<a id="stage-camera"></a>
## 16. Camera

From the camera bus to a photo and a video: sensor, raw frame, a viewable stream, focus and flash.

<a id="step-camera-bus-bound"></a>
### The camera bus binds

Step 19 in the chain, id `camera-bus-bound`, applies to `any`, checked on 2026-11-18.

- **Done when:** the camera receiver (CAMSS: CSIPHY, CSID, VFE) and the control bus (CCI) bind
- **Needs:**
  - [kernel-reaches-init](#step-kernel-reaches-init) - hard: the receiver is the kernel's
- **Enables:** [image-sensor-identified](#step-image-sensor-identified)
- **Proof:** `camera-bus`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: CAMSS binds, no sensor described yet (2026-11-11-cameras-understood, surya-lab research/cameras.md).

<a id="step-image-sensor-identified"></a>
### Each image sensor is identified

Step 27 in the chain, id `image-sensor-identified`, applies to `any`, checked on 2026-11-18.

- **Done when:** each sensor's chip-id register reads its expected value in its slot
- **Needs:**
  - [camera-bus-bound](#step-camera-bus-bound) - hard: read over the control bus
- **Enables:** [raw-frame-captured](#step-raw-frame-captured)
- **Proof:** `image-sensor`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya failing: the slots are being identified (camera-identify-slots).

<a id="step-raw-frame-captured"></a>
### A raw frame

Step 32 in the chain, id `raw-frame-captured`, applies to `any`, checked on 2026-11-18.

- **Done when:** one raw frame from each sensor arrives through the receiver
- **Needs:**
  - [image-sensor-identified](#step-image-sensor-identified) - hard: a sensor described and probed
- **Enables:** [camera-stream-viewable](#step-camera-stream-viewable)
- **Proof:** `raw-frame`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write. Sensor drivers are often out of tree (Pixel 3a, OnePlus 6).

<a id="step-camera-stream-viewable"></a>
### A viewable stream

Step 35 in the chain, id `camera-stream-viewable`, applies to `any`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** libcamera lists each camera and its ISP (software or hardware) gives a viewable stream
- **Needs:**
  - [raw-frame-captured](#step-raw-frame-captured) - hard: the ISP takes raw frames
  - [gpu-renders](#step-gpu-renders) - soft: libcamera's software ISP runs on the GPU (libcamera-softisp-fosdem-2026)
- **Enables:** [photo-taken](#step-photo-taken), [focus-and-flash](#step-focus-and-flash)
- **Proof:** `camera-stream`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Today a software ISP, on the GPU since libcamera 0.7 (libcamera-softisp-fosdem-2026). World gap: the hardware ISP is not used on any Qualcomm phone (camss-stats-uapi-rfc).
- **Sources:** [libcamera SoftISP status update](https://fosdem.org/2026/schedule/event/libcamera-softisp), [qcom-camss stats and params uAPI RFC](https://lkml.iu.edu/2604.3/02474.html)

<a id="step-photo-taken"></a>
### A photo

Step 41 in the chain, id `photo-taken`, applies to `any`, checked on 2026-11-19, first light of the part `camera-rear`.

- **Done when:** a capture tool saves a photo with sane exposure and colour from each camera
- **Needs:**
  - [camera-stream-viewable](#step-camera-stream-viewable) - hard: the app takes the stream
- **Enables:** [video-recorded](#step-video-recorded), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `photo`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Fairphone 6: all three cameras in 2026, the furthest any Qualcomm phone got (linmob-weekly-34-2026). Proven in the test layer with a capture tool; a shell's camera app is the shell's own use of it (2026-11-19-hardware-test-layer).
- **Sources:** [Weekly Linux phone update 34/2026](https://linmob.net/weekly-update-34-2026/)

<a id="step-focus-and-flash"></a>
### Focus and flash

Step 42 in the chain, id `focus-and-flash`, applies to `any`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** autofocus moves the lens to a sharp image and the flash fires
- **Needs:**
  - [camera-stream-viewable](#step-camera-stream-viewable) - hard: focus is judged on the stream
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `focus-flash`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** World gap: 3A tuning for phone sensors has no public prior art; focus-coil drivers were in review in 2025.

<a id="step-video-recorded"></a>
### A video with sound

Step 48 in the chain, id `video-recorded`, applies to `any`, checked on 2026-11-18.

- **Done when:** a recorded video plays back with its sound in step
- **Needs:**
  - [mic-captures](#step-mic-captures) - hard: its sound
  - [photo-taken](#step-photo-taken) - hard: the camera app
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `video`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Never tried in our labs.

<a id="stage-sleep"></a>
## 17. Sleep and battery life

Suspend that returns, wakes only for what matters and reaches the SoC's floor; a day on one charge.

<a id="step-suspend-way-back"></a>
### A hang in sleep finds its way back

Step 54 in the chain, id `suspend-way-back`, applies to `any`, checked on 2026-11-18.

- **Done when:** a hang in or after suspend resets the machine or panics into ramoops
- **Needs:**
  - [watchdog-way-back](#step-watchdog-way-back) - hard: the watchdog, kept armed through sleep
- **Enables:** [s2idle-cycle-returns](#step-s2idle-cycle-returns), [resume-without-stall](#step-resume-without-stall), [standby-current](#step-standby-current)
- **Proof:** `sleep-way-back,pmic-wdt-wakes-in-suspend`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Extends watchdog-way-back into sleep. surya: the stock watchdog stops in suspend (2026-11-17-surya-way-back-inventory), kept armed by a patch (qcom-wdt-keep-armed-in-suspend); walleye: the PMIC watchdog bit and did not return (walleye-pmic-bite-reset-type-how-it-stands).
- **Sources:** [watchdog: qcom: Add suspend/resume support (Sai Prakash Ranjan, 2019)](https://lkml.iu.edu/1901.2/01680.html), [Linux kernel: ramoops](https://docs.kernel.org/admin-guide/ramoops.html)

<a id="step-s2idle-cycle-returns"></a>
### A timed suspend returns

Step 85 in the chain, id `s2idle-cycle-returns`, applies to `any`, checked on 2026-11-18.

- **Done when:** a 15 s RTC-timed suspend returns in the same boot
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: an RTC-timed suspend from userspace
  - [test-layer-boots](#step-test-layer-boots) - hard: the suspend work runs in the test layer, with no shell to suspend or lock on its own
  - [suspend-way-back](#step-suspend-way-back) - soft: blind without it: a hang in sleep leaves no trace
- **Enables:** [suspend-wakes-quiet](#step-suspend-wakes-quiet), [radios-survive-suspend](#step-radios-survive-suspend), [sensors-across-suspend](#step-sensors-across-suspend), [resume-without-stall](#step-resume-without-stall), [soc-floor-reached](#step-soc-floor-reached), [standby-current](#step-standby-current), [call-wakes-from-sleep](#step-call-wakes-from-sleep)
- **Proof:** `suspend-cycle`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya partial (health-suspend-cycle-proof): woke at once (2026-11-17-surya-s2idle-wakes-at-once), a UART wake across suspend (2026-11-17-qca-uart-wake-across-suspend). These SoCs have s2idle only (qcom-sleep-path).
- **Sources:** [Qualcomm: SoC power-saving states (CXSD, AOSD) on QCS6490](https://docs.qualcomm.com/doc/80-70020-30/topic/qcs6490-soc-power-saving-state.html)

<a id="step-suspend-wakes-quiet"></a>
### Only the meant sources wake it

Step 91 in the chain, id `suspend-wakes-quiet`, applies to `any`, checked on 2026-11-18.

- **Done when:** over a suspend only the RTC, the modem, the keys and the charger wake it
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: read across a suspend
- **Enables:** [soc-floor-reached](#step-soc-floor-reached), [standby-current](#step-standby-current)
- **Proof:** `suspend-irq-quiet`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya partial (floor-irq-quiet); ath10k floods the modem's interrupt on sdm845 (qcom-sleep-blockers).

<a id="step-radios-survive-suspend"></a>
### The radios come back from sleep

Step 92 in the chain, id `radios-survive-suspend`, applies to `any`, checked on 2026-11-18.

- **Done when:** after 20 cycles Wi-Fi and Bluetooth are up, with no interrupt storm and no controller crash
- **Needs:**
  - [bt-controller-up](#step-bt-controller-up) - hard: Bluetooth up first
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: across suspends
  - [wifi-joins](#step-wifi-joins) - hard: Wi-Fi up first
- **Enables:** [real-suspend-under-shell](#step-real-suspend-under-shell)
- **Proof:** `bt-suspend`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya partial: the CTS pull-down hung the boot (2026-11-18-cts-pulldown-dtb-hangs); serial wakeup off (2026-11-17-serial-wakeup-off, 2026-11-18-bt-suspend-way).

<a id="step-sensors-across-suspend"></a>
### Sensors come back from sleep

Step 93 in the chain, id `sensors-across-suspend`, applies to `any`, checked on 2026-11-18.

- **Done when:** the sensor helper is stopped before suspend and serves again after
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: across suspends
  - [sensors-exposed](#step-sensors-exposed) - hard: sensors up first
- **Enables:** [resume-without-stall](#step-resume-without-stall)
- **Proof:** `sensors-after-suspend`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** FastRPC helpers attached across suspend crash the ADSP: surya and the Pixel 3a stop them around it (2026-11-18-systemctl-suspend-leaves-sensors-stopped, sleep-fastrpc-helpers).
- **Sources:** [pmaports !5400 and !7303: stop sensorspd before suspend (Pixel 3a)](https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/5400)

<a id="step-resume-without-stall"></a>
### Resume without a stall

Step 99 in the chain, id `resume-without-stall`, applies to `any`, checked on 2026-11-18.

- **Done when:** 20 attended cycles with no coprocessor crash and no RCU stall
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: across suspends
  - [sensors-across-suspend](#step-sensors-across-suspend) - hard: an attached helper crashes the DSP at resume (sleep-fastrpc-helpers)
  - [suspend-way-back](#step-suspend-way-back) - hard: a stall must come back to be counted
- **Enables:** [cycles-repeat-clean](#step-cycles-repeat-clean), [real-suspend-under-shell](#step-real-suspend-under-shell)
- **Proof:** `resume-clean`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya failing (2026-11-18-resume-stall-how-it-stands, resume-stall-stop-clients).

<a id="step-soc-floor-reached"></a>
### The SoC reaches its floor

Step 100 in the chain, id `soc-floor-reached`, applies to `any`, checked on 2026-11-18, first light of the part `deep-sleep`.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** in suspend the SoC's deepest-state counters rise (on Qualcomm: CX collapse and AOSS sleep)
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: read in suspend
  - [suspend-wakes-quiet](#step-suspend-wakes-quiet) - soft: wakes keep it off the floor
- **Enables:** [standby-current](#step-standby-current)
- **Proof:** `soc-sleeps`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya failing: cxsd, aosd and ddr stay 0 (2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0, sleep-cluster-params). World gap: no public example of that floor on an SM7150/845-class phone (2026-11-17-floor-research).
- **Sources:** [drivers/soc/qcom/qcom\_stats.c (rpmh-stats layout: aosd, cxsd, ddr read by name from the AOSS message RAM)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/soc/qcom/qcom_stats.c), [lab-tools: the soc-sleeps check - the SoC's own sleep counters after every boot](https://github.com/linux-phone-oco/lab-tools/blob/main/health/suite/checks/base/90-sleep.sh)

<a id="step-standby-current"></a>
### Standby draws little

Step 105 in the chain, id `standby-current`, applies to `power:battery`, checked on 2026-11-19.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** on battery alone, asleep with the modem attached, the average current is under the device's target (15 mA on surya)
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: measured first in the test layer
  - [soc-floor-reached](#step-soc-floor-reached) - hard: no floor, no low current
  - [suspend-wakes-quiet](#step-suspend-wakes-quiet) - hard: a phone woken by chatter does not stay low (floor-irq-quiet)
  - [suspend-way-back](#step-suspend-way-back) - hard: a hang in sleep must find its way back before a night is measured
  - [battery-gauge-reads](#step-battery-gauge-reads) - soft: a meter can stand in for the gauge
- **Enables:** [all-day-battery](#step-all-day-battery)
- **Proof:** `standby-current`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** The arbiter of sleep (2026-11-17-standby-current-is-the-arbiter). surya partial: median 31 mA (2026-11-17-r3-partial-and-the-reset-after). World gap: no published s2idle figures per SoC with a modem. Measured first in the test layer, with no shell to wake it; the shell's figure follows under real-suspend-under-shell (2026-11-19-hardware-test-layer).
- **Sources:** [Android developers: Optimize for Doze and App Standby](https://developer.android.com/training/monitoring-device-state/doze-standby)

<a id="step-call-wakes-from-sleep"></a>
### A call or a message wakes it

Step 110 in the chain, id `call-wakes-from-sleep`, applies to `form:phone`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** a call rings and an SMS arrives within 10 s while the phone sleeps
- **Needs:**
  - [s2idle-cycle-returns](#step-s2idle-cycle-returns) - hard: it sleeps in the test layer first, where nothing else wakes it
  - [sms-both-ways](#step-sms-both-ways) - hard: a message to arrive
  - [voice-call-both-ways](#step-voice-call-both-ways) - hard: a call to ring
- **Enables:** [all-day-battery](#step-all-day-battery), [days-without-reboot](#step-days-without-reboot), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `wakes-for-call`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** The IPCRTR glink wakeup plus ModemManager's quick suspend; reported not dependable on OnePlus 6 and Pixel 3a (qcom-wake-for-calls). World gap: waking for a call but not for chatter. surya open (sleep-wakes-for-calls).
- **Sources:** [Nura (postmarketOS) wiki, SDM845: s2idle only; waking for calls through the modem's IPCRTR glink wakeup](https://wiki.nura.eco/wiki/Qualcomm_Snapdragon_845/850_(SDM845/SDM850)), [Nura (postmarketOS) wiki, OnePlus 6: ModemManager's quick suspend/resume and the IPCRTR wakeup](https://wiki.nura.eco/wiki/OnePlus_6_(oneplus-enchilada))

<a id="step-all-day-battery"></a>
### A day on one charge

Step 113 in the chain, id `all-day-battery`, applies to `power:battery`, checked on 2026-11-18.

- **Done when:** a day of mixed use - standby, calls, screen time - ends with charge left
- **Needs:**
  - [call-wakes-from-sleep](#step-call-wakes-from-sleep) - hard: a sleeping phone that misses calls is not a day's use
  - [standby-current](#step-standby-current) - hard: most of a day is standby
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `battery-day`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Never measured. UBports keeps it as an endurance test (ubports-device-data).
- **Sources:** [devices.ubuntu-touch.io data: portStatus, progressStages, supportStatus](https://gitlab.com/ubports/infrastructure/devices.ubuntu-touch.io)

<a id="stage-upkeep"></a>
## 18. Updates and endurance

Updates that apply and roll back, and the phone still working after days, upgrades and crashes of its parts.

<a id="step-update-applies"></a>
### An update applies

Step 75 in the chain, id `update-applies`, applies to `any`, checked on 2026-11-18.

- **Done when:** an update from the distribution applies over the air and the phone boots it, the health suite as before
- **Needs:**
  - [rootfs-boots](#step-rootfs-boots) - hard: the distribution updates
  - [health-suite-runs](#step-health-suite-runs) - soft: an update is proven by the same suite
- **Enables:** [update-rolls-back](#step-update-rolls-back), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `update-applies`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Test to write. UBports proves it by a local OTA test before an installer (ubports-porting).
- **Sources:** [Ubuntu Touch porting introduction](https://docs.ubports.com/en/latest/porting/introduction/index.html)

<a id="step-kernel-upgrade-keeps-steps"></a>
### A kernel upgrade keeps every step

Step 76 in the chain, id `kernel-upgrade-keeps-steps`, applies to `any`, checked on 2026-11-18.

- **Done when:** on a new kernel release the suite passes what it passed before, and proven\_on moves to the new kernel
- **Needs:**
  - [health-suite-runs](#step-health-suite-runs) - hard: the suite says what still passes
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `suite-compare`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** How claims stay true without expiry: a later kernel is told by proven\_on and re-proven.

<a id="step-update-rolls-back"></a>
### A bad update rolls back

Step 86 in the chain, id `update-rolls-back`, applies to `any`, checked on 2026-11-18.

- **Done when:** an update that does not boot falls back to the last good one with no hands
- **Needs:**
  - [update-applies](#step-update-applies) - hard: a bad one to roll back from
  - [watchdog-way-back](#step-watchdog-way-back) - hard: a hung boot must come back
  - [slot-state-known](#step-slot-state-known) - soft: A/B slots are one way back
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `update-rollback`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** A/B slots (qbootctl) or a boot counter; Android's boot control HAL (aosp-compat-matrix).
- **Sources:** [AOSP framework compatibility matrix 202604](https://android.googlesource.com/platform/hardware/interfaces/+/refs/heads/main/compatibility_matrices/compatibility_matrix.202604.xml)

<a id="step-coprocessor-restart-recovers"></a>
### A coprocessor crash is survived

Step 101 in the chain, id `coprocessor-restart-recovers`, applies to `any`, checked on 2026-11-18.

**World gap** - the world has no open answer to this yet; the guide says what is missing.

- **Done when:** a coprocessor crashed on purpose restarts and its users - sound, modem, sensors - come back with no reboot
- **Needs:**
  - [remoteprocs-running](#step-remoteprocs-running) - hard: a coprocessor to crash
  - [mic-hears-speaker](#step-mic-hears-speaker) - soft: sound to come back
  - [modem-registered](#step-modem-registered) - soft: the modem to come back
  - [sensors-exposed](#step-sensors-exposed) - soft: sensors to come back
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `ssr-recovers`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya failing for audio after a DSP restart (surya-adsp-audio-after-suspend-loop). World gap: nobody tests whole-stack recovery.

<a id="step-cycles-repeat-clean"></a>
### Repeated cycles stay clean

Step 106 in the chain, id `cycles-repeat-clean`, applies to `any`, checked on 2026-11-18.

- **Done when:** 100 suspend cycles, 20 calls and 50 camera switches with no part lost
- **Needs:**
  - [health-suite-runs](#step-health-suite-runs) - hard: what is lost is read by the suite
  - [resume-without-stall](#step-resume-without-stall) - hard: a cycle that returns
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `cycles-clean`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** 'Does audio still work after two hours asleep' (weiss-fosdem-2025-missing-20).
- **Sources:** [Kernel support for Mobile Linux: the missing 20%](https://fosdem.org/2025/schedule/event/fosdem-2025-4836-kernel-support-for-mobile-linux-the-missing-20-/), [FOSDEM 2026: FOSS on Mobile devroom](https://archive.fosdem.org/2026/schedule/track/foss-on-mobile/)

<a id="stage-shell"></a>
## 19. Shell

The phone shell - sxmo, Phosh or Plasma Mobile - as a layer after the proven hardware: it runs on it, locks, types, notifies, rotates and holds its own idle suspend.

<a id="step-shell-autosleep-tamed"></a>
### The shell's idle suspend is held off while the lab works

Step 36 in the chain, id `shell-autosleep-tamed`, applies to `any`, checked on 2026-11-19.

- **Done when:** the shell's own idle suspend is off or held off while the lab works, proven per shell (sxmo's autosleep, Phosh's gsd-power, Plasma Mobile's PowerDevil)
- **Needs:**
  - [lab-link-held-awake](#step-lab-link-held-awake) - hard: the shell's loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999)
- **Enables:** [real-suspend-under-shell](#step-real-suspend-under-shell)
- **Proof:** `autosleep-off`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: sxmo's rtcwake loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999). The test layer has no shell to hold off, so the hardware steps do not wait on this; it is the shell's own, once for each shell, and the sxmo fork and its series are retired (2026-11-19-hardware-test-layer).

<a id="step-shell-runs-with-hardware"></a>
### A phone shell runs on the hardware

Step 77 in the chain, id `shell-runs-with-hardware`, applies to `any`, checked on 2026-11-18.

- **Done when:** a phone shell (sxmo, Phosh, Plasma Mobile) starts on the panel with touch, sound to the real card and its device profile
- **Needs:**
  - [panel-lit](#step-panel-lit) - hard: it shows
  - [rootfs-boots](#step-rootfs-boots) - hard: a distribution's shell
  - [touch-input](#step-touch-input) - hard: it is touched
  - [gpu-renders](#step-gpu-renders) - soft: Phosh and Plasma Mobile need the GPU; sxmo does not
  - [ucm-hifi-profile](#step-ucm-hifi-profile) - soft: its sound (plasma-silent)
- **Enables:** [on-screen-keyboard](#step-on-screen-keyboard), [lock-and-unlock](#step-lock-and-unlock), [auto-rotate-follows](#step-auto-rotate-follows), [brightness-follows-light](#step-brightness-follows-light), [notifications-arrive](#step-notifications-arrive), [real-suspend-under-shell](#step-real-suspend-under-shell), [proximity-blanks-in-call](#step-proximity-blanks-in-call)
- **Proof:** `shell-up`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya: sxmo with its profile; under Phosh the host loses the USB link (phosh-usb); Plasma was silent from a saved -110 dB mixer (plasma-silent). Phosh and Plasma need the GPU, sxmo does not.
- **Sources:** [Sxmo: contributing](https://sxmo.org/contribute/)

<a id="step-on-screen-keyboard"></a>
### The on-screen keyboard types

Step 87 in the chain, id `on-screen-keyboard`, applies to `any`, checked on 2026-11-18.

- **Done when:** the keyboard comes up in a text field and types into it
- **Needs:**
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell's keyboard
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `osk-types`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Witness for now; a robot finger or an input injection can stand in.

<a id="step-lock-and-unlock"></a>
### Lock and unlock

Step 88 in the chain, id `lock-and-unlock`, applies to `any`, checked on 2026-11-18.

- **Done when:** the power key locks and darkens; the phone unlocks with its code
- **Needs:**
  - [buttons-report](#step-buttons-report) - hard: the power key
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell's lock
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `lock-unlock`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Needs the keys clean of chatter (buttons-report).

<a id="step-auto-rotate-follows"></a>
### The screen follows rotation

Step 94 in the chain, id `auto-rotate-follows`, applies to `any`, checked on 2026-11-19.

- **Done when:** turning the phone turns the shell's screen
- **Needs:**
  - [sensors-exposed](#step-sensors-exposed) - hard: the accelerometer
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell rotates
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `auto-rotate`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Never tried in our labs.

<a id="step-brightness-follows-light"></a>
### Brightness follows the light

Step 95 in the chain, id `brightness-follows-light`, applies to `any`, checked on 2026-11-19.

- **Done when:** covering the light sensor dims the panel under auto-brightness
- **Needs:**
  - [panel-lit](#step-panel-lit) - hard: the backlight
  - [sensors-exposed](#step-sensors-exposed) - hard: the light sensor
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - soft: the shell's auto-brightness
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `auto-brightness`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Never tried in our labs.

<a id="step-notifications-arrive"></a>
### Notifications arrive with the screen off

Step 107 in the chain, id `notifications-arrive`, applies to `form:phone`, checked on 2026-11-18.

- **Done when:** a message or a call shows a notification and sounds while the screen is off
- **Needs:**
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell's notifications
  - [sms-both-ways](#step-sms-both-ways) - soft: a message to announce
  - [speaker-heard](#step-speaker-heard) - soft: it sounds
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `notification`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** Push for apps is a service (feature push-notifications), not a step.

<a id="step-real-suspend-under-shell"></a>
### The shell's own suspend returns

Step 108 in the chain, id `real-suspend-under-shell`, applies to `any`, checked on 2026-11-19.

- **Done when:** the shell's auto-suspend and systemctl suspend return, again and again
- **Needs:**
  - [radios-survive-suspend](#step-radios-survive-suspend) - hard: the radios come back
  - [resume-without-stall](#step-resume-without-stall) - hard: it returns
  - [shell-autosleep-tamed](#step-shell-autosleep-tamed) - hard: the shell's idle loop is held off first, or it cuts the lab off from its test (2026-11-18-who-runs-rtcwake-99999999)
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell's own suspend
- **Enables:** [alarm-wakes-from-sleep](#step-alarm-wakes-from-sleep), [days-without-reboot](#step-days-without-reboot), [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `shell-suspend`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** surya failing: the phone did not return (2026-11-18-real-suspend-try4-phone-did-not-return). The hardware's suspend steps (s2idle-cycle-returns, radios-survive-suspend, suspend-way-back) are proven first in the test layer; this one is the shell's own idle suspend and systemctl suspend, per shell (2026-11-19-hardware-test-layer).
- **Sources:** [sxmo-utils scripts/core/sxmo\_autosuspend.sh, sxmo\_suspend.sh, sxmo\_wakelock.sh (868b5c9)](https://git.sr.ht/~mil/sxmo-utils/tree/master/item/scripts/core/sxmo_autosuspend.sh)

<a id="step-alarm-wakes-from-sleep"></a>
### An alarm rings from sleep

Step 111 in the chain, id `alarm-wakes-from-sleep`, applies to `any`, checked on 2026-11-19.

- **Done when:** an alarm set in the clock app rings on time while the phone sleeps under its shell's suspend
- **Needs:**
  - [real-suspend-under-shell](#step-real-suspend-under-shell) - hard: it sleeps as in daily use
  - [speaker-heard](#step-speaker-heard) - hard: it rings
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `alarm-rings`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** The shell or clock must set an RTC wake alarm before suspend (kernel-sysfs-power-wakelock). Not known yet which phone shells do; never tried in our labs.
- **Sources:** [Linux ABI: sysfs-power wake\_lock, wake\_unlock, autosleep](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-power)

<a id="step-proximity-blanks-in-call"></a>
### The screen goes dark at the ear

Step 112 in the chain, id `proximity-blanks-in-call`, applies to `form:phone`, checked on 2026-11-19.

- **Done when:** in a call the screen blanks and touch is ignored while the proximity sensor is covered
- **Needs:**
  - [proximity-reads](#step-proximity-reads) - hard: the sensor it follows
  - [shell-runs-with-hardware](#step-shell-runs-with-hardware) - hard: the shell blanks the screen
  - [voice-call-both-ways](#step-voice-call-both-ways) - hard: in a call
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `proximity-in-call`, witness
- **Helper:** no helper yet - a helper to write
- **Guide:** surya open (sensors-proximity-in-calls). Sailfish checks it while suspended too (sailfish-hadk-checklist).
- **Sources:** [Sailfish OS HADK: hardware adaptation checklist](https://hadk.sailfishos.org/ha-checklist/)

<a id="step-days-without-reboot"></a>
### Days without a reboot

Step 114 in the chain, id `days-without-reboot`, applies to `any`, checked on 2026-11-19.

- **Done when:** seven days of ordinary use with no reboot, crash or part lost
- **Needs:**
  - [call-wakes-from-sleep](#step-call-wakes-from-sleep) - hard: and is reachable
  - [real-suspend-under-shell](#step-real-suspend-under-shell) - hard: daily use sleeps
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `uptime-days`, phone-suite
- **Helper:** no helper yet - a helper to write
- **Guide:** Reliability, not function (weiss-fosdem-2025-missing-20); UBports' noRebootTest (ubports-device-data).
- **Sources:** [Kernel support for Mobile Linux: the missing 20%](https://fosdem.org/2025/schedule/event/fosdem-2025-4836-kernel-support-for-mobile-linux-the-missing-20-/), [devices.ubuntu-touch.io data: portStatus, progressStages, supportStatus](https://gitlab.com/ubports/infrastructure/devices.ubuntu-touch.io)

<a id="stage-goals"></a>
## 20. Goals

The steps that only name a whole: Linux runs, a daily-usable phone, a complete phone - each done when all it needs is.

<a id="step-linux-runs"></a>
### Linux runs

Step 78 in the chain, id `linux-runs`, applies to `any`, checked on 2026-11-18.

- **Done when:** every step it needs is done or not-needed
- **Needs:**
  - [charger-online](#step-charger-online) - hard: the close of the generic bring-up
  - [dmesg-clean](#step-dmesg-clean) - hard: the close of the generic bring-up
  - [health-suite-runs](#step-health-suite-runs) - hard: the close of the generic bring-up
  - [storage-readonly](#step-storage-readonly) - hard: the close of the generic bring-up
  - [watchdog-way-back](#step-watchdog-way-back) - hard: the close of the generic bring-up
- **Enables:** [daily-usable-phone](#step-daily-usable-phone)
- **Proof:** `bringup-chain-ready`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). The close of the generic bring-up, any machine.
- **Sources:** [systemd.target](https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html)

<a id="step-daily-usable-phone"></a>
### A daily-usable phone

Step 115 in the chain, id `daily-usable-phone`, applies to `form:phone`, checked on 2026-11-18.

- **Done when:** every step it needs is done or not-needed
- **Needs:**
  - [alarm-wakes-from-sleep](#step-alarm-wakes-from-sleep) - hard: a person needs it every day
  - [all-day-battery](#step-all-day-battery) - hard: a person needs it every day
  - [bt-controller-up](#step-bt-controller-up) - hard: a person needs it every day
  - [call-wakes-from-sleep](#step-call-wakes-from-sleep) - hard: a person needs it every day
  - [earpiece-plays](#step-earpiece-plays) - hard: a person needs it every day
  - [emergency-numbers-known](#step-emergency-numbers-known) - hard: a person needs it every day
  - [gnss-fix](#step-gnss-fix) - hard: a person needs it every day
  - [key-reset-recovers](#step-key-reset-recovers) - hard: a person needs it every day
  - [linux-runs](#step-linux-runs) - hard: a person needs it every day
  - [lock-and-unlock](#step-lock-and-unlock) - hard: a person needs it every day
  - [mic-hears-speaker](#step-mic-hears-speaker) - hard: a person needs it every day
  - [mobile-data](#step-mobile-data) - hard: a person needs it every day
  - [notifications-arrive](#step-notifications-arrive) - hard: a person needs it every day
  - [off-mode-charging](#step-off-mode-charging) - hard: a person needs it every day
  - [on-screen-keyboard](#step-on-screen-keyboard) - hard: a person needs it every day
  - [photo-taken](#step-photo-taken) - hard: a person needs it every day
  - [proximity-blanks-in-call](#step-proximity-blanks-in-call) - hard: a person needs it every day
  - [real-suspend-under-shell](#step-real-suspend-under-shell) - hard: a person's phone sleeps under its shell and returns
  - [sms-both-ways](#step-sms-both-ways) - hard: a person needs it every day
  - [speaker-heard](#step-speaker-heard) - hard: a person needs it every day
  - [update-applies](#step-update-applies) - hard: a person needs it every day
  - [voice-call-both-ways](#step-voice-call-both-ways) - hard: a person needs it every day
  - [wifi-joins](#step-wifi-joins) - hard: a person needs it every day
- **Enables:** [complete-phone](#step-complete-phone)
- **Proof:** `bringup-chain-ready`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). What a person needs every day: calls, messages, data, sound, a photo, a position, a day of battery, charging, updates (the features of milestones lp-calls-and-messages, lp-connected, lp-daily-basics; UBports' stages 3-4).
- **Sources:** [systemd.target](https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html), [devices.ubuntu-touch.io data: portStatus, progressStages, supportStatus](https://gitlab.com/ubports/infrastructure/devices.ubuntu-touch.io)

<a id="step-complete-phone"></a>
### A complete phone

Step 116 in the chain, id `complete-phone`, applies to `form:phone`, checked on 2026-11-18.

- **Done when:** every step it needs is done or not-needed
- **Needs:**
  - [auto-rotate-follows](#step-auto-rotate-follows) - hard: everything the hardware does, lasting
  - [brightness-follows-light](#step-brightness-follows-light) - hard: everything the hardware does, lasting
  - [bt-pairs-carries-audio](#step-bt-pairs-carries-audio) - hard: everything the hardware does, lasting
  - [coprocessor-restart-recovers](#step-coprocessor-restart-recovers) - hard: everything the hardware does, lasting
  - [cycles-repeat-clean](#step-cycles-repeat-clean) - hard: everything the hardware does, lasting
  - [daily-usable-phone](#step-daily-usable-phone) - hard: everything the hardware does, lasting
  - [days-without-reboot](#step-days-without-reboot) - hard: everything the hardware does, lasting
  - [display-any-order](#step-display-any-order) - hard: a complete phone's display needs no hand-ordered modules: what mainline takes (2026-11-19)
  - [fingerprint-unlocks](#step-fingerprint-unlocks) - hard: everything the hardware does, lasting
  - [focus-and-flash](#step-focus-and-flash) - hard: everything the hardware does, lasting
  - [gpu-renders](#step-gpu-renders) - hard: everything the hardware does, lasting
  - [haptics-buzz](#step-haptics-buzz) - hard: everything the hardware does, lasting
  - [headset-jack](#step-headset-jack) - hard: everything the hardware does, lasting
  - [hotspot-shares-data](#step-hotspot-shares-data) - hard: everything the hardware does, lasting
  - [kernel-upgrade-keeps-steps](#step-kernel-upgrade-keeps-steps) - hard: everything the hardware does, lasting
  - [mms-both-ways](#step-mms-both-ways) - hard: everything the hardware does, lasting
  - [nfc-reads-tag](#step-nfc-reads-tag) - hard: everything the hardware does, lasting
  - [reset-state-survives](#step-reset-state-survives) - hard: everything the hardware does, lasting
  - [rtc-alarm-powers-on](#step-rtc-alarm-powers-on) - hard: everything the hardware does, lasting
  - [storage-full-speed](#step-storage-full-speed) - hard: a complete phone's storage runs at the speed its SoC supports (2026-11-19)
  - [thermal-zones-sane](#step-thermal-zones-sane) - hard: everything the hardware does, lasting
  - [update-rolls-back](#step-update-rolls-back) - hard: everything the hardware does, lasting
  - [usb-host-works](#step-usb-host-works) - hard: everything the hardware does, lasting
  - [video-recorded](#step-video-recorded) - hard: everything the hardware does, lasting
  - [volte-call](#step-volte-call) - hard: everything the hardware does, lasting
- **Enables:** nothing
- **Proof:** `bringup-chain-ready`, host-check
- **Helper:** no helper yet - a helper to write
- **Guide:** A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). Everything the hardware does, lasting: VoLTE, MMS, every radio and sensor, video, rollback, reliability. Apps and services (Android apps, banking, sync, backup) stay features, not steps.
- **Sources:** [systemd.target](https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html), [Android 17 Compatibility Definition Document](https://source.android.com/docs/compatibility/17/android-17-cdd), [Halium: scope](https://docs.halium.org/en/latest/project/Scope.html)

