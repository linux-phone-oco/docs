# Why the PMIC watchdog bite powered walleye off: the S2 reset type

Research pmic-wdt-reset-type (upstreams lane, 2026-11-18). Asked after walleye's z9 bite powered off
(google-walleye-lab PR 236, decision 2026-11-18-walleye-no-pmic-bite-until-reset-type). No PON register
was read on the phone, so the cause is not known yet; ranked by evidence.

## Likely causes

1. The probe wrote S2_CTL (PON +0x56) = 0x07 while S2 may have been enabled, with no disable, no wait
   and no read-back. Every Qualcomm path for an S2 reset disables it first, waits about ten 32 kHz
   sleep-clock cycles, writes the type, then re-enables: qpnp-power-on.c qpnp_pon_reset_config and
   qpnp_config_reset downstream; pm8941-pwrkey.c pm8941_reboot_notify in mainline. On msm8998 the
   firmware arms the PMIC watchdog: wahoo's msm-poweroff.c disables it before download mode. A dropped
   write would leave the firmware's type in place, possibly SHUTDOWN (0x04).
2. The PMIC did reset, but the boot chain (XBL/ABL) chose power-off for a PMIC_WD power-on. Not ruled
   out without a witness.
3. 0x07 is the wrong type for the platform. 8998 uses DVDD_HARD_RESET 0x08 for KPDPWR+RESIN, but 0x07
   for PS_HOLD: weaker.

Ruled out: another register (downstream QPNP_PON_WD_RST_S2_CTL is +0x56 and CTL2 is +0x57 for every
PON generation); a SEC_ACCESS unlock (needed only for S3_DBC_CTL 0x75); a different gen2 type
encoding (WARM 0x01, SHUTDOWN 0x04, DVDD_SHUTDOWN 0x05, HARD 0x07, DVDD_HARD 0x08 on both
generations).

## Done with it

Patch 5/5 on grenudi/linux topic/pmic-wdt-wake-in-suspend, f5bb57d27:
- if S2 was running, clear the S2_CTL2 enable bit and wait 500-1000 us;
- update only the type field (mask 0x0f) to 0x07;
- read it back, and fail the probe if the type did not take;
- if S2 was running, wait again and re-enable.

dev_dbg logs the firmware's original S2_CTL. Built with LLVM W=1 clean and checkpatch --strict clean;
not yet run on hardware. If 0x07 reads back and the phone still powers off, try 0x08 (cause 3) or set
up a witness (cause 2).

## Sources

- android.googlesource.com/kernel/msm, android-msm-wahoo-4.4-android10: drivers/input/misc/qpnp-power-on.c,
  drivers/power/reset/msm-poweroff.c (line 249, lines 412-414), arch/arm64/boot/dts/qcom/msm-pm8998.dtsi (pon_3).
- github.com/android-linux-stable/msm-4.14 include/dt-bindings/input/qcom,qpnp-power-on.h.
- Mainline v7.3: drivers/input/misc/pm8941-pwrkey.c, drivers/power/reset/qcom-pon.c.
- lore.kernel.org/all/1542443319-23369-1-git-send-email-loic.poulain@linaro.org/T/ (pm8916_wdt, 2018).
