# qcom_aoss prevent_* knobs: the AOP does not answer - floor-aoss-knobs (keeper surya-keeper-9, 2026-11-17)

Kept kernel, kept device tree, fresh boot (after the author's hard reboot). Before `way-back.sh cycle 15 bt-on`:
`echo 0 > /sys/kernel/debug/qcom_aoss/{prevent_aoss_sleep,prevent_cx_collapse,prevent_ddr_collapse}`.

Result: the writes to **prevent_cx_collapse and prevent_ddr_collapse failed with "Operation timed out"** (rc 1;
the prevent_aoss_sleep write line was cut from the read, not known yet), and the kernel logged, repeatedly,
`qcom_aoss_qmp c300000.power-management: ucore did not ack channel`. The cycle then ran as usual (real s2idle,
hci0 back): cxsd 0 -> 0, aosd 0 -> 0, ddr 0 -> 0 (adsp 0, cdsp 49).

Reading: the knobs settle nothing, because **the kernel's QMP link to the AOP does not work**: the AOP's ucore
never acknowledges the mailbox channel. So any "release" message to the AOP is dropped, and a firmware-left
request cannot be cleared this way. This is new evidence about the floor, not a result of the knob: until the QMP
channel acks, aosd (the AOP's own sleep) is not under the kernel's control and its counter may sit at 0 for that
reason. Next (not started): why the ucore does not ack - what the channel's mailbox/ring address and the
AOP message RAM show on this firmware (read only), compared with sm8150/sc7180; the sleep-set flush of rpmh is a
different path (apps_rsc) and is not affected by this.
