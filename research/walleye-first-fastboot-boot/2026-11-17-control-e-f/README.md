# Control try and variants e, f by fastboot boot (2026-11-17, 18:49 to 18:57)

Under decisions walleye-slot-flags-tries-on-b and walleye-boot-tries-standing-go, one at a time on slot b through `devlab fastboot boot now`, host USB polled every second for 90 s (`usb-poll-*.txt`, only the phone's line matters; the 18d1:d001 device is the other phone on the host, surya). devlab's whole report: `try-control-devlab.txt`, `try-e-devlab.txt`, `try-f-devlab.txt`; bootloader state before: `state-before-control.txt`, `getvar-before-e.txt`, `getvar-before-f.txt`. Nothing was written, nothing flashed.

| Image | sha256 | Answer |
|---|---|---|
| control: LineageOS 22.2 20261113 walleye boot.img (32 MiB, stock format) | 48dbc55c...7468 | Load Error |
| boot-e.img (a with only the command line changed) | 112ab284...a2da | Load Error |
| boot-f.img (e plus qcom,board-id in the dts) | 7a42e5bd...461a | Load Error |

Slot flags before and after each: current b; a unbootable yes, successful yes, retry 0; b unbootable no, successful yes, retry 0. Unchanged; no set-active. Phone left in fastboot, slot b good.

## What it says
- A real walleye image in the stock format is refused with the same words as ours. So the refusal is not (only) about our image: the bootloader's state, or something a fastboot boot needs that is not there (the dtbo, vbmeta), is the cause. Decision 2026-11-17-walleye-load-error-control-first says what follows: not our header, kernel or dts.
- e and f changed the command line and the board-id: both refused like a-d.

## Not known yet
Which of the phone's states the bootloader checks: the dtbo slot content, the slot a flags (unbootable), the first slot-flip's effects. A dtbo stub is a write and stays the author's word; so does restoring slot a's flags. Both go to the walleye coordinator.
