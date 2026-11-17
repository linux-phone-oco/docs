# The fastboot boot tries of boot-c.img and boot-d.img (2026-11-17, 18:25 to 18:29)

The builder's two header variants (os_version 8.1.0, patch level 2020-01; `image-differences.txt`: c = boot-a with that header word only, d = boot-b with it), tried one at a time on slot b through `devlab fastboot boot now`, under decision walleye-slot-flags-tries-on-b. The host was watched each time: `lsusb` every second for 90 s (`usb-poll-c.txt`, `usb-poll-d.txt`: one line per second, root hubs left out) and the host kernel log with microsecond stamps (empty both times). devlab's whole report with fastboot's words: `try-c-devlab.txt`, `try-d-devlab.txt`; all bootloader variables before each try: `getvar-before-c.txt`, `getvar-before-d.txt` (IMEI left out). Nothing was written.

## Both: refused, same words
fastboot: `Sending 'boot.img' (15868 KB) OKAY [0.368s]`, then `Booting FAILED (remote: 'Failed to load/authenticate boot image: Load Error')`. The refusal came within the fastboot call itself (devlab's report starts 18:25:58 and 18:27:37, each took its full minute of watching, the refusal was at the end of the transfer, under one second). The phone never left fastboot: 18d1:4ee0 was present in every one of the 90 one-second polls after each try; no USB re-enumeration, no new vendor and product id (no Linux gadget 1d6b, no serial port), no line in the host kernel log.
Slot flags before and after both tries: current b; a unbootable yes, successful yes, retry 0; b unbootable no, successful yes, retry 0. Unchanged. No set-active.

## What it says
- Setting the header's os_version and patch level did not help: the bootloader rejects both. And it made boot-a, which got `Booting OKAY` without starting, into a Load Error (c is a plus only that word). So with this header word, a is refused like b.
- All four images are now seen refused or not started by the bootloader itself, in words or silence; none started our kernel. Why the bootloader rejects them (image size 15.9 MB against the 32 MiB boot partition limit is fine; a missing dtbo, the kernel's format, or the header's other fields) is not known yet; the bootloader says only "Load Error".
- The "left fastboot, Android back" ending of the very first try b has not come back in four tries on slot b.

## Not known yet
Which part of the image the loader refuses (header, kernel, dtb, ramdisk); how long the bootloader works before refusing beyond "within the call"; whether a Pixel 2 bootloader accepts an unsigned boot image on an unlocked phone with a 7.x kernel without a dtbo - a dtbo stub is a write and stays the author's decision.
