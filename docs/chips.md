<!-- Generated from data/ by tad. Do not edit by hand. -->

# Chips

<a id="ti-drv2624"></a>
### ti-drv2624

Part
: DRV2624

Maker
: Texas Instruments

Kind
: haptics

Compatible
: ti,drv2624 (no binding anywhere yet: porthole's driver and Google's downstream driver both match it)

Identify
: I2C, at 0x5a on every board met (porthole's taimen dts, shift-otter's dts comment; the datasheet to confirm whether the address is fixed); ID register 0x00, its upper nibble (mask 0xf0) reads 0x0 (porthole patch 0018)

Driver stage
: fork

Homes
: fork: porthole patch 0018-Input-drv2624-add-TI-DRV2624-haptics-driver (driver only, no binding) https://github.com/porthole-dev/pmaports/tree/taimen-bringup/device/testing/linux-postmarketos-qcom-msm8998-7.2 ; downstream: Google msm-4.14 https://git.evolution-x.org/Evolution-X-Devices/kernel_google_msm-4.14/commit/7f072754a6794de44116d9100a777474584a4fc1 ; mainline: none - drivers/input/misc/drv260x.c covers drv2604/2604l/2605/2605l only (https://cateee.net/lkddb/web-lkddb/INPUT_DRV260X_HAPTICS.html); on the list: nothing found (lore not read directly)

Firmware
: None for porthole's driver: it is driven by registers alone. Android's stack ships a drv2624.bin (named in LineageOS blob lists); what that file holds is not read yet.

Quirks
: The LRA settings are board values in DT: ti,actuator, ti,smart-loop, ti,rated-voltage, ti,odclamp-voltage, ti,lra-frequency, ti,ol-lra-frequency, ti,lra-wave-shape (taimen: LRA, closed loop, 77 = 1.8 Vrms, 165 = 3.5 Vpeak, 155 Hz, square; porthole patch 0028). A YAML binding for them is the first patch an upstream series needs, and porthole has none. Porthole's driver is GPL-2.0, by Giuseppe Maggio, marked Assisted-by: LLM, ported from the downstream wahoo driver: its authorship is kept in any series (decision 2026-11-19-walleye-audio-port-shape, google-walleye-lab).

Boards
: google-taimen (I2C 0x5a, reset tlmm 95; porthole dts 0028); google-walleye (I2C bus 6, 0x5a, reset gpio 95, from the vendor kernel - not read back yet: walleye-haptics-i2c-answers in google-walleye-lab); shift-otter, qcm6490 (0x5a; a comment in mainline's dts, no node); xiaomi-surya (claimed by a blob name only: drv2624.bin in LineageOS's proprietary-files.txt, which also names aw8624_haptic.bin - which part is fitted is not known)

Steps
: haptics-buzz

Proof
: vibrator (test); felt by a person (walleye-haptics-felt in google-walleye-lab); the presence check today is walleye's own haptics-chip-present (google-walleye-lab tests/health/base/amp-present.sh), to become the generic chip check

Tools
: none yet: lpoco-chip-check (present and bound, from this row's identify and the board's device.toml), lpoco-chip-series-check (binding, driver, dts apart)

Datasheet
: ti-drv2624-datasheet

Sources
: porthole-pmaports,google-msm-4-14-drv2624,shift-otter-dts,lineage-surya-tree,lkddb

Checked on
: 2026-11-19


<a id="ti-tas2557"></a>
### ti-tas2557

Part
: TAS2557

Maker
: Texas Instruments

Kind
: audio-amp

Compatible
: ti,tas2557 (on the list: the binding in Boiano's v3; porthole's driver matches the same string with no binding)

Identify
: I2C; a board with two amps puts them at 0x4c and 0x4d (porthole's driver, Pixel 2 family); the register that identifies the part is not recorded yet (datasheet ti-tas2557-datasheet)

Driver stage
: in-review

Homes
: on the list: Boiano v3 0/2 (dt-bindings + ASoC driver) https://lkml.iu.edu/2607.2/04618.html, reviewed by Mark Brown https://lkml.iu.edu/2607.2/06067.html, no v4 found; fork: porthole patches 0024, 0162, 0171-0174 (driver only, no binding) https://github.com/porthole-dev/pmaports/tree/taimen-bringup/device/testing/linux-postmarketos-qcom-msm8998-7.2 ; mainline: none - sound/soc/codecs has tas2552/2562/2764/2770/2780/2781, none covers it; linux-firmware: none

Firmware
: Needs a board tuning made with TI PurePath Console: its PLL setup and DSP program live only in that file, and without it the amp is mute and the sound card waits forever (porthole's driver; Boiano v3). The Pixel 2 family's file is tas2557s_PG21_uCDSP.bin, loaded as tas2557s_uCDSP.bin. It sits on the phone's vendor partition; porthole fetches it from a LineageOS vendor mirror. It is not in linux-firmware and is not ours to ship: it is read from the phone at boot, never put in git (decision 2026-11-19-walleye-tas2557-firmware-stays-on-the-phone, google-walleye-lab).

Quirks
: No firmware-free bypass mode (research walleye-audio-haptics-porthole-has-it, google-walleye-lab). The two drivers do not take the same dts. v3 takes one or two amps as a reg array, with four supplies and firmware-name. Porthole's takes two I2C clients (0x4c, 0x4d) and a reset GPIO (pm8998_gpios 5 on taimen). A board should follow v3's binding, the one heading to mainline. v3's ASI word length and slot offset are confirmed only at 16-bit, offset 0 (vince); 32-bit, offset 1 boards are not confirmed. The maintainer asks for a firmware device-count check and a mute at suspend (tas2557-v3-review).

Boards
: google-taimen (I2C 0x4c and 0x4d, reset pm8998_gpios 5; porthole dts 0028); google-walleye (two amps in the vendor kernel - research google-walleye-vendor-kernel-hardware in google-walleye-lab; addresses not read back yet); xiaomi-jasmine (SDM660), xiaomi-tulip (SDM636), xiaomi-vince (MSM8953), mono; xiaomi-clover (SDM660), two amps (all four: Boiano v3's testing)

Steps
: firmware-reachable,sound-card-registered,speaker-amps-fed,speaker-heard

Proof
: amp-channels, amp-volume-0x4c, amp-volume-0x4d, heard-left, heard-right (tests); the presence check today is walleye's own amp-present-0x4c/0x4d (google-walleye-lab tests/health/base/amp-present.sh), to become the generic chip check

Tools
: none yet: lpoco-chip-check (present and bound, from this row's identify and the board's device.toml), lpoco-chip-series-check (binding, driver, dts apart)

Datasheet
: ti-tas2557-datasheet

Sources
: tas2557-v3-boiano,tas2557-v3-review,porthole-pmaports

Checked on
: 2026-11-19
