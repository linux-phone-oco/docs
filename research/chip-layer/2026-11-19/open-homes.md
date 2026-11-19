# Where knowledge of a chip lives in the open, and how one adds to each home

This folder holds the material for research `chip-layer-open-homes`, read on 2026-11-19 by two read-only researchers
and the research lead. It answers the author's question: is there already an open, shared base for per-chip
knowledge that we can add to? The answer holds for any product, not only phones. Pages that could not be read are
marked "not read". The postmarketOS wiki and lore.kernel.org refused automated readers, so they were read through
mirrors (lkml.iu.edu) and search snippets.

## The homes, by what they key on

| Home | Key | What it holds per chip | Who reads it | How one adds to it | Any product? |
|---|---|---|---|---|---|
| Mainline Linux: the driver, the binding (Documentation/devicetree/bindings/*.yaml) and MAINTAINERS | the devicetree compatible | the driver; the binding, a schema `make dt_binding_check` runs; the quirks inside the driver | every distribution, every board vendor, U-Boot (dts/upstream), Zephyr (by convention) | patches by mail to the list `scripts/get_maintainer.pl` names: the binding first, then the driver, then the dts, which goes through the SoC tree; `b4 prep`. The person who sends signs off. The kernel accepts AI-assisted work that a human signs (research giving-back-by-distro) | yes |
| linux-firmware (gitlab.com/kernel-firmware/linux-firmware) | the driver and chip, through WHENCE | blobs whose licence allows them to be redistributed | distributions | a merge request or mail to linux-firmware@kernel.org; the maker must own the licence or take part. A TAS2557 board tuning file cannot go in without TI | yes |
| linux-msm/mainline-status (GitHub) | a Qualcomm SoC or PMIC, then its block | which kernel brought each block up. pm8998.md marks haptics and watchdog N/A | Qualcomm mainliners | a pull request (branch trunk; edit pmic.yaml, run regen.py). Its stance on AI-assisted work is not known yet | Qualcomm only |
| msm8916-mainline/linux-mdss-dsi-panel-driver-generator and linux-panel-drivers | the panel, from the downstream qcom,mdss-dsi DT | a generated DRM panel driver and its config | panel porters | a pull request, then the driver goes by mail to dri-devel. Mainline has s6e3fa7 (the Pixel 3a, generated this way). It has no s6e3fa5 | panels from Qualcomm downstream trees |
| Zephyr, U-Boot, coreboot | compatible (Zephyr, U-Boot); board (coreboot) | MCU and bootloader drivers. Zephyr has drv2605, a tas2563 Kconfig; U-Boot has ufs-qcom, pmic_qcom. Neither has TAS2557 or DRV2624 | MCU and bootloader porters | a pull request (Zephyr), mail (U-Boot), Gerrit (coreboot) | yes |
| LKDDb (cateee.net/lkddb) | compatible, I2C or PCI id, Kconfig | an index generated from each kernel release: which driver and version carry an id | anyone looking up "which driver for this id" | none: it is generated, by one author. It cannot hold a chip that has no driver | yes, drivers only |
| linux-hardware.org (hw-probe) | the probed machine, then PCI and USB ids | works / limited / failed per device, from logs | desktop users | `hw-probe -all -upload`. Coverage of ARM DT platform devices is not known yet (the site was not read: HTTP 429) | mostly PCs |
| KernelCI, LAVA | board, then SoC (compatible chain) | which board boots and runs which test | kernel CI | a pull request to kernelci-pipeline (platforms.yaml), a LAVA lab of one's own | boards, not chips |
| postmarketOS (now Nura) wiki and pmaports | the device, then the SoC | how-to per device and SoC; firmware packages per device; soc-* common packages | phone porters | a wiki account. Nura forbids AI-made contributions: only the author, by his own hand (decision 2026-11-19-nura-relation) | phones and tablets |
| LineageOS device trees | the device, with -common trees and hardware/VENDOR HALs | proprietary-files.txt names each blob, a cheap fingerprint of which chips are fitted (surya's names drv2624.bin, tas25xx) | Android builders | Gerrit | Android devices |
| Asahi docs, linux-sunxi wiki, OpenWrt Table of Hardware, Armbian board/family files | the SoC family, the board | chip and peripheral pages for one family (linux-sunxi: AXP PMICs; Asahi: hw/peripherals) | that family's porters | a pull request or a wiki edit. linux-sunxi and the OpenWrt ToH were not read | one family each |
| WikiDevi and its successors (DeviWiki, TechInfoDepot) | the device, with chip fields | a cross-product chip index for wireless parts | router and Wi-Fi people | wiki edit. WikiDevi closed in 2019; whether its successors are alive is not known yet | wireless only |

## What none of them holds

No open home is keyed by part number for any part, whatever product carries it. In particular, no home holds all of
the following:

- how far a chip's driver has got across all its homes: mainline, in review on the list, in a fork, only in a vendor
  kernel, or nowhere;
- a chip that has no driver yet (the kernel and LKDDb know only chips that have one);
- the boards met carrying a chip, across products;
- where its firmware comes from and whether it may be shipped;
- the quirks a second board must know;
- the procedure and proofs that brought it up.

That gap is what a thin row per part fills. The row links up to each home and never copies one.

## The two first chips, as read

- **TAS2557.** The driver is in review: Gianluca Boiano's v3, 2026-07-17, two patches, `dt-bindings: sound: add Texas
  Instruments TAS2557` and the ASoC driver, at https://lkml.iu.edu/2607.2/04618.html. It was tested on four Xiaomi
  boards: SDM660, SDM636, MSM8953, and one dual-amp board. It needs a board firmware made with TI PurePath Console.
  Mark Brown reviewed v3 on 2026-07-19 (https://lkml.iu.edu/2607.2/06067.html) and asked about the board GPIO
  sequence, a firmware device-count check, the PLL index, and muting at suspend. No v4 was found.
  - Porthole (porthole-dev/pmaports, the 7.2.2 msm8998 kernel package) carries its own driver: patches 0024, 0162,
    0171-0174, by Giuseppe Maggio, marked `Assisted-by: LLM`. It has **no binding patch**. Its taimen dts names
    `ti,tas2557` at 0x4d with reset on pm8998_gpios 5, and the driver drives 0x4c and 0x4d. Its firmware comes from a
    LineageOS vendor mirror.
- **DRV2624.** No driver is in mainline or on the list; the drv260x binding covers 2604/2605/2605l only. Google's
  msm-4.14 kernel carries a downstream driver. Porthole carries patch 0018 (drivers/input/misc/drv2624.c, compatible
  `ti,drv2624`, ID register 0x00 masked 0xf0 = 0x00, properties ti,actuator, ti,rated-voltage, ti,lra-frequency, and
  others), again with **no binding patch**. Its taimen dts has the chip at 0x5a with reset on tlmm 95. Mainline
  qcm6490-shift-otter.dts names a "Ti drv2624 haptics @ 5a" in a comment only: a second product carrying it.
