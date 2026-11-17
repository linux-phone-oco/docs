# The two fastboot boot tries again, on slot b (2026-11-17, 18:07)

The same images as the first tries (boot-a.img and boot-b.img from the builder's first build, checksums in `../2026-11-17/image-sha256sums.txt`), now with slot b active as the decision walleye-slot-flags-tries-on-b says, and devlab's new before/after slot report. Files: `try-a-devlab.txt`, `try-b-devlab.txt` (devlab's whole report, fastboot's words included), `getvar-before.txt` (all bootloader variables before the tries, IMEI left out), `host-watch.txt` (host USB, every 5 s), `host-kernel-log.txt`.

## Before (both tries)
current-slot b; slot a: unbootable yes, successful yes, retry-count 0; slot b: unbootable no, successful yes, retry-count 0.

## Try a - boot-a.img
fastboot: `Sending 'boot.img' (15868 KB) OKAY [0.378s]`, `Booting OKAY [0.052s]`, finished in 0.436 s. The bootloader accepted the boot command; the phone stayed in fastboot (the host saw no USB event for 60 s), nothing answered. Slot flags after: unchanged.

## Try b - boot-b.img
fastboot: `Sending 'boot.img' (15868 KB) OKAY [0.377s]`, then `Booting FAILED (remote: 'Failed to load/authenticate boot image: Load Error')`. A refusal by the bootloader, in words. The phone stayed in fastboot. Slot flags after: unchanged. No set-active was needed (b current and bootable throughout).
The first try b on 2026-11-17 17:37 ended differently (`Status read failed (No such device)`, then Android on slot b, slot a flagged unbootable). Same image file, different answer: what differed is not known yet (that time slot a was current; the flip happened then).

## What it says
- The bootloader reads boot-a.img (taimen offset set) as a boot image and says OKAY but does not start it; boot-b.img (LineageOS offset set) it rejects with Load Error, when slot b is the active one.
- Neither try started our kernel as far as anything observable shows: no USB re-enumeration, no gadget, no serial port. Why boot-a is accepted and then not run is not known yet; the bootloader gives no more words.
- On the active slot b a refusal did not flag anything: both tries left the flags as they were.
- The other Google device on the host (Qualcomm SM7150, a different phone) re-enumerated at 18:09:27/44; not walleye.

## Not known yet
- Whether header fields (os_version and patch level are 0 in our images; a boot image the bootloader accepts and then does not start may be rejected by its later checks) or the missing dtbo explain boot-a; decision walleye-slot-flags-tries-on-b names a stub dtbo only as the author's decision.
- Anything about our kernel itself.
