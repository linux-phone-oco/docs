# WLAN unloaded: cxsd, aosd and ddr still 0 - floor-wlan-off (keeper surya-keeper-9, 2026-11-17)

One change on the kept kernel and kept device tree (after the one-shot no-DSP try fell back with a reboot):
`rmmod ath10k_snoc ath10k_core` (no ath10k module left: `lsmod | grep -c ^ath10k` = 0, wlan0 gone), then
`way-back.sh cycle 15 bt-on` from a transient unit. Real s2idle (suspend entry ... exit, asleep 17 s by the RTC for 15
asked), hci0 back.

Measured: cxsd 0 -> 0, aosd 0 -> 0, ddr 0 -> 0 (adsp 0 -> 0; cdsp 60 -> 60; modem 763 -> 763+ moving). Not run
this boot: the soc-sleeps check itself (its verdict on the same counters is fail: cxsd and aosd 0).

Reading: WLAN is not the holder (the decision's guess from SDM845 does not apply here). With the DSPs absent
(floor-dsps-never-started) and WLAN absent the counters are still 0; next subtractions: the USB controller
(`devlab-usb` wake lock), the SH0 x=1,y=3 owner, the aoss prevent_* knobs; the late-suspend state stays
not known yet (floor-suspend-late-dump).
