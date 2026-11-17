# The first two `fastboot boot` tries on the Pixel 2 (walleye), 2026-11-17

What the phone did when `devlab fastboot boot now` gave it the builder's first images (boot-a.img: taimen offset set; boot-b.img: LineageOS offset set; the kernel in both is our 7.3.0 build, checksums in `image-sha256sums.txt`). Nothing was flashed, erased or set by any command of ours. Files: `try-a-devlab.txt`, `try-b-devlab.txt` (devlab's own report), `host-observed.txt` (the host's USB events and a watch), `getvar-after-try-b.txt` (bootloader variables after the tries).

## Try a - boot-a.img, 17:35:14
- fastboot sent it; devlab: "took boot-a.img but the phone is still in fastboot after a minute ... it did not start".
- The host saw no USB disconnect or reconnect for 60 s; no serial port, no new network interface.
- Not measured: the bootloader's own message (devlab prints only its summary); the slot flags straight after this try (read after try b only).

## Try b - boot-b.img, 17:37:34
- fastboot sent the image (15868 KB in 0.377 s, OKAY), then "Booting: FAILED (Status read failed (No such device))": the phone left USB the moment it was told to boot. devlab called this "refused"; the host's kernel log shows what really happened, a USB disconnect at 17:37:35.
- 20 s later (17:37:55) the phone appeared on USB as Google 18d1:4ee7 "Pixel 2", with one adb interface: Android's own adb gadget, not ours.
- adb then showed Android again: LineageOS 15 userdebug, kernel 4.4.302 built 2025-11-28 (not 2025-12-05 as on slot a), `ro.boot.slot_suffix=_b`, boot reason "reboot,ota" - i.e. Android on slot **b**, a different build than the one measured on slot a an hour before.
- Nothing of ours answered: no ACM serial port, no RNDIS/ECM interface, 172.16.42.1 gave no reply (ping, 100 % loss), /sys/fs/pstore empty after Android came up.
- Whether our kernel ran at all is **not known yet**: no output reached the host, and the bootloader said nothing.

## The slot state changed (measured)
After try b the bootloader reports **current-slot b** and **slot a unbootable = yes** (before: current-slot a, slot a unbootable no, in the first look of the same day). slot-successful stays yes for both, retry-counts 0. Every other variable is the same (diff in the row). No write command was sent: the bootloader's own A/B logic did this, apparently treating the failed boot of the image as a failed boot of slot a and moving to b. That is an inference from the order of events; why exactly is not known yet. It was not checked after try a whether the flags changed already there.
Slot a's Android (the 2025-12-05 build measured earlier) is presumably untouched; only its flag changed. Putting the flags back needs `fastboot set_active a` (or Android's boot control), which is a write and needs a recorded decision and the author's word - not done.

## What it means for the next tries
Each `fastboot boot` that fails to start may flip the slot and leave the phone in Android on the other slot; devlab reports this as "refused". So a try is not free: before another, decide about the slot flags, and devlab should read the slot variables before and after and say so.
After the tries the keeper returned the phone to fastboot with `adb reboot bootloader` (adb was authorized; Android was running on slot b).

## Not known yet
- Whether the kernel started and died, or was never started (the first 20 s after the disconnect are unobserved); what a serial console or a pstore from our kernel would show.
- Whether try a changed the flags.
