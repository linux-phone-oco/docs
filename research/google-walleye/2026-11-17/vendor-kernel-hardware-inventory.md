# Pixel 2 (walleye): what the vendor's GPL kernel says the hardware is (2026-11-17)

Hardware facts read from the device-tree sources of Google's wahoo kernel, as LineageOS keeps it
(`LineageOS/android_kernel_google_wahoo`, branch `lineage-22.2`, Linux 4.4, GPL-2.0), and, for what mainline
can already express, from the out-of-tree mainline port `kcxt/linux-wahoo` (branch `wahoo/5.17`, GPL-2.0).
Read-only, nothing from the phone. Only observed facts, in our own words, for a table: no code, no panel
init sequences, no calibration or battery-profile data is copied here, and no proprietary blob was opened.
A later reader who needs a register sequence reads the GPL file named in the "where" column, with its
licence and copyright, and ports from there.

## How walleye hides in that tree
- Walleye is the **HTC-built** half of the wahoo pair: its sources are under `arch/arm64/boot/dts/htc/`
  with HTC's project name **muskie** (the taimen half, LG-built, is under `.../lge/`). Searching for
  "walleye" alone finds only battery, panel, touch and overlay files; the rest is called `muskie` or `htc`.
- One base (`base-msm8998-mtp` + `msm8998-htc_muskie` + the `htc-*` fragments) is completed by one of
  **two device-tree overlays**, chosen by board revision: `overlay-walleye-xa_xb_xc` and
  `overlay-walleye-xd_xe_a`. The two differ only in the touch power wiring, the notification-LED part and
  the battery profile set. Our phone reports hw-revision **MP1** (fastboot): which overlay the bootloader
  picks for MP1 is **not known yet** (by name MP1 is later than xd/xe, so the second is likely - inference).
- The base board id is 0x1D (the "muskie EVM" file); SoC variant is MSM8998 **v2.1** (`msm8998-v2.1-*`).
- The stock verified-boot node names the system partitions as `vbmeta, boot, system, vendor, dtbo` on the
  UFS controller at 1da4000 (so the phone boots from the 1da4000 UFS host, dtbo carries the overlays).
- The kernel builds as `wahoo_defconfig` (shared with taimen) and `lineageos_muskie_defconfig` (walleye).

## The hardware table
"how wired" is as the stock tree says (downstream bus labels, `i2c_N`, are the stock names, not mainline's
`blsp1_i2c5`-style names). GPIO numbers are TLMM unless said PM8998/PMI8998.

| part | chip / kind (stated by the tree) | how wired (observed) | where (GPL file in `dts/htc/` unless said) |
|---|---|---|---|
| SoC | Qualcomm MSM8998 v2.1 (Snapdragon 835) | UFS, DWC3 USB, 4-lane DSI, Adreno 540 | `msm8998-v2.1-*` |
| PMICs | PM8998 + PMI8998 (+ PM8005 for CPU rails per the mainline port) | SPMI; PMI8998 holds charger, fuel gauge, flash LEDs, a second GPIO bank | muskie / battery files |
| panel | Samsung **S6E3FA5**, 5.0 in, 1080x1920, 60 Hz, command mode, 4 DSI lanes, 62x110 mm | reset GPIO94, tearing-effect GPIO10, error-flag PMI8998 GPIO14; supplies: 1.8 V I/O = PM8998 L14, panel analog (VCI) 3.0 V = PM8998 L22; backlight set by DCS commands (no WLED, no LAB/IBB); the stock tree also supports always-on (ALPM) low-power modes | `dsi-panel-walleye-s6e3fa5.dtsi`, `msm8998-htc_muskie.dtsi` |
| touch | **Synaptics** DSX (HTC variant of the driver), I2C address 0x20 | stock `i2c_5` = BLSP1 QUP5 (SDA GPIO87, SCL GPIO88, 400 kHz); IRQ GPIO125 (level low), reset GPIO89, a mode "switch" GPIO75; supply PM8998 L6 1.8 V (overlay xa..xc), or an enable on PMI8998 GPIO2 (overlay xd..); display coords 1080x1920; firmware images are loaded by name (`synaptics_N.img`: proprietary, not in the tree) | `msm8998-touch-mw-common.dtsi`, `msm8998-touch-walleye-xa/xd.dtsi` |
| keys | power GPIO40, volume up GPIO126, volume down GPIO121 (active low, wake sources) | gpio-keys | `msm8998-key-muskie.dtsi` |
| audio codec | Qualcomm **WCD934x "Tavil"** (WCD9340/9341 class) on SLIMbus; analog jack paths disabled ("no audio jack") | SLIMbus, digital mics DMIC1-3 on the handset-mic bias rails; codec clock from the PMI clock | `msm8998-audio-muskie.dtsi` |
| speaker amplifier | **TI TAS2557** stereo smart amp, I2C 0x4d on `i2c_7` (BLSP2 QUP1, 0x0c1b5000); left/right channels at 0x4c/0x4d | I2S "quaternary MI2S" playback (RX 2 lines, TX 1); reset PM8998 GPIO6, left/right IRQ PM8998 GPIO7/8; 24-bit samples | same |
| (older amp) | NXP TFA98xx at 0x34/0x35, present in the tree but **disabled** (earlier hardware revision) | reset PM8998 GPIO6/7 | same |
| haptics | **TI DRV2624** at 0x5a on `i2c_6`, LRA actuator, 155 Hz, 1.8 Vrms rated, 3.5 V peak clamp; the PMI8998 built-in haptics are disabled | reset GPIO95 | `msm8998-htc-haptics-xa.dtsi` |
| notification LED | overlay xa..xc: **TI LP5562** RGB driver at 0x30 on `i2c_7`, enable PM8998 GPIO18, 3.3 V LED rail from PMI8998 GPIO9; overlay xd..: the PMI8998's own RGB LPG (no external chip) | - | `msm8998-htc-led-xa.dtsi`, `-xd.dtsi` |
| charger | Qualcomm **PMI8998 "SMB2" charger** with a Type-C PD PHY; a TI **TPS61099** boost makes the 5 V for USB host (OTG), enabled by PM8998 GPIO5 | USB-C: **NXP PTN36241G** redriver/switch, CC pin muxing by TLMM GPIO (41,42,49,76,77) | `msm8998-htc-usb-xa.dtsi`; defconfig `QPNP_SMB2`, `USB_PD_ENGINE` |
| fuel gauge | PMI8998 **FG gen3** (inside the PMIC), with an HTC battery module on top | battery profile per battery id (resistor on the pack): 2 known ids + "unknown"; **nominal 2700 mAh**, max 4.4 V, cutoff 3.4 V, charge-termination 50 mA, JEITA limits 0/15/48/55 C, recharge below 97 % | `batterydata-walleye*.dtsi`, `drivers/power/htc_battery.c` |
| thermistors | three on PM8998's ADC: "fpc_therm", "back_therm", "pa_therm" | ADC channels 0x4e, 0x4f, 0x50 | `msm8998-htc_muskie.dtsi` |
| NFC | NXP **NQ-series NFC controller** (Qualcomm `nq-nci` driver) at 0x28 on `i2c_8`, with an NXP **PN81A secure element** on `spi_1` (8 MHz, DMA off: "works only intermittently") | IRQ GPIO92, VEN GPIO12, firmware-download GPIO93, eSE power GPIO30, eSE reset GPIO29, clock request PM8998 GPIO21, clock from the BB_CLK3 pin | `msm8998-htc-nfc.dtsi` |
| fingerprint | **FPC 1020 family** (kernel option `FPR_FPC`), rear | IRQ GPIO86, reset GPIO128; the SPI link is not described in this file (it goes through the secure/TrustZone side - not known yet) | `msm8998-htc-fingerprint-muskie-xa.dtsi` |
| Wi-Fi | Qualcomm **WCN3990** (integrated Wi-Fi + Bluetooth radio, "ICNSS"/QCA_CLD driver, firmware from the vendor partition) | no I2C/SPI: memory-mapped through the SoC (ath10k-class on mainline: `wifi` node in the kcxt tree) | defconfig `ICNSS`, `QCA_CLD_WLAN`; kcxt `wahoo.dtsi` |
| Bluetooth | same **WCN3990**; HCI over **BLSP1 UART3** (high speed) and audio over SLIMbus | supplies from PM8998 S3, S5, L7, L17, L25 and the PMI8998 BOB pin | `base-msm8998-mtp.dtsi`; kcxt node `qcom,wcn3990-bt` |
| modem | MSM8998's own modem (MPSS), LTE Cat. 15; firmware from the modem partition | reserved RAM 0x8cc00000, 120 MiB; IPA block | `msm8998-htc-common.dtsi` |
| sensors | **no sensor chips in the application processor's tree**: they hang off the **SLPI** (sensor hub DSP) which owns their buses; firmware is a proprietary file (`slpi_v2`) | kernel only has the SSC glue (`SENSORS_SSC`); mainline port starts the SLPI remoteproc | defconfig; kcxt `wahoo.dtsi` |
| camera, rear/front | **two CCI-attached sensors** (CCI master 0 rear, master 1 front), clock 24 MHz; the chip **type is not in the tree** (named by userspace sensor libraries): public teardown/spec sources name Sony IMX362 (rear) and IMX179 (front), see the Android-reference research | rear mount angle 90, front 270; rear has autofocus actuator, **OIS**, an EEPROM per sensor, and a flash from the PMI8998 flash LEDs; supplies: VIO = PM8998 LVS1, analog and digital via PM8998 GPIOs 15 and 20 (rear), PMI8998 GPIOs 3 and 6 (front) | `msm8998-camera-sensor-muskie-xa.dtsi` |
| laser autofocus | ST time-of-flight ranger (by its address and the vendor's name `wahoo_laser`; iFixit names VL53L0X on the XL) at 0x29 on `i2c_9` | IRQ GPIO62, power-down GPIO39, 2.8 V = PM8998 L19, 1.8 V I/O = LVS1 | `msm8998-camera-laser-muskie.dtsi` |
| Pixel Visual Core ("Easel") | Google/Intel image coprocessor, PCIe 0 link, own PMIC (Broadcom **BCM15602**, I2C 0x08 on `i2c_9`), control SPI `spi_10` (25 MHz), own console UART | BCM15602: power-on GPIO25, interrupt GPIO26, reset GPIO91; 64 MiB RAM carve-out 0x95c00000; wake GPIO removed from the PCIe pinmux | `msm8998-htc-easel.dtsi` |
| Active Edge squeeze | an "edge" supply (3 V rail enable PM8998 GPIO2) and a Maxim ADC is the XL's reading (iFixit) - **how walleye reads the squeeze is not known yet** | - | `msm8998-htc-edge.dtsi` |
| storage | UFS (host at 1da4000), inline crypto engine on; rails: PM8998 L20 (VCC), L26 (VCCQ), S4 (VCCQ2); also an SD controller `sdhc_2` is described (card-detect GPIO95) but the phone has no card slot - an unused base-board leftover | - | `base-msm8998-mtp.dtsi` |
| USB | Qualcomm QUSB PHY + DWC3, role switching by the PMI8998 PD PHY | - | usb files above |
| console UART | BLSP2 UART1 (stock label `uartblsp2dm1`) with a "console" pinmux; the mainline port boots with it as `ttyMSM1` and with a USB-gadget serial `ttyGS0` | physical access (test pads) **not known yet** | `base-msm8998-mtp.dtsi`; kcxt `wahoo.dtsi` |

## Memory map and crash log (useful for a phone with no display)
- Stock reserved regions: modem 0x8cc00000 (120 MiB), modem boot authenticator 0x94500000, video 0x94700000,
  sensor-hub 0x94c00000 (15 MiB), IPA/GPU 0x95b00000, Easel 0x95c00000 (64 MiB).
- **RAM console (ramoops)** is described in stock: main region at **0xa1100000, 2 MiB** (console 1 MiB, pmsg 512 KiB,
  records 128 KiB) plus an alternate at **0xa3800000** and a metadata page at 0xaffff000. A kernel that sets these
  up leaves its log in RAM across a warm reset, readable by the next boot - the way to read a no-display
  crash. **The mainline port places its ramoops elsewhere (0xa1810000, 2 MiB): which address the phone's
  bootloader keeps intact is not known yet and has to be checked before relying on either.**
- The mainline port keeps the modem region as stock (0x8cc00000, 120 MiB) but places the video, modem-boot and
  sensor-hub regions at the stock-Qualcomm addresses (video 0x94400000, MBA 0x94900000, sensor hub 0x94b00000
  of 7 MiB), not at HTC's moved ones above (0x94700000, 0x94500000, 0x94c00000 of 15 MiB): the firmware the
  phone actually carries decides which is right; to be reconciled before those remote processors are started.

## What the mainline port (kcxt) covers for walleye
`msm8998-google-walleye.dts` is a 13-line file naming the board and including the shared wahoo file; it sets
no panel of its own, so on walleye the shared file's (taimen's LG) panel would be wrong - **walleye is only
nominally supported**. The shared file enables: UFS, USB (peripheral only, SuperSpeed dropped), display
controller + one DSI, GPU (zap shader, GPU firmware paths under `qcom/msm8998/wahoo/`), Wi-Fi, a Bluetooth
UART node, ADSP/SLPI remoteprocs (modem left off), the PM8998/PMI8998/PM8005 regulators. Nothing for touch,
audio, haptics, NFC, fuel gauge, charger, cameras or sensors.

## Not in the tree, therefore not known yet
Which exact camera chips; the touch controller's model number; the codec's exact part (WCD9340 vs 9341);
the sensor chips on walleye itself (XL teardown gives LSM6DSM, AK09915, BMP280, AK8789, TMD4903 - stated for
the XL only); the fingerprint SPI wiring; how Active Edge is sensed; physical debug-UART access; the
overlay used by MP1.
