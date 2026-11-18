#!/bin/sh
# Seeds the stages, the generic bring-up steps and their edges through the records (ikb; decision
# 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base). Run in docs; the records are bringup-stage,
# bringup-step and bringup-edge. The steps are walleye's real chain generalised; surya's path checked them.
# The stage list is the draft's and waits the author's word: stages are rows, changed with ikb bringup-stage.
set -eu
st() { ikb bringup-step --checked-on 2026-11-18 "$@" >/dev/null; }
ed() { ikb bringup-edge "$@" >/dev/null; }
sg() { ikb bringup-stage "$@" >/dev/null; }

sg --id prepare --ord 1 --title "Prepare" --what "Read what the machine is and what it allows before anything is changed: the stock system, the boot facts, the way back."
sg --id boot --ord 2 --title "Boot" --what "Get an image of ours accepted by the bootloader and run, one part swapped at a time, until it is known what refuses it."
sg --id console --ord 3 --title "Console" --what "A window onto the running kernel: a banner, a shell, over UART or the USB gadget."
sg --id kernel --ord 4 --title "Kernel" --what "Our kernel builds, reaches its init and says nothing worse than it should."
sg --id power --ord 5 --title "Power" --what "The PMIC, the charger and the watchdog: what keeps the machine alive and safe to leave running."
sg --id storage --ord 6 --title "Storage" --what "Internal storage seen, first read-only."
sg --id userspace --ord 7 --title "Userspace" --what "A distribution's root boots, the network is up and the health suite runs on every boot."
sg --id lab --ord 8 --title "Lab" --what "What the lab needs of a machine to work on it without hands: the ways in, a try that cannot brick."

st --id bootloader-unlocked --title "Bootloader unlocked" --stage prepare --ord 1 --applies boot:android \
  --done-when "fastboot getvar all says unlocked: yes" --proof fastboot-unlocked --proof-kind host-check \
  --helper "lpoco lab fastboot getvar" \
  --guide "Unlocking wipes the user's data and is the owner's act. Read the state before anything else (walleye google-walleye-bootloader-first-look, surya first-fastboot-probe)."
st --id stock-measured --title "The stock system measured" --stage prepare --ord 2 --applies any \
  --done-when "what works on the stock system, its battery and its partitions are recorded as the reference" \
  --proof android-reference --proof-kind research \
  --guide "Measure the stock system before anything is flashed: it is the reference 'as good as Android' is judged by, and an unlock may wipe it (walleye android-reference-walleye-measured)."
st --id stock-facts-read --title "The stock boot's facts read" --stage prepare --ord 3 --applies any \
  --done-when "the stock cmdline, boot header and offsets, dtb ids (msm-id, board-id), running fdt and ramoops region are recorded" \
  --proof stock-facts-recorded --proof-kind research --helper "lpoco bringup image info" \
  --guide "Read them from the running stock system and its boot image (walleye walleye-stock-ids-recorded, walleye-boot-cmdline-known). The running fdt is worth keeping whole: on walleye it named the cause of the dead dtbs (walleye-our-dts-gpio-reserved)."
st --id slot-state-known --title "Slots read, a way back known" --stage prepare --ord 4 --applies boot:android-ab \
  --done-when "both slots' flags are reported before and after every try, and the phone returns to the stock system by itself" \
  --proof slot-report --proof-kind host-check --helper "lpoco lab fastboot state" \
  --guide "On walleye the Load Error was the slot state left by refusals, not the image: restore the first state (Android booted to completion on a good slot) before each try (walleye-load-error-first-state)."
st --id control-image-boots --title "A known-good image boots from memory" --stage boot --ord 1 --applies boot:android \
  --done-when "fastboot boot of a known-good stock-format image leaves fastboot and runs, nothing written" \
  --proof fastboot-boot-control --proof-kind host-check --helper "lpoco lab fastboot boot" \
  --guide "The control tells 'the bootloader refuses' from 'our image is wrong' (walleye walleye-loaderror-control)."
st --id boot-image-packs --title "Our boot image packs as the device wants" --stage boot --ord 2 --applies boot:android \
  --done-when "header version, offsets, page size, dtb placement and os word match the control where they should" \
  --proof bringup-pack-matches-mkbootimg --proof-kind build-check --helper "lpoco bringup image pack, check" \
  --guide "Pack from the device's [boot] declaration and count it against the control (walleye walleye-bootimage). The helper packs header v0 only."
st --id dtbo-accepted --title "The bootloader's dtbo overlay accepted" --stage boot --ord 3 --applies boot:android-dtbo \
  --done-when "our dtb, built with -@ and the overlay's labels, merges with the stock dtbo, or the bootloader does not need it" \
  --proof dtbo-overlay-merges --proof-kind build-check \
  --guide "On walleye our dtb with -@ and the 137 labels merged; the dtbo stub that was planned was never needed (walleye-dtb-overlay-symbols-build, walleye-loaderror-dtbo-stub)."
st --id initramfs-gadget-emulated --title "Our initramfs brings the gadget up, emulated" --stage boot --ord 4 --applies usb:gadget \
  --done-when "in QEMU with dummy_hcd our initramfs makes the gadget (ACM console and a window) and the host side sees it" \
  --proof selftest-initramfs --proof-kind build-check --helper "lpoco bringup initramfs build" \
  --guide "Prove the init before any phone time (walleye walleye-initramfs-usb-gadget). The generic init under lpoco is backlog bringup-generic-init."
st --id stock-kernel-runs-our-init --title "The stock kernel runs our init" --stage boot --ord 5 --applies boot:android \
  --done-when "the stock kernel with only our ramdisk swapped runs our /init, and it shows (a gadget, a mass-storage window)" \
  --proof massstorage-window-read --proof-kind host-check --helper "lpoco bringup image swap" \
  --guide "Proves the image path apart from our kernel. On walleye the NCM function panics the vendor 4.4 kernel; a mass-storage window works (walleye-ncm-split, walleye-massstorage-window)."
st --id crash-window --title "A window on a dead boot" --stage boot --ord 6 --applies any \
  --done-when "a dead or hung boot leaves something the host reads: UART, pstore at the phone's own ramoops region, or a timing channel" \
  --proof crash-window-read --proof-kind host-check \
  --guide "On walleye ramoops survives only at the region the stock fdt names and only across a warm reset (walleye-pstore-warm-reset, walleye-pstore-t1-try); a timing channel told alive from dead (walleye-ml4-timing-channel); UART waits a cable (walleye-get-uart-setup)."
st --id kernel-builds --title "Our kernel and dts build" --stage kernel --ord 1 --applies any \
  --done-when "the mainline kernel and the device's dts build with no dtc warning from our file, and the dtb carries the ids the bootloader matches" \
  --proof dtb-builds-with-ids --proof-kind build-check \
  --guide "Start from the nearest sibling's dts in mainline (walleye from taimen, walleye-kernel-dts)."
st --id reference-kernel-boots --title "Someone else's mainline kernel boots here" --stage kernel --ord 2 --applies any \
  --done-when "another project's mainline kernel and dtb for this device or a sibling reach their init on this phone" \
  --proof reference-alive --proof-kind host-check --helper "lpoco bringup image bisect" \
  --guide "The reference to bisect against when ours is dead: swap one part at a time (walleye pk5 alive against ours dead: walleye-bisect-porthole-vs-ours, walleye-our-dtb-bisect, walleye-property-bisect)."
st --id kernel-reaches-init --title "Our kernel reaches our init" --stage kernel --ord 3 --applies any \
  --done-when "our kernel and our dtb reach /init: the phone stays up as long as /init says, with no early reset" \
  --proof kernel-alive --proof-kind host-check --helper "lpoco bringup image bisect" \
  --guide "Two traps on walleye: earlycon on an undeclared UART kills the kernel (walleye-no-earlycon); a pinctrl node without gpio-reserved-ranges touches the secure world's pins and resets the phone (walleye-our-dts-gpio-reserved)."
st --id uart-console --title "Kernel log on UART" --stage console --ord 1 --applies any \
  --done-when "the kernel's log reaches the host over the debug UART" \
  --proof uart-log --proof-kind host-check \
  --guide "Needs the device's debug cable or pads; on walleye it waits the cable (walleye-get-uart-setup), so the USB gadget was the console."
st --id gadget-enumerates --title "The host sees our gadget" --stage console --ord 2 --applies usb:gadget \
  --done-when "the host enumerates our own kernel's gadget by its vendor:product and serial" \
  --proof gadget-enumerates --proof-kind host-check \
  --guide "walleye y2: 1d6b:0104 18 s after the jump (walleye-try-y)."
st --id banner-on-console --title "The banner on the console" --stage console --ord 3 --applies any \
  --done-when "/init's banner with a heartbeat reaches the host on the console, read as the lab user" \
  --proof banner-seen --proof-kind host-check \
  --guide "The gadget serial must be the one the host's udev rule names, or the tty is root's (walleye-banner-serial-fix, walleye-try-banner2)."
st --id shell-on-console --title "A shell answers on the console" --stage console --ord 4 --applies any \
  --done-when "commands sent on the console answer, one at a time, reliably across hangups" \
  --proof shell-answers --proof-kind host-check \
  --guide "On walleye an interactive ash stayed silent; a plain read/exec loop and the host tty raw and -hupcl made it answer (walleye-shell-reliable, walleye-command-loop, walleye-try-z6)."
st --id first-dmesg-mapped --title "The first dmesg mapped" --stage kernel --ord 4 --applies any \
  --done-when "the first full dmesg of our kernel is read and every line placed: works, defers, fails, and whose" \
  --proof dmesg-map --proof-kind research \
  --guide "The map orders what follows (walleye-z6-dmesg-map, research walleye-bringup-order-plan)."
st --id dmesg-clean --title "dmesg clean" --stage kernel --ord 5 --applies any \
  --done-when "no WARN, oops or -110, and no probe deferred but the known ones" \
  --proof dmesg-clean --proof-kind host-check \
  --guide "walleye z7: the GPU smmu off cleared the gpu_gx WARNs (walleye-dmesg-clean); on a rootfs the suite's no-oops and boot-warnings carry it."
st --id pmic-bound --title "The PMIC bound" --stage power --ord 1 --applies any \
  --done-when "the PMIC's children bind on their bus, the RTC and the power-on reason read" \
  --proof pmic-bound --proof-kind host-check \
  --guide "walleye: pm8998 and pmi8998 on SPMI (walleye-pmic-spmi, proven in z7). UFS rails are RPM regulators and do not wait for it (walleye-bringup-order-plan)."
st --id charger-online --title "The charger online" --stage power --ord 2 --applies power:battery \
  --done-when "a power_supply of type USB appears, online follows the cable, and the voltage rises while connected" \
  --proof charger-online --proof-kind host-check \
  --guide "Until it works, tries are rationed by the battery. walleye c2: the charger defers on its tps61099 supplier (walleye-charger-wait-tps61099, walleye-charger-supplier)."
st --id watchdog-way-back --title "A hung kernel comes back by itself" --stage power --ord 3 --applies any \
  --done-when "a hung kernel resets by itself and the phone returns to a known system without hands" \
  --proof way-back --proof-kind host-check \
  --guide "surya: qcom_wdt kept armed through sleep (way-back.sh). walleye: the PMIC watchdog (walleye-pmic-wdt-proof)."
st --id storage-readonly --title "Internal storage read-only" --stage storage --ord 1 --applies any \
  --done-when "the internal storage lists its partitions by name, nothing written" \
  --proof storage-lists --proof-kind host-check \
  --guide "Gives the firmware partitions every later part needs (walleye-ufs-readonly)."
st --id usb-network --title "Network over USB" --stage userspace --ord 1 --applies usb:gadget \
  --done-when "ssh over the USB gadget's network answers" \
  --proof gadget-up --proof-kind host-check \
  --guide "walleye: walleye-usb-net. surya had the distribution's own gadget."
st --id rootfs-boots --title "A distribution root boots" --stage userspace --ord 2 --applies any \
  --done-when "a distribution's root filesystem boots to its init and ssh answers" \
  --proof rootfs-ssh --proof-kind host-check --helper "lpoco lab flash, provision" \
  --guide "surya boots Nura through U-Boot, systemd-boot and an EFI kernel (first-fastboot-probe)."
st --id health-suite-runs --title "The health suite runs after every boot" --stage userspace --ord 3 --applies any \
  --done-when "the phone's own suite runs after every boot and its run is filed in the device's base" \
  --proof suite-filed --proof-kind phone-suite --helper "lpoco lab suite put, run" \
  --guide "From here a part's status is measured, not judged (surya 2026-11-17-health-on-the-phone)."

ed --step bootloader-unlocked --requires stock-measured --kind soft --why "an unlock may wipe the stock system"
ed --step control-image-boots --requires bootloader-unlocked --kind hard --why "fastboot boot needs an unlocked bootloader"
ed --step control-image-boots --requires slot-state-known --kind hard --why "walleye: refusals were the slot state (walleye-load-error-first-state)"
ed --step boot-image-packs --requires stock-facts-read --kind hard --why "the header and offsets are the stock image's"
ed --step kernel-builds --requires stock-facts-read --kind soft --why "the dtb ids the bootloader matches"
ed --step dtbo-accepted --requires kernel-builds --kind hard --why "it is our dtb that must merge"
ed --step stock-kernel-runs-our-init --requires control-image-boots --kind hard --why "the control is the image swapped into"
ed --step stock-kernel-runs-our-init --requires boot-image-packs --kind hard --why "the swap repacks"
ed --step stock-kernel-runs-our-init --requires initramfs-gadget-emulated --kind soft --why "an init proven emulated spends no phone time"
ed --step crash-window --requires stock-facts-read --kind soft --why "the ramoops region is the stock fdt's"
ed --step reference-kernel-boots --requires control-image-boots --kind hard --why "same bootloader path"
ed --step reference-kernel-boots --requires boot-image-packs --kind hard --why "packed the device's way"
ed --step kernel-reaches-init --requires kernel-builds --kind hard --why "it is our kernel"
ed --step kernel-reaches-init --requires boot-image-packs --kind hard --why "packed the device's way"
ed --step kernel-reaches-init --requires control-image-boots --kind hard --why "the bootloader accepts images"
ed --step kernel-reaches-init --requires dtbo-accepted --kind hard --why "walleye: no start without the merge (walleye-dtbo-overlay-merge-why)"
ed --step kernel-reaches-init --requires crash-window --kind soft --why "without one a dead kernel says nothing"
ed --step kernel-reaches-init --requires reference-kernel-boots --kind soft --why "the bisect reference"
ed --step uart-console --requires kernel-builds --kind hard --why "it is our kernel's log"
ed --step gadget-enumerates --requires kernel-reaches-init --kind hard --why "our kernel's gadget"
ed --step gadget-enumerates --requires initramfs-gadget-emulated --kind hard --why "the init makes the gadget"
ed --step banner-on-console --requires gadget-enumerates --kind hard --group console --why "the console over the gadget"
ed --step banner-on-console --requires uart-console --kind hard --group console --why "or over UART"
ed --step shell-on-console --requires banner-on-console --kind hard --why "a console that carries text first"
ed --step first-dmesg-mapped --requires shell-on-console --kind hard --why "dmesg is read through the shell"
ed --step dmesg-clean --requires first-dmesg-mapped --kind hard --why "the map names what to clean"
ed --step pmic-bound --requires shell-on-console --kind hard --why "read through the shell"
ed --step pmic-bound --requires first-dmesg-mapped --kind soft --why "the map names the PMIC's faults"
ed --step charger-online --requires pmic-bound --kind hard --why "the charger is a PMIC child"
ed --step watchdog-way-back --requires kernel-reaches-init --kind hard --why "it is our kernel that hangs"
ed --step watchdog-way-back --requires pmic-bound --kind soft --why "walleye's way is the PMIC watchdog"
ed --step storage-readonly --requires shell-on-console --kind hard --why "read through the shell"
ed --step storage-readonly --requires dmesg-clean --kind soft --why "smmu and supplier faults stop DMA devices"
ed --step usb-network --requires gadget-enumerates --kind hard --why "the network rides the gadget"
ed --step rootfs-boots --requires storage-readonly --kind hard --why "the root is on the storage"
ed --step rootfs-boots --requires usb-network --kind hard --why "ssh is the proof"
ed --step health-suite-runs --requires rootfs-boots --kind hard --why "the suite runs on the root"
echo "seeded: $(tad sql 'SELECT count(*) FROM bringup_steps' --format csv | tail -1) steps, $(tad sql 'SELECT count(*) FROM bringup_step_edges' --format csv | tail -1) edges"
