# USB controller unbound: cxsd, aosd and ddr still 0 - floor-udc-unbound (keeper surya-keeper-9, 2026-11-17)

On the kept kernel and kept device tree, WLAN unloaded (previous item's state): `way-back.sh fuse 30`, then
`a6f8800.usb` unbound from `dwc3-qcom-legacy` (gadget off, the usb30 gdsc and its icc vote released), then
`way-back.sh cycle 15 bt-on` (real s2idle, asleep 17 s by the RTC, hci0 back), then bound again (rc 0).

Measured: cxsd 0 -> 0, aosd 0 -> 0, ddr 0 -> 0 (adsp 0, cdsp 60 -> 60, modem 763 -> 764). The USB controller is not
the holder. The soc-sleeps check was not run on this boot (it is the same counters: not passing).

What went wrong, kept as a lesson: the bind did not bring the gadget back (no usb interface on the host), the cycle
had defused the watchdog on return, and WLAN was still unloaded, so the phone had no link and nothing reset it:
the author held power. The result survived in /var/tmp/k9u.out and was read after the reboot (phone healthy:
35 pass, 0 fail). Rule: a step that can drop the only link keeps the watchdog armed (fuse) and is followed by a
reboot, never by a rebind that is hoped to re-enumerate.
