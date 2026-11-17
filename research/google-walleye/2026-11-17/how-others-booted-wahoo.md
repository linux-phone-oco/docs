# How others booted Linux on the Pixel 2 family, and reached it with no display (2026-11-17)

Read from public pages only; nothing touched on any phone. Collected by a read-only researcher, with the two
decisive pages (the dtbo README and the debug-cable page) read again by hand. Facts in our words; each has its
source id (sources table). Where a claim is an inference it says so.

## Who booted what
| effort | what is reported | source |
|---|---|---|
| postmarketOS / kcxt (Caleb Connolly), Pixel 2 XL (taimen), 2020 to 2022 | mainline-based kernel (5.10 to 5.17), out of tree; wiki: "boots but no display output", USB networking works, flashing works, screen and battery no; "USB networking is enough to get to a shell"; not packaged in pmaports; maintainer edit 2026-09-05 | pixel2xl-pmos-wiki, kcxt-linux-wahoo |
| the same fork for the Pixel 2 (walleye) | a device-tree file exists on branch wahoo/5.17; **no one reports that walleye boots** | kcxt-wahoo-5-17-dts |
| mainline submission for taimen, March 2021 | patch "add support for the Pixel 2 XL" posted; commit text: boots with USB networking, panel needs DSC; reviewer called `clk_ignore_unused` "a big hack"; Wi-Fi firmware crashes about every 10 s unless Bjorn Andersson's diag-router runs; no sign it was merged; mainline has Pixel 3/3a boards (sdm845-google-blueline/crosshatch, sdm670-google-sargo/bonito) but no msm8998 Google board | lkml-taimen-dts-patch-2021 |
| Ubuntu Touch / Halium 9 (Android 9, vendor kernel 4.4) for walleye | only the 16.04 (xenial) port, maintainer Flohack74, state abandoned (last commit 2022-09); needs Android 9 factory image PQ3A.190801.002 first; forum reports: boot loops, "Slot Unbootable: Load Error", no USB networking after flashing halium-boot; one 2021 report of a working install not confirmed in the threads read. A September 2026 post claims Ubuntu 24.04 on a Pixel 2 XL "with fixes" (screenshot only) | ubuntu-touch-walleye, ubports-walleye-forum |
| LineageOS 22.2 (Android 15, kernel 4.4) | the phone is alive on Android; install needs the latest Android 11 firmware first; recovery lives in the boot partition | lineageos-walleye-install |
| pmaports for other Google phones | Pixel 3a (sargo/bonito), 3 (blueline), 3 XL (crosshatch) are packaged; none for walleye or taimen | pmaports-google-devices |

## How a no-display phone was reached
1. **USB device mode with a serial or network function** (the route that worked for taimen): the device tree
   forces the USB controller to peripheral mode, drops the SuperSpeed PHY (high speed only), uses the USB 2
   PHY, and the kernel command line carries `console=ttyGS0,115200` next to an early UART console on
   `ttyMSM1`, with `clk_ignore_unused` and `earlycon=msm_serial_dm keep_bootcon`. A USB network (RNDIS-like) link
   then gives a shell. (kcxt-wahoo-5-17-dts, pixel2xl-pmos-wiki)
2. **UART through the USB-C connector.** The pmOS wiki's "Android Debug Cable" (USB-C sideband pins at 115200
   baud, 1.8 V logic via a 3.3 V adapter and the howto's design; Google's open design is `usb-cereal`) is listed
   as tested with **both Pixel 2 (walleye) and Pixel 2 XL**. Enabling it is `fastboot oem uart enable` (the
   page says bootloader and dmesg logs then come over that UART). A Suzy-Q cable is the wrong cable.
   (pmos-wiki-serial-cable, android-debug-cable-howto) **Not known yet:** whether that oem command only sets a
   RAM flag or writes something persistent on this bootloader - until that is known, it is a change to the
   phone and under the "nothing may be written" rule.
3. **RAM console (pstore/ramoops)**: tried by kcxt with several carve-outs; the wiki says the log only
   survived a reset partly and corrupt (RAM lost power on cold reboot) and recommends a serial cable instead.
   The stock userspace has a script that sets an "alt" ramoops region - hence the alternate carve-out in the
   vendor tree (inference).
4. **Halium initrd debug**: telnet on 192.168.2.15 over USB when the Android-kernel boot fails; the host takes
   192.168.2.1; `fastboot boot halium-boot.img -c break=LEVEL` stops the initrd at a chosen stage. Useless if
   the kernel never starts. (halium-usbnet-debug)

## What the bootloader wants (taimen, read; walleye unknown)
- **dtbo partition**: the XL's bootloader "refuses to boot" a kernel unless the dtbo partition holds an overlay
  with id **2704 (0xa90)**; the stock command line has `androidboot.dtbo_idx=12`; a minimal replacement dtbo
  was built with dtc and mkdtboimg (recipe from the Pixel 3 XL's equivalent). The README is about the **Pixel 2 XL
  only**; whether walleye needs the same id, another id, or none is **not known yet**, and replacing the dtbo
  means writing the phone. (kcxt-dtbo-wahoo-mainline)
- **Image form**: pmaports' Pixel 3/3a packages append the dtb to the kernel, build the boot image with 4096-byte
  pages, kernel offset 0x8000, ramdisk offset 0x1000000, tags 0x100, flash with fastboot (sparse), and ship a
  separate dtbo package for mainline on the Pixel 3 family. LineageOS' wahoo board config: `Image.lz4-dtb` (dtb
  appended), base 0, page 4096, tags offset 0x01E00000, ramdisk 0x02000000, 8 MB dtbo partition, recovery in the
  boot partition, A/B. No source sets a boot-header version. (pmaports-google-devices, lineageos-kernel-google-wahoo)
- **`fastboot boot` on this family**: no source states that a custom kernel boots from RAM on a Pixel 2; the one
  nearby report is a user who could not boot TWRP that way. **Not known yet.** Pixel 3 pages flash instead.
- A/B: the LineageOS install page has no `set_active` step; the pmOS pages give no slot handling. Not known yet.
- Verizon-branded units cannot be unlocked; ours is unlocked (bootloader first look).

## Not found
Pixel 2 (small) mainline boot report; header version; any `fastboot boot` success; pmaports MR or issue
history (the host rate-limited the search); lore.kernel.org itself (bot check; the same thread was read through
lkml.iu.edu).
