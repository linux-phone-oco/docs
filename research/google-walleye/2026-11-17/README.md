# What the Pixel 2 (walleye) bootloader says, read-only (2026-11-17)

Taken by the walleye keeper with plain `fastboot -s FA81N1A00790 getvar all` (stderr kept; fastboot 37.0.0p1).
Nothing was flashed, booted, erased or set; the phone stayed in fastboot. Files here:

- `getvar-all.txt` - the full output. One line is changed: the IMEI is replaced by a note (a device identifier, not kept in the repository).
- `getvar-probes.txt` - seven single-variable reads that answered "not found", kept so nobody asks again.

## What the bootloader says (measured)
| variable | value |
|---|---|
| product / hw-revision / mid | walleye / MP1 / G011A |
| boot-mode / kernel | FASTBOOT / uefi |
| unlocked / secure | yes / yes |
| slot-count / current-slot | 2 / a |
| slot a: successful / unbootable / retry-count | yes / no / 0 |
| slot b: successful / unbootable / retry-count | yes / no / 0 |
| version-bootloader | mw8998-003.0085.00 |
| version-baseband | g8998-00034-2006052136 |
| version-main | 1.02.0.100 |
| max-download-size | 0x20000000 (512 MiB) |
| avb_version / avb_user_settable_key_set | 1.0.0 / yes |
| avb_stored_rollback_indexes | (empty) |
| battery | 4344 mV, soc-ok yes |
| logical-block-size / erase-block-size | 0x1000 / 0x1000000 |
| has-slot | boot, system, vendor, vbmeta, dtbo, modem, radio, bootloader |

Partitions the bootloader lists with a size (all it lists):
| partition | type | size |
|---|---|---|
| boot_a, boot_b | raw | 0x2000000 (32 MiB) each |
| system_a, system_b | ext4 | 0xA0000000 (2560 MiB) each |
| vendor_a, vendor_b | ext4 | 0x1F400000 (500 MiB) each |
| userdata | ext4 | 0xD49BFB000 (54427 MiB, about 53 GiB) |

## What it suggests (inference, not measured)
- Android has booted on both slots at some time: both slots say successful=yes, unbootable=no, retry-count 0.
  That is the state Android's boot control leaves after a good boot; a freshly erased slot would not say it.
  It does not say *which* Android (stock, LineageOS, other) or whether it still starts: the flags are written
  once and never re-checked by the bootloader.
- system/vendor/userdata report type ext4 and the usual A/B sizes, so the partition table is the stock A/B
  layout. `partition-type` comes from the bootloader's own table; it does not prove a filesystem is on the partition.
- userdata of about 53 GiB fits the 64 GB model (the 128 GB model would show more); an inference from size only.
- The baseband string ends in 2006052136; read as YYMMDDHHMM that is 2020-06-05 21:36 (inference from the format),
  so the radio firmware is from the last years of stock updates.
- The bootloader is the older kind: no `is-userspace`, no `slot-suffixes`, no `snapshot-update-status`, no sizes
  for vbmeta/dtbo/modem - so no fastbootd (userspace fastboot) and no dynamic partitions to look at.
  `fastboot boot` of a kernel image is what this bootloader offers; whether it accepts a mainline kernel
  (Android boot image v1 header, appended or separate dtb) is not known yet.

## Not known yet
- Which Android is on it, its version and patch level, whether it boots, whether userdata holds the author's data.
- Whether `fastboot boot` works with a kernel built by us, and what the phone does afterwards (USB networking, screen, serial).
- Sleep current, audio levels, sensors, boot time of Android: the reference measurements (backlog google-walleye-lab/android-reference-walleye).
- Partition table beyond the eight lines above (no `fastboot` command lists it; it would come from a booted system, `/dev/block` and `sgdisk`).

## What the author must do for the Android reference (one paragraph)
To measure Android on the phone, the author must press power once to boot slot a normally (hands on the phone:
unlock the screen, and say yes if Android asks to trust the USB cable), then turn on Developer options and USB
debugging, and plug the phone to the lab machine over USB; he should say when the phone is at the home screen with
the battery above 60 %. The keeper then reads, through `adb` read-only commands only: `getprop` (build, patch level,
slot), `dumpsys battery` and the sleep current (after the screen off, a quiet 10 minutes, battery stats), `cat
/proc/asound/cards` and audio levels with a quiet tone (never full scale), `dumpsys sensorservice`, the boot time
(`getprop` boot-completed time from `adb logcat -b events` / `bootstat`), and the partition table. Afterwards
the phone is rebooted into the bootloader and left as it was; slots stay untouched. Needs his go before it starts.
