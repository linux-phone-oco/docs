# Pixel 2 (walleye): the shortest honest path to a mainline `fastboot boot` - research material

Made 2026-11-17 by walleye-research-mainline, from public sources only (GitHub API, kernel.org-mirrored
trees, public wikis). The phone was never touched. Nothing proprietary was read: every file below is GPL
(kernel trees, device-tree sources) or a public description. Where a file is only a copy of what a source
says, the source id of the knowledge base is named.

## 1. What exists (as of 2026-11-17)

| where | what | state |
|---|---|---|
| kernel.org mainline v7.3 (v7.4-rc3 is out) | MSM8998 SoC + boards: mtp, OnePlus 5/5T, Xiaomi Mi 6 (sagit), Sony Yoshino x3, F(x)tec Pro1, HP Envy x2, Asus Novago, Lenovo Miix 630 | **no Google board**: no `msm8998-google-*`; `lore` search finds no submission |
| kcxt/linux-wahoo (`wahoo/5.17`, last push 2022-02-27) | `msm8998-google-wahoo.dtsi` + `-taimen.dts` + `-walleye.dts` on a 5.17 fork of the MSM8998 community tree | `walleye.dts` is 13 lines: model + compatible only (`google,walleye`, `google,wahoo`, `qcom,msm8998`, `qcom,msm8998-mtp`), **no `qcom,msm-id`**, no panel override. Everything real is taimen's (LG SW43402 panel). Old, unmaintained. |
| porthole-dev/pmaports `taimen-bringup` (pushed 2026-10-14) | `linux-postmarketos-qcom-msm8998-7.2`: pristine kernel.org v7.2.2 + 263 numbered patches, `device-google-taimen` package, config, cmdline, a stub dtbo | taimen (Pixel 2 XL) is far ahead: display (cmd mode + DSC), GPU, touch, haptics, audio amps, wifi, modem, sensors, fingerprint, camera, suspend work. **Walleye: patch 0029 only** - a 33-line board file with a battery node; its commit text says "nobody has run this branch on an actual walleye device yet" |
| movq/linux-taimen (v6.15-taimen, 2025-09) | another taimen kernel | not read further |
| pmaports (postmarketOS / Nura) | no walleye package, no taimen package in master (taimen only in the porthole fork) | |

## 2. What the Pixel 2 (walleye) is, from the GPL downstream device-tree sources

Source: kerneltoast/android_kernel_google_wahoo (branch `11.0.0-sultan`, Google's GPL kernel plus patches),
`arch/arm64/boot/dts/htc/` - the Pixel 2 was built by HTC (board family `muskie`/`mw`), the Pixel 2 XL by LG
(`lge/`, taimen). Read, not copied.

| part | walleye | taimen | in mainline v7.3 |
|---|---|---|---|
| panel | Samsung S6E3FA5 5.0" 1080x1920, **DSI command mode**, 4 lanes, TE pin, reset gpio94, cont-splash enabled | LG SW43402 6.0" 1440x2880 cmd mode + DSC | **no S6E3FA5 driver** (only s6e3fa7, s6e3fc2x01, s6e3ha2/ha8); an out-of-tree one exists (Jami Kettunen, in kcxt `wahoo/5.17`, written for OnePlus 5); no SW43402 either (porthole has it, 0019) |
| touch | Synaptics RMI (DSX) on blsp1_i2c5 addr 0x20, irq gpio125, reset gpio89, supplies pm8998 l6 (1.8 V) + l28 (3.3 V); xd boards also a power gpio on pmi8998 | STMicro FTM4 | `rmi_i2c`, `rmi_f01/f11/f12/f1a` are in mainline: the same driver family OnePlus 5 and Mi 6 use on blsp1_i2c5 |
| haptics | TI DRV2624 (reset gpio95) | same | no driver in mainline (porthole 0018) |
| speaker amps | NXP TFA98xx x2 (reset pm8998 gpio6/7) and/or TI TAS2557 | TAS2557 | tfa989x exists in mainline (tfa9890 per kcxt); TAS2557 not |
| keys | power gpio40, vol-up gpio126, vol-down gpio121 | vol-up gpio126; vol-down on PMIC RESIN | gpio-keys |
| NFC / fingerprint | NXP PN81A / FPC1020 | | later |
| USB | TPS61099 boost + PTN36241G redriver, type-C | | `qusb2phy` + dwc3 are in mainline; kcxt and porthole run USB 2.0 peripheral only |
| battery | 2700 mAh, 4.4 V (published cell spec; porthole 0029, unmeasured) | 3520 mAh | `pmi8998_charger` + `rradc` in mainline v7.3 dtsi; the fuel gauge (`qcom_fg`) is out of tree (porthole 0022) |
| storage / Wi-Fi / GPU / SMMU / USB / UFS / pinctrl / DPU / DSI PHY | MSM8998 | same | in `msm8998.dtsi` of v7.3: `qcom,msm8998-ufshc`, `-dwc3`, `-qusb2-phy`, `-mdss`, `-dpu`, `dsi-phy-10nm-8998`, `adreno-540.1`, `wcn3990-wifi`, smmu, `mss-pil`, `adsp-pas` |

Partition map (taimen, from the Nura wiki - walleye is expected the same, **not measured**): UFS; `boot_a/_b`,
`dtbo_a/_b`, `vbmeta_a/_b`, `abl_a/_b`, `xbl_a/_b`, `modem_a/_b`, `vendor_a/_b`, `system_a/_b`, `userdata`,
`persist`, `pstore`; A/B.

## 3. Boot image facts (observed by porthole against the stock taimen boot.img, RP1A.201005.004.a1)

`deviceinfo` of device-google-taimen: header version **0**, base 0x0, kernel offset 0x8000, ramdisk offset
0x1000000, second 0x00f00000, tags 0x100, page size 4096, **dtb appended to the kernel** (`append_dtb`),
dtbo flashed to the `dtbo` partition. Walleye shares the SoC and bootloader family; its own boot.img header
was **not read** (needs the phone's stock boot.img - the keeper's android-reference, read-only).

cmdline used by porthole (`kernel-cmdline.mainline.conf`): `clk_ignore_unused ignore_loglevel panic=10
earlycon=msm_serial_dm,0xc1b0000 qcom_wdt.arm_on_probe=1 watchdog.open_timeout=300 reboot=w`; kcxt adds
`console=ttyGS0,115200 console=ttyMSM1,115200`. `clk_ignore_unused` is needed or the board dies early (Nura
wiki, taimen).

**Do not put `bootargs` in the DTS**: the bootloader (ABL) appends the boot.img cmdline with
`fdt_appendprop_string()`; a bootargs already in the DTS makes the kernel see only the DTS half (porthole
0027 comment). kcxt's old dtsi does put `bootargs` there - not to be copied.

**dtbo**: porthole needs a stub DTBO entry with id 2704 ("the bootloader needs entry 2704; the mainline DTB
needs its empty stub"); "the stock overlay does not match the mainline kernel" and they flash `dtbo_b` and
`boot_b` (slot b only, never activate slot a). Whether `fastboot boot` also applies the *stock* dtbo of the
active slot to a mainline DTB is **not known**: nobody's report says. The DTB itself must carry
`qcom,msm-id = <0x124 0x20001>` (taimen has it; the OnePlus 5 comment says the bootloader needs it "to select
correct board"); kcxt's walleye lacks it.

`fastboot boot` itself works on unlocked walleye: TWRP's own instructions use `fastboot boot
twrp-...-walleye.img` (xdaforums TWRP thread). Verified boot on an unlocked Pixel: orange-state warning, not
a refusal - **not tested on this phone**.

## 4. Reaching the phone without a display

- USB gadget: `usb3` + `qusb2phy` + `usb3_dwc3` with `dr_mode = "peripheral"`, `maximum-speed =
  "high-speed"`, the SuperSpeed PHY dropped, `qcom,select-utmi-as-pipe-clk`, `assigned-clock-rates =
  <19200000>, <60000000>` (kcxt/porthole wahoo.dtsi: "doesn't seem to work when superspeed mode is
  enabled"). Nura wiki: "USB networking is enough to get to a shell" on taimen. postmarketOS's initramfs
  gives telnet at 172.16.42.1, which is what `device.toml` already expects.
- pstore/ramoops: reserved at 0xa1810000 (0x200000) in the wahoo dtsi - the address the stock system uses;
  after a crash, a *cold* reboot scrambles it (kcxt froze a phone to read it); `qcom_wdt.arm_on_probe=1`,
  `reboot=w` and a watchdog open timeout are porthole's way to a warm reset.
- UART: BLSP2 UART1 at 0xc1b0000 (earlycon); reachable through Google's "Android Debug Cable" (Nura wiki
  schematics) - needs a cable that is not in the lab yet.
- Display cannot be the first sign of life: the Pixel 2 panel is command-mode, so there is no scanned-out
  bootloader framebuffer for `simple-framebuffer` (porthole's reasoning for taimen, same for walleye's
  command-mode S6E3FA5; the mainline OnePlus/Sony/Mi 6 boards use a simple-framebuffer at 0x9d400000 with
  video-mode panels - the 0x9d400000 splash region is the Qualcomm default; walleye's is **not known**).

## 5. Reading of the path

1. Mainline v7.3 does not boot a Google board yet; the shortest first boot is **not** adopting porthole's 263
   patches (taimen-focused, large, one untested walleye board) - it is a new tiny `msm8998-google-walleye.dts`
   written from the GPL wahoo dtsi (kcxt/porthole, authors Caleb Connolly, Giuseppe Maggio) trimmed to what a
   USB-reachable initramfs needs: memory carve-outs, pm8998/pm8005/pmi8998 regulators, `qusb2phy`, dwc3
   peripheral, ramoops, UART; UFS, display, GPU, Wi-Fi, remoteprocs all `disabled` (no firmware at hand, nothing
   written to storage), plus `qcom,msm-id`.
2. Fall back to porthole's pinned v7.2.2 where something in v7.3 breaks; take porthole patches one by one only
   when a part needs them (display: 0019/0047..., touch: none, charger: 0022).
3. Then `fastboot boot` (devlab's `fastboot boot now BOOT.IMG`), one try; success is the phone leaving
   fastboot and the host seeing its USB gadget.

## 6. Not known

walleye's own boot.img header and cmdline; whether ABL applies the stock dtbo to a booted-in-memory mainline
DTB; whether `fastboot boot` accepts a dtb-appended v0 image with our offsets here; the bootloader
version and max-download-size; walleye's splash/framebuffer address; walleye's real audio amps; the touch
quirks (xa vs xd boards); whether the mainline USB path works on this phone at all (taimen only).

## 7. Sources read

kcxt/linux-wahoo (wahoo/5.17 dts, commit list); porthole-dev/pmaports taimen-bringup (device-google-taimen
deviceinfo, kernel APKBUILD and patches 0027/0028/0029, IMAGE-INSTALL.md); Nura wiki Pixel 2 XL page;
torvalds/linux v7.3 trees (arch/arm64/boot/dts/qcom, drivers/gpu/drm/panel, drivers/input, drivers/power/
supply); kerneltoast/android_kernel_google_wahoo (htc/ and lge/ device-tree sources, GPL); xdaforums TWRP for
Pixel 2; android.googlesource.com kernel/msm refs (wahoo branches exist; its dts tree holds only the SoC files,
the boards live in the dtbo).

## 8. Corrections after the keeper's getvar and the vendor-kernel research (same day)

Read after this file was first written: `research/google-walleye/2026-11-17/` (the keeper's read-only
`getvar all`, how others booted, the vendor-kernel hardware inventory - research rows
google-walleye-bootloader-first-look, -how-others-booted, -vendor-kernel-hardware). They correct and
settle this file in four places:
- Speaker amp is the TI TAS2557 as on taimen (TFA98xx is in the vendor tree but disabled, an older
  revision); the panel needs no LAB/IBB and no WLED (DCS backlight), rails PM8998 L14 / L22 - taimen's
  panel rails do not carry over.
- Offsets: LineageOS's wahoo config says tags 0x01E00000 / ramdisk 0x02000000, porthole verified 0x100 /
  0x1000000 against the stock taimen image - walleye's own header decides.
- Known now: bootloader mw8998-003.0085.00, hw-revision MP1, boot partition 32 MiB, max-download-size
  0x20000000, unlocked, `kernel:uefi`, no fastbootd.
- `fastboot boot`: TWRP's instructions use it for walleye, one report could not boot TWRP that way, and no
  source shows a mainline kernel booted from RAM on a Pixel 2 - not known, so the first try is the test.
