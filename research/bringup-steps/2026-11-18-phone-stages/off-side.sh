#!/bin/sh
# The off side of a phone, added after the author's word (2026-11-18): "it cant be powered off ... android
# smartphones have another hardwired state or small os ... that shows charging when off ... waking on alarms".
# What is: no separate processor does it. The PMIC is always powered; it charges by itself, keeps the RTC, and
# turns the phone on for a reason it records (key, USB charger, RTC alarm, watchdog, warm reset). Android's
# bootloader reads that reason and boots the same kernel with androidboot.mode=charger, and init runs only the
# charger (healthd's animation) - Sailfish's act-dead mode. Mainline has the pieces (the PON block, rtc-pm8xxx,
# PSCI SYSTEM_OFF); what is missing is the user space and the boot chain's use of the reason.
# Run in docs after seed-phone.sh: bringup_* rows only.
set -eu
st() { ikb bringup-step --checked-on 2026-11-18 "$@" >/dev/null; }
h() { ikb bringup-edge --step "$1" --requires "$2" --kind hard --why "$3" >/dev/null; }
s() { ikb bringup-edge --step "$1" --requires "$2" --kind soft --why "$3" >/dev/null; }

st --id pon-reason-read --title "Why it turned on, and why it last turned off, are read" --stage power --ord 8 --applies any \
  --done-when "each boot logs the power-on reason (key, USB charger, RTC alarm, warm reset, watchdog, key-combo reset) and the last power-off reason, read from the PMIC" \
  --proof pon-reason --proof-kind phone-suite \
  --guide "Test to write. On Qualcomm the PON block keeps PON_REASON, WARM_RESET_REASON and POFF_REASON (gen2 moves POFF_REASON1 to 0xc5; downstream-qpnp-power-on-sm6150 logs them, mainline's qcom-pon does not show them). surya read its PON registers by hand (surya-lab PR 269; upstreams-lane). Every step of the off side is told apart by this reason." \
  --sources downstream-qpnp-power-on-sm6150
st --id reset-types-right --title "Power-off, reboot and a bite each reach the right PMIC reset" --stage power --ord 9 --applies any \
  --done-when "power-off ends in the PMIC's shutdown, reboot in a warm or hard reset, and a watchdog bite in a hard reset - each read back from the PMIC and seen in the next boot's reason" \
  --proof reset-types --proof-kind host-check \
  --guide "On Qualcomm, power-off goes by PSCI SYSTEM_OFF to the secure firmware, which sets the PS_HOLD reset type and drops PS_HOLD; reboot sets another type. A wrong type, the firmware's own choice, or a power-on trigger still pending (a plugged cable, an armed PMIC watchdog, an RTC alarm) turns off into a new boot. surya: the firmware leaves S2 at warm reset 0x01; patch 5/5 sets hard reset 0x07 with a read-back (upstreams-lane). walleye: a bite powered off instead of restarting (pmic-wdt-reset-type). Test to write." \
  --sources downstream-qpnp-power-on-sm6150,lkml-qcom-wdt-suspend-2019
st --id power-off-stays-off --title "Off stays off" --stage power --ord 5 --applies any \
  --done-when "poweroff leaves the machine off, and plugging a charger in does not boot the full system" \
  --proof stays-off --proof-kind witness \
  --guide "surya fails: poweroff and a plugged charger both boot pmOS (off-state-charging); only the old eOS recovery's power-off held, so the PMIC can stay off and our power-off path is what differs. Read the power-on reason (pon-reason-read) and the reset types (reset-types-right) to tell a reboot from a charger power-on." \
  --sources downstream-qpnp-power-on-sm6150
st --id charger-mode-entered --title "A charger power-on starts the charging screen, not the system" --stage power --ord 10 --applies power:battery \
  --done-when "plugged in while off, the phone starts a small charger mode that shows the level and turns the screen off again; the power key starts the full system" \
  --proof charger-mode --proof-kind witness \
  --guide "Android: the bootloader reads the power-on reason and passes androidboot.mode=charger; init then runs only the charger - the same kernel, no separate processor (Sailfish's act-dead mode, sailfish-hadk-checklist). World gap: no maintained charger mode in any mainline distribution; charging-sdl is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064)." \
  --sources sailfish-hadk-checklist,pmaports-charging-sdl-1064
st --id reset-state-survives --title "What must survive a reset does, and the rest is set again" --stage power --ord 11 --applies any \
  --done-when "across a warm reset the reboot mode (the PMIC's spare register: bootloader, recovery), the RTC and ramoops survive; after any reset the kernel sets again the PMIC state it relies on (S2 reset type, watchdogs) and reads it back" \
  --proof reset-state --proof-kind host-check \
  --guide "The PMIC keeps its registers across a warm reset and the firmware rewrites some at boot (surya's S2 type 0x01 from firmware, upstreams-lane). ramoops survives a warm reset only if its memory is not cleared (ramoops-doc). Test to write." \
  --sources ramoops-doc,downstream-qpnp-power-on-sm6150
st --id key-reset-recovers --title "A held key resets a hung phone" --stage power --ord 12 --applies any \
  --done-when "holding power (with volume down where so wired) for the set time hard-resets a hung phone, and the next boot's reason says so" \
  --proof key-reset --proof-kind witness \
  --guide "The PMIC's S1/S2 key reset, set by the firmware or the PON driver; a user's way back that needs no software. Test by hand."
st --id rtc-alarm-powers-on --title "An alarm turns the phone on from off" --stage power --ord 13 --applies any \
  --done-when "an alarm set before power-off turns the phone on at its time, and the reason reads RTC alarm" \
  --proof rtc-poweron --proof-kind host-check \
  --guide "Android's power-off alarm: the PMIC RTC alarm powers it up and the bootloader boots an alarm mode. PCs have rtcwake -m off. World gap: no mainline phone distribution sets an alarm that survives power-off, and whether rtc-pm8xxx keeps the alarm armed through shutdown is not known yet."
st --id alarm-wakes-from-sleep --title "An alarm rings from sleep" --stage sleep --ord 12 --applies any \
  --done-when "an alarm set in the clock app rings on time while the phone sleeps under its shell's suspend" \
  --proof alarm-rings --proof-kind phone-suite \
  --guide "The shell or clock must set an RTC wake alarm before suspend (kernel-sysfs-power-wakelock). Not known yet which phone shells do; never tried in our labs." \
  --sources kernel-sysfs-power-wakelock

h pon-reason-read pmic-bound "the reasons are the PMIC's registers"
h reset-types-right pmic-bound "the reset types are the PMIC's"
s reset-types-right pon-reason-read "blind without it: the next boot's reason is the proof"
h power-off-stays-off reset-types-right "off must end in the PMIC's shutdown, not a reset"
s power-off-stays-off pon-reason-read "tells a reboot from a charger or alarm power-on"
h charger-mode-entered pon-reason-read "a charger power-on is told by its reason"
h charger-mode-entered power-off-stays-off "a charger mode needs an off to start from"
h charger-mode-entered panel-lit "it shows the level"
s charger-mode-entered battery-gauge-reads "the level is the gauge's"
h off-mode-charging charger-mode-entered "the screen and the power key while off"
h reset-state-survives pon-reason-read "read after each kind of reset"
h reset-state-survives watchdog-way-back "the watchdog state is part of it"
h key-reset-recovers pmic-bound "the key reset is the PMIC's"
s key-reset-recovers pon-reason-read "the reason proves it was the key"
h rtc-alarm-powers-on power-off-stays-off "it must be off to be turned on"
h rtc-alarm-powers-on pon-reason-read "the reason reads RTC alarm"
h alarm-wakes-from-sleep real-suspend-under-shell "it sleeps as in daily use"
h alarm-wakes-from-sleep speaker-heard "it rings"

h daily-usable-phone alarm-wakes-from-sleep "a person needs it every day"
h daily-usable-phone key-reset-recovers "a person needs it every day"
for n in rtc-alarm-powers-on reset-state-survives; do
  h complete-phone "$n" "everything the hardware does, lasting"
done
