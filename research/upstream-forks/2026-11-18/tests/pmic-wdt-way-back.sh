#!/bin/sh
# pmic-wdt-way-back.sh VERB - the proof of linux topic/pmic-wdt-wake-in-suspend on a phone (surya: pm6150,
# walleye: pm8998), run ON the phone as root by its keeper, from a kernel that carries the series and a
# board dts that enables the PMIC watchdog (&pm6150_wdt or &pm8998_wdt: status okay, wakeup-source).
# Nothing here is run by the research that wrote it; each verb says what it proves.
#
# Verbs (no verb: this text, nothing changed):
#   check        read only: the PMIC watchdog is there, takes a pretimeout, may wake; the last boot's
#                bootstatus (CARDRESET after a bite). Exit 1 if one is missing.
#   bite SECS    (10 to 60) the dry run, nothing suspends: arm for SECS with a pretimeout of SECS/2 and let
#                go of it unpetted - the phone must reset in about SECS. After the boot, `check` must say
#                CARDRESET: the bite is the PMIC watchdog's (test pmic-wdt-bites).
#   wake         one suspend kept by the watchdog: timeout 60 s, pretimeout 30 s, wakeup on, a petter
#                running, an RTC alarm at 150 s as the backstop, then suspend with nothing else to wake it.
#                Pass: back in 25 to 45 s, woken by the watchdog (its wakeup count up by one), same boot id
#                (test pmic-wdt-wakes-in-suspend). Back near 150 s: the bark did not wake (RTC did); a reset
#                at about 60 s: the bark did not wake but the bite came - the way back holds, the wake does not.
set -eu
say() { printf '%s\n' "$*"; }
usage() { sed -n '2,/^set -eu/p' "$0" | sed '$d;s/^# \{0,1\}//'; }
wdt=""
for d in /sys/class/watchdog/watchdog*; do
	[ "$(cat "$d/identity" 2>/dev/null)" = "QCOM PM8916 PON WDT" ] && wdt=$d
done
dev=/dev/${wdt##*/}
wakeup=$wdt/device/power/wakeup
wakecount() { cat "$wdt/device/power/wakeup_count" 2>/dev/null || echo 0; }
need_wdt() { [ -n "$wdt" ] || { say "pmic-wdt: no PMIC watchdog (identity QCOM PM8916 PON WDT)" >&2; exit 1; }; }
# wdctl sets the timeouts and closes with the magic character: nothing is left armed by it
set_timeouts() { wdctl -d "$dev" -s "$1" -p "$2" >/dev/null; }

case ${1:-} in
	check) need_wdt; bad=0
		say "ok   $dev: $(cat "$wdt/identity")"
		[ -f "$wdt/pretimeout" ] && say "ok   takes a pretimeout (now $(cat "$wdt/pretimeout") s)" || { say "FAIL no pretimeout: no bark interrupt"; bad=1; }
		[ -f "$wakeup" ] && say "ok   may wake the system: power/wakeup=$(cat "$wakeup")" || { say "FAIL not wakeup capable: no wakeup-source in the dts"; bad=1; }
		bs=$(cat "$wdt/bootstatus" 2>/dev/null || echo 0)
		[ $((bs & 0x20)) -ne 0 ] && say "note the last boot was a PMIC watchdog reset (bootstatus $bs: CARDRESET)" || say "note the last boot was not a PMIC watchdog reset (bootstatus $bs)"
		command -v wdctl >/dev/null && command -v watchdog >/dev/null && command -v rtcwake >/dev/null || { say "FAIL wdctl, watchdog or rtcwake missing"; bad=1; }
		[ "$bad" = 0 ] ;;
	bite) need_wdt; s=${2:-0}
		[ "$s" -ge 10 ] 2>/dev/null && [ "$s" -le 60 ] || { say "pmic-wdt: bite needs SECS from 10 to 60" >&2; exit 2; }
		set_timeouts "$s" $((s / 2))
		say "pmic-wdt: bite of $s s armed, unpetted" > /dev/kmsg; sync
		watchdog -F -T "$s" -t 2 "$dev" & p=$!; sleep 3; kill -9 "$p"
		say "armed: the phone resets in about $s s; after the boot run: $0 check" ;;
	wake) need_wdt
		echo enabled > "$wakeup"
		set_timeouts 60 30
		watchdog -F -T 60 -t 10 "$dev" & p=$!
		boot=$(cat /proc/sys/kernel/random/boot_id); before=$(wakecount); t0=$(date +%s)
		say "pmic-wdt: wake test, suspending with only the watchdog (and a 150 s RTC backstop) to wake" > /dev/kmsg; sync
		rtcwake -m no -s 150 >/dev/null
		echo mem > /sys/power/state || true
		t=$(( $(date +%s) - t0 )); after=$(wakecount)
		printf V > "$dev" 2>/dev/null || true; kill "$p" 2>/dev/null || true
		echo disabled > "$wakeup"; rtcwake -m disable >/dev/null 2>&1 || true
		say "back after $t s; watchdog wakeups $before -> $after; same boot: $([ "$boot" = "$(cat /proc/sys/kernel/random/boot_id)" ] && echo yes || echo no)"
		[ "$t" -ge 25 ] && [ "$t" -le 45 ] && [ "$after" -gt "$before" ] && say "PASS pmic-wdt-wakes-in-suspend" && exit 0
		say "FAIL pmic-wdt-wakes-in-suspend"; exit 1 ;;
	*) usage ;;
esac
