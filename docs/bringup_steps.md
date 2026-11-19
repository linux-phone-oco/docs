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


<a id="battery-gauge-reads"></a>
### The battery gauge reads true

Stage
: power

Ord
: 4

Applies
: power:battery

Done when
: capacity, voltage and current read in power_supply agree with a meter within 5 % over a discharge

Proof
: battery-gauge

Proof kind
: host-check

Component
: battery

Guide
: Test to write. surya read gauge averages in its standby run (2026-11-17-r3-partial-and-the-reset-after); walleye open (walleye-fuel-gauge). PMI8998-class gauges are still RFCs (pmi8998-fg-rfc).

Sources
: pmi8998-fg-rfc

Checked on
: 2026-11-18


<a id="off-mode-charging"></a>
### Charges while off

Stage
: power

Ord
: 6

Applies
: power:battery

Done when
: plugged in while off it charges, shows its level, and boots on the power key

Proof
: off-mode-charging

Proof kind
: witness

Component
: battery

Guide
: Sailfish names it act-dead mode (sailfish-hadk-checklist). World gap: the usual tool, charging-sdl, is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064).

Sources
: sailfish-hadk-checklist,pmaports-charging-sdl-1064

Checked on
: 2026-11-18


<a id="thermal-zones-sane"></a>
### Thermal zones read and throttle

Stage
: power

Ord
: 7

Applies
: any

Done when
: every thermal zone reads a plausible temperature, trips are set, and a load throttles before any shutdown

Proof
: thermal-zones

Proof kind
: phone-suite

Guide
: Test to write; never touched in our labs. Android has a thermal HAL and a policy; Linux phones have the kernel's zones and no policy daemon (aosp-compat-matrix, sailfish-hadk-checklist).

Sources
: aosp-compat-matrix,sailfish-hadk-checklist

Checked on
: 2026-11-18


<a id="lab-link-held-awake"></a>
### The lab's link holds the phone awake

Stage
: lab

Ord
: 1

Applies
: any

Done when
: while a host holds the USB link, nothing suspends the phone, and the hold is released on purpose for sleep tests

Proof
: usb-awake

Proof kind
: phone-suite

Guide
: surya: 26 link drops in 5 minutes before the hold (2026-11-10-usb-flapping), the screen blanking by itself (2026-11-18-screen-blanks-by-itself); held by devlab-usb-awake-hold-through-resume, moving to a package (surya-awake-from-package).

Checked on
: 2026-11-18


<a id="firmware-reachable"></a>
### The device's firmware is reachable

Stage
: coprocessors

Ord
: 1

Applies
: any

Done when
: every firmware file the kernel asks for is found: no failed direct firmware load for a needed file

Proof
: firmware-found

Proof kind
: host-check

Guide
: Signed blobs are the stock system's, per device: from the stock partitions read-only (msm-firmware-loader, which assumes eMMC) or a firmware package (pmos-firmware-docs; surya firmware-xiaomi-surya).

Sources
: msm-firmware-loader-emmc,pmos-firmware-docs,firmware-xiaomi-surya

Checked on
: 2026-11-18


<a id="pd-mapper-before-remoteproc"></a>
### The domain mapper is up before the DSPs

Stage
: coprocessors

Ord
: 2

Applies
: soc:qcom

Done when
: the protection-domain mapper serves before qcom_q6v5_pas probes, so the audio domain comes up on 20 boots of 20

Proof
: sound-card

Proof kind
: phone-suite

Guide
: surya: 8 boots of 42 had no sound card without a softdep (no-sound-card-boots; surya-lab lab/devlab-pd-mapper.conf), 21 of 21 with it; the upstream form is open (upstream-pd-mapper-order). The mapper is in the kernel since 2024 (inkernel-pd-mapper).

Sources
: inkernel-pd-mapper

Checked on
: 2026-11-18


<a id="remoteprocs-running"></a>
### Every coprocessor runs

Stage
: coprocessors

Ord
: 3

Applies
: any

Done when
: every remoteproc the device has reads running and none crashed this boot

Proof
: adsp-running,cdsp-running,modem-running,no-processor-crashes

Proof kind
: phone-suite

Guide
: surya done; walleye open (walleye-radios-research). Trap: the ADSP 'handover signaled' every second (adsp-handover-loop).

Checked on
: 2026-11-18


<a id="fastrpc-helpers-stable"></a>
### The DSP helpers run without crashing the DSP

Stage
: coprocessors

Ord
: 4

Applies
: soc:qcom

Done when
: the FastRPC helpers (hexagonrpcd) serve and the DSP they talk to stays up over three boots

Proof
: no-processor-crashes

Proof kind
: phone-suite

Guide
: surya: the rootpd helper crashed the ADSP 24 times of 24 (2026-11-10-suspend-crash-found, adsp-sensor-crash-loop); masked in surya's device.toml.

Checked on
: 2026-11-18


<a id="panel-lit"></a>
### The panel lights

Stage
: display

Ord
: 1

Applies
: any

Done when
: the console or a test pattern shows on the panel and the backlight follows its control

Proof
: panel-connected,backlight

Proof kind
: phone-suite

Component
: display-panel

Guide
: Qualcomm DSI panels: a driver generated from the downstream tree (lmdpdg). walleye needs a command-mode panel driver (walleye-display-s6e3fa5).

Sources
: lmdpdg

Checked on
: 2026-11-18


<a id="touch-input"></a>
### Touch answers

Stage
: display

Ord
: 2

Applies
: any

Done when
: a touch at each corner gives events at the right coordinates

Proof
: touch-device

Proof kind
: phone-suite

Component
: touchscreen

Guide
: surya done; walleye open (walleye-touch-rmi4). The suite proves presence; coordinates need a hand or a robot.

Checked on
: 2026-11-18


<a id="buttons-report"></a>
### The keys report one event a press

Stage
: display

Ord
: 3

Applies
: any

Done when
: power and volume keys give one press and one release each, no chatter

Proof
: key-events

Proof kind
: witness

Component
: buttons

Guide
: surya: the volume-down key on the PMIC chatters (2026-11-18-screen-off-while-typing-key-events, surya-key-chatter-resin).

Checked on
: 2026-11-18


<a id="haptics-buzz"></a>
### The vibrator buzzes

Stage
: display

Ord
: 4

Applies
: any

Done when
: a force-feedback effect is felt

Proof
: vibrator

Proof kind
: phone-suite

Component
: haptics

Guide
: The suite proves presence only; the buzz is a hand's witness. walleye open (walleye-audio-haptics, DRV2624).

Checked on
: 2026-11-18


<a id="gpu-renders"></a>
### The GPU renders

Stage
: display

Ord
: 5

Applies
: any

Done when
: a GL and a Vulkan client render on the GPU (not a software renderer) to the panel

Proof
: gpu-renders

Proof kind
: phone-suite

Component
: gpu

Guide
: Test to write; never measured in our labs. Adreno needs its zap shader and GMU firmware from the device.

Checked on
: 2026-11-18


<a id="audio-codec-attached"></a>
### The codec attaches and stays

Stage
: audio

Ord
: 1

Applies
: any

Done when
: the codec enumerates on its buses (SoundWire, I2S, I2C) and stays attached across the boot

Proof
: sound-card,mic-records

Proof kind
: phone-suite

Guide
: surya WCD937x: a wrong aoncc address hung the boot (wcd937x-dt-aoncc); the sleep pin state drove reset low (microphone-codec-drops-off); the LPI mux from the vendor tree (2026-11-11-lpi-mux-from-vendor). Hazard: reading the LPASS pinctrl in debugfs hangs the phone.

Sources
: lineage-sm6150-wcd937x,vendor-sm6150-lpi-dtsi

Checked on
: 2026-11-18


<a id="sound-card-registered"></a>
### The sound card registers

Stage
: audio

Ord
: 2

Applies
: any

Done when
: the machine's card is listed on every boot

Proof
: sound-card

Proof kind
: phone-suite

Guide
: surya: lost on 8 boots of 42 until the domain mapper was ordered (no-sound-card-boots).

Checked on
: 2026-11-18


<a id="speaker-amps-fed"></a>
### The amplifiers get their channels

Stage
: audio

Ord
: 3

Applies
: any

Done when
: each speaker amplifier gets its slot and is unmuted at the chip, not only in the driver's cache

Proof
: amp-channels,amp-volume-0x4c,amp-volume-0x4d

Proof kind
: phone-suite

Guide
: surya tas2562: the slot length (upstream-tas2562-slot-length) and a volume write that reached only the cache (plasma-silent, upstream-tas2562-volume).

Checked on
: 2026-11-18


<a id="ucm-hifi-profile"></a>
### A UCM profile plays to the real card

Stage
: audio

Ord
: 4

Applies
: any

Done when
: the shell's sound server picks the card's HiFi verb and plays in stereo, the right channel to the right speaker

Proof
: default-output,speaker-stereo

Proof kind
: phone-suite

Guide
: surya ucm/Xiaomi/surya/HiFi.conf (2026-11-11-right-is-bottom), upstream open (upstream-ucm-surya-stereo).

Sources
: sm7125-mainline-ucm-miatoll

Checked on
: 2026-11-18


<a id="speaker-heard"></a>
### The speaker is heard

Stage
: audio

Ord
: 5

Applies
: any

Done when
: a quiet tone on each channel is heard by the lab's ear

Proof
: heard-left,heard-right

Proof kind
: phone-suite

Component
: audio-speaker

Guide
: Quiet tones only. surya: one 'heard' was withdrawn when the microphone had moved (2026-11-10-heard).

Checked on
: 2026-11-18


<a id="mic-captures"></a>
### The microphones capture

Stage
: audio

Ord
: 6

Applies
: any

Done when
: a second of capture from each microphone is not digital silence

Proof
: mic-records

Proof kind
: phone-suite

Component
: audio-mic

Guide
: surya: zeros meant the link named the wrong DAI (mic-zeros-meant-no-input); the mics are analog through the WCD, ADC2 on its own port (2026-11-17-microphones-analog-wcd-path).

Sources
: lineage-sm6150-bolero

Checked on
: 2026-11-18


<a id="mic-hears-speaker"></a>
### Each microphone hears the speaker

Stage
: audio

Ord
: 7

Applies
: any

Done when
: each microphone finds the phone's own tone 20 dB above the noise

Proof
: mic-hears-speaker,mic-top-hears-speaker

Proof kind
: phone-suite

Guide
: A closed loop with no hands: surya done (mic-held).

Checked on
: 2026-11-18


<a id="earpiece-plays"></a>
### The earpiece plays

Stage
: audio

Ord
: 8

Applies
: form:phone

Done when
: a tone through the earpiece is heard by the bottom microphone

Proof
: earpiece-heard

Proof kind
: phone-suite

Component
: audio-earpiece

Guide
: surya: the earpiece is the second TAS256x at 0x4d, not the codec's EAR amplifier (parts row audio-earpiece).

Checked on
: 2026-11-18


<a id="headset-jack"></a>
### A headset works through the jack

Stage
: audio

Ord
: 9

Applies
: any

Done when
: plugging is detected, sound plays to the headset and its microphone records

Proof
: jack-detector,headset-loop

Proof kind
: phone-suite

Component
: audio-headphone

Guide
: surya partial: detection only (verify-headphone-mic-earpiece). A loopback plug can prove both ways without hands.

Checked on
: 2026-11-18


<a id="modem-file-services"></a>
### The modem's file services serve

Stage
: modem

Ord
: 1

Applies
: soc:qcom

Done when
: rmtfs, the qrtr name service, pd-mapper and tqftpserv run and the modem's mode is online, not shutting down

Proof
: modem-running

Proof kind
: phone-suite

Guide
: surya: tqftpserv 1.1.1 never wrote short files and the modem looped 4769 times; 1.2 or later fixed it (modem-online-tqftpserv, upstream-alpine-tqftpserv).

Sources
: pmaports-tqftpserv-4747,pmaports-4441-tqftpserv

Checked on
: 2026-11-18


<a id="modem-seen"></a>
### The modem is seen

Stage
: modem

Ord
: 2

Applies
: radio:cellular

Done when
: ModemManager (or oFono) lists the modem

Proof
: modem-seen

Proof kind
: phone-suite

Guide
: On Qualcomm SoCs through the qcom-soc plugin over QRTR and IPA or BAM-DMUX (mm-qcom-soc-plugin).

Sources
: mm-qcom-soc-plugin

Checked on
: 2026-11-18


<a id="sim-ready"></a>
### The SIM is read

Stage
: modem

Ord
: 3

Applies
: radio:cellular

Done when
: the SIM reads present and unlocked, in each slot the device has

Proof
: sim-ready

Proof kind
: phone-suite

Guide
: surya: the SIM works only in slot 2 (modem-online-tqftpserv); checks that need a SIM skip, not fail, without one (sim-removed-skips).

Sources
: pmaports-4441-tqftpserv

Checked on
: 2026-11-18


<a id="modem-registered"></a>
### The modem joins the network

Stage
: modem

Ord
: 4

Applies
: radio:cellular

Done when
: the modem is registered on a network

Proof
: modem-registered

Proof kind
: phone-suite

Guide
: Read-only first (2026-11-11-modem-read-only-first). surya done.

Checked on
: 2026-11-18


<a id="sms-both-ways"></a>
### SMS both ways

Stage
: modem

Ord
: 5

Applies
: radio:cellular

Done when
: a message sent to the phone's own number comes back

Proof
: sms-loopback

Proof kind
: phone-suite

Component
: modem-sms

Guide
: surya done (tests/health/telephony/sms-loopback.sh); it costs money, so it runs at most once a day.

Checked on
: 2026-11-18


<a id="mobile-data"></a>
### Mobile data

Stage
: modem

Ord
: 6

Applies
: radio:cellular

Done when
: pings and a 100 kB download go over the bearer's own interface, so Wi-Fi cannot stand in

Proof
: mobile-data

Proof kind
: phone-suite

Component
: modem-data

Guide
: surya: naming the APN gave 'Multiple PDN connection', so the connection carries none (modem-online-tqftpserv); budget mobile-data-check-budget.

Checked on
: 2026-11-18


<a id="mms-both-ways"></a>
### MMS both ways

Stage
: modem

Ord
: 7

Applies
: radio:cellular

Done when
: a picture message sent to the phone's own number comes back

Proof
: mms-loopback

Proof kind
: phone-suite

Guide
: Test to write; never tried in our labs (mmsd-tng).

Checked on
: 2026-11-18


<a id="call-audio-path"></a>
### The call's sound path exists

Stage
: calls

Ord
: 1

Applies
: form:phone

Done when
: the voice DSP path (q6voice on Qualcomm), its routing and a Voice Call UCM verb are present

Proof
: call-audio-path

Proof kind
: phone-suite

Guide
: surya: a TX topology sent silence; the uplink needs a 1-channel capture on TX_CODEC_DMA_TX_3 (call-audio-on-surya, calls-q6voice-kernel, calls-voice-ucm-uplink). World gap: q6voice lives out of tree in diverging copies and nothing exists for AudioReach SoCs (ixit-sdm845-upstreaming-0).

Sources
: ixit-sdm845-upstreaming-0

Checked on
: 2026-11-18


<a id="voice-call-both-ways"></a>
### A call carries sound both ways

Stage
: calls

Ord
: 2

Applies
: form:phone

Done when
: a tone sent into a call comes back from an echo line

Proof
: call-echo

Proof kind
: phone-suite

Component
: modem-calls

Guide
: Proven by an echo call, no hands (2026-11-17-calls-proven-by-echo-call, echo-call-test-design). surya done.

Sources
: twilio-voice

Checked on
: 2026-11-18


<a id="emergency-numbers-known"></a>
### Emergency numbers are known

Stage
: calls

Ord
: 3

Applies
: form:phone

Done when
: the modem's emergency list is read, and 112 would be dialled as an emergency call even without a SIM - proven without dialling

Proof
: emergency-list

Proof kind
: phone-suite

Guide
: Test to write. Android's rule: 112 and 911 always; the list from network, SIM, modem or defaults (android-emergency-call). surya open (volte-and-emergency).

Sources
: android-emergency-call

Checked on
: 2026-11-18


<a id="volte-call"></a>
### A call over LTE

Stage
: calls

Ord
: 5

Applies
: radio:cellular

Done when
: a call is known to go over IMS and carries sound both ways

Proof
: volte-call

Proof kind
: phone-suite

Guide
: World gap: no open IMS works across carriers; 81voltd serves the IMS data service on some phones and carriers, OpenIMSd reverse-engineers the rest, one emergency VoLTE call on a Fairphone 6 (linmob-weekly-34-2026). surya open (volte-and-emergency).

Sources
: voltd-81,openimsd-nlnet,nura-volte-frida,linmob-weekly-34-2026

Checked on
: 2026-11-18


<a id="wifi-joins"></a>
### Wi-Fi joins and reaches the gateway

Stage
: radios

Ord
: 1

Applies
: any

Done when
: the interface joins a network and reaches its gateway

Proof
: wifi-interface,wifi-connected,wifi-reaches-gateway

Proof kind
: phone-suite

Component
: wifi

Guide
: walleye open: the WCN3990 firmware from the vendor partition (walleye-wifi-wcn3990). 5 GHz and speed never measured.

Checked on
: 2026-11-18


<a id="bt-controller-up"></a>
### The Bluetooth controller is up

Stage
: radios

Ord
: 2

Applies
: any

Done when
: the controller is listed and powers on

Proof
: bt-controller,bt-powered

Proof kind
: phone-suite

Component
: bluetooth

Guide
: surya done; walleye open (walleye-wifi-wcn3990).

Checked on
: 2026-11-18


<a id="bt-pairs-carries-audio"></a>
### Bluetooth pairs and carries sound

Stage
: radios

Ord
: 3

Applies
: any

Done when
: a headset pairs, plays and records, in a call too

Proof
: bt-pairs

Proof kind
: witness

Guide
: surya open (bt-pairing).

Checked on
: 2026-11-18


<a id="nfc-reads-tag"></a>
### NFC reads a tag

Stage
: radios

Ord
: 4

Applies
: any

Done when
: a tag held to the phone is read

Proof
: nfc-reads-tag

Proof kind
: witness

Component
: nfc

Guide
: surya: the controller probes (nfc-device), nothing reads tags. World gap: NFC unclaimed on these phones.

Checked on
: 2026-11-18


<a id="usb-host-works"></a>
### USB host works

Stage
: radios

Ord
: 5

Applies
: any

Done when
: the port switches to host and a plugged device enumerates

Proof
: usb-role,usb-host-device

Proof kind
: phone-suite

Component
: usb-otg

Guide
: Switching the port cuts the lab's USB link: a second way in first.

Checked on
: 2026-11-18


<a id="hotspot-shares-data"></a>
### The phone shares its data

Stage
: radios

Ord
: 6

Applies
: radio:cellular

Done when
: a client on the phone's Wi-Fi hotspot reaches the internet over mobile data

Proof
: hotspot

Proof kind
: host-check

Guide
: Test to write; never tried.

Checked on
: 2026-11-18


<a id="sensor-hub-stable"></a>
### The sensor hub runs without crashing its DSP

Stage
: sensors

Ord
: 1

Applies
: soc:qcom

Done when
: the sensor domain runs with no DSP crash over three boots

Proof
: no-processor-crashes

Proof kind
: phone-suite

Guide
: surya: the registry kept current and a hexagonrpcd patch (2026-11-17-sensors-registry-kept-current, 2026-11-17-sensors-lasting-install-three-boots). World gap: why registry writes fail on some firmware.

Sources
: hexagonrpc-source,libssc,wiki-surya-ssc-2024

Checked on
: 2026-11-18


<a id="sensors-exposed"></a>
### Motion and light sensors read

Stage
: sensors

Ord
: 2

Applies
: any

Done when
: accelerometer, gyroscope and light give changing values through iio-sensor-proxy

Proof
: motion-and-light

Proof kind
: phone-suite

Component
: sensors

Guide
: surya done (motion-and-light; the test once counted devices only, sensors-hardware-surya). Behind the Qualcomm DSP through libssc (iio-sensor-proxy-libssc).

Sources
: iio-sensor-proxy-libssc

Checked on
: 2026-11-18


<a id="proximity-reads"></a>
### Proximity reads near and far

Stage
: sensors

Ord
: 3

Applies
: any

Done when
: covering the sensor changes its reading from far to near and back

Proof
: proximity-reads

Proof kind
: phone-suite

Guide
: surya partial: covering it waits a witness (sensors-proximity-cover-witnessed).

Checked on
: 2026-11-18


<a id="gnss-fix"></a>
### A position fix

Stage
: sensors

Ord
: 6

Applies
: any

Done when
: a fix outdoors within 5 minutes, reaching geoclue

Proof
: gps-fix

Proof kind
: phone-suite

Component
: gnss

Guide
: On Qualcomm the location engine is the modem's (QMI LOC), through ModemManager and gnss-share. surya open (gps-measurable). World gap: no assisted GPS (XTRA) anywhere.

Sources
: gnss-share

Checked on
: 2026-11-18


<a id="fingerprint-unlocks"></a>
### The fingerprint unlocks

Stage
: sensors

Ord
: 7

Applies
: any

Done when
: a finger enrols and unlocks through fprintd

Proof
: fingerprint-unlock

Proof kind
: witness

Component
: fingerprint

Guide
: surya: the reader is not exposed (reader-exposed fails, a declared gap). Most phone readers are not in libfprint.

Checked on
: 2026-11-18


<a id="camera-bus-bound"></a>
### The camera bus binds

Stage
: camera

Ord
: 1

Applies
: any

Done when
: the camera receiver (CAMSS: CSIPHY, CSID, VFE) and the control bus (CCI) bind

Proof
: camera-bus

Proof kind
: phone-suite

Guide
: surya: CAMSS binds, no sensor described yet (2026-11-11-cameras-understood, surya-lab research/cameras.md).

Checked on
: 2026-11-18


<a id="image-sensor-identified"></a>
### Each image sensor is identified

Stage
: camera

Ord
: 2

Applies
: any

Done when
: each sensor's chip-id register reads its expected value in its slot

Proof
: image-sensor

Proof kind
: phone-suite

Guide
: surya failing: the slots are being identified (camera-identify-slots).

Checked on
: 2026-11-18


<a id="raw-frame-captured"></a>
### A raw frame

Stage
: camera

Ord
: 3

Applies
: any

Done when
: one raw frame from each sensor arrives through the receiver

Proof
: raw-frame

Proof kind
: phone-suite

Guide
: Test to write. Sensor drivers are often out of tree (Pixel 3a, OnePlus 6).

Checked on
: 2026-11-18


<a id="camera-stream-viewable"></a>
### A viewable stream

Stage
: camera

Ord
: 4

Applies
: any

Done when
: libcamera lists each camera and its ISP (software or hardware) gives a viewable stream

Proof
: camera-stream

Proof kind
: phone-suite

Guide
: Today a software ISP, on the GPU since libcamera 0.7 (libcamera-softisp-fosdem-2026). World gap: the hardware ISP is not used on any Qualcomm phone (camss-stats-uapi-rfc).

Sources
: libcamera-softisp-fosdem-2026,camss-stats-uapi-rfc

Checked on
: 2026-11-18


<a id="video-recorded"></a>
### A video with sound

Stage
: camera

Ord
: 6

Applies
: any

Done when
: a recorded video plays back with its sound in step

Proof
: video

Proof kind
: witness

Guide
: Never tried in our labs.

Checked on
: 2026-11-18


<a id="focus-and-flash"></a>
### Focus and flash

Stage
: camera

Ord
: 7

Applies
: any

Done when
: autofocus moves the lens to a sharp image and the flash fires

Proof
: focus-flash

Proof kind
: witness

Guide
: World gap: 3A tuning for phone sensors has no public prior art; focus-coil drivers were in review in 2025.

Checked on
: 2026-11-18


<a id="suspend-way-back"></a>
### A hang in sleep finds its way back

Stage
: sleep

Ord
: 1

Applies
: any

Done when
: a hang in or after suspend resets the machine or panics into ramoops

Proof
: sleep-way-back,pmic-wdt-wakes-in-suspend

Proof kind
: phone-suite

Guide
: Extends watchdog-way-back into sleep. surya: the stock watchdog stops in suspend (2026-11-17-surya-way-back-inventory), kept armed by a patch (qcom-wdt-keep-armed-in-suspend); walleye: the PMIC watchdog bit and did not return (walleye-pmic-bite-reset-type-how-it-stands).

Sources
: lkml-qcom-wdt-suspend-2019,ramoops-doc

Checked on
: 2026-11-18


<a id="s2idle-cycle-returns"></a>
### A timed suspend returns

Stage
: sleep

Ord
: 2

Applies
: any

Done when
: a 15 s RTC-timed suspend returns in the same boot

Proof
: suspend-cycle

Proof kind
: phone-suite

Guide
: surya partial (health-suspend-cycle-proof): woke at once (2026-11-17-surya-s2idle-wakes-at-once), a UART wake across suspend (2026-11-17-qca-uart-wake-across-suspend). These SoCs have s2idle only (qcom-sleep-path).

Sources
: qcom-soc-sleep-states

Checked on
: 2026-11-18


<a id="suspend-wakes-quiet"></a>
### Only the meant sources wake it

Stage
: sleep

Ord
: 3

Applies
: any

Done when
: over a suspend only the RTC, the modem, the keys and the charger wake it

Proof
: suspend-irq-quiet

Proof kind
: phone-suite

Guide
: surya partial (floor-irq-quiet); ath10k floods the modem's interrupt on sdm845 (qcom-sleep-blockers).

Checked on
: 2026-11-18


<a id="radios-survive-suspend"></a>
### The radios come back from sleep

Stage
: sleep

Ord
: 4

Applies
: any

Done when
: after 20 cycles Wi-Fi and Bluetooth are up, with no interrupt storm and no controller crash

Proof
: bt-suspend

Proof kind
: phone-suite

Guide
: surya partial: the CTS pull-down hung the boot (2026-11-18-cts-pulldown-dtb-hangs); serial wakeup off (2026-11-17-serial-wakeup-off, 2026-11-18-bt-suspend-way).

Checked on
: 2026-11-18


<a id="sensors-across-suspend"></a>
### Sensors come back from sleep

Stage
: sleep

Ord
: 5

Applies
: any

Done when
: the sensor helper is stopped before suspend and serves again after

Proof
: sensors-after-suspend

Proof kind
: phone-suite

Guide
: FastRPC helpers attached across suspend crash the ADSP: surya and the Pixel 3a stop them around it (2026-11-18-systemctl-suspend-leaves-sensors-stopped, sleep-fastrpc-helpers).

Sources
: pmaports-sargo-suspend

Checked on
: 2026-11-18


<a id="resume-without-stall"></a>
### Resume without a stall

Stage
: sleep

Ord
: 6

Applies
: any

Done when
: 20 attended cycles with no coprocessor crash and no RCU stall

Proof
: resume-clean

Proof kind
: phone-suite

Guide
: surya failing (2026-11-18-resume-stall-how-it-stands, resume-stall-stop-clients).

Checked on
: 2026-11-18


<a id="soc-floor-reached"></a>
### The SoC reaches its floor

Stage
: sleep

Ord
: 8

Applies
: any

Done when
: in suspend the SoC's deepest-state counters rise (on Qualcomm: CX collapse and AOSS sleep)

Proof
: soc-sleeps

Proof kind
: phone-suite

Component
: deep-sleep

Guide
: surya failing: cxsd, aosd and ddr stay 0 (2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0, sleep-cluster-params). World gap: no public example of that floor on an SM7150/845-class phone (2026-11-17-floor-research).

Sources
: qcom-stats-c,soc-sleeps-check

Checked on
: 2026-11-18


<a id="call-wakes-from-sleep"></a>
### A call or a message wakes it

Stage
: sleep

Ord
: 9

Applies
: form:phone

Done when
: a call rings and an SMS arrives within 10 s while the phone sleeps

Proof
: wakes-for-call

Proof kind
: phone-suite

Guide
: The IPCRTR glink wakeup plus ModemManager's quick suspend; reported not dependable on OnePlus 6 and Pixel 3a (qcom-wake-for-calls). World gap: waking for a call but not for chatter. surya open (sleep-wakes-for-calls).

Sources
: nura-sdm845-wiki,nura-enchilada-wiki

Checked on
: 2026-11-18


<a id="all-day-battery"></a>
### A day on one charge

Stage
: sleep

Ord
: 11

Applies
: power:battery

Done when
: a day of mixed use - standby, calls, screen time - ends with charge left

Proof
: battery-day

Proof kind
: witness

Guide
: Never measured. UBports keeps it as an endurance test (ubports-device-data).

Sources
: ubports-device-data

Checked on
: 2026-11-18


<a id="shell-runs-with-hardware"></a>
### A phone shell runs on the hardware

Stage
: shell

Ord
: 1

Applies
: any

Done when
: a phone shell (sxmo, Phosh, Plasma Mobile) starts on the panel with touch, sound to the real card and its device profile

Proof
: shell-up

Proof kind
: phone-suite

Guide
: surya: sxmo with its profile; under Phosh the host loses the USB link (phosh-usb); Plasma was silent from a saved -110 dB mixer (plasma-silent). Phosh and Plasma need the GPU, sxmo does not.

Sources
: sxmo-contribute

Checked on
: 2026-11-18


<a id="on-screen-keyboard"></a>
### The on-screen keyboard types

Stage
: shell

Ord
: 2

Applies
: any

Done when
: the keyboard comes up in a text field and types into it

Proof
: osk-types

Proof kind
: witness

Guide
: Witness for now; a robot finger or an input injection can stand in.

Checked on
: 2026-11-18


<a id="lock-and-unlock"></a>
### Lock and unlock

Stage
: shell

Ord
: 3

Applies
: any

Done when
: the power key locks and darkens; the phone unlocks with its code

Proof
: lock-unlock

Proof kind
: witness

Guide
: Needs the keys clean of chatter (buttons-report).

Checked on
: 2026-11-18


<a id="notifications-arrive"></a>
### Notifications arrive with the screen off

Stage
: shell

Ord
: 4

Applies
: form:phone

Done when
: a message or a call shows a notification and sounds while the screen is off

Proof
: notification

Proof kind
: witness

Guide
: Push for apps is a service (feature push-notifications), not a step.

Checked on
: 2026-11-18


<a id="update-applies"></a>
### An update applies

Stage
: upkeep

Ord
: 1

Applies
: any

Done when
: an update from the distribution applies over the air and the phone boots it, the health suite as before

Proof
: update-applies

Proof kind
: phone-suite

Guide
: Test to write. UBports proves it by a local OTA test before an installer (ubports-porting).

Sources
: ubports-porting

Checked on
: 2026-11-18


<a id="update-rolls-back"></a>
### A bad update rolls back

Stage
: upkeep

Ord
: 2

Applies
: any

Done when
: an update that does not boot falls back to the last good one with no hands

Proof
: update-rollback

Proof kind
: phone-suite

Guide
: A/B slots (qbootctl) or a boot counter; Android's boot control HAL (aosp-compat-matrix).

Sources
: aosp-compat-matrix

Checked on
: 2026-11-18


<a id="kernel-upgrade-keeps-steps"></a>
### A kernel upgrade keeps every step

Stage
: upkeep

Ord
: 3

Applies
: any

Done when
: on a new kernel release the suite passes what it passed before, and proven_on moves to the new kernel

Proof
: suite-compare

Proof kind
: phone-suite

Guide
: How claims stay true without expiry: a later kernel is told by proven_on and re-proven.

Checked on
: 2026-11-18


<a id="coprocessor-restart-recovers"></a>
### A coprocessor crash is survived

Stage
: upkeep

Ord
: 4

Applies
: any

Done when
: a coprocessor crashed on purpose restarts and its users - sound, modem, sensors - come back with no reboot

Proof
: ssr-recovers

Proof kind
: phone-suite

Guide
: surya failing for audio after a DSP restart (surya-adsp-audio-after-suspend-loop). World gap: nobody tests whole-stack recovery.

Checked on
: 2026-11-18


<a id="cycles-repeat-clean"></a>
### Repeated cycles stay clean

Stage
: upkeep

Ord
: 6

Applies
: any

Done when
: 100 suspend cycles, 20 calls and 50 camera switches with no part lost

Proof
: cycles-clean

Proof kind
: phone-suite

Guide
: 'Does audio still work after two hours asleep' (weiss-fosdem-2025-missing-20).

Sources
: weiss-fosdem-2025-missing-20,fosdem-2026-foss-on-mobile

Checked on
: 2026-11-18


<a id="linux-runs"></a>
### Linux runs

Stage
: goals

Ord
: 1

Applies
: any

Done when
: every step it needs is done or not-needed

Proof
: bringup-chain-ready

Proof kind
: host-check

Guide
: A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). The close of the generic bring-up, any machine.

Sources
: systemd-target

Checked on
: 2026-11-18


<a id="daily-usable-phone"></a>
### A daily-usable phone

Stage
: goals

Ord
: 2

Applies
: form:phone

Done when
: every step it needs is done or not-needed

Proof
: bringup-chain-ready

Proof kind
: host-check

Guide
: A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). What a person needs every day: calls, messages, data, sound, a photo, a position, a day of battery, charging, updates (the features of milestones lp-calls-and-messages, lp-connected, lp-daily-basics; UBports' stages 3-4).

Sources
: systemd-target,ubports-device-data

Checked on
: 2026-11-18


<a id="complete-phone"></a>
### A complete phone

Stage
: goals

Ord
: 3

Applies
: form:phone

Done when
: every step it needs is done or not-needed

Proof
: bringup-chain-ready

Proof kind
: host-check

Guide
: A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target). Everything the hardware does, lasting: VoLTE, MMS, every radio and sensor, video, rollback, reliability. Apps and services (Android apps, banking, sync, backup) stay features, not steps.

Sources
: systemd-target,android-cdd,halium-scope

Checked on
: 2026-11-18


<a id="pon-reason-read"></a>
### Why it turned on, and why it last turned off, are read

Stage
: power

Ord
: 8

Applies
: any

Done when
: each boot logs the power-on reason (key, USB charger, RTC alarm, warm reset, watchdog, key-combo reset) and the last power-off reason, read from the PMIC

Proof
: pon-reason

Proof kind
: phone-suite

Guide
: Test to write. On Qualcomm the PON block keeps PON_REASON, WARM_RESET_REASON and POFF_REASON (gen2 moves POFF_REASON1 to 0xc5; downstream-qpnp-power-on-sm6150 logs them, mainline's qcom-pon does not show them). surya read its PON registers by hand (surya-lab PR 269; upstreams-lane). Every step of the off side is told apart by this reason.

Sources
: downstream-qpnp-power-on-sm6150

Checked on
: 2026-11-18


<a id="reset-types-right"></a>
### Power-off, reboot and a bite each reach the right PMIC reset

Stage
: power

Ord
: 9

Applies
: any

Done when
: power-off ends in the PMIC's shutdown, reboot in a warm or hard reset, and a watchdog bite in a hard reset - each read back from the PMIC and seen in the next boot's reason

Proof
: reset-types

Proof kind
: host-check

Guide
: On Qualcomm, power-off goes by PSCI SYSTEM_OFF to the secure firmware, which sets the PS_HOLD reset type and drops PS_HOLD; reboot sets another type. A wrong type, the firmware's own choice, or a power-on trigger still pending (a plugged cable, an armed PMIC watchdog, an RTC alarm) turns off into a new boot. surya: the firmware leaves S2 at warm reset 0x01; patch 5/5 sets hard reset 0x07 with a read-back (upstreams-lane). walleye: a bite powered off instead of restarting (pmic-wdt-reset-type). Test to write.

Sources
: downstream-qpnp-power-on-sm6150,lkml-qcom-wdt-suspend-2019

Checked on
: 2026-11-18


<a id="power-off-stays-off"></a>
### Off stays off

Stage
: power

Ord
: 5

Applies
: any

Done when
: poweroff leaves the machine off, and plugging a charger in does not boot the full system

Proof
: stays-off

Proof kind
: witness

Guide
: surya fails: poweroff and a plugged charger both boot pmOS (off-state-charging); only the old eOS recovery's power-off held, so the PMIC can stay off and our power-off path is what differs. Read the power-on reason (pon-reason-read) and the reset types (reset-types-right) to tell a reboot from a charger power-on.

Sources
: downstream-qpnp-power-on-sm6150

Checked on
: 2026-11-18


<a id="charger-mode-entered"></a>
### A charger power-on starts the charging screen, not the system

Stage
: power

Ord
: 10

Applies
: power:battery

Done when
: plugged in while off, the phone starts a small charger mode that shows the level and turns the screen off again; the power key starts the full system

Proof
: charger-mode

Proof kind
: witness

Component
: battery

Guide
: Android: the bootloader reads the power-on reason and passes androidboot.mode=charger; init then runs only the charger - the same kernel, no separate processor (Sailfish's act-dead mode, sailfish-hadk-checklist). World gap: no maintained charger mode in any mainline distribution; charging-sdl is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064).

Sources
: sailfish-hadk-checklist,pmaports-charging-sdl-1064

Checked on
: 2026-11-18


<a id="reset-state-survives"></a>
### What must survive a reset does, and the rest is set again

Stage
: power

Ord
: 11

Applies
: any

Done when
: across a warm reset the reboot mode (the PMIC's spare register: bootloader, recovery), the RTC and ramoops survive; after any reset the kernel sets again the PMIC state it relies on (S2 reset type, watchdogs) and reads it back

Proof
: reset-state

Proof kind
: host-check

Guide
: The PMIC keeps its registers across a warm reset and the firmware rewrites some at boot (surya's S2 type 0x01 from firmware, upstreams-lane). ramoops survives a warm reset only if its memory is not cleared (ramoops-doc). Test to write.

Sources
: ramoops-doc,downstream-qpnp-power-on-sm6150

Checked on
: 2026-11-18


<a id="key-reset-recovers"></a>
### A held key resets a hung phone

Stage
: power

Ord
: 12

Applies
: any

Done when
: holding power (with volume down where so wired) for the set time hard-resets a hung phone, and the next boot's reason says so

Proof
: key-reset

Proof kind
: witness

Component
: buttons

Guide
: The PMIC's S1/S2 key reset, set by the firmware or the PON driver; a user's way back that needs no software. Test by hand.

Checked on
: 2026-11-18


<a id="rtc-alarm-powers-on"></a>
### An alarm turns the phone on from off

Stage
: power

Ord
: 13

Applies
: any

Done when
: an alarm set before power-off turns the phone on at its time, and the reason reads RTC alarm

Proof
: rtc-poweron

Proof kind
: host-check

Guide
: Android's power-off alarm: the PMIC RTC alarm powers it up and the bootloader boots an alarm mode. PCs have rtcwake -m off. World gap: no mainline phone distribution sets an alarm that survives power-off, and whether rtc-pm8xxx keeps the alarm armed through shutdown is not known yet.

Checked on
: 2026-11-18


<a id="test-layer-boots"></a>
### The test layer boots, with no shell

Stage
: lab

Ord
: 2

Applies
: any

Done when
: a boot with no phone shell (multi-user.target, no display manager) is up with a tty, ssh and the lab's services, and nothing in it suspends, locks or reacts to keys unless a test asks; the lab's suspend work runs there

Proof
: test-layer-quiet

Proof kind
: phone-suite

Guide
: Hardware steps are proven here, the shell's own in the shell stage (2026-11-19-hardware-test-layer). lab-tools' health-test-layer-quiet reads it: no shell or idle-suspend process runs, logind's IdleAction and HandlePowerKey are ignore, no suspend this boot but the health suite's own cycles; in a shell layer it says skip and names the shell, so the step stays unknown until the test layer boots. surya: the image it runs, booted from a second entry with systemd.unit=multi-user.target, the sxmo entry beside it. A new device's first root filesystem is this layer. Measured: test-layer-sxmo-cost-measured, test-layer-landscape.

Checked on
: 2026-11-19


<a id="shell-autosleep-tamed"></a>
### The shell's idle suspend is held off while the lab works

Stage
: shell

Ord
: 5

Applies
: any

Done when
: the shell's own idle suspend is off or held off while the lab works, proven per shell (sxmo's autosleep, Phosh's gsd-power, Plasma Mobile's PowerDevil)

Proof
: autosleep-off

Proof kind
: phone-suite

Guide
: surya: sxmo's rtcwake loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999). The test layer has no shell to hold off, so the hardware steps do not wait on this; it is the shell's own, once for each shell, and the sxmo fork and its series are retired (2026-11-19-hardware-test-layer).

Checked on
: 2026-11-19


<a id="real-suspend-under-shell"></a>
### The shell's own suspend returns

Stage
: shell

Ord
: 6

Applies
: any

Done when
: the shell's auto-suspend and systemctl suspend return, again and again

Proof
: shell-suspend

Proof kind
: phone-suite

Guide
: surya failing: the phone did not return (2026-11-18-real-suspend-try4-phone-did-not-return). The hardware's suspend steps (s2idle-cycle-returns, radios-survive-suspend, suspend-way-back) are proven first in the test layer; this one is the shell's own idle suspend and systemctl suspend, per shell (2026-11-19-hardware-test-layer).

Sources
: sxmo-autosuspend

Checked on
: 2026-11-19


<a id="alarm-wakes-from-sleep"></a>
### An alarm rings from sleep

Stage
: shell

Ord
: 7

Applies
: any

Done when
: an alarm set in the clock app rings on time while the phone sleeps under its shell's suspend

Proof
: alarm-rings

Proof kind
: phone-suite

Guide
: The shell or clock must set an RTC wake alarm before suspend (kernel-sysfs-power-wakelock). Not known yet which phone shells do; never tried in our labs.

Sources
: kernel-sysfs-power-wakelock

Checked on
: 2026-11-19


<a id="auto-rotate-follows"></a>
### The screen follows rotation

Stage
: shell

Ord
: 8

Applies
: any

Done when
: turning the phone turns the shell's screen

Proof
: auto-rotate

Proof kind
: witness

Guide
: Never tried in our labs.

Checked on
: 2026-11-19


<a id="brightness-follows-light"></a>
### Brightness follows the light

Stage
: shell

Ord
: 9

Applies
: any

Done when
: covering the light sensor dims the panel under auto-brightness

Proof
: auto-brightness

Proof kind
: witness

Guide
: Never tried in our labs.

Checked on
: 2026-11-19


<a id="proximity-blanks-in-call"></a>
### The screen goes dark at the ear

Stage
: shell

Ord
: 10

Applies
: form:phone

Done when
: in a call the screen blanks and touch is ignored while the proximity sensor is covered

Proof
: proximity-in-call

Proof kind
: witness

Guide
: surya open (sensors-proximity-in-calls). Sailfish checks it while suspended too (sailfish-hadk-checklist).

Sources
: sailfish-hadk-checklist

Checked on
: 2026-11-19


<a id="days-without-reboot"></a>
### Days without a reboot

Stage
: shell

Ord
: 11

Applies
: any

Done when
: seven days of ordinary use with no reboot, crash or part lost

Proof
: uptime-days

Proof kind
: phone-suite

Guide
: Reliability, not function (weiss-fosdem-2025-missing-20); UBports' noRebootTest (ubports-device-data).

Sources
: weiss-fosdem-2025-missing-20,ubports-device-data

Checked on
: 2026-11-19


<a id="photo-taken"></a>
### A photo

Stage
: camera

Ord
: 5

Applies
: any

Done when
: a capture tool saves a photo with sane exposure and colour from each camera

Proof
: photo

Proof kind
: witness

Component
: camera-rear

Guide
: Fairphone 6: all three cameras in 2026, the furthest any Qualcomm phone got (linmob-weekly-34-2026). Proven in the test layer with a capture tool; a shell's camera app is the shell's own use of it (2026-11-19-hardware-test-layer).

Sources
: linmob-weekly-34-2026

Checked on
: 2026-11-19


<a id="standby-current"></a>
### Standby draws little

Stage
: sleep

Ord
: 10

Applies
: power:battery

Done when
: on battery alone, asleep with the modem attached, the average current is under the device's target (15 mA on surya)

Proof
: standby-current

Proof kind
: phone-suite

Guide
: The arbiter of sleep (2026-11-17-standby-current-is-the-arbiter). surya partial: median 31 mA (2026-11-17-r3-partial-and-the-reset-after). World gap: no published s2idle figures per SoC with a modem. Measured first in the test layer, with no shell to wake it; the shell's figure follows under real-suspend-under-shell (2026-11-19-hardware-test-layer).

Sources
: android-doze-standby

Checked on
: 2026-11-19


<a id="display-any-order"></a>
### The display comes up at boot in any order

Stage
: display

Ord
: 6

Applies
: any

Done when
: on three cold boots the panel, its bridge and the GPU bind by deferred probe with their modules autoloaded (modalias), no initramfs module list or modprobe ordering of ours, and the console shows on the panel each time

Proof
: display-boots-any-order: three boots; each boot's dmesg shows the panel bound after any deferral, lsmod lists the modules with no ordering file in the image, the panel lit

Proof kind
: phone-suite

Component
: display-panel

Guide
: Upstream-readiness: a driver that only works with a hand-ordered module list is not ready for mainline. Return -EPROBE_DEFER for each supplier not yet there (regulators, the DSI host, the backlight, the GPIO expander), declare the suppliers in the device tree so fw_devlink orders it, and drop any modules-load or initramfs ordering list. walleye's B1 bring-up met the order dependence (walleye-display-s6e3fa5).

Checked on
: 2026-11-19


<a id="storage-full-speed"></a>
### Internal storage links at full speed

Stage
: storage

Ord
: 2

Applies
: any

Done when
: the internal storage's link runs at the fastest mode the SoC and the card both support - UFS: the HS gear and lane count of the SoC's spec, both lanes up; eMMC: HS400 (or HS200 where HS400 is not supported) - read from the kernel, and a sequential read measures within reach of that mode

Proof
: storage-link-speed: the link mode from debugfs or dmesg (UFS power mode HS-Gn, lanes; eMMC timing) matches the SoC's documented maximum, and a read-only dd of a partition measures the throughput

Proof kind
: phone-suite

Guide
: Upstream-readiness: a storage driver that links at PWM or one lane boots but is not done. On Qualcomm UFS the PHY tables and the gear limits per SoC decide it; compare with the downstream tree's settings. Read only: never write the internal storage to measure it.

Checked on
: 2026-11-19
