# walleye-board-dts: the Google Pixel 2 board file (draft v0, not sent)

Two patches on v7.3, made by the walleye lane on 2026-11-19 and copied here unchanged on 2026-11-20
from google-walleye-lab research/walleye-first-fastboot-boot/2026-11-19-upstream-dts/ (research
walleye-upstream-dts-series):
1. dt-bindings: arm: qcom: Add Google Pixel 2: `google,walleye` in the msm8998 enum.
2. arm64: dts: qcom: msm8998: Add Google Pixel 2 (walleye): a minimal board file with reserved
   memory, the USB 2.0 PHY's RPM regulators, USB as a high-speed gadget, ramoops and the debug UART.
   UFS is off, the APSS watchdog is dropped, and adreno_smmu stays disabled.

Checked (walleye, on v7.3): dt_binding_check clean, W=1 dtbs, dt-check-style relaxed clean, strict down
from 76 findings to 2, checkpatch 0 errors apart from the sign-off.

Booted: once, the exact dtb, to the usb0 network shell (google-walleye-lab research
walleye-upstream-dts-tried-boots, 2026-11-19). The cover letter here still says "this exact file has
not booted yet". That is stale, and gets fixed in the next version.

Next version: walleye's item walleye-upstream-board-dts-next. It adds touch, haptics, the display chain
and the splash region (walleye-display-splash-region-dts), and the PMIC watchdog node once
pmic-wdt-gen2-v1 is in. Each node is its own patch, with the binding first. The panel driver
(samsung,s6e3fa5) is a separate series to dri-devel: walleye-upstream-panel-series.

Open before sending: the author's authorship and sign-off, the provenance of the carve-out and
ramoops, the fresh cover letter, and the author's go. Nothing is sent from here.
