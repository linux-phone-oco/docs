# One-off scripts and workarounds, measured 2026-11-18

The measurements behind research oneoffs-and-workarounds-measured: every tracked one-off script at origin/main with its commits, last change and callers; content shared across repos; the keepers' scratch scripts. `workarounds-read.sh` beside it is the failing check of decision 2026-11-18-workarounds-read-as-one (7 FAIL on this day).

Columns: commits, last change, (refs column not valid in this run; base rows naming each file were counted by basename: 66 of 97), Makefile/CI/other-script callers, header words, path.

```
# Tracked one-off scripts at origin/main, 2026-11-18: commits, last change, base rows naming it, Makefile/CI/other-script callers
# commits last refs ci hdr path (refs column broken in this run; rows naming the file: 66 of 97, counted by basename across docs, surya-lab, google-walleye-lab data/)
1 2026-11-09 refs=0 ci=0 hdr=0 surya-lab/adsp/registry-trial.sh
2 2026-11-18 refs=0 ci=1 hdr=0 surya-lab/bin/install-ikb.sh
2 2026-11-17 refs=0 ci=2 hdr=0 surya-lab/bin/install-tad.sh
3 2026-11-09 refs=0 ci=0 hdr=0 surya-lab/dt/build-dtbs.sh
2 2026-11-09 refs=0 ci=0 hdr=0 surya-lab/dt/disable-node.py
2 2026-11-09 refs=0 ci=0 hdr=0 surya-lab/dt/irq-audit.py
2 2026-11-09 refs=0 ci=0 hdr=0 surya-lab/dt/reg-audit.py
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/lab/build-hexagonrpcd-sns.sh
1 2026-11-17 refs=0 ci=1 hdr=0 surya-lab/lab/sensors-install.sh
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/research/deep-sleep/2026-11-17-adsp-floor/adsp-floor.sh
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/research/deep-sleep/2026-11-17/suspend-cycle.sh
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/research/deep-sleep/2026-11-17/suspend-wake-trace.sh
1 2026-11-18 refs=0 ci=0 hdr=1 surya-lab/sleep/bt-trace.sh
1 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/sleep/build-wdt.sh
7 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/sleep/standby-run.sh
3 2026-11-18 refs=0 ci=1 hdr=0 surya-lab/sleep/way-back.sh
2 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/amplifiers.sh
2 2026-11-18 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/autosleep-off.sh
1 2026-11-18 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/bt-suspend.sh
2 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/call-audio.sh
4 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/microphone.sh
2 2026-11-18 refs=0 ci=0 hdr=0 surya-lab/tests/health/base/sleep-way-back.sh
3 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/shell/earpiece.sh
5 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/shell/microphone-hears.sh
2 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/shell/speaker-stereo.sh
4 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/telephony/call-echo.sh
4 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/tests/health/telephony/sms-loopback.sh
3 2026-11-17 refs=0 ci=0 hdr=0 surya-lab/ui/switch.sh
2 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/bin/install-ikb.sh
2 2026-11-17 refs=0 ci=2 hdr=0 google-walleye-lab/bin/install-tad.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/adreno-smmu-disabled-selftest.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/adreno-smmu-disabled.sh
1 2026-11-18 refs=0 ci=3 hdr=0 google-walleye-lab/tests/host/banner-check.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/banner-loop-check.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/banner-loop-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/banner-selftest.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/banner-shell-check.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/banner-shell-selftest.sh
2 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/battery-ok.sh
2 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/battery-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/c5-loader-selftest.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/charger-check.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/charger-selftest.sh
2 2026-11-18 refs=0 ci=1 hdr=1 google-walleye-lab/tests/host/dmesg-clean-check.sh
2 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/dmesg-clean-selftest.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/dtbo-overlay-merges.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ffs-acm-up.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/fixture-shell-read-per-command.sh
2 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/gadget-up.sh
1 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/idle-android.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/mainline-acm-up.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/mainline-light-up.sh
8 2026-11-18 refs=0 ci=4 hdr=0 google-walleye-lab/tests/host/mainline-shell-read.sh
4 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/mainline-shell-selftest.sh
2 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/massstorage-read.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ml3-ramoops-read.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ml4-bin-table.sh
1 2026-11-17 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ml5-bin-table.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/overlay-clock-gcc.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/phone-state-selftest.sh
1 2026-11-18 refs=0 ci=8 hdr=0 google-walleye-lab/tests/host/phone-state.sh
1 2026-11-18 refs=0 ci=1 hdr=1 google-walleye-lab/tests/host/pmic-dmesg-check.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pmic-dmesg-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pmic-wdt-bites.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pmic-wdt-pon-regs-banner.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pmic-wdt-s2-regs-read.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pon-regs-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pstore-t1-read.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/pstore-t3-read.sh
2 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/restart-check.sh
2 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/restart-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ufs-lsblk-check.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/ufs-lsblk-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/vendor-facts-poll-selftest-vf4.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/vendor-facts-poll-selftest.sh
3 2026-11-18 refs=0 ci=2 hdr=0 google-walleye-lab/tests/host/vendor-facts-poll.sh
3 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/vendor-facts-read.sh
2 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/vendor-facts-selftest.sh
2 2026-11-18 refs=0 ci=1 hdr=0 google-walleye-lab/tests/host/window-payload-read.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/window-payload-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/z5-console-selftest.sh
1 2026-11-18 refs=0 ci=0 hdr=0 google-walleye-lab/tests/host/z6-loop-selftest.sh
2 2026-11-18 refs=0 ci=0 hdr=0 docs/research/base-graph/2026-11-18/graph-drift.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18-phone-stages/daily-phone.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18-phone-stages/off-side.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18-phone-stages/seed-phone.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18-phone-stages/sources.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18/bringup-chain-walleye.sh
1 2026-11-18 refs=0 ci=0 hdr=1 docs/research/bringup-steps/2026-11-18/claims-walleye.sh
2 2026-11-18 refs=0 ci=0 hdr=0 docs/research/bringup-steps/2026-11-18/seed.sh
1 2026-11-17 refs=0 ci=0 hdr=0 docs/research/deep-sleep/2026-11-17-adsp-floor/adsp-floor.sh
1 2026-11-17 refs=0 ci=0 hdr=0 docs/research/deep-sleep/2026-11-17/suspend-cycle.sh
1 2026-11-17 refs=0 ci=0 hdr=0 docs/research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh
1 2026-11-17 refs=0 ci=0 hdr=0 docs/research/deep-sleep/2026-11-17/suspend-wake-trace.sh
2 2026-11-18 refs=0 ci=0 hdr=0 docs/research/device-template/2026-11-18/template-drift.sh
1 2026-11-18 refs=0 ci=0 hdr=0 docs/research/upstream-forks/2026-11-18/tests/pmic-wdt-way-back.sh

# identical content across repos (sha1 of 230 tracked .sh/.rs/.py)
3  surya-lab/bin/install-ikb.sh google-walleye-lab/bin/install-ikb.sh docs/bin/install-ikb.sh
3  surya-lab/bin/install-tad.sh google-walleye-lab/bin/install-tad.sh docs/bin/install-tad.sh
2  surya-lab/research/deep-sleep/2026-11-17/suspend-wake-trace.sh docs/research/deep-sleep/2026-11-17/suspend-wake-trace.sh
2  surya-lab/research/deep-sleep/2026-11-17-adsp-floor/adsp-floor.sh docs/research/deep-sleep/2026-11-17-adsp-floor/adsp-floor.sh
2  surya-lab/research/deep-sleep/2026-11-17/suspend-cycle.sh docs/research/deep-sleep/2026-11-17/suspend-cycle.sh
2  surya-lab/research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh docs/research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh

# keepers' scratch: loose .sh/.rs outside a checkout under /tmp/claude-1000/-home-mll/*/scratchpad: 735 in 60 sessions, 77 .rs; most copied names:
     23 install-tad.sh
     22 install-ikb.sh
     12 suspend-wake-trace.sh
     12 suspend-wake-arm-trace.sh
     12 suspend-cycle.sh
     12 adsp-floor.sh
     11 run-feeds.sh
     11 landings.sh
     11 check-principles.sh
     10 pmic-wdt-way-back.sh
      9 seed.sh
      9 claims-walleye.sh
```
