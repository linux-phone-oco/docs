
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
