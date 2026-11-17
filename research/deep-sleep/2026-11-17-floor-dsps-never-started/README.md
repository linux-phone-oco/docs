# DSPs never started: cxsd, aosd and ddr still 0 - floor-dsps-never-started (keeper surya-keeper-9, 2026-11-17)

One change: the kept kernel (7.1.0-sm7150-calls+) with the kept device tree copied and `status = "disabled"` set
on `/soc@0/remoteproc@62400000` (adsp), `@8300000` (cdsp), `@4080000` (modem) with `fdtput`; booted once with
`devlab kernel try calls --dtb nodsp.dtb` (it falls back by itself). A device-tree disable, not
`module_blacklist=qcom_q6v5_pas` as the item says: devlab's try takes a dtb and no cmdline, and both mean the same
here - no DSP is ever started, so none can have latched RPMh votes. The remoteproc nodes read `disabled` in
/proc/device-tree after boot; adsp, cdsp, modem do not exist in qcom_stats.

Health on that boot (expected to fail where a DSP is needed): 15 of 41 failing (rmtfs, adsp/cdsp/modem running,
sound card ...), `no-processor-crashes` pass.

Measured: `way-back.sh cycle 15 bt-on` (real s2idle, suspend entry ... exit, asleep 17 s by the RTC; hci0 back):
cxsd 0 -> 0, aosd 0 -> 0, ddr 0 -> 0. `soc-sleeps` fails: "suspended, yet the SoC never reached its lowest state:
cxsd 0, aosd 0; suspends this boot: 1; processors never asleep: none; wake locks: devlab-usb".

Reading: **no DSP vote is the holder** - hypothesis 1 (a DSP's latched RPMh vote) is retired for good, and the ADSP
question with it (decision adsp-is-not-the-floor now rests on never-started DSPs too). The holder is on the
application side; what is left to subtract is WLAN, the USB controller (the `devlab-usb` wake lock was active
through the boot), the SH0 x=1,y=3 owner and the aoss knobs (floor-wlan-off, floor-udc-unbound, floor-sh0-owner,
floor-aoss-knobs). Not known yet: whether the late-suspend state differs from the pre-suspend one
(floor-suspend-late-dump).
